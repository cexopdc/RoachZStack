
#include "RoachZStack_ADC.h"
#include "hal_adc.h"
#include "hal_lcd.h"
#include "hal_led.h"
#include "hal_dma.h"
#include "hal_sleep.h"
#include "ZConfig.h"
#include "OSAL.h"

adcMsg_t* pBufferReading = NULL;
adcMsg_t* pBufferDone = NULL;
adcMsg_t* pBufferNext = NULL;

// Task ID not initialized
#define NO_TASK_ID 0xFF

#define ADC_R 0x10  //P0_4->P18_13
#define ADC_L 0x02  //P0_1->P18_7
#define ADC_C 0x20  //P0_5->P18_15


#define HAL_ADC_EOC         0x80    /* End of Conversion bit */
#define HAL_ADC_START       0x40    /* Starts Conversion */

#define HAL_ADC_STSEL_EXT   0x00    /* External Trigger */
#define HAL_ADC_STSEL_FULL  0x10    /* Full Speed, No Trigger */
#define HAL_ADC_STSEL_T1C0  0x20    /* Timer1, Channel 0 Compare Event Trigger */
#define HAL_ADC_STSEL_ST    0x30    /* ADCCON1.ST =1 Trigger */

#define HAL_ADC_RAND_NORM   0x00    /* Normal Operation */
#define HAL_ADC_RAND_LFSR   0x04    /* Clock LFSR */
#define HAL_ADC_RAND_SEED   0x08    /* Seed Modulator */
#define HAL_ADC_RAND_STOP   0x0c    /* Stop Random Generator */
#define HAL_ADC_RAND_BITS   0x0c    /* Bits [3:2] */

#define HAL_ADC_DEC_064     0x00    /* Decimate by 64 : 8-bit resolution */
#define HAL_ADC_DEC_128     0x10    /* Decimate by 128 : 10-bit resolution */
#define HAL_ADC_DEC_256     0x20    /* Decimate by 256 : 12-bit resolution */
#define HAL_ADC_DEC_512     0x30    /* Decimate by 512 : 14-bit resolution */
#define HAL_ADC_DEC_BITS    0x30    /* Bits [5:4] */

#define HAL_ADC_STSEL       HAL_ADC_STSEL_ST
#define HAL_ADC_RAND_GEN    HAL_ADC_RAND_STOP
#define HAL_ADC_REF_VOLT    HAL_ADC_REF_AVDD
#define HAL_ADC_DEC_RATE    HAL_ADC_DEC_064
#define HAL_ADC_SCHN        HAL_ADC_CHN_VDD3
#define HAL_ADC_ECHN        HAL_ADC_CHN_GND


// Registered keys task ID, initialized to NOT USED.
extern volatile uint8 allocCount;
static uint8 registeredADCTaskID = NO_TASK_ID;
uint8 RoachZStack_ADC_TaskID;    // Task ID for internal task/event processing.

uint16 data = 0;

uint16 overflow = 0;

  #ifndef ZDO_COORDINATOR
HAL_ISR_FUNCTION( DMA_ISR, DMA_VECTOR )
{
  
  T1CTL = 0x00 | 0x0C | 0x00;
  HAL_ENTER_ISR();

  DMAIF = 0;

  pBufferDone = pBufferReading;
  pBufferReading = pBufferNext;
  pBufferNext = NULL;
  if (pBufferReading != NULL)
  {
    HAL_DMA_SET_DEST(HAL_DMA_GET_DESC1234(1), pBufferReading->buffer);
    HAL_DMA_ARM_CH(1);
    T1CTL = 0x00 | 0x0C | 0x02;
  }

  osal_set_event(RoachZStack_ADC_TaskID, RZS_ADC_READ );

  CLEAR_SLEEP_MODE();
  HAL_EXIT_ISR();
}
#endif
/*********************************************************************
 * @fn      RoachZStack_Init
 *
 * @brief   This is called during OSAL tasks' initialization.
 *
 * @param   task_id - the Task ID assigned by OSAL.
 *
 * @return  none
 */
