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

#ifdef ZDO_COORDINATOR

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

/*********************************************************************
 * MACROS
 */

/*********************************************************************
 * CONSTANTS
 */

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
uint8 uart_buffer[SERIAL_APP_TX_MAX+2+6];

// This list should be filled with Application specific Cluster IDs.
const cId_t RoachZStack_ClusterListIn[1] =
{
  ROACHZSTACK_CLUSTER_MIC,
};

// This list should be filled with Application specific Cluster IDs.
const cId_t RoachZStack_ClusterListOut[1] =
{
  ROACHZSTACK_CLUSTER_CMD,
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
static uint8 RoachZStack_TxSeq;
static uint8 RoachZStack_TxBuf[SERIAL_APP_TX_MAX+1];
static uint8 RoachZStack_TxLen;

static afAddrType_t RoachZStack_RxAddr;
static uint8 RoachZStack_RxSeq;
static uint8 RoachZStack_RspBuf[SERIAL_APP_RSP_CNT];
static bool startStreaming;

/*********************************************************************
 * LOCAL FUNCTIONS
 */

static void RoachZStack_ProcessZDOMsgs( zdoIncomingMsg_t *inMsg );
static void RoachZStack_HandleKeys( uint8 shift, uint8 keys );
static void RoachZStack_ProcessMSGCmd( afIncomingMSGPacket_t *pkt );
static void RoachZStack_Send(void);
static void RoachZStack_Resp(void);
static void RoachZStack_CallBack(uint8 port, uint8 event);
static void showMessage(void);

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
  halUARTCfg_t uartConfig;
  
  startStreaming = false;

  RoachZStack_TaskID = task_id;
  RoachZStack_RxSeq = 0xC3;

  afRegister( (endPointDesc_t *)&RoachZStack_epDesc );

  RegisterForKeys( task_id );

  uartConfig.configured           = TRUE;              // 2x30 don't care - see uart driver.
  uartConfig.baudRate             = SERIAL_APP_BAUD;
  uartConfig.flowControl          = TRUE;
  uartConfig.flowControlThreshold = SERIAL_APP_THRESH; // 2x30 don't care - see uart driver.
  uartConfig.rx.maxBufSize        = SERIAL_APP_RX_SZ;  // 2x30 don't care - see uart driver.
  uartConfig.tx.maxBufSize        = SERIAL_APP_TX_SZ;  // 2x30 don't care - see uart driver.
  uartConfig.idleTimeout          = SERIAL_APP_IDLE;   // 2x30 don't care - see uart driver.
  uartConfig.intEnable            = TRUE;              // 2x30 don't care - see uart driver.
  uartConfig.callBackFunc         = RoachZStack_CallBack;
  HalUARTOpen (SERIAL_APP_PORT, &uartConfig);

  
#if defined ( LCD_SUPPORTED )
  HalLcdWriteString( "RoachZStack", HAL_LCD_LINE_2 );
#endif
  
  ZDO_RegisterForZDOMsg( RoachZStack_TaskID, Match_Desc_req );
 
  
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
          
      case KEY_CHANGE:
        RoachZStack_HandleKeys( ((keyChange_t *)MSGpkt)->state, ((keyChange_t *)MSGpkt)->keys );
        break;

      case AF_INCOMING_MSG_CMD:
        RoachZStack_ProcessMSGCmd( MSGpkt );
        break;

      default:
        break;
      }

      osal_msg_deallocate( (uint8 *)MSGpkt );
    }

    return ( events ^ SYS_EVENT_MSG );
  }

  if ( events & ROACHZSTACK_SEND_EVT )
  {
    RoachZStack_Send();
    return ( events ^ ROACHZSTACK_SEND_EVT );
  }

  if ( events & ROACHZSTACK_RESP_EVT )
  {
    RoachZStack_Resp();
    return ( events ^ ROACHZSTACK_RESP_EVT );
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
    case End_Device_Bind_rsp:
      if ( ZDO_ParseBindRsp( inMsg ) == ZSuccess )
      {
        // Light LED
        HalLedSet( HAL_LED_4, HAL_LED_MODE_ON );
      }
#if defined(BLINK_LEDS)
      else
      {
        // Flash LED to show failure
        HalLedSet ( HAL_LED_4, HAL_LED_MODE_FLASH );
      }
#endif
      break;
      
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
            
            RegisterForADC( RoachZStack_TaskID );
            
            osal_stop_timerEx( RoachZStack_TaskID, RZS_DO_HANDSHAKE);
          }
          osal_mem_free( pRsp );
        }
      }
      break;
      
    case Match_Desc_req:
      RoachZStack_TxAddr.addrMode = (afAddrMode_t)Addr16Bit;
      RoachZStack_TxAddr.addr.shortAddr = inMsg->srcAddr.addr.shortAddr;
      RoachZStack_TxAddr.endPoint = ROACHZSTACK_ENDPOINT;
      
      break;
  }
}

