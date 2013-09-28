
#include "RoachZStack_ADC.h"
#include "hal_adc.h"
#include "hal_lcd.h"
#include "ZConfig.h"

adcMsg_t* pBufferMsg = NULL;
uint8 bufferIndex;

// Task ID not initialized
#define NO_TASK_ID 0xFF

// Registered keys task ID, initialized to NOT USED.
static uint8 registeredADCTaskID = NO_TASK_ID;
uint8 RoachZStack_ADC_TaskID;    // Task ID for internal task/event processing.

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
    bufferIndex = 0;
    HalAdcInit();
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
      osal_start_timerEx( RoachZStack_ADC_TaskID, RZS_ADC_READ, 500); 
      return events ^ RZS_ADC_READ;
    }
    if (pBufferMsg == NULL)
    {
      pBufferMsg = (adcMsg_t*) osal_msg_allocate( sizeof(adcMsg_t) );
    }
    if (pBufferMsg == NULL)
    {
      return events ^ RZS_ADC_READ;
    }
    
    uint8 adcVal = (uint8) HalAdcRead ( HAL_ADC_CHANNEL_4, HAL_ADC_RESOLUTION_8 );
    pBufferMsg->buffer[bufferIndex++] = adcVal;
    if (bufferIndex == BUFFER_SIZE)
    {
      bufferIndex = 0;
      // Send the address to the task
      pBufferMsg->hdr.event = RZS_ADC_VALUE;
      osal_msg_send( registeredADCTaskID, (uint8 *)pBufferMsg );
      pBufferMsg = NULL;
    }
    
    HalLcdWriteValue ( adcVal,16, HAL_LCD_LINE_3);
    //osal_set_event(RoachZStack_ADC_TaskID, RZS_ADC_READ );
    osal_start_timerEx( RoachZStack_ADC_TaskID, RZS_ADC_READ, 1); 
    return events ^ RZS_ADC_READ;
  }
    return 0;
}