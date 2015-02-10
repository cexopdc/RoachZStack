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
 *         Testing the Unicast layer in Rime and how distance affects performance
 * \author
 *         fgong
 */

#include "contiki.h"
#include "net/rime.h"
#include "net/mac/frame802154.h"
#include "random.h"

#include "dev/button-sensor.h"

#include "dev/leds.h"

#include <stdio.h>
#include <string.h>

#define PAYLOAD_MAX "Hello_North_Carolina_State_UniversityHello_North_Carolina_State_UniversityHello_North_Carolina_State_Universi" /*MAXIMUM Payload (112bytes) of the transmitted msg in broadcast can not be used in Unicast, probablity due to unicast address, the maximum payload is 100bytes*/
//#define PAYLOAD "hello"
#define PAYLOAD_ARR "HHHHHHHHH", "HHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", PAYLOAD_MAX  /*The payload array that consists 10:10:110 bytes of payload*/
#define PAYLOAD_100 "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
#define PAYLOAD_ARR_LEN 11 /*length of the payload array*/
#define TOTPKT 250 /*Total number of transmitted packets*/
#define TOTCNT 1  /*Total number of the timer fraction array*/
#define CNTBASE 4  /*Multipy factor to avoid pow() function call*/
#define DIVBASE 0  /*Index to change from division to multiplication of the CNTBASE*/
#define LOOPCNT 1 /*Total number of experimental trials*/
#define FACTOR  0.000001 /*The timer period of the transmission, push_mode does not work for unicast*/
//#define FACTOR 0.125
#define OVERFLOW_NUM 65535 /*rtimer_clock_t overflow max_number*/
/*---------------------------------------------------------------------------*/
PROCESS(example_unicast_process, "Unicast example");
AUTOSTART_PROCESSES(&example_unicast_process);
/*---------------------------------------------------------------------------*/
static char* payload_arr[] = {PAYLOAD_ARR};
static char* PAYLOAD = NULL; 
static uint8_t recPktTag=0;
static int totCount = TOTPKT;
static unsigned long counterTime = 0U;
static rtimer_clock_t rt_now, rt_prev, rt_diff;
static void
recv_uc(struct unicast_conn *c, const rimeaddr_t *from)
{
   if (strcmp((char *)packetbuf_dataptr(), "YES")==0)
	recPktTag = 1;
}
static const struct unicast_callbacks unicast_callbacks = {recv_uc};
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
  /* Wait until we get a sensor event with the button sensor as data. */
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event &&
                             data == &button_sensor);
  printf("After Button\n");
  leds_off(LEDS_RED);
  for(trial_cnt=0;trial_cnt<LOOPCNT;trial_cnt++){
  for(cnt=0;cnt>=0;cnt++){
  PAYLOAD = PAYLOAD_100;
  totCount = TOTPKT;
  leds_on(LEDS_RED);
  /* Wait until we get a sensor event with the button sensor as data. */
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event && data == &button_sensor);
  leds_off(LEDS_RED);
  /* Start sending back_to_back packets below */
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
    addr.u8[0] = 7; //receiver addr=7.0; sender addr=8.0
    addr.u8[1] = 0;
    if(!rimeaddr_cmp(&addr, &rimeaddr_node_addr)) {
      unicast_send(&uc, &addr);
      //printf("Unicast message sent\n");
    }
    else
      printf("Unicast destination address same as the source\n");
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
  printf("sending %u pkts(size=%u) using %fms\n",(TOTPKT-1),(unsigned)strlen(PAYLOAD)+1,counterTime*64.0/1000);
  /*Notify receiver preparing for the next round*/
  recPktTag = 0;
  while(1){
    etimer_set(&et, 2*CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
    if (recPktTag == 1)
	break;
    packetbuf_copyfrom("NEW", 4);
    unicast_send(&uc, &addr); 
  }

  }
  }
  leds_on(LEDS_YELLOW);
  
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
