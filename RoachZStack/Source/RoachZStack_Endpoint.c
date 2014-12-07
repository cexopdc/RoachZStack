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

#include "AF.h"
#include "OnBoard.h"
#include "OSAL_Tasks.h"
#include "RoachZStack.h"
#include "ZDApp.h"
#include "ZDObject.h"
#include "ZDProfile.h"

#include "hal_drivers.h"
#include "hal_key.h"
#include "hal_lcd.h"
#include "hal_led.h"
#include "hal_uart.h"
#include "RoachZStack_ADC.h"
#include "ZConfig.h"
#include "commands.h"
#include "stimulator.h"
#ifdef BIPHASIC_STIM
#include "spi.h"
#endif

/*********************************************************************
 * MACROS
 */

/*********************************************************************
 * CONSTANTS
 */

#define LEFT_PORT P1
#define LEFT_PIN 4
#define LEFT_2_PORT P1
#define LEFT_2_PIN 3
#define RIGHT_PORT P1
#define RIGHT_PIN 2
#define FORWARD_PORT P1
#define FORWARD_PIN 2 // temporary
#define LED_PORT P1
#define LED_PIN 5
#define BICLK_PORT P1
#define BICLK_PIN 7

#define FORWARD 'A'
#define BACK 1
#define RIGHT 2
#define LEFT 3
#define DIGIPOT 16

#if !defined( SERIAL_APP_PORT )
#define SERIAL_APP_PORT  0
#endif

#if !defined( SERIAL_APP_BAUD )
//#define SERIAL_APP_BAUD  HAL_UART_BR_38400
#define SERIAL_APP_BAUD  HAL_UART_BR_115200
#endif

// When the Rx buf space is less than this threshold, invoke the Rx callback.
#if !defined( SERIAL_APP_THRESH )
#define SERIAL_APP_THRESH  64
#endif

#if !defined( SERIAL_APP_RX_SZ )
#define SERIAL_APP_RX_SZ  128
#endif

#if !defined( SERIAL_APP_TX_SZ )
#define SERIAL_APP_TX_SZ  128
#endif

// Millisecs of idle time after a byte is received before invoking Rx callback.
#if !defined( SERIAL_APP_IDLE )
#define SERIAL_APP_IDLE  6
#endif

// Loopback Rx bytes to Tx for throughput testing.
#if !defined( SERIAL_APP_LOOPBACK )
#define SERIAL_APP_LOOPBACK  FALSE
#endif

// This is the max byte count per OTA message.
#if !defined( SERIAL_APP_TX_MAX )
#define SERIAL_APP_TX_MAX  99
#endif

#define SERIAL_APP_RSP_CNT  4

unsigned char premic_signal[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};



// This list should be filled with Application specific Cluster IDs.
const cId_t RoachZStack_ClusterListIn[1] =
{
  ROACHZSTACK_CLUSTER_CMD,
};

// This list should be filled with Application specific Cluster IDs.
const cId_t RoachZStack_ClusterListOut[1] =
{
  ROACHZSTACK_CLUSTER_MIC,
};

const SimpleDescriptionFormat_t RoachZStack_SimpleDesc =
{
  ROACHZSTACK_ENDPOINT,              //  int   Endpoint;
  ROACHZSTACK_PROFID,                //  uint16 AppProfId[2];
  ROACHZSTACK_DEVICEID,              //  uint16 AppDeviceId[2];
  ROACHZSTACK_DEVICE_VERSION,        //  int   AppDevVer:4;
  ROACHZSTACK_FLAGS,                 //  int   AppFlags:4;
  sizeof(RoachZStack_ClusterListIn),   //  byte  AppNumInClusters;
  (cId_t *)RoachZStack_ClusterListIn,  //  byte *pAppInClusterList;
  sizeof(RoachZStack_ClusterListOut),  //  byte  AppNumOutClusters;
  (cId_t *)RoachZStack_ClusterListOut  //  byte *pAppOutClusterList;
};

const endPointDesc_t RoachZStack_epDesc =
{
  ROACHZSTACK_ENDPOINT,
 &RoachZStack_TaskID,
  (SimpleDescriptionFormat_t *)&RoachZStack_SimpleDesc,
  noLatencyReqs
};

/*********************************************************************
 * TYPEDEFS
 */

/*********************************************************************
 * GLOBAL VARIABLES
 */

uint8 RoachZStack_TaskID;    // Task ID for internal task/event processing.

/*********************************************************************
 * EXTERNAL VARIABLES
 */

