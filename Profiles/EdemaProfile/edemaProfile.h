/**************************************************************************************************
  Filename:       simpleGATTprofile.h
  Revised:        $Date: 2010-08-06 08:56:11 -0700 (Fri, 06 Aug 2010) $
  Revision:       $Revision: 23333 $

  Description:    This file contains the Simple GATT profile definitions and
                  prototypes.

  Copyright 2010 - 2013 Texas Instruments Incorporated. All rights reserved.

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

#ifndef SIMPLEGATTPROFILE_H
#define SIMPLEGATTPROFILE_H

#ifdef __cplusplus
extern "C"
{
#endif

/*********************************************************************
 * INCLUDES
 */

/*********************************************************************
 * CONSTANTS
 */

// Profile Parameters
#define EDEMAPROFILE_CHAR1                   0  // RW uint8 - Profile Characteristic 1 value 
#define EDEMAPROFILE_CHAR2                   1  // RW uint8 - Profile Characteristic 2 value
#define EDEMAPROFILE_CHAR3                   2  // RW uint8 - Profile Characteristic 3 value
#define EDEMAPROFILE_SWEEP_DONE              3  // RW uint8 - Profile Characteristic 4 value
#define EDEMAPROFILE_SWEEPDATA               4  // RW uint8 - Profile Characteristic 4 value
#define EDEMAPROFILE_SWEEPDATA2              5  // RW uint8 - Profile Characteristic 4 value
#define EDEMAPROFILE_STARTFREQ               6
#define EDEMAPROFILE_NUMFREQ                 7
#define EDEMAPROFILE_INCFREQ                 8
#define EDEMAPROFILE_RANGE                   9
#define EDEMAPROFILE_GAIN                    10
#define EDEMAPROFILE_ELECTRODES              11
  
// Simple Profile Service UUID
#define EDEMAPROFILE_SERV_UUID               0xFFF0
    
// Key Pressed UUID
#define EDEMAPROFILE_CHAR1_UUID            0xFFF1
#define EDEMAPROFILE_CHAR2_UUID            0xFFF2
#define EDEMAPROFILE_CHAR3_UUID            0xFFF3
#define EDEMAPROFILE_SWEEP_DONE_UUID       0xFFF4
#define EDEMAPROFILE_SWEEPDATA_UUID        0xFFF5
#define EDEMAPROFILE_SWEEPDATA2_UUID       0xFFF6
#define EDEMAPROFILE_STARTFREQ_UUID        0xFFF7
#define EDEMAPROFILE_NUMFREQ_UUID          0xFFF8
#define EDEMAPROFILE_INCFREQ_UUID          0xFFF9
#define EDEMAPROFILE_RANGE_UUID            0xFFFA
#define EDEMAPROFILE_GAIN_UUID             0xFFFB
#define EDEMAPROFILE_ELECTRODES_UUID       0xFFFC
  
// Simple Keys Profile Services bit fields
#define EDEMAPROFILE_SERVICE               0x00000123

// Length of Characteristic 5 in bytes
#define NUM_FREQ 50
#define EDEMAPROFILE_SWEEPDATA_LEN           NUM_FREQ*4  
#define EDEMAPROFILE_SWEEP_DONE_LEN          1
#define EDEMAPROFILE_STARTFREQ_LEN           4
#define EDEMAPROFILE_NUMFREQ_LEN             2
#define EDEMAPROFILE_INCFREQ_LEN             4
#define EDEMAPROFILE_RANGE_LEN               1
#define EDEMAPROFILE_GAIN_LEN                1
#define EDEMAPROFILE_ELECTRODES_LEN          1

/*********************************************************************
 * TYPEDEFS
 */

  
/*********************************************************************
 * MACROS
 */

/*********************************************************************
 * Profile Callbacks
 */

// Callback when a characteristic value has changed
typedef void (*edemaProfileChange_t)( uint8 paramID );

typedef struct
{
  edemaProfileChange_t        pfnEdemaProfileChange;  // Called when characteristic value changes
} edemaProfileCBs_t;

    

/*********************************************************************
 * API FUNCTIONS 
 */


/*
 * EdemaProfile_AddService- Initializes the Simple GATT Profile service by registering
 *          GATT attributes with the GATT server.
 *
 * @param   services - services to add. This is a bit map and can
 *                     contain more than one service.
 */

extern bStatus_t EdemaProfile_AddService( uint32 services );

/*
 * EdemaProfile_RegisterAppCBs - Registers the application callback function.
 *                    Only call this function once.
 *
 *    appCallbacks - pointer to application callbacks.
 */
extern bStatus_t EdemaProfile_RegisterAppCBs( edemaProfileCBs_t *appCallbacks );

/*
 * EdemaProfile_SetParameter - Set a Simple GATT Profile parameter.
 *
 *    param - Profile parameter ID
 *    len - length of data to right
 *    value - pointer to data to write.  This is dependent on
 *          the parameter ID and WILL be cast to the appropriate 
 *          data type (example: data type of uint16 will be cast to 
 *          uint16 pointer).
 */
extern bStatus_t EdemaProfile_SetParameter( uint8 param, unsigned int len, void *value );
  
/*
 * EdemaProfile_GetParameter - Get a Simple GATT Profile parameter.
 *
 *    param - Profile parameter ID
 *    value - pointer to data to write.  This is dependent on
 *          the parameter ID and WILL be cast to the appropriate 
 *          data type (example: data type of uint16 will be cast to 
 *          uint16 pointer).
 */
extern bStatus_t EdemaProfile_GetParameter( uint8 param, void *value );


/*********************************************************************
*********************************************************************/

#ifdef __cplusplus
}
#endif

#endif /* SIMPLEGATTPROFILE_H */
