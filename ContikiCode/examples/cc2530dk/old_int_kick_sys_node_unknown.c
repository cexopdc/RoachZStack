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

#include <math.h> // for square root -hxiong

#define SCALING_FACTOR 100
#define INITIAL_STD 1000*SCALING_FACTOR
/*---------------------------------------------------------------------------*/
PROCESS(example_broadcast_process, "Broadcast example");
AUTOSTART_PROCESSES(&example_broadcast_process);
/*---------------------------------------------------------------------------*/
/*****  RSSI PACKET FORMAT -hxiong *******/
/* First number: ATTRIBUTE: 0 means Unknown, 1 means beacon.
 * Second number: x position
 * Third number: y position
 * Fourth number: std                   */
static long int rssi_pkt_buf[4]={0,30*SCALING_FACTOR,40*SCALING_FACTOR,INITIAL_STD};
static long int neighbor_attr = 0;
static long int neighbor_x = 0;
static long int neighbor_y = 0;
static long int neighbor_std = 0;
static long int neighbor_dis = 0;
static long int neighbor_dis_std = 0;
static long int tmp = 0;
static void kick_loc();
long int my_sqrt2(const long int number);
static int32_t tmp2;

static void
broadcast_recv(struct broadcast_conn *c, const rimeaddr_t *from)
{
	tmp = my_sqrt2(10000);
	//printf("msg received\n");

	/*
	neighbor_attr = *(int *)packetbuf_dataptr();
    neighbor_x = *((int *)packetbuf_dataptr()+1);
	neighbor_y = *((int *)packetbuf_dataptr()+2);
	neighbor_std = *((int *)packetbuf_dataptr()+3);
    neighbor_dis = (-packetbuf_attr(PACKETBUF_ATTR_RSSI))*0.5; // need a mapping function
	neighbor_dis_std = 0.2*neighbor_dis; // need a look up table
	//tmp = my_sqrt2(400);
	tmp = 400;
	tmp2 = (int32_t)tmp;
	tmp2 = tmp2 + 100;
	tmp = (int16_t)tmp2;
	
	printf("%d\n",tmp);
	*/
	//printf("output=%d\n", 5);//output = 5;

	//printf("attr=%f,x=%f,y=%f, std=%f\n",neighbor_attr, neighbor_x, neighbor_y, neighbor_std);
	//printf("dis=%f\n", neighbor_dis);
	//tmp = sqrtf(16.0);

	//u.x = input;
	//u.i = (1<<29) + (u.i >> 1) - (1<<22);
	 
	// Two Babylonian Steps (simplified from:)
	//u.x = (u.x + input/u.x)/2;
//	u.x = 0.5f * (u.x + input/u.x);
//	u.x = u.x + input/u.x;
//	u.x = 0.25*u.x + input/u.x;

//	my_sqrt();
//	printf("tmp: %f\n",tmp);
//  printf("broadcast message received from %d.%d: '%s', rssi=%d\n",
//         from->u8[0], from->u8[1], (char *)packetbuf_dataptr(), packetbuf_attr(PACKETBUF_ATTR_RSSI));
	//printf("***************\n");
//	printf("tmp: %f\n",tmp);
//	printf("Tx ID: %d.%d\nRx ID: %d.%d\nType: %f\nPos: %f,%f\nSTD:%f\nrssi: %d\n",
//			from->u8[0], from->u8[1],rimeaddr_node_addr.u8[0],rimeaddr_node_addr.u8[1],*(double *)packetbuf_dataptr(),*((double *)packetbuf_dataptr()+1),*((double *)packetbuf_dataptr()+2),*((double *)packetbuf_dataptr()+3),packetbuf_attr(PACKETBUF_ATTR_RSSI));
/*
	printf("Tx ID: %d.%d\nRx ID: %d.%d\n", from->u8[0], from->u8[1],rimeaddr_node_addr.u8[0],rimeaddr_node_addr.u8[1]);
	printf("Type: %f\n",*(float *)packetbuf_dataptr());
	printf("Pos: %f,%f\n",*((float *)packetbuf_dataptr()+1),*((float *)packetbuf_dataptr()+2));
	printf("STD: %f\n",*((float *)packetbuf_dataptr()+3));
*/
	//kick_loc();
}

long int my_sqrt2(const long int number)
{
	
	const int ACCURACY=1;
	long int lower, upper, guess;
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
		if(guess*guess > number)
			upper =guess;
		else
			lower = guess;
	}
	
	return (lower + upper)/2;
}  




static const struct broadcast_callbacks broadcast_call ={broadcast_recv};
static struct broadcast_conn broadcast;
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(example_broadcast_process, ev, data)
{
  static struct etimer et;
  PROCESS_EXITHANDLER(broadcast_close(&broadcast);)

  PROCESS_BEGIN();
  SENSORS_ACTIVATE(button_sensor);
  printf("before sensor\n");
  broadcast_open(&broadcast, 129, &broadcast_call);
  PROCESS_WAIT_EVENT_UNTIL(ev == sensors_event &&
		                                data == &button_sensor);
  while(1) {
    etimer_set(&et, CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
	packetbuf_copyfrom(rssi_pkt_buf, 4*sizeof(int));
    //broadcast_send(&broadcast);
  }
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
