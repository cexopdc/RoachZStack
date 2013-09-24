
#include "RoachZStack_ADC.h"
#include "hal_adc.h"
#include "hal_lcd.h"
#include "ZConfig.h"

#define BUFFER_SIZE 256
uint8 buffer[BUFFER_SIZE];

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
  RoachZStack_ADC_TaskID = task_id;
  HalAdcInit();
  osal_set_event(RoachZStack_ADC_TaskID, RZS_ADC_READ );
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
    uint8 adcVal = (uint8) HalAdcRead ( HAL_ADC_CHANNEL_4, HAL_ADC_RESOLUTION_8 );
    
    
    
    // Send the address to the task
    adcMsg_t* msgPtr = (adcMsg_t*) osal_msg_allocate( sizeof(adcVal) );
    if ( msgPtr )
    {
      msgPtr->hdr.event = RZS_ADC_VALUE;
      msgPtr->value = adcVal;

      osal_msg_send( registeredADCTaskID, (uint8 *)msgPtr );
    }
  
          HalLcdWriteValue ( adcVal,16, HAL_LCD_LINE_3);
    //osal_set_event(RoachZStack_ADC_TaskID, RZS_ADC_READ );
    osal_start_timerEx( RoachZStack_ADC_TaskID, RZS_ADC_READ, 2000); 
    return events ^ RZS_ADC_READ;
  }
    return 0;
}