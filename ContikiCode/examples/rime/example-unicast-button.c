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
 *         Best-effort single-hop unicast example with button enabled
 * \author
 *         fgong
 */

#include "contiki.h"
#include "net/rime.h"

#include "dev/button-sensor.h"

#include "dev/leds.h"

#include <stdio.h>
#include <string.h>

//#define PAYLOAD "Hello_North_Carolina_State_University" /*Payload of the transmitted msg*/
#define PAYLOAD "HELLO"
#define TOTPKT 250 /*Total number of transmitted packets*/
#define TOTCNT 11  /*Total number of the timer fraction array*/
#define CNTBASE 4  /*Multipy factor to avoid pow() function call*/
#define DIVBASE 0  /*Index to change from division to multiplication of the CNTBASE*/
#define LOOPCNT 10 /*Total number of experimental trials*/
#define FACTOR 0.02 /*The timer period of the transmission*/
#define TOTCNT_PUSH_TH 1 /*Total number of high throughput array number*/
#define CNTBASE_PUSH_TH 16 /*Multiply factor to enlarge the range of uint_8*/
/*---------------------------------------------------------------------------*/
PROCESS(example_unicast_process, "Example unicast");
AUTOSTART_PROCESSES(&example_unicast_process);
/*---------------------------------------------------------------------------*/
static uint8_t recPktTag=0;
static uint8_t totCount = TOTPKT;
static void
recv_uc(struct unicast_conn *c, const rimeaddr_t *from)
{
  printf("unicast message received from %d.%d, pkt='%s', recPktTag:%u\n",
  	 from->u8[0], from->u8[1], (char *)packetbuf_dataptr(), recPktTag);
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
  //static uint8_t factor[TOTCNT] = {4,1,2,4,8,16,32,64,90,100,128}; /*Linear Throughtput Range*/
  static uint8_t factor[TOTCNT_PUSH_TH] = {1,41,49,58,72,93,113,134,206};/*Push Throughtput Range, given a low rate of 1/16 for testing only*/
  
  PROCESS_EXITHANDLER(unicast_close(&uc);)
    
  PROCESS_BEGIN();

  unicast_open(&uc, 146, &unicast_callbacks);

  /* Activate the button sensor. We use the button to drive traffic -
     when the button is pressed, a packet is sent. */
  SENSORS_ACTIVATE(button_sensor);
  printf("Before Button\n");
  leds_on(LEDS_RED);
  /* Wait until we get a sensor event with the button sensor as data. */
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event &&
                             data == &button_sensor);
  printf("After Button\n");
  leds_off(LEDS_RED);
  for(trial_cnt=0;trial_cnt<LOOPCNT;trial_cnt++){
  for(cnt=0;cnt<TOTCNT_PUSH_TH;cnt++){
  totCount = TOTPKT;
  while(totCount) {
      
    //etimer_set(&et, cnt<=DIVBASE ? CLOCK_SECOND*(factor[cnt]/CNTBASE) : CLOCK_SECOND/(factor[cnt]*CNTBASE)); /*Linear Throughtput Range*/
    etimer_set(&et, FACTOR*CLOCK_SECOND); /*50 pkt per second*/
 
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

    packetbuf_copyfrom(PAYLOAD, sizeof(PAYLOAD));/*Set payload*/ 
    addr.u8[0] = 7; //receiver addr=7.0; sender addr=8.0
    addr.u8[1] = 0;
    if(!rimeaddr_cmp(&addr, &rimeaddr_node_addr)) {
      unicast_send(&uc, &addr);
      //printf("Unicast message sent\n");
    }
    --totCount;
  }
  recPktTag = 0;
  while(1){
    etimer_set(&et, 3*CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
    if (recPktTag == 1)
        break;
    packetbuf_copyfrom("NEW", 4);
    unicast_send(&uc, &addr); 
  }
  }
  }
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
