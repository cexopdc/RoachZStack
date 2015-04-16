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
#define INITIAL_STD 1000
/*---------------------------------------------------------------------------*/
PROCESS(example_broadcast_process, "Broadcast example");
AUTOSTART_PROCESSES(&example_broadcast_process);
/*---------------------------------------------------------------------------*/
/*****  RSSI PACKET FORMAT -hxiong *******/
/* First number: ATTRIBUTE: 0 means Unknown, 1 means beacon.
 * Second number: x position
 * Third number: y position
 * Fourth number: std                   */
static const long int SCALED_INTIAL_STD = (long int)INITIAL_STD*SCALING_FACTOR;
static long int rssi_pkt_buf[4]={0,50*SCALING_FACTOR,50*SCALING_FACTOR, (long int)INITIAL_STD*SCALING_FACTOR};
static long int neighbor_attr = 0;
static long int neighbor_x = 0;
static long int neighbor_y = 0;
static long int neighbor_std = 0;
static long int neighbor_dis = 0;
static long int neighbor_dis_std = 0;
static long int tmp = 0;
static void kick_loc();
static void kick_cal();
static float my_sqrt(const float x);
static long int my_sqrt2(const long int number);
// calibrated rssi_distance mapping from -26 to -86 dBm. The mapping between rssi value and array index is: index = -RSSI -25.
static struct RSSI_DIS_MEAN_STD
{
	int mean;
	int std;
}mean_std_array[62] = {
						{30,0}, // -25
						{30,0}, // -26
						{30,0}, // -27
						{30,0}, // -28
						{30,0}, // -29
						{45,15}, // -30
						{45,15}, // -31
						{45,15}, // -32
						{60,0}, // -33
						{60,0}, // -34
						{60,0}, // -35
						{60,0}, // -36
						{90,0}, // -37
						{90,0}, // -38
						{90,0}, // -39
						{90,0}, // -40
						{79,14}, // -41
						{100,14}, // -42
						{120,0}, // -43
						{120,2}, // -44
						{151,20}, // -45
						{167,17}, // -46
						{147,17}, // -47
						{146,34}, // -48
						{217,66}, // -49
						{229,59}, // -50
						{318,73}, // -51
						{340,177}, // -52
						{338,145}, // -53
						{590,319}, // -54
						{516,317}, // -55
						{833,475}, // -56
						{733,405}, // -57
						{924,420}, // -58
						{1027,515}, // -59
						{887,513}, // -60
						{1156,722}, // -61
						{1305,775}, // -62
						{1456,793}, // -63
						{1156,582}, // -64
						{1336,637}, // -65
						{1279,730}, // -66
						{805,846}, // -67
						{1096,951}, // -68
						{1450,746}, // -69
						{1246,820}, // -70
						{1196,760}, // -71
						{1343,960}, // -72
						{1679,1016}, // -73
						{1822,1088}, // -74
						{1467,1010}, // -75
						{1752,1024}, // -76
						{2181,921}, // -77
						{2174,1016}, // -78
						{2473,853}, // -79
						{2518,344}, // -80
						{2289,746}, // -81
						{2400,744}, // -82
						{2442,662}, // -83
						{2312,726}, // -84
						{2476,658}, // -85
						{2625,453}, // -86
};
static void
broadcast_recv(struct broadcast_conn *c, const rimeaddr_t *from)
{
	neighbor_dis = mean_std_array[-packetbuf_attr(PACKETBUF_ATTR_RSSI)-25].mean; // need a mapping function
	neighbor_dis_std = mean_std_array[-packetbuf_attr(PACKETBUF_ATTR_RSSI)-25].std; // need a look up table
	neighbor_attr = *(long int *)packetbuf_dataptr();
    neighbor_x = *((long int *)packetbuf_dataptr()+1);
	neighbor_y = *((long int *)packetbuf_dataptr()+2);
	neighbor_std = *((long int *)packetbuf_dataptr()+3);

	//printf("attr=%f,x=%f,y=%f, std=%f\n",neighbor_attr, neighbor_x, neighbor_y, neighbor_std);

//  printf("broadcast message received from %d.%d: '%s', rssi=%d\n",
//         from->u8[0], from->u8[1], (char *)packetbuf_dataptr(), packetbuf_attr(PACKETBUF_ATTR_RSSI));
	//printf("***************\n");
//	printf("tmp: %f\n",tmp);
//	printf("Tx ID: %d.%d\nRx ID: %d.%d\nType: %f\nPos: %f,%f\nSTD:%f\nrssi: %d\n",
//			from->u8[0], from->u8[1],rimeaddr_node_addr.u8[0],rimeaddr_node_addr.u8[1],*(double *)packetbuf_dataptr(),*((double *)packetbuf_dataptr()+1),*((double *)packetbuf_dataptr()+2),*((double *)packetbuf_dataptr()+3),packetbuf_attr(PACKETBUF_ATTR_RSSI));

	kick_loc();
	printf("After received packet from %d.%d, RSSI = %d\n",from->u8[0], from->u8[1],packetbuf_attr(PACKETBUF_ATTR_RSSI));
	printf("Updated estimate: (%ld,%ld), std: %ld\n", rssi_pkt_buf[1], rssi_pkt_buf[2], rssi_pkt_buf[3]);
	
}

