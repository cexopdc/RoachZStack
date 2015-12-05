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
  PROVIDED �AS IS� WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, 
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
static void n_stimulate(uint8 direction);
static void p_stimulate(uint8 direction);
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
  NEG_STIM1_DDR |= NEG_STIM1_BV;
  NEG_STIM2_DDR |= NEG_STIM2_BV;
  NEG_STIM3_DDR |= NEG_STIM3_BV;
  NEG_STIM4_DDR |= NEG_STIM4_BV;
  
  POS_STIM1_DDR |= POS_STIM1_BV;
  POS_STIM2_DDR |= POS_STIM2_BV;
  POS_STIM3_DDR |= POS_STIM3_BV;
  POS_STIM4_DDR |= POS_STIM4_BV;
  /*
  LEFT_1_DDR |= LEFT_1_BV;
  RIGHT_1_DDR |= RIGHT_1_BV;
  LEFT_2_DDR |= LEFT_2_BV;
  RIGHT_2_DDR |= RIGHT_2_BV;*/

// not used for our project  
#if defined IMPEDANCE && (defined BIPHASIC_STIM || defined VOLT_MONITOR)
  BI_IMP_DDR |= BI_IMP_BV;
#endif
    
#ifdef VOLT_MONITOR
  HalAdcInit();
#endif
  
  stopStimulate();
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
    // section deals with silence time and tracking total cycle count
  
  if ( events & ROACHZSTACK_STIM_START )
  {
    if (command != NULL && command->repeats > 0 && command->totalCount > 0 && command->stim == 1)
    {
#ifdef BIPHASIC_STIM
      //BICLK_SBIT = 0;
#endif
      p_stimulate(command->direction);
#ifdef VOLT_MONITOR
      measureVoltage();
#endif
      command->repeats--;
      if (command->repeats == 0) {
        command->stim = 0;
      }
      osal_start_timerEx( Stimulator_TaskID, ROACHZSTACK_STIM_STOP, command->posOn); 
    }
    
    return ( events ^ ROACHZSTACK_STIM_START );
  }
  
  if ( events & ROACHZSTACK_STIM_STOP )
  {
#ifdef VOLT_MONITOR
    measureVoltage();
#endif
    stopStimulate();
#ifdef BIPHASIC_STIM
    if (command->negOn)
    {
      osal_start_timerEx( Stimulator_TaskID, ROACHZSTACK_NSTIM_START, command->posOff);  
    }
    else
#endif
    {
      osal_start_timerEx( Stimulator_TaskID, ROACHZSTACK_NSTIM_STOP, command->posOff);
    }
    
    return ( events ^ ROACHZSTACK_STIM_STOP );
  }
  

  if ( events & ROACHZSTACK_NSTIM_START )
  {
    if (command != NULL)
    {
#ifdef BIPHASIC_STIM
      //BICLK_SBIT = 1;
#endif
      n_stimulate(command->direction);
      osal_start_timerEx( Stimulator_TaskID, ROACHZSTACK_NSTIM_STOP, command->negOn); 
    }
    return ( events ^ ROACHZSTACK_NSTIM_START );
  }
  
  if ( events & ROACHZSTACK_NSTIM_STOP )
  {
#ifdef BIPHASIC_STIM
    //BICLK_SBIT = 0;
#endif
    stopStimulate();
    if (command != NULL && command->repeats > 0 && command->stim == 1)
    {
      osal_start_timerEx( Stimulator_TaskID, ROACHZSTACK_STIM_START, command->negOff);   
    }
    
    if (command != NULL && command->totalCount > 0 && command->stim == 0)
    {
      command->totalCount--; 
      command->stim = 1;
      command->repeats = command->pulseCount; // resets repeat counter 
      stopStimulate();
      // do nothing for 'silence' ms and then return to STIM_START
      osal_start_timerEx( Stimulator_TaskID, ROACHZSTACK_STIM_START, command->silence); 
    }
    return ( events ^ ROACHZSTACK_NSTIM_STOP );
  }

  return ( 0 );  // Discard unknown events.
}


static void stopStimulate(void)
{
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 0;
      
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;      
  /*LEFT_1_SBIT = 0;
  RIGHT_1_SBIT = 0;
  LEFT_2_SBIT = 0;
  RIGHT_2_SBIT = 0;
  BICLK_SBIT = 0; */
}

static void p_stimulate(uint8 direction)
{
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 0;
  switch(direction)
  {
    case 'A':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
      break;
    case 'B':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
      break;
    case 'C':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
      break;
     case 'D':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
      break;
     case 'E':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 0;
      break;
    case 'F':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 0;
      break;
    case 'G':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 0;
      break;
     case 'H':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 0;
      break;
    case 'I':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 1;
      break;
    case 'J':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 1;
      break;
    case 'K':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 1;
      break;
     case 'L':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 1;
      break;
    case 'M':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 1;
      break;
    case 'N':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 1;
      break;
    case 'O':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 1;
      break;
     case 'P':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 1;
      break;
    
  //case 'P':
    //LEFT_2_SBIT = 1;
    //RIGHT_2_SBIT = 0; // used for negative stimulation
  }
}

