/*
 * Copyright (c) 2007, Swedish Institute of Computer Science.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the Institute nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * This file is part of the Contiki operating system.
 *
 */

/**
 * \file
 *         Testing the Unicast layer in Rime with contentions of CSMA and relialbe transmission
 * \author
 *         fgong <fgong@ncsu.edu>
 */

#include "contiki.h"
#include "net/rime.h"
#include "net/mac/frame802154.h"
#include "random.h"

#include "dev/button-sensor.h"

#include "dev/leds.h"

#include <stdio.h>
#include <string.h>
#include "net/mac/mac.h" /*for MAC-return values_fgong*/

#define PAYLOAD_MAX "Hello_North_Carolina_State_UniversityHello_North_Carolina_State_UniversityHello_North_Carolina_State_Univer" 
/*MAXIMUM Payload (112bytes,including the last byte of NULL character) of the transmitted msg in broadcast can not be used in Unicast, probablity due to unicast address, the maximum payload is 110bytes! But after adding the PKT_ID attribute, the maximum payload reduces to 108 bytes! Actually, maybe dueto PKT attribute?*/
//#define PAYLOAD "hello"
#define PAYLOAD_ARR "HHHHHHHHH", "HHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", PAYLOAD_MAX  /*The payload array that consists 10:10:100,108 bytes of payload*/
#define PAYLOAD_ARR_LEN 11 /*The number of variable length payloads*/ 
#define TOTPKT 100 /*Total number of transmitted packets*/
#define TOTCNT 1  /*Total number of the timer fraction array*/
#define CNTBASE 4  /*Multipy factor to avoid pow() function call*/
#define DIVBASE 0  /*Index to change from division to multiplication of the CNTBASE*/
#define LOOPCNT 1 /*Total number of experimental trials*/
#define FACTOR  0.000001 /*The timer period of the transmission, push_mode does not work for unicast*/
//#define FACTOR 0.125
#define OVERFLOW_NUM 65535 /*rtimer_clock_t overflow max_number*/
#define MAX_TRANSMISSION 10 
/*Enable Reliable Transmission*/
#define RELIABLE_TX_FGONG 1
//#define QUEUE_BUFFER_USE 1
#define fgong_DEBUG_STATUS 1
#define fgong_DEBUG_LOG 1
#define fgong_LOOP 1
#undef fgong_LOOP
#define fgong_LOOP_AUTO 1
#define PAYLOAD_CHOICE 0 /*From 0 to 10, as the index of payload array*/
/*---------------------------------------------------------------------------*/
PROCESS(example_unicast_process, "Unicast Throughput test");
AUTOSTART_PROCESSES(&example_unicast_process);
/*---------------------------------------------------------------------------*/
static char* payload_arr[] = {PAYLOAD_ARR};
static char* PAYLOAD = NULL; 
static uint8_t recPktTag=0;
static int totCount = TOTPKT,i;
static unsigned long counterTime = 0U;
static rtimer_clock_t rt_now, rt_prev, rt_diff;
/*Reliable Transmission Use below*/
static uint8_t reTxcounter=MAX_TRANSMISSION;
static struct queuebuf *q;
static uint8_t tx_status=MAC_TX_OK;
static uint8_t pktSeqNo=0;
static uint16_t NRtimeOut=0, NRtx=0; //number of time out packets and total transmitted packets
#ifdef fgong_DEBUG_STATUS
static int cnt_macTx_ok=0,cnt_macTx_col=0,cnt_macTx_noAck=0,cnt_macTx_defer=0,cnt_macTx_err=0,cnt_macTx_fatal_err=0;
#endif
#ifdef fgong_DEBUG_LOG
#define MAX_LOG_ENTRY 2050
struct logseqno {
  uint8_t status;
  uint8_t seqno;
};
static struct logseqno sent_logs[MAX_LOG_ENTRY];
static uint16_t total_cnt=0;
#endif

static void
recv_uc(struct unicast_conn *c, const rimeaddr_t *from)
{
   //if (from->u8[0]==13 && strcmp((char *)packetbuf_dataptr(), "YES")==0)
   if(from->u8[0] == 13)
	recPktTag = 1;
}

