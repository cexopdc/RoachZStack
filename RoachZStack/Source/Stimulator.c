/**************************************************************************************************
  Filename:       RoachZStack.c
  Revised:        $Date: 2009-03-29 10:51:47 -0700 (Sun, 29 Mar 2009) $
  Revision:       $Revision: 19585 $

  Description -   Serial Transfer Application (no Profile).


  Copyright 2004-2009 Texas Instruments Incorporated. All rights reserved.

  IMPORTANT: Your use of this Software is limited to those specific rights
  granted under the terms of a software license agreement between the user
  who downloaded the software, his/her employer (which must be your employer)
  and Texas Instruments Incorporated (the "License").  You may not use this
  Software unless you agree to abide by the terms of the License. The License
  limits your use, and you acknowledge, that the Software may not be modified,
  copied or distributed unless embedded on a Texas Instruments microcontroller
  or used solely and exclusively in conjunction with a Texas Instruments radio
  frequency transceiver, which is integrated into your product.  Other than for
  the foregoing purpose, you may not use, reproduce, copy, prepare derivative
  works of, modify, distribute, perform, display or sell this Software and/or
  its documentation for any purpose.

  YOU FURTHER ACKNOWLEDGE AND AGREE THAT THE SOFTWARE AND DOCUMENTATION ARE
  PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, 
  INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, TITLE, 
  NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL
  TEXAS INSTRUMENTS OR ITS LICENSORS BE LIABLE OR OBLIGATED UNDER CONTRACT,
  NEGLIGENCE, STRICT LIABILITY, CONTRIBUTION, BREACH OF WARRANTY, OR OTHER
  LEGAL EQUITABLE THEORY ANY DIRECT OR INDIRECT DAMAGES OR EXPENSES
  INCLUDING BUT NOT LIMITED TO ANY INCIDENTAL, SPECIAL, INDIRECT, PUNITIVE
  OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, COST OF PROCUREMENT
  OF SUBSTITUTE GOODS, TECHNOLOGY, SERVICES, OR ANY CLAIMS BY THIRD PARTIES
  (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF), OR OTHER SIMILAR COSTS.

  Should you have any questions regarding your right to use this Software,
  contact Texas Instruments Incorporated at www.TI.com. 
**************************************************************************************************/

#ifndef ZDO_COORDINATOR

/*********************************************************************
 * INCLUDES
 */

#include "OnBoard.h"
#include "OSAL_Tasks.h"

#include "hal_drivers.h"
#include "hal_key.h"
#include "hal_lcd.h"
#include "hal_led.h"
#include "hal_uart.h"
#include "Stimulator.h"
#include "ZConfig.h"
#include "commands.h"
#ifdef VOLT_MONITOR
#include "hal_adc.h"
#include "RoachProfile.h"
#endif

/*********************************************************************
 * GLOBAL VARIABLES
 */

uint8 Stimulator_TaskID;    // Task ID for internal task/event processing.

/*********************************************************************
 * LOCAL VARIABLES
 */

static stimCommand* command = NULL;

static void stimulate(uint8 direction);
static void stopStimulate(void);

#ifdef VOLT_MONITOR
static void measureVoltage(void);
#endif

/*********************************************************************
 * @fn      Stimulator_Init
 *
 * @brief   This is called during OSAL tasks' initialization.
 *
 * @param   task_id - the Task ID assigned by OSAL.
 *
 * @return  none
 */
void Stimulator_Init( uint8 task_id )
{
  Stimulator_TaskID = task_id;
  LEFT_1_DDR |= LEFT_1_BV;
  RIGHT_1_DDR |= RIGHT_1_BV;
  LEFT_2_DDR |= LEFT_2_BV;
  RIGHT_2_DDR |= RIGHT_2_BV;

  stopStimulate(); // ensure it starts off
}

/*********************************************************************
 * @fn      Stimulator_ProcessEvent
 *
 * @brief   Generic Application Task event processor.
 *
 * @param   task_id  - The OSAL assigned task ID.
 * @param   events   - Bit map of events to process.
 *
 * @return  Event flags of all unprocessed events.
 */
uint16 Stimulator_ProcessEvent( uint8 task_id, uint16 events )
{
  (void)task_id;  // Intentionally unreferenced parameter
  
  if ( events & ROACHZSTACK_STIM_START )
  {
    if (command != NULL && command->repeats > 0)
    {
      stimulate(command->direction);
      command->repeats--;
      osal_start_timerEx( Stimulator_TaskID, ROACHZSTACK_STIM_STOP, command->posOn); 
    }
    return ( events ^ ROACHZSTACK_STIM_START );
  }
  
  if ( events & ROACHZSTACK_STIM_STOP )
  {
    stopStimulate();
    return ( events ^ ROACHZSTACK_STIM_STOP );
  }
  
  return ( 0 );  // Discard unknown events.
}


static void stopStimulate(void)
{
  LEFT_1_SBIT = OFF; // = 0
  LEFT_2_SBIT = OFF;
  RIGHT_1_SBIT = OFF;
  RIGHT_2_SBIT = OFF;
}

static void stimulate(uint8 direction)
{
  switch (direction) // test with three cases
  {
  case A: // all off
    LEFT_1_SBIT = OFF; // = 0
    LEFT_2_SBIT = OFF;
    RIGHT_1_SBIT = OFF;
    RIGHT_2_SBIT = OFF;
    break;
  case B: 
    LEFT_1_SBIT = ON; 
    LEFT_2_SBIT = OFF;
    RIGHT_1_SBIT = OFF;
    RIGHT_2_SBIT = OFF;
    break;
  case C: 
    LEFT_1_SBIT = ON; 
    LEFT_2_SBIT = ON;
    RIGHT_1_SBIT = ON;
    RIGHT_2_SBIT = ON;
    break;
  }
}

void Stimulator_SetCommand(stimCommand* data)
{
  if (command != NULL)
  {
    osal_mem_free(command);
  }
  command = data;
  osal_set_event(Stimulator_TaskID, ROACHZSTACK_STIM_START);
}


#ifdef VOLT_MONITOR
void measureVoltage()
{
  uint16 v1 = HalAdcRead(HAL_ADC_CHN_AIN1, HAL_ADC_RESOLUTION_14);
  uint16 v2 = HalAdcRead(HAL_ADC_CHN_AIN3, HAL_ADC_RESOLUTION_14);
  
  uint16 buf[2] = {v1, v2};
  
  RoachProfile_SetParameter(ROACHPROFILE_VOLTAGE, sizeof(buf), buf);
  
}
#endif

/*********************************************************************
*********************************************************************/

#endif