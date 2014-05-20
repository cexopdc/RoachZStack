/**************************************************************************************************
  Filename:       simpleGATTprofile.c
  Revised:        $Date: 2013-05-06 13:33:47 -0700 (Mon, 06 May 2013) $
  Revision:       $Revision: 34153 $

  Description:    This file contains the Simple GATT profile sample GATT service 
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

#include "edemaProfile.h"

/*********************************************************************
 * MACROS
 */

/*********************************************************************
 * CONSTANTS
 */

#define SERVAPP_NUM_ATTR_SUPPORTED        38

/*********************************************************************
 * TYPEDEFS
 */

/*********************************************************************
 * GLOBAL VARIABLES
 */
// Simple GATT Profile Service UUID: 0xFFF0
CONST uint8 EdemaProfileServUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_SERV_UUID), HI_UINT16(EDEMAPROFILE_SERV_UUID)
};

// Characteristic 1 UUID: 0xFFF1
CONST uint8 EdemaProfilechar1UUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_CHAR1_UUID), HI_UINT16(EDEMAPROFILE_CHAR1_UUID)
};

// Characteristic 2 UUID: 0xFFF2
CONST uint8 EdemaProfilechar2UUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_CHAR2_UUID), HI_UINT16(EDEMAPROFILE_CHAR2_UUID)
};

// Characteristic 3 UUID: 0xFFF3
CONST uint8 EdemaProfilechar3UUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_CHAR3_UUID), HI_UINT16(EDEMAPROFILE_CHAR3_UUID)
};

// Characteristic 4 UUID: 0xFFF4
CONST uint8 EdemaProfilechar4UUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_SWEEP_DONE_UUID), HI_UINT16(EDEMAPROFILE_SWEEP_DONE_UUID)
};

// Characteristic 5 UUID: 0xFFF5
CONST uint8 EdemaProfileSweepDataUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_SWEEPDATA_UUID), HI_UINT16(EDEMAPROFILE_SWEEPDATA_UUID)
};

// Characteristic 5 UUID: 0xFFF6
CONST uint8 EdemaProfileSweepData2UUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_SWEEPDATA2_UUID), HI_UINT16(EDEMAPROFILE_SWEEPDATA2_UUID)
};

// Start freq UUID: 0xFFF7
CONST uint8 EdemaProfileStartFreqUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_STARTFREQ_UUID), HI_UINT16(EDEMAPROFILE_STARTFREQ_UUID)
};

// Num freq UUID: 0xFFF8
CONST uint8 EdemaProfileNumFreqUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_NUMFREQ_UUID), HI_UINT16(EDEMAPROFILE_NUMFREQ_UUID)
};

// Inc freq UUID: 0xFFF9
CONST uint8 EdemaProfileIncFreqUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_INCFREQ_UUID), HI_UINT16(EDEMAPROFILE_INCFREQ_UUID)
};

// Range UUID: 0xFFFA
CONST uint8 EdemaProfileRangeUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_RANGE_UUID), HI_UINT16(EDEMAPROFILE_RANGE_UUID)
};

// Gain UUID: 0xFFFB
CONST uint8 EdemaProfileGainUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_GAIN_UUID), HI_UINT16(EDEMAPROFILE_GAIN_UUID)
};

