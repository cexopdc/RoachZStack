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
 *         Best-effort single-hop unicast example
 * \author
 *         fgong
 */

/* fgong_Contention_Spec:
initiator Address = (8,0)
sender1 Address   = (9,0)
sender2 Address   = (10,0)
sender3 Address   = (11,0)
sender4 Address   = (12,0)
receiver Address  = (13,0) unicast_required
*/

#include "contiki.h"
#include "net/rime.h"

#include "dev/button-sensor.h"

#include "dev/leds.h"

#include <stdio.h>
#include <string.h>
#define fgong_LOOP 1
#undef fgong_LOOP
#define NUM_SENDER 3 /*The number of consecutive senders*/
#define SENDER_ID_BASE 9 /*The starting node's ID*/
#define fgong_LOOP_AUTO 1 /*Receiver sends signal to start all senders*/
#define PAYLOAD "Hello_North_Carolina_State_University" /*Payload of the transmitted msg*/
#define TOTPKT 250 /*Total number of transmitted packets*/
#define TOTCNT 10  /*Total number of the timer fraction array*/
#define FACTOR 0.000001 /*The timer period of the transmission*/
#define OVERFLOW_NUM 65535 /*rtimer_clock_t overflow max_number*/
#define fgong_DEBUG_PRINT 1
/*---------------------------------------------------------------------------*/
PROCESS(example_unicast_process, "Example unicast contention");
AUTOSTART_PROCESSES(&example_unicast_process);
/*---------------------------------------------------------------------------*/
#ifdef fgong_DEBUG_PRINT 
#define MAX_LOG_ENTRY 2050
struct logseqno {
  uint8_t sender;
  uint8_t seqno;
};
static struct logseqno received_logs[MAX_LOG_ENTRY];
static uint16_t total_cnt=0;
#endif
static int curSeqNo, preSeqNo1=-1, preSeqNo2=-1, preSeqNo3=-1, dup1=0, dup2=0, dup3=0;
static int recPktNum=0, i;
static uint8_t totCount = TOTPKT, recCnt=0;
static int cnt_rec1=0, cnt_rec2=0, cnt_rec3=0, cnt_rec4=0;
static uint8_t roundCnt = 0;
static struct unicast_conn uc;
static rimeaddr_t addr;
static unsigned long counterTime1=0U, counterTime2=0U, counterTime3=0U;
static rtimer_clock_t rt_now1, rt_prev1, rt_diff1, rt_now2, rt_prev2, rt_diff2, rt_now3, rt_prev3, rt_diff3;
static void
recv_uc(struct unicast_conn *c, const rimeaddr_t *from)
{ 
  //printf("%u\n", from->u8[0]);
  curSeqNo = (uint8_t)packetbuf_attr(PACKETBUF_ATTR_PACKET_ID);
  #ifdef fgong_LOOP //looping over multiple payloads from sender
  if (curSeqNo == 1){
        ++recCnt;
        if(recCnt == NUM_SENDER){
          printf("recPktNum_1=%d, dup1=%d, recPktNum_2=%d, dup2=%d, recPktNum_3=%d, dup3=%d, recPktNum_4=%d\n", cnt_rec1, dup1, cnt_rec2, dup2, cnt_rec3, dup3, cnt_rec4);
          printf("recPkt1 time = %f ms, recPkt2 time = %f ms, recPkt3 time = %f ms\n", counterTime1*64.0/1000, counterTime2*64.0/1000, counterTime3*64.0/1000);
          cnt_rec1=0; preSeqNo1=0;
          cnt_rec2=0; preSeqNo2=0;
          cnt_rec3=0; preSeqNo3=0;
          cnt_rec4=0;
          recCnt = 0;
          leds_on(LEDS_RED);
        }
        return;
  }
  #endif

  switch(from->u8[0]){
        case 9: 
	    if(cnt_rec1==0){
		rt_prev1 = RTIMER_NOW();
        	counterTime1 = 0U;
		leds_off(LEDS_RED);
  	    }
  	    else{
        	rt_now1 = RTIMER_NOW();
        	if (rt_now1 < rt_prev1) /*overflow happened*/
                	counterTime1 += rt_now1 + (OVERFLOW_NUM-rt_prev1);
        	else
                	counterTime1 += rt_now1 - rt_prev1;
        	rt_prev1 = rt_now1;
  	    }
	    if(curSeqNo != preSeqNo1){
	    cnt_rec1++; 
	    preSeqNo1 = curSeqNo;
	    }
	    else dup1++;
	    break;
        case 10: 
            if(cnt_rec2==0){
                rt_prev2 = RTIMER_NOW();
                counterTime2 = 0U;
		leds_off(LEDS_RED);
            }
            else{
                rt_now2 = RTIMER_NOW();
                if (rt_now2 < rt_prev2) /*overflow happened*/
                        counterTime2 += rt_now2 + (OVERFLOW_NUM-rt_prev2);
                else
                        counterTime2 += rt_now2 - rt_prev2;
                rt_prev2 = rt_now2;
            }
	    if(curSeqNo != preSeqNo2){
            cnt_rec2++;
            preSeqNo2 = curSeqNo;
            }
            else dup2++;
	    break;
        case 11: 
	    if(cnt_rec3==0){
                rt_prev3 = RTIMER_NOW();
                counterTime3 = 0U;
		leds_off(LEDS_RED);
            }
            else{
                rt_now3 = RTIMER_NOW();
                if (rt_now3 < rt_prev3) /*overflow happened*/
                        counterTime3 += rt_now3 + (OVERFLOW_NUM-rt_prev3);
                else
                        counterTime3 += rt_now3 - rt_prev3;
                rt_prev3 = rt_now3;
            }
            if(curSeqNo != preSeqNo3){
            cnt_rec3++;
            preSeqNo3 = curSeqNo;
            }
            else dup3++;
            break;
        case 12: cnt_rec4++; break;
  }
#ifdef fgong_DEBUG_PRINT //logging 
  if(total_cnt < MAX_LOG_ENTRY){
  received_logs[total_cnt].sender =  from->u8[0];
  received_logs[total_cnt].seqno  =  curSeqNo;
  ++total_cnt;
  }
#endif
}
static const struct unicast_callbacks unicast_callbacks = {recv_uc};


