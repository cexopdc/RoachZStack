#ifndef ROACHZSTACK_H
#define ROACHZSTACK_H

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
 
#define LEFT_DDR                        P1DIR
#define LEFT_BV                         BV(4)
#define LEFT_SBIT                       P1_4
  
#define RIGHT_DDR                       P1DIR
#define RIGHT_BV                        BV(2)
#define RIGHT_SBIT                      P1_2

#ifdef FORWARD_STIM
#define FORWARD_DDR                     P1DIR
#define FORWARD_BV                      BV(3)
#define FORWARD_SBIT                    P1_3
  
#define FORWARD 0
#endif
  
#define LED_DDR                         P1DIR
#define LED_BV                          BV(5)
#define LED_SBIT                        P1_5
 
#ifdef BIPHASIC_STIM
#define BICLK_DDR                       P0DIR
#define BICLK_BV                        BV(7)
#define BICLK_SBIT                      P0_7
#endif
  
#if defined(IMPEDANCE) && (defined(BIPHASIC_STIM) || defined (VOLT_MONITOR))
#define BI_IMP_DDR                      P1DIR
#define BI_IMP_BV                       BV(0)
#define BI_IMP_SBIT                     P1_0
#endif
  
#define BACK 1
#define RIGHT 2
#define LEFT 3

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

#endif /* ROACHZSTACK_H */