// Electrodes UUID: 0xFFFC
CONST uint8 EdemaProfileElectrodesUUID[ATT_BT_UUID_SIZE] =
{ 
  LO_UINT16(EDEMAPROFILE_ELECTRODES_UUID), HI_UINT16(EDEMAPROFILE_ELECTRODES_UUID)
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

static edemaProfileCBs_t *EdemaProfile_AppCBs = NULL;

/*********************************************************************
 * Profile Attributes - variables
 */

// Simple Profile Service attribute
static CONST gattAttrType_t EdemaProfileService = { ATT_BT_UUID_SIZE, EdemaProfileServUUID };


// Simple Profile Characteristic 1 Properties
static uint8 EdemaProfileChar1Props = GATT_PROP_READ | GATT_PROP_WRITE;

// Characteristic 1 Value
static uint8 EdemaProfileChar1 = 0;

// Simple Profile Characteristic 1 User Description
static uint8 EdemaProfileChar1UserDesp[17] = "Characteristic 1\0";


// Simple Profile Characteristic 2 Properties
static uint8 EdemaProfileChar2Props = GATT_PROP_READ;

// Characteristic 2 Value
static uint8 EdemaProfileChar2 = 0;

// Simple Profile Characteristic 2 User Description
static uint8 EdemaProfileChar2UserDesp[17] = "Characteristic 2\0";


// Simple Profile Characteristic 3 Properties
static uint8 EdemaProfileChar3Props = GATT_PROP_WRITE;

// Characteristic 3 Value
static uint8 EdemaProfileChar3 = 0;

// Simple Profile Characteristic 3 User Description
static uint8 EdemaProfileChar3UserDesp[17] = "Characteristic 3\0";


// Simple Profile Characteristic 4 Properties
static uint8 EdemaProfileChar4Props = GATT_PROP_NOTIFY;

// Characteristic 4 Value
static uint8 EdemaProfileChar4[EDEMAPROFILE_SWEEP_DONE_LEN];

// Simple Profile Characteristic 4 Configuration Each client has its own
// instantiation of the Client Characteristic Configuration. Reads of the
// Client Characteristic Configuration only shows the configuration for
// that client and writes only affect the configuration of that client.
static gattCharCfg_t EdemaProfileChar4Config[GATT_MAX_NUM_CONN];
                                        
// Simple Profile Characteristic 4 User Description
static uint8 EdemaProfileChar4UserDesp[17] = "Characteristic 4\0";


// Simple Profile Characteristic 5 Properties
static uint8 EdemaProfileSweepDataProps = GATT_PROP_READ;

// Characteristic 5 Value
static uint8 EdemaProfileSweepData[EDEMAPROFILE_SWEEPDATA_LEN];

// Simple Profile Characteristic 5 User Description
static uint8 EdemaProfileSweepDataUserDesp[17] = "SweepData       \0";



// Simple Profile Characteristic 5 Properties
static uint8 EdemaProfileSweepData2Props = GATT_PROP_READ;

// Characteristic 5 Value
static uint8 EdemaProfileSweepData2[EDEMAPROFILE_SWEEPDATA_LEN];

// Simple Profile Characteristic 5 User Description
static uint8 EdemaProfileSweepData2UserDesp[17] = "SweepData 2     \0";


// Simple Profile Start Freq Properties
static uint8 EdemaProfileStartFreqProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Start Freq Value
static unsigned long EdemaProfileStartFreq;

// Simple Profile Start Freq User Description
static uint8 EdemaProfileStartFreqUserDesp[17] = "Start Frequency \0";


// Simple Profile Num Freq Properties
static uint8 EdemaProfileNumFreqProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Num Freq Value
static uint8 EdemaProfileNumFreq[EDEMAPROFILE_NUMFREQ_LEN];

// Simple Profile Num Freq User Description
static uint8 EdemaProfileNumFreqUserDesp[17] = "Num   Frequency \0";


// Simple Profile Inc Freq Properties
static uint8 EdemaProfileIncFreqProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Inc Freq Value
static unsigned long EdemaProfileIncFreq;

// Simple Profile Inc Freq User Description
static uint8 EdemaProfileIncFreqUserDesp[17] = "Inc   Frequency \0";


// Simple Profile Range Properties
static uint8 EdemaProfileRangeProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Range Value
static uint8 EdemaProfileRange;

// Simple Profile Range User Description
static uint8 EdemaProfileRangeUserDesp[17] = "Range           \0";

// Simple Profile Gain Properties
static uint8 EdemaProfileGainProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Gain Value
static uint8 EdemaProfileGain;

// Simple Profile Gain User Description
static uint8 EdemaProfileGainUserDesp[17] = "Gain            \0";

// Simple Profile Electrodes Properties
static uint8 EdemaProfileElectrodesProps = GATT_PROP_READ | GATT_PROP_WRITE;

// Gain Value
static uint8 EdemaProfileElectrodes;

// Simple Profile Gain User Description
static uint8 EdemaProfileElectrodesUserDesp[17] = "Electrodes      \0";
/*********************************************************************
 * Profile Attributes - Table
 */

static gattAttribute_t EdemaProfileAttrTbl[SERVAPP_NUM_ATTR_SUPPORTED] = 
{
  // Simple Profile Service
  { 
    { ATT_BT_UUID_SIZE, primaryServiceUUID }, /* type */
    GATT_PERMIT_READ,                         /* permissions */
    0,                                        /* handle */
    (uint8 *)&EdemaProfileService            /* pValue */
  },

    // Characteristic 1 Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileChar1Props 
    },

      // Characteristic Value 1
      { 
        { ATT_BT_UUID_SIZE, EdemaProfilechar1UUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        &EdemaProfileChar1 
      },

      // Characteristic 1 User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileChar1UserDesp 
      },      

    // Characteristic 2 Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileChar2Props 
    },

      // Characteristic Value 2
      { 
        { ATT_BT_UUID_SIZE, EdemaProfilechar2UUID },
        GATT_PERMIT_READ, 
        0, 
        &EdemaProfileChar2 
      },

      // Characteristic 2 User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileChar2UserDesp 
      },           
      
    // Characteristic 3 Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileChar3Props 
    },

      // Characteristic Value 3
      { 
        { ATT_BT_UUID_SIZE, EdemaProfilechar3UUID },
        GATT_PERMIT_WRITE, 
        0, 
        &EdemaProfileChar3 
      },

      // Characteristic 3 User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileChar3UserDesp 
      },

    // Characteristic 4 Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileChar4Props 
    },

      // Characteristic Value 4
      { 
        { ATT_BT_UUID_SIZE, EdemaProfilechar4UUID },
        0, 
        0, 
        EdemaProfileChar4 
      },

      // Characteristic 4 configuration
      { 
        { ATT_BT_UUID_SIZE, clientCharCfgUUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        (uint8 *)EdemaProfileChar4Config 
      },
      
      // Characteristic 4 User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileChar4UserDesp 
      },
      
    // Characteristic 5 Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileSweepDataProps 
    },

      // Characteristic Value 5
      { 
        { ATT_BT_UUID_SIZE, EdemaProfileSweepDataUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileSweepData
      },

      // Characteristic 5 User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileSweepDataUserDesp 
      },
      
    // Characteristic 5 Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileSweepData2Props 
    },

      // Characteristic Value 5
      { 
        { ATT_BT_UUID_SIZE, EdemaProfileSweepData2UUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileSweepData2
      },

      // Characteristic 5 User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileSweepData2UserDesp 
      },

     // Start Freq Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileStartFreqProps 
    },

      // Start Freq Value
      { 
        { ATT_BT_UUID_SIZE, EdemaProfileStartFreqUUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        (unsigned char*)&EdemaProfileStartFreq 
      },

      // Start Freq User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileStartFreqUserDesp 
      },      

     // Num Freq Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileNumFreqProps 
    },

      // Num Freq Value
      { 
        { ATT_BT_UUID_SIZE, EdemaProfileNumFreqUUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        EdemaProfileNumFreq 
      },

      // Num Freq User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileNumFreqUserDesp 
      },   
      
    // Inc Freq Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileIncFreqProps 
    },

      // Inc Freq Value
      { 
        { ATT_BT_UUID_SIZE, EdemaProfileIncFreqUUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        (unsigned char*) &EdemaProfileIncFreq 
      },

      // Inc Freq User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileIncFreqUserDesp 
      },   
      
     // Range Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileRangeProps 
    },

      // Range Value
      { 
        { ATT_BT_UUID_SIZE, EdemaProfileRangeUUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        &EdemaProfileRange
      },

      // Range User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileRangeUserDesp 
      },   
      
    // Gain Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileGainProps 
    },

      // Gain Value
      { 
        { ATT_BT_UUID_SIZE, EdemaProfileGainUUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        &EdemaProfileGain
      },

      // Gain User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileGainUserDesp 
      },   
    // Electrodes Declaration
    { 
      { ATT_BT_UUID_SIZE, characterUUID },
      GATT_PERMIT_READ, 
      0,
      &EdemaProfileElectrodesProps 
    },

      // Electrodes Value
      { 
        { ATT_BT_UUID_SIZE, EdemaProfileElectrodesUUID },
        GATT_PERMIT_READ | GATT_PERMIT_WRITE, 
        0, 
        &EdemaProfileElectrodes
      },

      // Electrodes User Description
      { 
        { ATT_BT_UUID_SIZE, charUserDescUUID },
        GATT_PERMIT_READ, 
        0, 
        EdemaProfileElectrodesUserDesp 
      },   
};