/*********************************************************************
 * @fn      RoachZStack_HandleKeys
 *
 * @brief   Handles all key events for this device.
 *
 * @param   shift - true if in shift/alt.
 * @param   keys  - bit field for key events.
 *
 * @return  none
 */
void RoachZStack_HandleKeys( uint8 shift, uint8 keys )
{
  if ( shift )
  {
    if ( keys & HAL_KEY_SW_1 )
    {
    }
    if ( keys & HAL_KEY_SW_2 )
    {
    }
    if ( keys & HAL_KEY_SW_3 )
    {
    }
    if ( keys & HAL_KEY_SW_4 )
    {
    }
  }
  else
  {
    if ( keys & HAL_KEY_SW_1 )
    {
    }

    if ( keys & HAL_KEY_SW_2 )
    {
    }

    if ( keys & HAL_KEY_SW_3 )
    {
    }

    if ( keys & HAL_KEY_SW_4 )
    {

    }
  }
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
  uint8 stat;
  uint8 seqnb;
  uint8 delay;

  switch ( pkt->clusterId )
  {
  // A message with microphone data to be transmitted on the serial port.
  case ROACHZSTACK_CLUSTER_MIC:
    if (startStreaming)
    {
      // Store the address for sending and retrying.
      osal_memcpy(&RoachZStack_RxAddr, &(pkt->srcAddr), sizeof( afAddrType_t ));

      seqnb = pkt->cmd.Data[0];
  #ifdef LCD_SUPPORTED          
      HalLcdWriteValue ( pkt->nwkSeqNum, 16, HAL_LCD_LINE_3);
  #endif
      // Keep message if not a repeat packet
      if ( (seqnb > RoachZStack_RxSeq) ||                    // Normal
          ((seqnb < 0x80 ) && ( RoachZStack_RxSeq > 0x80)) ) // Wrap-around
      {
         uint16 size = pkt->cmd.DataLength-1;
        /*HalUARTWrite( SERIAL_APP_PORT, premic_signal, sizeof(premic_signal) );
       
        uart_buffer[0] = size & 0xff;
        uart_buffer[1] = size >> 8;
        osal_memcpy(uart_buffer+2, pkt->cmd.Data+1, size);*/
        // Transmit the data on the serial port.
        if ( HalUARTWrite( SERIAL_APP_PORT,  pkt->cmd.Data+1, size ) )
        {
          // Save for next incoming message
          RoachZStack_RxSeq = seqnb;
          stat = OTA_SUCCESS;
        }
        else
        {
          stat = OTA_SER_BUSY;
        }
      }
      else
      {
        
        stat = OTA_DUP_MSG;
      }

      // Select approproiate OTA flow-control delay.
      delay = (stat == OTA_SER_BUSY) ? ROACHZSTACK_NAK_DELAY : ROACHZSTACK_ACK_DELAY;

      // Build & send OTA response message.
      RoachZStack_RspBuf[0] = stat;
      RoachZStack_RspBuf[1] = seqnb;
      RoachZStack_RspBuf[2] = LO_UINT16( delay );
      RoachZStack_RspBuf[3] = HI_UINT16( delay );
      osal_set_event( RoachZStack_TaskID, ROACHZSTACK_RESP_EVT );
      osal_stop_timerEx(RoachZStack_TaskID, ROACHZSTACK_RESP_EVT);
    }
    break;

    default:
      break;
  }
}