/*********************************************************************
 * EXTERNAL FUNCTIONS
 */

/*********************************************************************
 * LOCAL VARIABLES
 */

static uint8 RoachZStack_MsgID;

static afAddrType_t RoachZStack_TxAddr;
static uint8 RoachZStack_TxBuf[SERIAL_APP_TX_MAX];
static uint8 RoachZStack_TxLen;
static stimCommand* command = NULL;

/*********************************************************************
 * LOCAL FUNCTIONS
 */

static void RoachZStack_ProcessZDOMsgs( zdoIncomingMsg_t *inMsg );
static void RoachZStack_ProcessMSGCmd( afIncomingMSGPacket_t *pkt );
static void showMessage(afMSGCommandFormat_t data);

volatile uint8 allocCount = 0;
volatile uint8 deallocCount = 0;


/*********************************************************************
 * @fn      RoachZStack_Init
 *
 * @brief   This is called during OSAL tasks' initialization.
 *
 * @param   task_id - the Task ID assigned by OSAL.
 *
 * @return  none
 */
void RoachZStack_Init( uint8 task_id )
{
#ifdef BIPHASIC_STIM  
  SPI_Init();
#endif

  RoachZStack_TaskID = task_id;

  afRegister( (endPointDesc_t *)&RoachZStack_epDesc );
  
  RegisterForKeys( task_id );
  
  P1DIR |= (0x1 << FORWARD_PIN) | (0x1 << LED_PIN) | 
    (0x1 << LEFT_PIN) | (0x1 << RIGHT_PIN) | (0x1 << BICLK_PIN) | (0x1 << LEFT_2_PIN);
  
  LED_PORT &= ~(0x1 << LED_PIN);
  FORWARD_PORT &= ~(0x1 << FORWARD_PIN);
  LEFT_PORT &= ~(0x1 << LEFT_PIN);
  LEFT_2_PORT &= ~(0x1 << LEFT_2_PIN);
  RIGHT_PORT &= ~(0x1 << RIGHT_PIN);
  BICLK_PORT &= ~(0x1 << BICLK_PIN);
  
  
#if defined ( LCD_SUPPORTED )
  HalLcdWriteString( "RoachZStack", HAL_LCD_LINE_2 );
#endif
  
  ZDO_RegisterForZDOMsg( RoachZStack_TaskID, Match_Desc_rsp );
  
  //ZMacSetTransmitPower(TX_PWR_MINUS_22);
  
  osal_set_event(RoachZStack_TaskID, RZS_DO_HANDSHAKE );
  
}

/*********************************************************************
 * @fn      RoachZStack_ProcessEvent
 *
 * @brief   Generic Application Task event processor.
 *
 * @param   task_id  - The OSAL assigned task ID.
 * @param   events   - Bit map of events to process.
 *
 * @return  Event flags of all unprocessed events.
 */
UINT16 RoachZStack_ProcessEvent( uint8 task_id, UINT16 events )
{
  (void)task_id;  // Intentionally unreferenced parameter

  if ( events & SYS_EVENT_MSG )
  {
    afIncomingMSGPacket_t *MSGpkt;

    while ( (MSGpkt = (afIncomingMSGPacket_t *)osal_msg_receive( RoachZStack_TaskID )) )
    {
      switch ( MSGpkt->hdr.event )
      {
      case ZDO_CB_MSG:
        RoachZStack_ProcessZDOMsgs( (zdoIncomingMsg_t *)MSGpkt );
        break;

      case AF_INCOMING_MSG_CMD:
        RoachZStack_ProcessMSGCmd( MSGpkt );
        break;
  
      case RZS_ADC_VALUE: // set ADC input value
      {
        adcMsg_t* adcMsg = ((adcMsg_t*) MSGpkt);
        
        RoachZStack_TxLen = sizeof(adcMsg->buffer);
        if (RoachZStack_TxLen)
        {
          osal_memcpy( RoachZStack_TxBuf, adcMsg->buffer, sizeof(adcMsg->buffer) );
          HalLedSet(HAL_LED_4, HAL_LED_MODE_TOGGLE);
          afStatus_t s = AF_DataRequest(&RoachZStack_TxAddr,
                                                 (endPointDesc_t *)&RoachZStack_epDesc,
                                                  ROACHZSTACK_CLUSTER_MIC,
                                                  RoachZStack_TxLen, RoachZStack_TxBuf,
                                                  &RoachZStack_MsgID, AF_DISCV_ROUTE, AF_DEFAULT_RADIUS);
          deallocCount++;
        }
        break;
      }
      default:
        break;
      }

      osal_msg_deallocate( (uint8 *)MSGpkt );
    }

    return ( events ^ SYS_EVENT_MSG );
  }

  if ( events & RZS_DO_HANDSHAKE )
  {
    zAddrType_t txAddr;
    // Initiate a Match Description Request (Service Discovery)
    txAddr.addrMode = AddrBroadcast;
    txAddr.addr.shortAddr = NWK_BROADCAST_SHORTADDR;
    afStatus_t status = ZDP_MatchDescReq( &txAddr, NWK_BROADCAST_SHORTADDR,
                    ROACHZSTACK_PROFID,
                    sizeof(RoachZStack_ClusterListIn), (cId_t *)RoachZStack_ClusterListIn,
                    sizeof(RoachZStack_ClusterListOut), (cId_t *)RoachZStack_ClusterListOut,
                    FALSE );
    if (status != afStatus_SUCCESS)
    {
      osal_start_timerEx( RoachZStack_TaskID, RZS_DO_HANDSHAKE, 500); 
    }
    return ( events ^ RZS_DO_HANDSHAKE );
  }
  
  
  return ( 0 );  // Discard unknown events.
}