/*********************************************************************
 * LOCAL FUNCTIONS
 */
static uint8 EdemaProfile_ReadAttrCB( uint16 connHandle, gattAttribute_t *pAttr, 
                            uint8 *pValue, uint8 *pLen, uint16 offset, uint8 maxLen );
static bStatus_t EdemaProfile_WriteAttrCB( uint16 connHandle, gattAttribute_t *pAttr,
                                 uint8 *pValue, uint8 len, uint16 offset );

static void EdemaProfile_HandleConnStatusCB( uint16 connHandle, uint8 changeType );


/*********************************************************************
 * PROFILE CALLBACKS
 */
// Simple Profile Service Callbacks
CONST gattServiceCBs_t EdemaProfileCBs =
{
  EdemaProfile_ReadAttrCB,  // Read callback function pointer
  EdemaProfile_WriteAttrCB, // Write callback function pointer
  NULL                       // Authorization callback function pointer
};

/*********************************************************************
 * PUBLIC FUNCTIONS
 */

/*********************************************************************
 * @fn      EdemaProfile_AddService
 *
 * @brief   Initializes the Simple Profile service by registering
 *          GATT attributes with the GATT server.
 *
 * @param   services - services to add. This is a bit map and can
 *                     contain more than one service.
 *
 * @return  Success or Failure
 */