static void 
kick_loc()
{
	long int before_sqrt = 0;
	//printf("Enter kick_loc...\n");
	if (rssi_pkt_buf[3] == SCALED_INTIAL_STD){
		// I don't have estimate yet
		if (neighbor_std != SCALED_INTIAL_STD){
			// neighbor has estimate, I'll update x,y,std accordingly.
		//	printf("here");
			rssi_pkt_buf[1] = neighbor_x;
			rssi_pkt_buf[2] = neighbor_y;
			before_sqrt = neighbor_std*neighbor_std + neighbor_dis*neighbor_dis + neighbor_dis_std*neighbor_dis_std;
			rssi_pkt_buf[3] = my_sqrt2(neighbor_std*neighbor_std + neighbor_dis*neighbor_dis + neighbor_dis_std*neighbor_dis_std);
		}
			// neighbor also doesn't have estimate yet, do nothing.
	}
	
	else{
		if ((neighbor_std == SCALED_INTIAL_STD) || (rssi_pkt_buf[1] == neighbor_x && rssi_pkt_buf[2] == neighbor_y))
		   // if neighbor also has no est, or neighbor and I have same est, do nothing.
			;	
		else
			kick_cal(); // call kick_cal to update the est.
				
	}	
}

/* calculate the kick */
static void kick_cal()
{
	long int est_d,delta_d_x,delta_d_y,std_update,alpha;
	// calculate est_d
	est_d = (rssi_pkt_buf[1] - neighbor_x)*(rssi_pkt_buf[1] - neighbor_x) + (rssi_pkt_buf[2] - neighbor_y)*(rssi_pkt_buf[2] - neighbor_y);
	est_d = my_sqrt2(est_d);
	// calculate delta_d
	delta_d_x = (est_d - neighbor_dis) * (neighbor_x - rssi_pkt_buf[1])/est_d;
	delta_d_y = (est_d - neighbor_dis) * (neighbor_y - rssi_pkt_buf[2])/est_d;
    // calculate the std of the update
	std_update = my_sqrt2(neighbor_dis_std*neighbor_dis_std + neighbor_std*neighbor_std);
	// calculate the alpha factor
	alpha = 1000 * rssi_pkt_buf[3]/(rssi_pkt_buf[3] + std_update);
	// update the est_std
	rssi_pkt_buf[3] = (alpha * std_update + (1000 - alpha) * rssi_pkt_buf[3])/1000;
	// update the est
	rssi_pkt_buf[1] = rssi_pkt_buf[1] + alpha * delta_d_x /1000;
	rssi_pkt_buf[2] = rssi_pkt_buf[2] + alpha * delta_d_y /1000;

}

static long int my_sqrt2(const long int number)
{	
	const int ACCURACY=1;
	long int lower, upper, guess;

	if (number < 10000)
	{
		lower = 1;
		upper = number;
	}
	else
	{
		lower = 1;
		upper = number/100;
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


static float my_sqrt(const float x)
{
	//printf("inside mysqrt\n");
	static union
	{
		int32_t i;
		float x;
	} u;
	u.x = x;
	u.i = (1<<29) + (u.i >> 1) - (1<<22);
	return u.x;
	// Two Babylonian Steps (simplified from:)
	// u.x = 0.5f * (u.x + x/u.x);
	// u.x = 0.5f * (u.x + x/u.x);
	//u.x = u.x + x/u.x;
	//u.x = 0.25f*u.x + x/u.x;
	//return u.x;

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
    etimer_set(&et, CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
	packetbuf_copyfrom(rssi_pkt_buf, 4*sizeof(long int));
    broadcast_send(&broadcast);
	//printf("broadcast msg sent\n");
  }
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