/*---------------------------------------------------------------------------*/
PROCESS_THREAD(example_unicast_process, ev, data)
{
  static struct etimer et;

  PROCESS_EXITHANDLER(unicast_close(&uc);)
    
  PROCESS_BEGIN();

  unicast_open(&uc, 146, &unicast_callbacks);

  /* Activate the button sensor. We use the button to drive traffic -
     when the button is pressed, a packet is sent. */
  SENSORS_ACTIVATE(button_sensor);
  printf("Before Button\n");
  leds_on(LEDS_RED);
#ifdef fgong_LOOP_AUTO
  printf("Receiver will sends signal to senders after button pressed\n");
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event && data == &button_sensor);
  printf("Button Pressed\n");
  totCount = 0; 
  while(totCount<NUM_SENDER) {
    etimer_set(&et, FACTOR*CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
    packetbuf_copyfrom("YES", 4);/*Set payload*/
    addr.u8[0] = SENDER_ID_BASE+totCount;  /*set sender address*/
    addr.u8[1] = 0;
    if(!rimeaddr_cmp(&addr, &rimeaddr_node_addr)) {
      unicast_send(&uc, &addr);
    }
    ++totCount;
  }
#endif
  /* Wait until we get a sensor event with the button sensor as data. */
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event && data == &button_sensor);
  printf("After Button\n");
  printf("recPktNum_1=%d, dup1=%d, recPktNum_2=%d, dup2=%d, recPktNum_3=%d, dup3=%d, recPktNum_4=%d\n", cnt_rec1, dup1, cnt_rec2, dup2, cnt_rec3, dup3, cnt_rec4);
  printf("recPkt1 time = %f ms, recPkt2 time = %f ms, recPkt3 time = %f ms\n", counterTime1*64.0/1000, counterTime2*64.0/1000, counterTime3*64.0/1000);
#ifdef fgong_DEBUG_PRINT
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event && data == &button_sensor);
  for (i=0; i< total_cnt; i++){
    etimer_set(&et, 0.01*CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
    printf("id=%u,seq=%u\n", received_logs[i].sender, received_logs[i].seqno);
  }
#endif
  PROCESS_END();
#ifdef fgong_CONTENT_DEBUG
  while(totCount) {
      
    etimer_set(&et, CLOCK_SECOND);
 
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

    packetbuf_copyfrom(PAYLOAD, sizeof(PAYLOAD));/*Set payload*/ 
    addr.u8[0] = 8; //receiver addr=7.0; sender addr=8.0
    addr.u8[1] = 0;
    if(!rimeaddr_cmp(&addr, &rimeaddr_node_addr)) {
      unicast_send(&uc, &addr);
      //printf("Unicast message sent\n");
    }
    --totCount;
  }
  PROCESS_END();
#endif
}
/*---------------------------------------------------------------------------*/