bStatus_t EdemaProfile_AddService( uint32 services )
{
  uint8 status = SUCCESS;

  // Initialize Client Characteristic Configuration attributes
  GATTServApp_InitCharCfg( INVALID_CONNHANDLE, EdemaProfileChar4Config );

  // Register with Link DB to receive link status change callback
  VOID linkDB_Register( EdemaProfile_HandleConnStatusCB );  
  
  if ( services & EDEMAPROFILE_SERVICE )
  {
    // Register GATT attribute list and CBs with GATT Server App
    status = GATTServApp_RegisterService( EdemaProfileAttrTbl, 
                                          GATT_NUM_ATTRS( EdemaProfileAttrTbl ),
                                          &EdemaProfileCBs );
  }

  return ( status );
}


/*********************************************************************
 * @fn      EdemaProfile_RegisterAppCBs
 *
 * @brief   Registers the application callback function. Only call 
 *          this function once.
 *
 * @param   callbacks - pointer to application callbacks.
 *
 * @return  SUCCESS or bleAlreadyInRequestedMode
 */
bStatus_t EdemaProfile_RegisterAppCBs( edemaProfileCBs_t *appCallbacks )
{
  if ( appCallbacks )
  {
    EdemaProfile_AppCBs = appCallbacks;
    
    return ( SUCCESS );
  }
  else
  {
    return ( bleAlreadyInRequestedMode );
  }
}
  

