/**************************************************************************************************
  Filename:       simpleGATTprofile.c
  Revised:        $Date: 2013-05-06 13:33:47 -0700 (Mon, 06 May 2013) $
  Revision:       $Revision: 34153 $

  Description:    This file contains the Roach GATT profile sample GATT service 
                  profile for use with the BLE sample application.

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

/*********************************************************************
 * INCLUDES
 */
#include "bcomdef.h"
#include "OSAL.h"
#include "linkdb.h"
#include "att.h"
#include "gatt.h"
#include "gatt_uuid.h"
#include "gattservapp.h"
#include "gapbondmgr.h"

#include "roachProfile.h"

/*********************************************************************
 * MACROS
 */

/*********************************************************************
 * CONSTANTS
 */

#define SERVAPP_NUM_ATTR_SUPPORTED        10

/*********************************************************************
 * TYPEDEFS
 */

/*********************************************************************
 * GLOBAL VARIABLES
 */
// Roach GATT Profile Service UUID: 0xFFF0
CONST uint8 RoachProfileServUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(ROACHPROFILE_SERV_UUID), HI_UINT16(ROACHPROFILE_SERV_UUID)
};

// Characteristic 1 UUID: 0xFFF1
CONST uint8 RoachProfileDirectionUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(ROACHPROFILE_DIRECTION_UUID), HI_UINT16(ROACHPROFILE_DIRECTION_UUID)
};

// Characteristic 2 UUID: 0xFFF2
CONST uint8 RoachProfileRepeatsUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(ROACHPROFILE_REPEATS_UUID), HI_UINT16(ROACHPROFILE_REPEATS_UUID)
};

// Characteristic 3 UUID: 0xFFF3
CONST uint8 RoachProfileDurationUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(ROACHPROFILE_DURATION_UUID), HI_UINT16(ROACHPROFILE_DURATION_UUID)
};

/*********************************************************************
 * EXTERNAL VARIABLES
 */

/*********************************************************************
 * EXTERNAL FUNCTIONS
 */

/*********************************************************************
 * LOCAL VARIABLES
 */

static roachProfileCBs_t *RoachProfile_AppCBs = NULL;

/*********************************************************************
 * Profile Attributes - variables
 */

// Roach Profile Service attribute
static CONST gattAttrType_t RoachProfileService = { ATT_BT_UUID_SIZE, RoachProfileServUUID };


// Direction Properties
static uint8 RoachProfileDirectionProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Direction Value
static uint8 RoachProfileDirection = 0;

// Direction User Description
static uint8 RoachProfileDirectionUserDesp[17] = "Direction       \0";


// Repeats Properties
static uint8 RoachProfileRepeatsProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Repeats Value
static uint8 RoachProfileRepeats = 0;

// Repeats User Description
static uint8 RoachProfileRepeatsUserDesp[17] = "Repeats         \0";


// Duration Properties
static uint8 RoachProfileDurationProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Duration Value
static uint8 RoachProfileDuration = 0;

// Duration User Description
static uint8 RoachProfileDurationUserDesp[17] = "Duration        \0";


/*********************************************************************
 * Profile Attributes - Table
 */

static gattAttribute_t RoachProfileAttrTbl[SERVAPP_NUM_ATTR_SUPPORTED] = 
{
  // Roach Profile Service
  { 
    { ATT_BT_UUID_SIZE, primaryServiceUUID }, /* type */
    GATT_PERMIT_READ,                         /* permissions */
    0,                                        /* handle */
    (uint8 *)&RoachProfileService            /* pValue */
  },

    // Direction Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &RoachProfileDirectionProps 
    },

      // Direction
      { 
        { ATT_BT_UUID_SIZE, RoachProfileDirectionUUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        &RoachProfileDirection 
      },

      // Direction User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        RoachProfileDirectionUserDesp 
      },      

    // Repeats Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &RoachProfileRepeatsProps 
    },

      // Repeats
      { 
        { ATT_BT_UUID_SIZE, RoachProfileRepeatsUUID },
        GATT_PERMIT_READ, 
        0, 
        &RoachProfileRepeats
      },

      // Repeats User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        RoachProfileRepeatsUserDesp 
      },           
      
    // Duration Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &RoachProfileDurationProps 
    },

      // Duration
      { 
        { ATT_BT_UUID_SIZE, RoachProfileDurationUUID },
        GATT_PERMIT_WRITE, 
        0, 
        &RoachProfileDuration 
      },

      // Duration User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        RoachProfileDurationUserDesp 
      }
};


