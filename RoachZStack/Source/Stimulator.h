#ifndef STIMULATOR_H
#define STIMULATOR_H

#ifdef __cplusplus
extern "C"
{
#endif

#include "commands.h"

#define ROACHZSTACK_SEND_EVT           0x0001
#define ROACHZSTACK_RESP_EVT           0x0002
#define ROACHZSTACK_STIM_START         0x0004
#define ROACHZSTACK_STIM_STOP          0x0008
#define ROACHZSTACK_NSTIM_START        0x0010
#define ROACHZSTACK_NSTIM_STOP         0x0020
 
#define LEFT_1_DDR                   P1DIR
#define LEFT_1_BV                    BV(4)
#define LEFT_1_SBIT                  P1_4

#define LEFT_2_DDR                   P1DIR
#define LEFT_2_BV                    BV(3)
#define LEFT_2_SBIT                  P1_3
  
#define RIGHT_1_DDR                  P1DIR
#define RIGHT_1_BV                   BV(2)
#define RIGHT_1_SBIT                 P1_2
   
#define RIGHT_2_DDR                  P1DIR
#define RIGHT_2_BV                   BV(1)
#define RIGHT_2_SBIT                 P1_1

 
#if defined(IMPEDANCE) && (defined(BIPHASIC_STIM) || defined(VOLT_MONITOR))
#define BI_IMP_DDR                      P1DIR
#define BI_IMP_BV                       BV(1)
#define BI_IMP_SBIT                     P1_1            // Change back to P1_0 on new boards
#endif
  
#define A 'A'
#define B 'B'
#define C 'C'
#define OFF 0
#define ON 1

/*********************************************************************
 * GLOBAL VARIABLES
 */
extern uint8 Stimulator_TaskID;

/*********************************************************************
 * FUNCTIONS
 */

/*
 * Task Initialization for the Serial Transfer Application
 */
extern void Stimulator_Init( uint8 task_id );

/*
 * Task Event Processor for the Serial Transfer Application
 */
extern uint16 Stimulator_ProcessEvent( uint8 task_id, uint16 events );

extern void Stimulator_SetCommand (stimCommand* data);

/*********************************************************************
*********************************************************************/

#ifdef __cplusplus
}
#endif

#endif /* STIMULATOR_H */