/*********************************************************************
 * @fn      EdemaProfile_SetParameter
 *
 * @brief   Set a Simple Profile parameter.
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
bStatus_t EdemaProfile_SetParameter( uint8 param, unsigned int len, void *value )
{
  bStatus_t ret = SUCCESS;
  switch ( param )
  {
    case EDEMAPROFILE_CHAR1:
      if ( len == sizeof ( uint8 ) ) 
      {
        EdemaProfileChar1 = *((uint8*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;

    case EDEMAPROFILE_CHAR2:
      if ( len == sizeof ( uint8 ) ) 
      {
        EdemaProfileChar2 = *((uint8*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;

    case EDEMAPROFILE_CHAR3:
      if ( len == sizeof ( uint8 ) ) 
      {
        EdemaProfileChar3 = *((uint8*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;

    case EDEMAPROFILE_SWEEP_DONE:
      if ( len == EDEMAPROFILE_SWEEP_DONE_LEN ) 
      {
        osal_memcpy(EdemaProfileChar4, value, len);
        
        // See if Notification has been enabled
        ret = GATTServApp_ProcessCharCfg( EdemaProfileChar4Config, EdemaProfileChar4, FALSE,
                                    EdemaProfileAttrTbl, GATT_NUM_ATTRS( EdemaProfileAttrTbl ),
                                    INVALID_TASK_ID );
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;

    case EDEMAPROFILE_SWEEPDATA:
      if ( len == EDEMAPROFILE_SWEEPDATA_LEN ) 
      {
        VOID osal_memcpy( EdemaProfileSweepData, value, EDEMAPROFILE_SWEEPDATA_LEN );
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;
      
    case EDEMAPROFILE_SWEEPDATA2:
      if ( len == EDEMAPROFILE_SWEEPDATA_LEN ) 
      {
        VOID osal_memcpy( EdemaProfileSweepData2, value, EDEMAPROFILE_SWEEPDATA_LEN );
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;
      
    case EDEMAPROFILE_STARTFREQ:
      if ( len == EDEMAPROFILE_STARTFREQ_LEN ) 
      {
        EdemaProfileStartFreq = *((unsigned long*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;
      
    case EDEMAPROFILE_INCFREQ:
      if ( len == EDEMAPROFILE_INCFREQ_LEN ) 
      {
        EdemaProfileIncFreq = *((unsigned long*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;
      
    case EDEMAPROFILE_NUMFREQ:
      if ( len == EDEMAPROFILE_NUMFREQ_LEN ) 
      {
        VOID osal_memcpy( EdemaProfileNumFreq, value, EDEMAPROFILE_NUMFREQ_LEN );
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;
      
    case EDEMAPROFILE_RANGE:
      if ( len == EDEMAPROFILE_RANGE_LEN ) 
      {
        EdemaProfileRange = *((uint8*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;
      
    case EDEMAPROFILE_GAIN:
      if ( len == EDEMAPROFILE_GAIN_LEN ) 
      {
        EdemaProfileGain = *((uint8*)value);
      }
      else
      {
        ret = bleInvalidRange;
      }
      break;
      
  case EDEMAPROFILE_ELECTRODES:
      if ( len == EDEMAPROFILE_ELECTRODES_LEN ) 
      {
        EdemaProfileElectrodes = *((uint8*)value);
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
 * @fn      EdemaProfile_GetParameter
 *
 * @brief   Get a Simple Profile parameter.
 *
 * @param   param - Profile parameter ID
 * @param   value - pointer to data to put.  This is dependent on
 *          the parameter ID and WILL be cast to the appropriate 
 *          data type (example: data type of uint16 will be cast to 
 *          uint16 pointer).
 *
 * @return  bStatus_t
 */
bStatus_t EdemaProfile_GetParameter( uint8 param, void *value )
{
  bStatus_t ret = SUCCESS;
  switch ( param )
  {
    case EDEMAPROFILE_CHAR1:
      *((uint8*)value) = EdemaProfileChar1;
      break;

    case EDEMAPROFILE_CHAR2:
      *((uint8*)value) = EdemaProfileChar2;
      break;      

    case EDEMAPROFILE_CHAR3:
      *((uint8*)value) = EdemaProfileChar3;
      break;  

    case EDEMAPROFILE_SWEEP_DONE:
      osal_memcpy(value, EdemaProfileChar4, sizeof(EdemaProfileChar4));
      break;

    case EDEMAPROFILE_SWEEPDATA:
      VOID osal_memcpy( value, EdemaProfileSweepData, EDEMAPROFILE_SWEEPDATA_LEN );
      break;      
    
    case EDEMAPROFILE_SWEEPDATA2:
      VOID osal_memcpy( value, EdemaProfileSweepData2, EDEMAPROFILE_SWEEPDATA_LEN );
      break;    
         
    case EDEMAPROFILE_STARTFREQ:
      *((unsigned long*)value) = EdemaProfileStartFreq;
      break;
      
    case EDEMAPROFILE_NUMFREQ:
      VOID osal_memcpy( value, EdemaProfileNumFreq, EDEMAPROFILE_NUMFREQ_LEN );
      break;
      
    case EDEMAPROFILE_INCFREQ:
      *((unsigned long*)value) = EdemaProfileIncFreq;
      break;  
      
    case EDEMAPROFILE_RANGE:
      *((unsigned char*)value) = EdemaProfileRange;
      break;     
      
    case EDEMAPROFILE_GAIN:
      *((unsigned char*)value) = EdemaProfileGain;
      break;
      
    case EDEMAPROFILE_ELECTRODES:
      *((unsigned char*)value) = EdemaProfileElectrodes;
      break;
      
    default:
      ret = INVALIDPARAMETER;
      break;
  }
  
  return ( ret );
}