/*********************************************************************
 * @fn      RoachZStack_ProcessZDOMsgs()
 *
 * @brief   Process response messages
 *
 * @param   none
 *
 * @return  none
 */
static void RoachZStack_ProcessZDOMsgs( zdoIncomingMsg_t *inMsg )
{
  switch ( inMsg->clusterID )
  {
    
    case Match_Desc_rsp:
      {
        ZDO_ActiveEndpointRsp_t *pRsp = ZDO_ParseEPListRsp( inMsg );
        if ( pRsp )
        {
          if ( pRsp->status == ZSuccess && pRsp->cnt )
          {
            RoachZStack_TxAddr.addrMode = (afAddrMode_t)Addr16Bit;
            RoachZStack_TxAddr.addr.shortAddr = pRsp->nwkAddr;
            // Take the first endpoint, Can be changed to search through endpoints
            RoachZStack_TxAddr.endPoint = pRsp->epList[0];
            
            // Light LED
            HalLedSet( HAL_LED_4, HAL_LED_MODE_ON );
            
#ifdef AUDIO
            RegisterForADC( RoachZStack_TaskID );
#endif
          }
          osal_mem_free( pRsp );
        }
      }
      break;
  }
}
#define DIGIPOT_R 100000
static void showMessage(afMSGCommandFormat_t data)
{

  uint8 commandType  = data.Data[1]; // first transmitted char
  // intially only testing one output pin per command
  // final version will have 16 options for all stim possibilities
  
/*  
#ifdef BIPHASIC_STIM
  uint16 r;
  uint8 val;
  uint8 buf[2];
#endif
  switch (commandType)
  {
  case FORWARD:
  case RIGHT:
  case LEFT:
  case BACK:
    command = parseCommand(data.Data+1, data.DataLength-1);
    Stimulator_SetCommand(command);
    break;
  case DIGIPOT:
#ifdef BIPHASIC_STIM
    r = data.Data[2] + (data.Data[3]<<8);
    val = (int8)(r*255.0/DIGIPOT_R);
    buf[0] = 0x13;
    buf[1] = 255-val;
    SPI_Write(2, buf);
#endif
    break;
  }*/
}
/*********************************************************************
 * @fn      RoachZStack_ProcessMSGCmd
 *
 * @brief   Data message processor callback. This function processes
 *          any incoming data - probably from other devices. Based
 *          on the cluster ID, perform the intended action.
 *
 * @param   pkt - pointer to the incoming message packet
 *
 * @return  TRUE if the 'pkt' parameter is being used and will be freed later,
 *          FALSE otherwise.
 */
void RoachZStack_ProcessMSGCmd( afIncomingMSGPacket_t *pkt )
{
  switch ( pkt->clusterId )
  {

  // stimulation command
  case ROACHZSTACK_CLUSTER_CMD:
    //showMessage(pkt->cmd); // parse received data
    command = parseCommand(pkt->cmd.Data+1, pkt->cmd.DataLength-1);
    Stimulator_SetCommand(command);
    if (command != NULL)
    {
      osal_set_event(RoachZStack_TaskID, ROACHZSTACK_STIM_START );
    }
    default:
      break;
  }
}



/*********************************************************************
*********************************************************************/

#endif