/*********************************************************************
 * LOCAL FUNCTIONS
 */
static uint8 RoachProfile_ReadAttrCB( uint16 connHandle, gattAttribute_t *pAttr, 
                            uint8 *pValue, uint8 *pLen, uint16 offset, uint8 maxLen );
static bStatus_t RoachProfile_WriteAttrCB( uint16 connHandle, gattAttribute_t *pAttr,
                                 uint8 *pValue, uint8 len, uint16 offset );

static void RoachProfile_HandleConnStatusCB( uint16 connHandle, uint8 changeType );


/*********************************************************************
 * PROFILE CALLBACKS
 */
// Roach Profile Service Callbacks
CONST gattServiceCBs_t RoachProfileCBs =
{
  RoachProfile_ReadAttrCB,  // Read callback function pointer
  RoachProfile_WriteAttrCB, // Write callback function pointer
  NULL                       // Authorization callback function pointer
};

/*********************************************************************
 * PUBLIC FUNCTIONS
 */

/*********************************************************************
 * @fn      RoachProfile_AddService
 *
 * @brief   Initializes the Roach Profile service by registering
 *          GATT attributes with the GATT server.
 *
 * @param   services - services to add. This is a bit map and can
 *                     contain more than one service.
 *
 * @return  Success or Failure
 */
bStatus_t RoachProfile_AddService( uint32 services )
{
  uint8 status = SUCCESS;


  // Register with Link DB to receive link status change callback
  VOID linkDB_Register( RoachProfile_HandleConnStatusCB );  
  
  if ( services & ROACHPROFILE_SERVICE )
  {
    // Register GATT attribute list and CBs with GATT Server App
    status = GATTServApp_RegisterService( RoachProfileAttrTbl, 
                                          GATT_NUM_ATTRS( RoachProfileAttrTbl ),
                                          &RoachProfileCBs );
  }

  return ( status );
}


/*********************************************************************
 * @fn      RoachProfile_RegisterAppCBs
 *
 * @brief   Registers the application callback function. Only call 
 *          this function once.
 *
 * @param   callbacks - pointer to application callbacks.
 *
 * @return  SUCCESS or bleAlreadyInRequestedMode
 */
bStatus_t RoachProfile_RegisterAppCBs( roachProfileCBs_t *appCallbacks )
{
  if ( appCallbacks )
  {
    RoachProfile_AppCBs = appCallbacks;
    
    return ( SUCCESS );
  }
  else
  {
    return ( bleAlreadyInRequestedMode );
  }
}
  

/*********************************************************************
 * @fn      RoachProfile_SetParameter
 *
 * @brief   Set a Roach Profile parameter.
 *
 * @param   param - Profile parameter ID
 * @param   len - length of data to right
 * @param   value - pointer to data to write.  This is dependent on
 *          the parameter ID and WILL be cast to the appropriate 
 *          data type (example: data type of uint16 will be cast to 
 *          uint16 pointer).
 *
 * @return  bStatus_t
 */