static void n_stimulate(uint8 direction)
{
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
  switch(direction)
  {
    case 'A':
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 0;
      break;
    case 'B':
      NEG_STIM1_SBIT = 1;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 0;
      break;
    case 'C':
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 1;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 0;
      break;
     case 'D':
      NEG_STIM1_SBIT = 1;
      NEG_STIM2_SBIT = 1;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 0;
      break;
     case 'E':
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 1;
      NEG_STIM4_SBIT = 0;
      break;
    case 'F':
      NEG_STIM1_SBIT = 1;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 1;
      NEG_STIM4_SBIT = 0;
      break;
    case 'G':
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 1;
      NEG_STIM3_SBIT = 1;
      NEG_STIM4_SBIT = 0;
      break;
     case 'H':
      NEG_STIM1_SBIT = 1;
      NEG_STIM2_SBIT = 1;
      NEG_STIM3_SBIT = 1;
      NEG_STIM4_SBIT = 0;
      break;
    case 'I':
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 1;
      break;
    case 'J':
      NEG_STIM1_SBIT = 1;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 1;
      break;
    case 'K':
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 1;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 1;
      break;
     case 'L':
      NEG_STIM1_SBIT = 1;
      NEG_STIM2_SBIT = 1;
      NEG_STIM3_SBIT = 0;
      NEG_STIM4_SBIT = 1;
      break;
    case 'M':
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 1;
      NEG_STIM4_SBIT = 1;
      break;
    case 'N':
      NEG_STIM1_SBIT = 1;
      NEG_STIM2_SBIT = 0;
      NEG_STIM3_SBIT = 1;
      NEG_STIM4_SBIT = 1;
      break;
    case 'O':
      NEG_STIM1_SBIT = 0;
      NEG_STIM2_SBIT = 1;
      NEG_STIM3_SBIT = 1;
      NEG_STIM4_SBIT = 1;
      break;
     case 'P':
      NEG_STIM1_SBIT = 1;
      NEG_STIM2_SBIT = 1;
      NEG_STIM3_SBIT = 1;
      NEG_STIM4_SBIT = 1;
      break;
    
  //case 'P':
    //LEFT_2_SBIT = 0;
    //RIGHT_2_SBIT = 1; // used for negative stimulation
  }
}
/*
static void stimulate(uint8 direction)
{
  switch (direction)
  {
    case 'A':
      LEFT_1_SBIT = 0;
      RIGHT_1_SBIT = 0;
      LEFT_2_SBIT = 0;
      RIGHT_2_SBIT = 0;
      break;
    case 'B':
      LEFT_1_SBIT = 1;
      RIGHT_1_SBIT = 0;
      LEFT_2_SBIT = 0;
      RIGHT_2_SBIT = 0;
      break;
    case 'C':
      LEFT_1_SBIT = 0;
      RIGHT_1_SBIT = 1;
      LEFT_2_SBIT = 0;
      RIGHT_2_SBIT = 0;
      break;
     case 'D':
      LEFT_1_SBIT = 1;
      RIGHT_1_SBIT = 1;
      LEFT_2_SBIT = 0;
      RIGHT_2_SBIT = 0;
      break;
     case 'E':
      LEFT_1_SBIT = 0;
      RIGHT_1_SBIT = 0;
      LEFT_2_SBIT = 1;
      RIGHT_2_SBIT = 0;
      break;
    case 'F':
      LEFT_1_SBIT = 1;
      RIGHT_1_SBIT = 0;
      LEFT_2_SBIT = 1;
      RIGHT_2_SBIT = 0;
      break;
    case 'G':
      LEFT_1_SBIT = 0;
      RIGHT_1_SBIT = 1;
      LEFT_2_SBIT = 1;
      RIGHT_2_SBIT = 0;
      break;
     case 'H':
      LEFT_1_SBIT = 1;
      RIGHT_1_SBIT = 1;
      LEFT_2_SBIT = 1;
      RIGHT_2_SBIT = 0;
      break;
    case 'I':
      LEFT_1_SBIT = 0;
      RIGHT_1_SBIT = 0;
      LEFT_2_SBIT = 0;
      RIGHT_2_SBIT = 1;
      break;
    case 'J':
      LEFT_1_SBIT = 1;
      RIGHT_1_SBIT = 0;
      LEFT_2_SBIT = 0;
      RIGHT_2_SBIT = 1;
      break;
    case 'K':
      LEFT_1_SBIT = 0;
      RIGHT_1_SBIT = 1;
      LEFT_2_SBIT = 0;
      RIGHT_2_SBIT = 1;
      break;
     case 'L':
      LEFT_1_SBIT = 1;
      RIGHT_1_SBIT = 1;
      LEFT_2_SBIT = 0;
      RIGHT_2_SBIT = 1;
      break;
    case 'M':
      LEFT_1_SBIT = 0;
      RIGHT_1_SBIT = 0;
      LEFT_2_SBIT = 1;
      RIGHT_2_SBIT = 1;
      break;
    case 'N':
      LEFT_1_SBIT = 1;
      RIGHT_1_SBIT = 0;
      LEFT_2_SBIT = 1;
      RIGHT_2_SBIT = 1;
      break;
    case 'O':
      LEFT_1_SBIT = 0;
      RIGHT_1_SBIT = 1;
      LEFT_2_SBIT = 1;
      RIGHT_2_SBIT = 1;
      break;
     case 'P':
      LEFT_1_SBIT = 1;
      RIGHT_1_SBIT = 1;
      LEFT_2_SBIT = 1;
      RIGHT_2_SBIT = 1;
      break;
  }
} */

void Stimulator_SetCommand(stimCommand* data)
{
  if (command != NULL)
  {
    osal_mem_free(command);
  }
  command = data;
#if defined(IMPEDANCE) && (defined(BIPHASIC_STIM) || defined(VOLT_MONITOR))
  BI_IMP_SBIT = 0;
#endif
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