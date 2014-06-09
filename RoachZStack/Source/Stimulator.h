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
 
#define LEFT_PORT P1
#define LEFT_PIN 4
#define RIGHT_PORT P1
#define RIGHT_PIN 2
#define FORWARD_PORT P1
#define FORWARD_PIN 2 //temporary
#define LED_PORT P1
#define LED_PIN 5
#define BICLK_PORT P1
#define BICLK_PIN 7

#define FORWARD 0
#define BACK 1
#define RIGHT 2
#define LEFT 3
#define DIGIPOT 16

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