/*********************************************************************
 * @fn          EdemaProfile_ReadAttrCB
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
static uint8 EdemaProfile_ReadAttrCB( uint16 connHandle, gattAttribute_t *pAttr, 
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

      // characteristics 1 and 2 have read permissions
      // characteritisc 3 does not have read permissions; therefore it is not
      //   included here
      // characteristic 4 does not have read permissions, but because it
      //   can be sent as a notification, it is included here
      case EDEMAPROFILE_CHAR1_UUID:
      case EDEMAPROFILE_CHAR2_UUID:
        if ( offset > 0 )
        {
          return ( ATT_ERR_ATTR_NOT_LONG );
        }
        *pLen = 1;
        pValue[0] = *pAttr->pValue;
        break;

      case EDEMAPROFILE_SWEEP_DONE_UUID:
        if ( offset > 0 )
        {
          return ( ATT_ERR_ATTR_NOT_LONG );
        }
        *pLen = EDEMAPROFILE_SWEEP_DONE_LEN;
        VOID osal_memcpy( pValue, pAttr->pValue, EDEMAPROFILE_SWEEP_DONE_LEN );
        break;
      case EDEMAPROFILE_SWEEPDATA_UUID:
      case EDEMAPROFILE_SWEEPDATA2_UUID:
      {
        uint8 len = maxLen;
        if (offset + maxLen > EDEMAPROFILE_SWEEPDATA_LEN)
        {
          len = EDEMAPROFILE_SWEEPDATA_LEN - offset;
        }
        *pLen = len;
        VOID osal_memcpy( pValue, pAttr->pValue + offset, len );
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
 * @fn      EdemaProfile_WriteAttrCB
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
static bStatus_t EdemaProfile_WriteAttrCB( uint16 connHandle, gattAttribute_t *pAttr,
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
      case EDEMAPROFILE_CHAR1_UUID:
      case EDEMAPROFILE_CHAR3_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != 1 )
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

          if( pAttr->pValue == &EdemaProfileChar1 )
          {
            notifyApp = EDEMAPROFILE_CHAR1;        
          }
          else
          {
            notifyApp = EDEMAPROFILE_CHAR3;           
          }
        }
             
        break;
      case EDEMAPROFILE_STARTFREQ_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != EDEMAPROFILE_STARTFREQ_LEN )
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
          notifyApp = EDEMAPROFILE_STARTFREQ;
        }
             
        break;
      case EDEMAPROFILE_NUMFREQ_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != EDEMAPROFILE_NUMFREQ_LEN )
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
          notifyApp = EDEMAPROFILE_NUMFREQ;
        }
             
        break;
      case EDEMAPROFILE_INCFREQ_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != EDEMAPROFILE_INCFREQ_LEN )
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
          notifyApp = EDEMAPROFILE_INCFREQ;
        }
             
        break;
        
      case EDEMAPROFILE_RANGE_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != EDEMAPROFILE_RANGE_LEN )
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
          notifyApp = EDEMAPROFILE_RANGE;
        }
             
        break;
      
      case EDEMAPROFILE_GAIN_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != EDEMAPROFILE_GAIN_LEN )
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
          notifyApp = EDEMAPROFILE_GAIN;
        }
             
        break;
        
      case EDEMAPROFILE_ELECTRODES_UUID:

        //Validate the value
        // Make sure it's not a blob oper
        if ( offset == 0 )
        {
          if ( len != EDEMAPROFILE_ELECTRODES_LEN )
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
          notifyApp = EDEMAPROFILE_ELECTRODES;
        }
             
        break;
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
  if ( (notifyApp != 0xFF ) && EdemaProfile_AppCBs && EdemaProfile_AppCBs->pfnEdemaProfileChange )
  {
    EdemaProfile_AppCBs->pfnEdemaProfileChange( notifyApp );  
  }
  
  return ( status );
}

/*********************************************************************
 * @fn          EDEMAPROFILE_HandleConnStatusCB
 *
 * @brief       Simple Profile link status change handler function.
 *
 * @param       connHandle - connection handle
 * @param       changeType - type of change
 *
 * @return      none
 */
static void EdemaProfile_HandleConnStatusCB( uint16 connHandle, uint8 changeType )
{ 
  // Make sure this is not loopback connection
  if ( connHandle != LOOPBACK_CONNHANDLE )
  {
    // Reset Client Char Config if connection has dropped
    if ( ( changeType == LINKDB_STATUS_UPDATE_REMOVED )      ||
         ( ( changeType == LINKDB_STATUS_UPDATE_STATEFLAGS ) && 
           ( !linkDB_Up( connHandle ) ) ) )
    { 
      GATTServApp_InitCharCfg( connHandle, EdemaProfileChar4Config );
    }
  }
}


/*********************************************************************
*********************************************************************/
