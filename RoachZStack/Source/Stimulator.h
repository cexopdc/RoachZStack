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
 
#define LEFT_2_DDR                        P1DIR
#define LEFT_2_BV                         BV(4)
#define LEFT_2_SBIT                       P1_4 // 18.14
  
#define RIGHT_2_DDR                       P1DIR
#define RIGHT_2_BV                        BV(2)
#define RIGHT_2_SBIT                      P1_2 // 20.18

#define LEFT_1_DDR                     P1DIR
#define LEFT_1_BV                      BV(1)
#define LEFT_1_SBIT                    P1_1//P1_7//P1_6//P1_3 // not working (used as ground previously)
  
#define RIGHT_1_DDR                         P1DIR
#define RIGHT_1_BV                          BV(0)  //BV(5)
#define RIGHT_1_SBIT                        P1_0//20.04   //P1_5
 
#define BICLK_DDR                       P2DIR
#define BICLK_BV                        BV(1)
#define BICLK_SBIT                      P2_1//P2_2//P0_4//P0_2//P0_6//P0_0//P2_0

// not needed for our project  
#if defined(IMPEDANCE) && (defined(BIPHASIC_STIM) || defined(VOLT_MONITOR))
#define BI_IMP_DDR                      P1DIR
#define BI_IMP_BV                       BV(1)
#define BI_IMP_SBIT                     P1_1            // Change back to P1_0 on new boards
#endif
  

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
