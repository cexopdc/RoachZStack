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
 *         Testing the broadcast layer in Rime for contention with CSMA 
 * \author
 *         fgong 
 */

#include "contiki.h"
#include "net/rime.h"
#include "net/mac/frame802154.h"
#include "net/mac/mac.h"
#include "random.h"

#include "dev/button-sensor.h"

#include "dev/leds.h"

#include <stdio.h>
#include <string.h>

#define PAYLOAD_MAX "Hello_North_Carolina_State_UniversityHello_North_Carolina_State_UniversityHello_North_Carolina_State_University" /*MAXIMUM Payload (112bytes) of the transmitted msg*/
//#define PAYLOAD "hello"
#define PAYLOAD_ARR "HHHHHHHHH", "HHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", PAYLOAD_MAX /*The payload array that consists 10:10:112 bytes of payload*/
#define PAYLOAD_100 "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
#define PAYLOAD_ARR_LEN 11 /*length of the payload array*/
#define TOTPKT 100 /*Total number of transmitted packets*/
#define TOTCNT 1  /*Total number of the timer fraction array*/
#define CNTBASE 4  /*Multipy factor to avoid pow() function call*/
#define DIVBASE 0  /*Index to change from division to multiplication of the CNTBASE*/
#define LOOPCNT 1 /*Total number of experimental trials*/
#define FACTOR  0.000001 /*The timer period of the transmission, push_hard_mode does not work for LPP*/
//#define FACTOR 0.125 /*LPP Testing*/
#define OVERFLOW_NUM 65535 /*rtimer_clock_t overflow max_number*/
//#define fgong_DEBUG_LOG 1
#define fgong_LOOP 1
//#undef fgong_LOOP
#define fgong_LOOP_AUTO 1

#ifdef fgong_DEBUG_LOG
#define MAX_LOG_ENTRY 2050
struct logseqno {
  uint8_t status;
  uint8_t seqno;
};
static struct logseqno sent_logs[MAX_LOG_ENTRY];
static uint16_t total_cnt=0;
#endif

/*---------------------------------------------------------------------------*/
PROCESS(example_broadcast_process, "Broadcast example contention");
AUTOSTART_PROCESSES(&example_broadcast_process);
/*---------------------------------------------------------------------------*/
static char* payload_arr[] = {PAYLOAD_ARR};
static char* PAYLOAD = NULL; 
static uint8_t recPktTag=0,pktSeqNo;
static int totCount = TOTPKT;
static int cnt_macTx_ok=0,cnt_macTx_col=0,cnt_macTx_noAck=0,cnt_macTx_defer=0,cnt_macTx_err=0,cnt_macTx_fatal_err=0;
static unsigned long counterTime = 0U;
static rtimer_clock_t rt_now, rt_prev, rt_diff;
static struct broadcast_conn broadcast;
static struct etimer et;
static void
broadcast_recv(struct broadcast_conn *c, const rimeaddr_t *from)
{
   /*printf("broadcast message received from %d.%d: '%s', recPktTag:%u\n",
         from->u8[0], from->u8[1], (char *)packetbuf_dataptr(), recPktTag);*/
   //if (strcmp((char *)packetbuf_dataptr(), "YES")==0){
   if(from->u8[0] == 13){
	recPktTag = 1;
   }
}
/*sent_bc statistics_fgong*/
static void
sent_by_bc(struct broadcast_conn *c, int status, int num_tx)
{
  switch(status){
        case MAC_TX_OK: cnt_macTx_ok++; break;
        case MAC_TX_COLLISION:  cnt_macTx_col++; break;
        case MAC_TX_NOACK:  cnt_macTx_noAck++; break;
        case MAC_TX_DEFERRED:  cnt_macTx_defer++; break;
        case MAC_TX_ERR:  cnt_macTx_err++; break;
        case MAC_TX_ERR_FATAL:  cnt_macTx_fatal_err++; break;
  }
}

static const struct broadcast_callbacks broadcast_call = {broadcast_recv,sent_by_bc};

/*---------------------------------------------------------------------------*/
PROCESS_THREAD(example_broadcast_process, ev, data)
{
  static struct etimer et;
  static uint8_t cnt,trial_cnt;
  //static uint8_t factor[TOTCNT] = {4,1,2,4,8,16,32,64,90,100,128};
  PROCESS_EXITHANDLER(broadcast_close(&broadcast);)

  PROCESS_BEGIN();

  broadcast_open(&broadcast, 129, &broadcast_call);

  /*when the button is pressed, a packet is sent. */
  SENSORS_ACTIVATE(button_sensor);
  printf("Before Button\n");
  printf("sizeof(frame802154_t)=%u\n", sizeof(frame802154_t));
  leds_on(LEDS_RED);
  
#ifdef fgong_CONTENT_DEBUG
  /* Wait until we get a sensor event with the button sensor as data. */
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event && data == &button_sensor);
#endif
#ifdef fgong_LOOP_AUTO 
  /* Wait until START COMMAND. */
  while(1){
	etimer_set(&et, 0.01*CLOCK_SECOND); 
        PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
	if (recPktTag == 1)
		break;
  }
#endif
  	etimer_set(&et, CLOCK_SECOND);
 	PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
  	/* Start sending consecutive packets*/
  	leds_off(LEDS_RED);
	for(trial_cnt=0;trial_cnt<LOOPCNT;trial_cnt++){
	#ifdef fgong_LOOP
  	for(cnt=0;cnt<PAYLOAD_ARR_LEN;cnt++){
  	PAYLOAD = payload_arr[cnt];
	#else
	for(cnt=0;cnt<1;cnt++){
        PAYLOAD = PAYLOAD_100;
	#endif
        totCount = TOTPKT;
	leds_off(LEDS_YELLOW);
	pktSeqNo = (unsigned short)random_rand()%256; //randomize the initial sequence number
  	//printf("initSeqNo=%u\n", pktSeqNo);
        while(totCount) {
        etimer_set(&et, CLOCK_SECOND*FACTOR); /*load factor*/

        PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

        packetbuf_copyfrom(PAYLOAD, (strlen(PAYLOAD)+1));/*Set payload, +1 for the NULL character*/
	pktSeqNo = pktSeqNo % 254 + 2; //fgong_DEBUG: set seqno(seq=1 is reserved for looping message)
    	packetbuf_set_attr(PACKETBUF_ATTR_MAC_SEQNO, pktSeqNo);  
        broadcast_send(&broadcast);
        --totCount;
        /*Counting offered_load below*/
        if (totCount == TOTPKT-1){  /*accumulate pkt receiving time*/
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
        cnt_macTx_ok=0; /*Reset TX counters*/
        cnt_macTx_col=0;
        cnt_macTx_noAck=0;
        cnt_macTx_defer=0;
        cnt_macTx_err=0;
        cnt_macTx_fatal_err=0;
        leds_on(LEDS_YELLOW); 
	#ifdef fgong_LOOP
  	/*Notify receiver preparing for the next round*/
  	recPktTag = 0;
	leds_on(LEDS_YELLOW);
  	do{
    	//if (recPktTag == 1)  break;
	etimer_set(&et, CLOCK_SECOND);
        PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
    	packetbuf_copyfrom("NEW", 4);
	packetbuf_set_attr(PACKETBUF_ATTR_MAC_SEQNO, 1);
    	broadcast_send(&broadcast);
	etimer_set(&et, 5*CLOCK_SECOND);
    	PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
  	}while(0);
	#endif
  }
  }

  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
