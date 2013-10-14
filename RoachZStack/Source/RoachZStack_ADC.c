
#include "RoachZStack_ADC.h"
#include "hal_adc.h"
#include "hal_lcd.h"
#include "ZConfig.h"
#include "OSAL.h"

adcMsg_t* pBufferMsg = NULL;

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

uint8 nextADC = 50;

uint8 micADC[3] = {HAL_ADC_CHANNEL_1, HAL_ADC_CHANNEL_4, HAL_ADC_CHANNEL_5};

HAL_ISR_FUNCTION(ADC_ISR,ADC_VECTOR)
{
  //HAL_ENTER_ISR();
  
  /* Read the result */
  int16 reading = (int16) (ADCL);
  reading |= (int16) (ADCH << 8);

  /* Treat small negative as 0 */
  if (reading < 0)
    reading = 0;
  
  reading >>= 2;
  if (pBufferMsg != NULL && pBufferMsg->size < BUFFER_SIZE)
  {
    pBufferMsg->buffer[pBufferMsg->size++] = reading;
  }
  
  if (nextADC+1 < sizeof(micADC))
  {
    ADCCON3 = HAL_ADC_REF_VOLT | HAL_ADC_DEC_512 | micADC[nextADC+1];
  }
  nextADC++;
  //HAL_EXIT_ISR();
}

HAL_ISR_FUNCTION(T3_ISR,T3_VECTOR)
{
  //HAL_ENTER_ISR();
  
  if (registeredADCTaskID != NO_TASK_ID)
  {
    if (nextADC >= sizeof(micADC))
    {
      nextADC = 0;
      ADCCON3 = HAL_ADC_REF_VOLT | HAL_ADC_DEC_512 | micADC[0];
    }
  }
  
  //HAL_EXIT_ISR();
}

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
    
    ADCCFG |= 1 << HAL_ADC_CHANNEL_1;
    ADCCFG |= 1 << HAL_ADC_CHANNEL_4;
    ADCCFG |= 1 << HAL_ADC_CHANNEL_5;
    
    IEN0 |= 0x02; //ADCIE
    IEN1 |= 0x08;
    T3CTL = 0xF8;
    CLKCONCMD |= 0x38;
    
    osal_set_event(RoachZStack_ADC_TaskID, RZS_ADC_READ );
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
        
    if (pBufferMsg != NULL && pBufferMsg->size > sizeof(pBufferMsg->buffer)/sizeof(*(pBufferMsg->buffer))/2 &&  pBufferMsg->size % sizeof(micADC) == 0)
    {
      // Send the address to the task
      pBufferMsg->hdr.event = RZS_ADC_VALUE;
      osal_msg_send( registeredADCTaskID, (uint8 *)pBufferMsg );
      pBufferMsg = NULL;
    }
    
    if (pBufferMsg == NULL)
    {
      pBufferMsg = (adcMsg_t*) osal_msg_allocate( sizeof(adcMsg_t) );
      allocCount++;
      if (pBufferMsg != NULL)
      {  
        pBufferMsg->size = 0;
      }
    }
    
    HAL_EXIT_CRITICAL_SECTION( intState );   // Re-enable interrupts.
    
    osal_start_timerEx( RoachZStack_ADC_TaskID, RZS_ADC_READ, 1); 
    return events ^ RZS_ADC_READ;
  }
    return 0;
}