static void
sent_by_uc(struct unicast_conn *c, int status, int num_tx)
{
        tx_status = (uint8_t)status;
#ifdef fgong_DEBUG_STATUS
	switch(status){
        case MAC_TX_OK: cnt_macTx_ok++; break;                 /*0*/
        case MAC_TX_COLLISION:  cnt_macTx_col++; break;        /*1*/
        case MAC_TX_NOACK:  cnt_macTx_noAck++; break;          /*2*/
        case MAC_TX_DEFERRED:  cnt_macTx_defer++; break;       /*3*/
        case MAC_TX_ERR:  cnt_macTx_err++; break;              /*4*/
        case MAC_TX_ERR_FATAL:  cnt_macTx_fatal_err++; break;  /*5*/
  	}

#endif
}

static const struct unicast_callbacks unicast_callbacks = {recv_uc, sent_by_uc};
static struct unicast_conn uc;
static rimeaddr_t addr;
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(example_unicast_process, ev, data)
{
  static struct etimer et;
  static uint8_t cnt,trial_cnt;
  //static uint8_t factor[TOTCNT] = {4,1,2,4,8,16,32,64,90,100,128};
  PROCESS_EXITHANDLER(unicast_close(&uc);)

  PROCESS_BEGIN();

  unicast_open(&uc, 146, &unicast_callbacks); 
  /* Activate the button sensor. We use the button to drive traffic -
     when the button is pressed, a packet is sent. */
  SENSORS_ACTIVATE(button_sensor);
  printf("Before Button\n");
  printf("sizeof(frame802154_t)=%u\n", sizeof(frame802154_t));
  leds_on(LEDS_RED);
#ifdef fgong_LOOP_AUTO //automatically starts after receiving from receiver
  while(1){
    etimer_set(&et, 0.01*CLOCK_SECOND); //seems that lower than 0.01s is hard to receive the packet
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
    if (recPktTag == 1)
        break;
  }
#endif
  /* Wait until we get a sensor event with the button sensor as data. */
  //PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event && data == &button_sensor);
  etimer_set(&et, CLOCK_SECOND); 
  PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
  leds_off(LEDS_RED);

  for(trial_cnt=0;trial_cnt<LOOPCNT;trial_cnt++){
#ifdef fgong_LOOP
  for(cnt=0;cnt<PAYLOAD_ARR_LEN;cnt++){
  PAYLOAD = payload_arr[cnt];
#else
  for(cnt=0;cnt<1;cnt++){
  PAYLOAD = payload_arr[PAYLOAD_CHOICE];
#endif
  totCount = TOTPKT;
  leds_off(LEDS_YELLOW);
  pktSeqNo = (unsigned short)random_rand()%256; //randomize the initial sequence number
  while(totCount) {
    /* Delay 2-4 seconds */
    //etimer_set(&et, CLOCK_SECOND * 4 + random_rand() % (CLOCK_SECOND * 4));
    //etimer_set(&et, cnt<=DIVBASE ? CLOCK_SECOND*(factor[cnt]/CNTBASE) : CLOCK_SECOND/(factor[cnt]*CNTBASE));
    /*PROBLEM: Push sender to send back to back, thus no need to set timer
               But once not setting timer, the program crashes and restarts :-(
    */
    etimer_set(&et, CLOCK_SECOND*FACTOR); /*load factor*/

    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

    packetbuf_copyfrom(PAYLOAD, (strlen(PAYLOAD)+1));/*Set payload, +1 for the NULL character*/
#ifdef RELIABLE_TX_FGONG
    /*PREPARE RELIABLE TRANSMISSION*/
    #ifdef fgong_LOOP
    pktSeqNo = pktSeqNo % 254 + 2; //fgong_DEBUG: set seqno(seq=1 is reserved for looping message)
    #else
    pktSeqNo = pktSeqNo % 255 + 1;
    #endif
    packetbuf_set_attr(PACKETBUF_ATTR_MAC_SEQNO, pktSeqNo);
    reTxcounter = MAX_TRANSMISSION;
    #ifdef QUEUE_BUFFER_USE
    queuebuf_free(q); 
    q = queuebuf_new_from_packetbuf();
    #endif
    /*PREPARE DONE*/
#endif 
    addr.u8[0] = 13; //receiver addr=13.0; 
    addr.u8[1] = 0;
    if(!rimeaddr_cmp(&addr, &rimeaddr_node_addr)) {
      unicast_send(&uc, &addr);
      NRtx++;
      //printf("Unicast message sent\n");
    }
    else
      printf("Unicast destination address same as the source\n");
#ifdef RELIABLE_TX_FGONG
    /*HANDLE RELIABLE TRANSMISSION BELOW*/
    while(reTxcounter>0){
    	#ifdef fgong_DEBUG_LOG
	sent_logs[total_cnt].status =  tx_status;
  	sent_logs[total_cnt].seqno  =  pktSeqNo;
  	++total_cnt;
    	#endif
        if(tx_status == MAC_TX_OK){
		#ifdef RELIABLE_TX_DEBUG
                printf("retransmission times: %u\n", MAX_TRANSMISSION-reTxcounter);
		#endif
                break;
        }
        reTxcounter--;
	#ifdef QUEUE_BUFFER_USE
        queuebuf_to_packetbuf(q);
	#else
	packetbuf_copyfrom(PAYLOAD, (strlen(PAYLOAD)+1));
	packetbuf_set_attr(PACKETBUF_ATTR_MAC_SEQNO, pktSeqNo);
	#endif
        unicast_send(&uc, &addr);
	NRtx++;
	#ifdef RELIABLE_TX_DEBUG
        printf("msg resent,%u\n",tx_status);
	#endif
    }
    if(!reTxcounter){
	#ifdef RELIABLE_TX_DEBUG
        printf("msg time out\n");
	#endif
	NRtimeOut++;
	#ifdef fgong_DEBUG_LOG
	sent_logs[total_cnt].status =  100;
        sent_logs[total_cnt].seqno  =  pktSeqNo;
        ++total_cnt;
	#endif
    }
    /*HANDLE RELIABLE TRANSMISSION DONE*/
#endif

    --totCount;
    /*Counting offered_load below*/
    if (totCount == TOTPKT-1){  /*accumulate pkt receiving time of (TOTPKT-1) pkts */
        rt_prev = RTIMER_NOW();
	counterTime = 0U;
    }
    else{
        rt_now = RTIMER_NOW();
        if (rt_now < rt_prev) /*overflow happened*/
                counterTime += rt_now + (OVERFLOW_NUM-rt_prev);
        else
                counterTime += rt_now - rt_prev;
        rt_prev = rt_now;
    }
  }
  printf("sending %u pkts(size=%u) using %fms\nTX_OK=%d,collision=%d,noACK=%d,defer=%d,err=%d,fatalErr=%d\n",(TOTPKT-1),(unsigned)strlen(PAYLOAD)+1,counterTime*64.0/1000,cnt_macTx_ok,cnt_macTx_col,cnt_macTx_noAck,cnt_macTx_defer,cnt_macTx_err,cnt_macTx_fatal_err);
  printf("NRtx=%u,NRtimeOut=%u\n", NRtx, NRtimeOut);
#ifdef fgong_LOOP
  /*Notify receiver preparing for the next round*/
  recPktTag = 0;
  NRtx = 0; 
  NRtimeOut=0;
  cnt_macTx_ok=0; /*Reset TX counters*/
  cnt_macTx_col=0;
  cnt_macTx_noAck=0;
  cnt_macTx_defer=0;
  cnt_macTx_err=0;
  cnt_macTx_fatal_err=0;
  leds_on(LEDS_YELLOW);
  do{
    //if (recPktTag == 1)  break;
    etimer_set(&et, CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
    packetbuf_copyfrom("NEW", 4);
    packetbuf_set_attr(PACKETBUF_ATTR_MAC_SEQNO, 1);
    unicast_send(&uc, &addr); 
    etimer_set(&et, 5*CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
  }while(0);
#endif
  leds_on(LEDS_YELLOW);
  }
  }
  #ifdef fgong_DEBUG_LOG  
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event && data == &button_sensor);
  for (i=0; i< total_cnt; i++){
    etimer_set(&et, 0.01*CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
    printf("id=%u,seq=%u,st=%u\n",rimeaddr_node_addr.u8[0],sent_logs[i].seqno,sent_logs[i].status);
  }
  #endif
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
