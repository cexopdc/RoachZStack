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
 *         Testing the broadcast layer in Rime for receiver
 * \author
 *         fgong
 */

#include "contiki.h"
#include "net/rime.h"
#include "random.h"

#include "dev/button-sensor.h"

#include "dev/leds.h"

#include <stdio.h>
#include <string.h>
#include "sys/rtimer.h"

#define fgong_LOOP 1
#define PAYLOAD "Hello_North_Carolina_State_University" /*Payload of the transmitted msg*/
#define TOTPKT 250 /*Total number of transmitted packets*/
#define TOTCNT 10  /*Total number of the timer fraction array*/
#define FACTOR 0.1 /*The timer period of the transmission*/
#define OVERFLOW_NUM 65535 /*rtimer_clock_t overflow max_number*/
/*---------------------------------------------------------------------------*/
PROCESS(example_broadcast_process, "Broadcast example");
AUTOSTART_PROCESSES(&example_broadcast_process);
/*---------------------------------------------------------------------------*/
static int recPktNum=0;
static uint8_t totCount = TOTPKT;
static uint8_t roundCnt = 0;
static struct broadcast_conn broadcast;
static unsigned long counterTime = 0U;
static rtimer_clock_t rt_now, rt_prev, rt_diff;
static void
broadcast_recv(struct broadcast_conn *c, const rimeaddr_t *from)
{
#ifdef fgong_LOOP
   //char * rec_Msg = (char *)packetbuf_dataptr();
#ifdef fgong_DEBUG_TEST
   printf("broadcast message received from %d.%d: '%s', recNum:%u\n",
         from->u8[0], from->u8[1], rec_Msg, strlen(rec_Msg)>1 ? ++recPktNum : recPktNum);
#endif /*end_fgong_DEBUG_TEST*/
   if (strcmp((char *)packetbuf_dataptr(), "NEW")==0){
	packetbuf_copyfrom("YES", 4);
    	broadcast_send(&broadcast);
	printf("recPktNum=%d with elapsed time = %f ms\n", recPktNum, counterTime*64.0/1000);
	printf("Round %u done, resetting recPktNum=0...\n", ++roundCnt);
 	recPktNum = 0;
   }
   else{
#endif /*end_fgong_LOOP*/
  //printf("broadcast message received '%s'", (char *)packetbuf_dataptr());
  if (recPktNum == 0){  /*accumulate pkt receiving time*/
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
  ++recPktNum;
#ifdef fgong_LOOP
  }
#endif /*end_fgong_LOOP*/
}
static const struct broadcast_callbacks broadcast_call = {broadcast_recv};
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(example_broadcast_process, ev, data)
{
  static struct etimer et;
  PROCESS_EXITHANDLER(broadcast_close(&broadcast);)

  PROCESS_BEGIN();

  broadcast_open(&broadcast, 129, &broadcast_call);

  /* Activate the button sensor. We use the button to drive traffic -
     when the button is pressed, a packet is sent. */
  SENSORS_ACTIVATE(button_sensor);
  printf("Before Button\n");
  /* Wait until we get a sensor event with the button sensor as data. */
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event &&
                             data == &button_sensor);
  printf("After Button\n");
  printf("recPktNum=%d with elapsed time = %f ms\n", recPktNum, counterTime*64.0/1000);
  PROCESS_END();
  //while(totCount) {

    /* Delay 2-4 seconds */
    //etimer_set(&et, CLOCK_SECOND * 4 + random_rand() % (CLOCK_SECOND * 4));
    //etimer_set(&et, FACTOR*CLOCK_SECOND);

    //PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

    //packetbuf_copyfrom(PAYLOAD, sizeof(PAYLOAD));/*Set payload*/
    //broadcast_send(&broadcast);
    //printf("broadcast message sent: %u\n",packetbuf_attr(PACKETBUF_ATTR_MAC_SEQNO));
    //--totCount;
  //}
  //PROCESS_END();
}
/*---------------------------------------------------------------------------*/