static void showMessage(void)
{
  if (*(RoachZStack_TxBuf+1) == '*')
  {
    startStreaming = true;
  }
  stimCommand* cmd = parseCommand(RoachZStack_TxBuf+1, RoachZStack_TxLen);
  HalLcdWriteValue ( cmd->direction, 10, HAL_LCD_LINE_1);
  HalLcdWriteValue ( cmd->repeats, 10, HAL_LCD_LINE_2);
  HalLcdWriteValue ( cmd->duration, 10, HAL_LCD_LINE_3);
  osal_mem_free(cmd);
}

/*********************************************************************
 * @fn      RoachZStack_Send
 *
 * @brief   Send data OTA.
 *
 * @param   none
 *
 * @return  none
 */
static void RoachZStack_Send(void)
{
#if SERIAL_APP_LOOPBACK
  if (RoachZStack_TxLen < SERIAL_APP_TX_MAX)
  {
    RoachZStack_TxLen += HalUARTRead(SERIAL_APP_PORT, RoachZStack_TxBuf+RoachZStack_TxLen+1,
                                                    SERIAL_APP_TX_MAX-RoachZStack_TxLen);
  }

  if (RoachZStack_TxLen)
  {
    (void)RoachZStack_TxAddr;
    if (HalUARTWrite(SERIAL_APP_PORT, RoachZStack_TxBuf+1, RoachZStack_TxLen))
    {
      RoachZStack_TxLen = 0;
    }
    else
    {
      osal_set_event(RoachZStack_TaskID, ROACHZSTACK_SEND_EVT);
    }
  }
#else
  if (!RoachZStack_TxLen && 
      (RoachZStack_TxLen = HalUARTRead(SERIAL_APP_PORT, RoachZStack_TxBuf+1, SERIAL_APP_TX_MAX-1)))
  {
    // Pre-pend sequence number to the Tx message.
    RoachZStack_TxBuf[0] = ++RoachZStack_TxSeq;
  }
  
  if (RoachZStack_TxLen)
  {
    showMessage();
    afStatus_t status = AF_DataRequest(&RoachZStack_TxAddr,
                                           (endPointDesc_t *)&RoachZStack_epDesc,
                                            ROACHZSTACK_CLUSTER_CMD,
                                            RoachZStack_TxLen+1, RoachZStack_TxBuf,
                                            &RoachZStack_MsgID, 0, AF_DEFAULT_RADIUS);
    if (afStatus_SUCCESS != status)
    {
      HalLcdWriteValue ( status, 10, HAL_LCD_LINE_1);
      HalLcdWriteValue ( RoachZStack_TxLen, 10, HAL_LCD_LINE_2);
      osal_set_event(RoachZStack_TaskID, ROACHZSTACK_SEND_EVT);
    }
    else
    {
      RoachZStack_TxLen = 0;
    }
  }
#endif
}

/*********************************************************************
 * @fn      RoachZStack_Resp
 *
 * @brief   Send data OTA.
 *
 * @param   none
 *
 * @return  none
 */
static void RoachZStack_Resp(void)
{
  if (afStatus_SUCCESS != AF_DataRequest(&RoachZStack_RxAddr,
                                         (endPointDesc_t *)&RoachZStack_epDesc,
                                          ROACHZSTACK_CLUSTER_MIC,
                                          SERIAL_APP_RSP_CNT, RoachZStack_RspBuf,
                                         &RoachZStack_MsgID, 0, AF_DEFAULT_RADIUS))
  {
    osal_set_event(RoachZStack_TaskID, ROACHZSTACK_RESP_EVT);
  }
}

/*********************************************************************
 * @fn      RoachZStack_CallBack
 *
 * @brief   Send data OTA.
 *
 * @param   port - UART port.
 * @param   event - the UART port event flag.
 *
 * @return  none
 */
static void RoachZStack_CallBack(uint8 port, uint8 event)
{
  (void)port;

  if ((event & (HAL_UART_RX_FULL | HAL_UART_RX_ABOUT_FULL | HAL_UART_RX_TIMEOUT)) &&
#if SERIAL_APP_LOOPBACK
      (RoachZStack_TxLen < SERIAL_APP_TX_MAX))
#else
      !RoachZStack_TxLen)
#endif
  {
    RoachZStack_Send();
  }
}

/*********************************************************************
*********************************************************************/
#endif