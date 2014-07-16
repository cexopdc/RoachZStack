#ifdef AUDIO

#include "RoachZStack_ADC.h"
#include "hal_adc.h"
#include "hal_lcd.h"
#include "hal_led.h"
#include "hal_dma.h"
#include "hal_sleep.h"
#include "ZConfig.h"
#include "OSAL.h"
#include "AF.h"
#include "RoachZStack.h"


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
#define HAL_ADC_REF_VOLT    HAL_ADC_REF_125V
#define HAL_ADC_DEC_RATE    HAL_ADC_DEC_064
#define HAL_ADC_SCHN        HAL_ADC_CHN_VDD3
#define HAL_ADC_ECHN        HAL_ADC_CHN_GND


// Registered keys task ID, initialized to NOT USED.

static uint8 registeredADCTaskID = NO_TASK_ID;
uint8 RoachZStack_ADC_TaskID;    // Task ID for internal task/event processing.
extern afAddrType_t RoachZStack_TxAddr;
extern const endPointDesc_t RoachZStack_epDesc;
extern uint8 RoachZStack_MsgID;

uint16 data = 0;

uint16 overflow = 0;

#define SEND_SIZE 90
#define BUFFER_LEN 3600
#define PACKETS (BUFFER_LEN / SEND_SIZE)
int8 adc_buffer[BUFFER_LEN];
uint16 read_index;
uint16 send_index;
uint16 packets_ready;


#ifndef ZDO_COORDINATOR
HAL_ISR_FUNCTION( DMA_ISR, DMA_VECTOR )
{
  HAL_ENTER_ISR();
  T1CTL = 0x00 | 0x0C | 0x00;
  
  DMAIF = 0;
  packets_ready++;
  if (packets_ready != PACKETS)
  {
    read_index += SEND_SIZE;
    
    if (read_index >= BUFFER_LEN)
    {
      read_index = 0;
    }
    HAL_DMA_SET_DEST(HAL_DMA_GET_DESC1234(1), adc_buffer + read_index);
    HAL_DMA_ARM_CH(1);
    T1CTL = 0x00 | 0x0C | 0x02;
  }
  CLEAR_SLEEP_MODE();
  HAL_EXIT_ISR();
}
#endif
/*********************************************************************
 *
 * @fn      RoachZStack_Init
 * @brief   This is called during OSAL tasks' initialization.
 *
 * @param   task_id - the Task ID assigned by OSAL.
 *
 * @return  none
 */
void RoachZStack_ADC_Init( uint8 task_id )
{
  #ifndef ZDO_COORDINATOR
    PERCFG |= 0x40;
    RoachZStack_ADC_TaskID = task_id;   
    uint8 micCfg = 1 << HAL_ADC_CHANNEL_1;
    
    APCFG = 0x00 | micCfg;
    ADCCON1 = HAL_ADC_STSEL_T1C0 | 0x03; // 0x03 reserved
    //HAL_ADC_REF_AVDD or HAL_ADC_REF_125V
    ADCCON2 = HAL_ADC_REF_125V | HAL_ADC_DEC_512 | 0x01; //stop at channel 5
    //P2INP |= 0x20;
    T1CTL = 0x00 | 0x0C | 0x02;
    
    uint16 counter = 40;//125;
    
    T1CC0H = counter >> 8;
    T1CC0L = (uint8)counter;
    // no rf, no interrupt, set->clear, compare, no capture
    T1CCTL0 = 0x00 | 0x00 | 0x18 | 0x04 | 0x00; // 5C;
    DMAIE = 1;
    
    send_index = 0;
    read_index = 0;
    packets_ready = 0;
    HalDmaInit();
    
    HAL_DMA_SET_SOURCE(HAL_DMA_GET_DESC1234(1), &X_ADCL);
    HAL_DMA_SET_VLEN(HAL_DMA_GET_DESC1234(1), HAL_DMA_VLEN_USE_LEN);
    HAL_DMA_SET_LEN(HAL_DMA_GET_DESC1234(1), SEND_SIZE/2);
    HAL_DMA_SET_WORD_SIZE(HAL_DMA_GET_DESC1234(1), HAL_DMA_WORDSIZE_WORD);
    HAL_DMA_SET_TRIG_MODE(HAL_DMA_GET_DESC1234(1), HAL_DMA_TMODE_SINGLE);
    HAL_DMA_SET_TRIG_SRC(HAL_DMA_GET_DESC1234(1), HAL_DMA_TRIG_ADC_CHALL);
    HAL_DMA_SET_SRC_INC(HAL_DMA_GET_DESC1234(1), HAL_DMA_SRCINC_0);
    HAL_DMA_SET_DST_INC(HAL_DMA_GET_DESC1234(1), HAL_DMA_DSTINC_1);
    HAL_DMA_SET_IRQ(HAL_DMA_GET_DESC1234(1), HAL_DMA_IRQMASK_ENABLE);
    HAL_DMA_SET_PRIORITY(HAL_DMA_GET_DESC1234(1), HAL_DMA_PRI_GUARANTEED);
    HAL_DMA_SET_DEST(HAL_DMA_GET_DESC1234(1), adc_buffer);
    
  #endif
}

void RecordBurst(void)
{
  HAL_DMA_ARM_CH(1);
  
  osal_set_event(RoachZStack_ADC_TaskID, RZS_ADC_PROCESS );

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
    RecordBurst();
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
  
  if (events & RZS_ADC_PROCESS)
  {
    if (registeredADCTaskID == NO_TASK_ID)
    {
      return events;
    } 
    
    if (packets_ready > 0)
    {
      if (send_index >= BUFFER_LEN)
      {
        send_index = 0;
      }
      
      //osal_memcpy( RoachZStack_TxBuf+1, adcMsg->buffer, sizeof(adcMsg->buffer) );
      //osal_msg_send( registeredADCTaskID, (uint8 *)data_buffer );
      afStatus_t s = AF_DataRequest(&RoachZStack_TxAddr,
        (endPointDesc_t *)&RoachZStack_epDesc,
        ROACHZSTACK_CLUSTER_MIC,
        SEND_SIZE, (uint8 *)(adc_buffer + send_index),
        &RoachZStack_MsgID, AF_DISCV_ROUTE, AF_DEFAULT_RADIUS);
      
      send_index += SEND_SIZE;
      halIntState_t intState;
      HAL_ENTER_CRITICAL_SECTION( intState );  // Hold off interrupts.
      packets_ready--;
      HAL_EXIT_CRITICAL_SECTION( intState );   // Re-enable interrupts.
      
      
    }
    osal_start_timerEx(RoachZStack_ADC_TaskID, RZS_ADC_PROCESS, 1 );
    return events ^ RZS_ADC_PROCESS;
  }
  return 0;
}

#endif