void RoachZStack_ADC_Init( uint8 task_id )
{
  #ifndef ZDO_COORDINATOR
    RoachZStack_ADC_TaskID = task_id;   
    APCFG = 0x00 | (1 << HAL_ADC_CHANNEL_1) | (1 << HAL_ADC_CHANNEL_4) | (1 << HAL_ADC_CHANNEL_5);
    ADCCON1 = HAL_ADC_STSEL_T1C0 | 0x03; // 0x03 reserved
    ADCCON2 = HAL_ADC_REF_VOLT | HAL_ADC_DEC_064 | 0x04; //stop at channel 5

    T1CTL = 0x00 | 0x0C | 0x02;
    
    uint16 counter = 100;//200;//125;
    
    T1CC0H = counter >> 8;
    T1CC0L = (uint8)counter;
    // no rf, no interrupt, set->clear, compare, no capture
    T1CCTL0 = 0x00 | 0x00 | 0x18 | 0x04 | 0x00; // 5C;
    DMAIE = 1;
    
    HalDmaInit();
    HAL_DMA_SET_SOURCE(HAL_DMA_GET_DESC1234(1), &X_ADCH);
    HAL_DMA_SET_VLEN(HAL_DMA_GET_DESC1234(1), HAL_DMA_VLEN_USE_LEN);
    HAL_DMA_SET_LEN(HAL_DMA_GET_DESC1234(1), sizeof(pBufferReading->buffer));
    HAL_DMA_SET_WORD_SIZE(HAL_DMA_GET_DESC1234(1), HAL_DMA_WORDSIZE_BYTE);
    HAL_DMA_SET_TRIG_MODE(HAL_DMA_GET_DESC1234(1), HAL_DMA_TMODE_SINGLE);
    HAL_DMA_SET_TRIG_SRC(HAL_DMA_GET_DESC1234(1), HAL_DMA_TRIG_ADC_CHALL);
    HAL_DMA_SET_SRC_INC(HAL_DMA_GET_DESC1234(1), HAL_DMA_SRCINC_0);
    HAL_DMA_SET_DST_INC(HAL_DMA_GET_DESC1234(1), HAL_DMA_DSTINC_1);
    HAL_DMA_SET_IRQ(HAL_DMA_GET_DESC1234(1), HAL_DMA_IRQMASK_ENABLE);
    HAL_DMA_SET_PRIORITY(HAL_DMA_GET_DESC1234(1), HAL_DMA_PRI_GUARANTEED);

    
  #endif
}

/*********************************************************************
 * ADC Register function
 *
 * The adc handler is setup to send all adc changes to
 * one task (if a task is registered).
 *
 *********************************************************************/
uint8 RegisterForADC( uint8 task_id )
{
  // Allow only the first task
  if ( registeredADCTaskID == NO_TASK_ID )
  {
    registeredADCTaskID = task_id;
    osal_set_event(RoachZStack_ADC_TaskID, RZS_ADC_READ );
    return ( true );
  }
  else
    return ( false );
}


/*********************************************************************
 * @fn      RoachZStack_ProcessEvent
 *
 * @brief   Generic Application Task event processor.
 *
 * @param   task_id  - The OSAL assigned task ID.
 * @param   events   - Bit map of events to process.
 *
 * @return  Event flags of all unprocessed events.
 */
UINT16 RoachZStack_ADC( uint8 task_id, UINT16 events )
{
  
  if (events & RZS_ADC_READ)
  {
    if (registeredADCTaskID == NO_TASK_ID)
    {
      osal_start_timerEx( RoachZStack_ADC_TaskID, RZS_ADC_READ, 2); 
      return events ^ RZS_ADC_READ;
    }
    
    halIntState_t intState;
    HAL_ENTER_CRITICAL_SECTION( intState );  // Hold off interrupts.
        
    if (pBufferDone != NULL)
    {
      // Send the address to the task
      pBufferDone->hdr.event = RZS_ADC_VALUE;
      osal_msg_send( registeredADCTaskID, (uint8 *)pBufferDone );
      pBufferDone = NULL;
    }
    
    if (pBufferNext == NULL)
    {
      pBufferNext = (adcMsg_t*) osal_msg_allocate( sizeof(adcMsg_t) );
      allocCount++;
      if (pBufferNext != NULL)
      {  
        pBufferNext->size = 0;
        overflow = 0;
      }
      else
      {
        HalLedSet(HAL_LED_2, HAL_LED_MODE_TOGGLE);
      }
    }
    if (pBufferReading == NULL)
    {
      pBufferReading = pBufferNext;
      pBufferNext = (adcMsg_t*) osal_msg_allocate( sizeof(adcMsg_t) );
      if (pBufferReading != NULL)
      {  
        HAL_DMA_SET_DEST(HAL_DMA_GET_DESC1234(1), pBufferReading->buffer);
        HAL_DMA_ARM_CH(1);
        T1CTL = 0x00 | 0x0C | 0x02;
      }
    }
    
    HAL_EXIT_CRITICAL_SECTION( intState );   // Re-enable interrupts.
    
    return events ^ RZS_ADC_READ;
  }
    return 0;
}