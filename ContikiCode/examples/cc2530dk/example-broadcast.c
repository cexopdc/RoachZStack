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
 *         Testing the broadcast layer in Rime
 * \author
 *         Adam Dunkels <adam@sics.se>
 */

#include "contiki.h"
#include "net/rime.h"
#include "random.h"

#include "dev/button-sensor.h"

#include "dev/leds.h"

#include <stdio.h>
/*---------------------------------------------------------------------------*/
PROCESS(example_broadcast_process, "Broadcast example");
AUTOSTART_PROCESSES(&example_broadcast_process);

#define SCALING_FACTOR 100
#define INITIAL_STD 1000*SCALING_FACTOR
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*****  RSSI PACKET FORMAT -hxiong *******/
/* First number: ATTRIBUTE: 0 means Unknown, 1 means beacon.
 *  * Second number: x position
 *   * Third number: y position
 *    * Fourth number: std                   */
static int rssi_pkt_buf[4]={0,30*SCALING_FACTOR,40*SCALING_FACTOR,INITIAL_STD};
static int neighbor_attr = 0;
static int neighbor_x = 0;
static int neighbor_y = 0;
static int neighbor_std = 0;
static int neighbor_dis = 0;
static int neighbor_dis_std = 0;
static int tmp = 0;
static int32_t tmp2;


void my_sqrt2()
{
	
	static int number=100;
	const static int32_t ACCURACY=1;
	static int32_t lower, upper, guess;
	if (number < 1)
	{
		lower = number;
		upper = 1;
	}
	else
	{
		lower = 1;
		upper = number;
	}
			
	  while ((upper-lower) > ACCURACY)
	  {
		 
		guess = (lower + upper)/2;
		break;
		
		if(guess*guess>number)//guess*guess > number)
			upper =guess;
		else
			lower = guess;
		
	   //printf("guess: %d\n",guess);	
	}
		
	//return (lower + upper)/2;
	
	//return 0;
} 

static void 
kick_loc()
{
	printf("Enter kick_loc...\n");
	if (rssi_pkt_buf[3] == INITIAL_STD){
		// I don't have estimate yet
		if (neighbor_std != INITIAL_STD){
			// neighbor has estimate, I'll update x,y,std accordingly.
		//	printf("here");
		//	rssi_pkt_buf[1] = neighbor_x;
		//	rssi_pkt_buf[2] = neighbor_y;
		//	rssi_pkt_buf[3] = sqrtf(neighbor_std*neighbor_std + neighbor_dis*neighbor_dis + neighbor_dis_std*neighbor_dis_std);
		//	printf("estimate std: %f\n",rssi_pkt_buf[3]);
		}
			// neighbor also doesn't have estimate yet, do nothing.
	}
}

/*---------------------------------------------------------------------------*/
static void
broadcast_recv(struct broadcast_conn *c, const rimeaddr_t *from)
{
  printf("broadcast message received from %d.%d: '%s', rssi=%d\n",
         from->u8[0], from->u8[1], (char *)packetbuf_dataptr(), packetbuf_attr(PACKETBUF_ATTR_RSSI));
}
static const struct broadcast_callbacks broadcast_call = {broadcast_recv};
static struct broadcast_conn broadcast;
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(example_broadcast_process, ev, data)
{
  static struct etimer et;

  PROCESS_EXITHANDLER(broadcast_close(&broadcast);)

  PROCESS_BEGIN();

  broadcast_open(&broadcast, 129, &broadcast_call);

  while(1) {

    /* Delay 2-4 seconds */
    etimer_set(&et, CLOCK_SECOND * 4 + random_rand() % (CLOCK_SECOND * 4));

    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

    packetbuf_copyfrom("Hello", 6);
    broadcast_send(&broadcast);
    printf("broadcast message sent\n");
  }

  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