bStatus_t RoachProfile_SetParameter( uint8 param, unsigned int len, void *value )
{
  bStatus_t ret = SUCCESS;
  switch ( param )
  {
    case ROACHPROFILE_DIRECTION:
      if ( len == sizeof ( uint8 ) ) 
      {
        RoachProfileDirection = *((uint8*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;

    case ROACHPROFILE_REPEATS:
      if ( len == sizeof ( uint16 ) ) 
      {
        RoachProfileRepeats = *((uint16*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;

    case ROACHPROFILE_DURATION:
      if ( len == sizeof ( uint16 ) ) 
      {
        RoachProfileDuration = *((uint16*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;

    default:
      ret = INVALIDPARAMETER;
      break;
  }  return ( ret );
}

/*********************************************************************
 * @fn      RoachProfile_GetParameter
 *
 * @brief   Get a Roach Profile parameter.
 *
 * @param   param - Profile parameter ID
 * @param   value - pointer to data to put.  This is dependent on
 *          the parameter ID and WILL be cast to the appropriate 
 *          data type (example: data type of uint16 will be cast to 
 *          uint16 pointer).
 *
 * @return  bStatus_t
 */
bStatus_t RoachProfile_GetParameter( uint8 param, void *value )
{
  bStatus_t ret = SUCCESS;
  switch ( param )
  {
    case ROACHPROFILE_DIRECTION:
      *((uint8*)value) = RoachProfileDirection;
      break;

    case ROACHPROFILE_REPEATS:
      *((uint16*)value) = RoachProfileRepeats;
      break;      

    case ROACHPROFILE_DURATION:
      *((uint16*)value) = RoachProfileDuration;
      break;  

    default:
      ret = INVALIDPARAMETER;
      break;
  }
  
  return ( ret );
}

/*********************************************************************
 * @fn          RoachProfile_ReadAttrCB
 *
 * @brief       Read an attribute.
 *
 * @param       connHandle - connection message was received on
 * @param       pAttr - pointer to attribute
 * @param       pValue - pointer to data to be read
 * @param       pLen - length of data to be read
 * @param       offset - offset of the first octet to be read
 * @param       maxLen - maximum length of data to be read
 *
 * @return      Success or Failure
 */
static uint8 RoachProfile_ReadAttrCB( uint16 connHandle, gattAttribute_t *pAttr, 
                            uint8 *pValue, uint8 *pLen, uint16 offset, uint8 maxLen )
{
  bStatus_t status = SUCCESS;

  // If attribute permissions require authorization to read, return error
  if ( gattPermitAuthorRead( pAttr->permissions ) )
  {
    // Insufficient authorization
    return ( ATT_ERR_INSUFFICIENT_AUTHOR );
  }
  
  // Make sure it's not a blob operation (no attributes in the profile are long)

 
  if ( pAttr->type.len == ATT_BT_UUID_SIZE )
  {
    // 16-bit UUID
    uint16 uuid = BUILD_UINT16( pAttr->type.uuid[0], pAttr->type.uuid[1]);
    switch ( uuid )
    {
      // No need for "GATT_SERVICE_UUID" or "GATT_CLIENT_CHAR_CFG_UUID" cases;
      // gattserverapp handles those reads

      case ROACHPROFILE_DIRECTION_UUID:
        if ( offset > 0 )
        {
          return ( ATT_ERR_ATTR_NOT_LONG );
        }
        *pLen = 1;
        pValue[0] = *pAttr->pValue;
        break;

      case ROACHPROFILE_REPEATS_UUID:
        if ( offset > 0 )
        {
          return ( ATT_ERR_ATTR_NOT_LONG );
        }
        *pLen = ROACHPROFILE_REPEATS_LEN;
        VOID osal_memcpy( pValue, pAttr->pValue, ROACHPROFILE_REPEATS_LEN );
        break;
      case ROACHPROFILE_DURATION_UUID:
      {
        if ( offset > 0 )
        {
          return ( ATT_ERR_ATTR_NOT_LONG );
        }
        *pLen = ROACHPROFILE_DURATION_LEN;
        VOID osal_memcpy( pValue, pAttr->pValue, ROACHPROFILE_DURATION_LEN );
        break;
      }
        
      default:
        // Should never get here! (characteristics 3 and 4 do not have read permissions)
        *pLen = 0;
        status = ATT_ERR_ATTR_NOT_FOUND;
        break;
    }
  }
  else
  {
    // 128-bit UUID
    *pLen = 0;
    status = ATT_ERR_INVALID_HANDLE;
  }

  return ( status );
}

/*********************************************************************
 * @fn      RoachProfile_WriteAttrCB
 *
 * @brief   Validate attribute data prior to a write operation
 *
 * @param   connHandle - connection message was received on
 * @param   pAttr - pointer to attribute
 * @param   pValue - pointer to data to be written
 * @param   len - length of data
 * @param   offset - offset of the first octet to be written
 *
 * @return  Success or Failure
 */
static bStatus_t RoachProfile_WriteAttrCB( uint16 connHandle, gattAttribute_t *pAttr,
                                 uint8 *pValue, uint8 len, uint16 offset )
{
  bStatus_t status = SUCCESS;
  uint8 notifyApp = 0xFF;
  
  // If attribute permissions require authorization to write, return error
  if ( gattPermitAuthorWrite( pAttr->permissions ) )
  {
    // Insufficient authorization
    return ( ATT_ERR_INSUFFICIENT_AUTHOR );
  }
  
  if ( pAttr->type.len == ATT_BT_UUID_SIZE )
  {
    // 16-bit UUID
    uint16 uuid = BUILD_UINT16( pAttr->type.uuid[0], pAttr->type.uuid[1]);
    switch ( uuid )
    {
      case ROACHPROFILE_DIRECTION_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != ROACHPROFILE_DIRECTION_LEN )
          {
            status = ATT_ERR_INVALID_VALUE_SIZE;
          }
        }
        else
        {
          status = ATT_ERR_ATTR_NOT_LONG;
        }
        
        //Write the value
        if ( status == SUCCESS )
        {
          uint8 *pCurValue = (uint8 *)pAttr->pValue;        
          *pCurValue = pValue[0];

          notifyApp = ROACHPROFILE_DIRECTION;
        }
             
        break;
      case ROACHPROFILE_REPEATS_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != ROACHPROFILE_REPEATS_LEN )
          {
            status = ATT_ERR_INVALID_VALUE_SIZE;
          }
        }
        else
        {
          status = ATT_ERR_ATTR_NOT_LONG;
        }
        
        //Write the value
        if ( status == SUCCESS )
        {
          uint8 *pCurValue = (uint8 *)pAttr->pValue; 
          osal_memcpy(pCurValue, pValue, len);
          notifyApp = ROACHPROFILE_REPEATS;
        }
             
        break;
      case ROACHPROFILE_DURATION_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != ROACHPROFILE_DURATION_LEN )
          {
            status = ATT_ERR_INVALID_VALUE_SIZE;
          }
        }
        else
        {
          status = ATT_ERR_ATTR_NOT_LONG;
        }
        
        //Write the value
        if ( status == SUCCESS )
        {
          uint8 *pCurValue = (uint8 *)pAttr->pValue; 
          osal_memcpy(pCurValue, pValue, len);
          notifyApp = ROACHPROFILE_DURATION;
        }
      
      case GATT_CLIENT_CHAR_CFG_UUID:
        status = GATTServApp_ProcessCCCWriteReq( connHandle, pAttr, pValue, len,
                                                 offset, GATT_CLIENT_CFG_NOTIFY );
        break;
        
      default:
        // Should never get here! (characteristics 2 and 4 do not have write permissions)
        status = ATT_ERR_ATTR_NOT_FOUND;
        break;
    }
  }
  else
  {
    // 128-bit UUID
    status = ATT_ERR_INVALID_HANDLE;
  }

  // If a charactersitic value changed then callback function to notify application of change
  if ( (notifyApp != 0xFF ) && RoachProfile_AppCBs && RoachProfile_AppCBs->pfnRoachProfileChange )
  {
    RoachProfile_AppCBs->pfnRoachProfileChange( notifyApp );  
  }
  
  return ( status );
}

/*********************************************************************
 * @fn          ROACHPROFILE_HandleConnStatusCB
 *
 * @brief       Roach Profile link status change handler function.
 *
 * @param       connHandle - connection handle
 * @param       changeType - type of change
 *
 * @return      none
 */
static void RoachProfile_HandleConnStatusCB( uint16 connHandle, uint8 changeType )
{ 
  // Make sure this is not loopback connection
  if ( connHandle != LOOPBACK_CONNHANDLE )
  {
    // Reset Client Char Config if connection has dropped
    if ( ( changeType == LINKDB_STATUS_UPDATE_REMOVED )      ||
         ( ( changeType == LINKDB_STATUS_UPDATE_STATEFLAGS ) && 
           ( !linkDB_Up( connHandle ) ) ) )
    { 
    }
  }
}


/*********************************************************************
*********************************************************************/
