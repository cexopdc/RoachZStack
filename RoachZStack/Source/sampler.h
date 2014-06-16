
#ifndef ROACHZSTACK_ADC_H
#define ROACHZSTACK_ADC_H

#ifdef __cplusplus
extern "C"
{
#endif

/*********************************************************************
 * INCLUDES
 */
#include "ZComDef.h"
#include "osal.h"

/*********************************************************************
 * CONSTANTS
 */

#define SAMPLER_START_SWEEP                              0x0001
#define SAMPLER_START_INC                                0x0002
#define SAMPLER_INC_SWEEP                                0x0004
#define SAMPLER_CALC_IMP                                 0x0008
#define SAMPLER_STOP_SWEEP                               0x0010
  
/*********************************************************************
 * MACROS
 */

/*********************************************************************
 * GLOBAL VARIABLES
 */
extern byte RoachZStack_ADC_TaskID;


/*********************************************************************
 * FUNCTIONS
 */

/*
 * Task Initialization for the Serial Transfer Application
 */
extern void Sampler_Init( byte task_id );

/*
 * Task Event Processor for the Serial Transfer Application
 */
extern UINT16 Sampler_ProcessEvent( byte task_id, UINT16 events );

/*
 * Task Event Processor for the Serial Transfer Application
 */
extern void Sampler_SetState( int cmd );

/*********************************************************************
*********************************************************************/

#ifdef __cplusplus
}
#endif

#endif /* ROACHZSTACK_H */
