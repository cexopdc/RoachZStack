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

#define INITIAL_STD 10000
/*---------------------------------------------------------------------------*/
PROCESS(example_broadcast_process, "Broadcast example");
AUTOSTART_PROCESSES(&example_broadcast_process);
/*---------------------------------------------------------------------------*/
/*****  RSSI PACKET FORMAT -hxiong *******/
/* First number: ATTRIBUTE: 0 means Unknown, 1 means beacon.
 * Second number: x position
 * Third number: y position
 * Fourth number: std                   */
static float rssi_pkt_buf[4]={0,50,50,INITIAL_STD};
static float neighbor_attr = 0;
static float neighbor_x = 0;
static float neighbor_y = 0;
static float neighbor_std = 0;
static float neighbor_dis = 0;
static float neighbor_dis_std = 0;
static float tmp = 0;
static void kick_loc();
static void kick_cal();
static float my_sqrt(const float x);
static float my_sqrt2(const float number);
// calibrated rssi_distance mapping from -26 to -86 dBm. The mapping between rssi value and array index is: index = -RSSI -25.
static struct RSSI_DIS_MEAN_STD
{
	float mean;
	float std;
}mean_std_array[62] = {
						{0.3,0}, // -25
						{0.3,0}, // -26
						{0.3,0}, // -27
						{0.3,0}, // -28
						{0.3,0}, // -29
						{0.45,0.15}, // -30
						{0.45,0.15}, // -31
						{0.45,0.15}, // -32
						{0.6,0}, // -33
						{0.6,0}, // -34
						{0.6,0}, // -35
						{0.6,0}, // -36
						{0.9,0}, // -37
						{0.9,0}, // -38
						{0.9,0}, // -39
						{0.9,0}, // -40
						{0.79,0.14}, // -41
						{1.00,0.14}, // -42
						{1.2,0}, // -43
						{1.20,0.02}, // -44
						{1.51,0.20}, // -45
						{1.67,0.17}, // -46
						{1.47,0.17}, // -47
						{1.46,0.34}, // -48
						{2.17,0.66}, // -49
						{2.29,0.59}, // -50
						{3.18,1.73}, // -51
						{3.40,1.77}, // -52
						{3.38,1.45}, // -53
						{5.90,3.19}, // -54
						{5.16,3.17}, // -55
						{8.33,4.75}, // -56
						{7.33,4.05}, // -57
						{9.24,4.20}, // -58
						{10.27,5.15}, // -59
						{8.87,5.13}, // -60
						{11.56,7.22}, // -61
						{13.05,7.75}, // -62
						{14.56,7.93}, // -63
						{11.56,5.82}, // -64
						{13.36,6.37}, // -65
						{12.79,7.30}, // -66
						{8.05,8.46}, // -67
						{10.96,9.51}, // -68
						{14.50,7.46}, // -69
						{12.46,8.20}, // -70
						{11.96,7.60}, // -71
						{13.43,9.60}, // -72
						{16.79,10.16}, // -73
						{18.22,10.88}, // -74
						{14.67,10.10}, // -75
						{17.52,10.24}, // -76
						{21.81,9.21}, // -77
						{21.74,10.16}, // -78
						{24.73,8.53}, // -79
						{25.18,3.44}, // -80
						{22.89,7.46}, // -81
						{24,7.44}, // -82
						{24.42,6.62}, // -83
						{23.12,7.26}, // -84
						{24.76,6.58}, // -85
						{26.25,4.53}, // -86
};
static void
broadcast_recv(struct broadcast_conn *c, const rimeaddr_t *from)
{
	neighbor_dis = mean_std_array[-packetbuf_attr(PACKETBUF_ATTR_RSSI)-25].mean; // need a mapping function
	neighbor_dis_std = mean_std_array[-packetbuf_attr(PACKETBUF_ATTR_RSSI)-25].std; // need a look up table
	neighbor_attr = *(float *)packetbuf_dataptr();
    neighbor_x = *((float *)packetbuf_dataptr()+1);
	neighbor_y = *((float *)packetbuf_dataptr()+2);
	neighbor_std = *((float *)packetbuf_dataptr()+3);
	printf("%f\n",neighbor_x);
	//printf("attr=%f,x=%f,y=%f, std=%f\n",neighbor_attr, neighbor_x, neighbor_y, neighbor_std);

//  printf("broadcast message received from %d.%d: '%s', rssi=%d\n",
//         from->u8[0], from->u8[1], (char *)packetbuf_dataptr(), packetbuf_attr(PACKETBUF_ATTR_RSSI));
	//printf("***************\n");
//	printf("tmp: %f\n",tmp);
//	printf("Tx ID: %d.%d\nRx ID: %d.%d\nType: %f\nPos: %f,%f\nSTD:%f\nrssi: %d\n",
//			from->u8[0], from->u8[1],rimeaddr_node_addr.u8[0],rimeaddr_node_addr.u8[1],*(double *)packetbuf_dataptr(),*((double *)packetbuf_dataptr()+1),*((double *)packetbuf_dataptr()+2),*((double *)packetbuf_dataptr()+3),packetbuf_attr(PACKETBUF_ATTR_RSSI));
	kick_loc();
	printf("After received packet from %d.%d, RSSI = %d\n",from->u8[0], from->u8[1],packetbuf_attr(PACKETBUF_ATTR_RSSI));
	printf("Updated estimate: (%f,fd), std: %f\n", (float )rssi_pkt_buf[1],(float )rssi_pkt_buf[2],(float )rssi_pkt_buf[3]);
}

static void 
kick_loc()
{
	float before_sqrt = 0.0;
	//printf("Enter kick_loc...\n");
	if (rssi_pkt_buf[3] == INITIAL_STD){
		// I don't have estimate yet
		if (neighbor_std != INITIAL_STD){
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
		if ((neighbor_std == INITIAL_STD) || (rssi_pkt_buf[1] == neighbor_x && rssi_pkt_buf[2] == neighbor_y))
		   // if neighbor also has no est, or neighbor and I have same est, do nothing.
			;	
		else
			kick_cal(); // call kick_cal to update the est.
				
	}	
	
	
//	else {
		// 
//	}

}

/* calculate the kick */
static void kick_cal()
{
	float est_d,delta_d_x,delta_d_y,std_update,alpha;
	// calculate est_d
	est_d = (rssi_pkt_buf[1] - neighbor_x)*(rssi_pkt_buf[1] - neighbor_x) + (rssi_pkt_buf[2] - neighbor_y)*(rssi_pkt_buf[2] - neighbor_y);
	est_d = my_sqrt2(est_d);
	// calculate delta_d
	delta_d_x = (est_d - neighbor_dis) * (neighbor_x - rssi_pkt_buf[1])/est_d;
	delta_d_y = (est_d - neighbor_dis) * (neighbor_y - rssi_pkt_buf[2])/est_d;
    // calculate the std of the update
	std_update = my_sqrt2(neighbor_dis_std*neighbor_dis_std + neighbor_std*neighbor_std);
	// calculate the alpha factor
	alpha = rssi_pkt_buf[3]/(rssi_pkt_buf[3] + std_update);
	// update the est_std
	rssi_pkt_buf[3] = alpha * std_update + (1 - alpha) * rssi_pkt_buf[3];
	// update the est
	rssi_pkt_buf[1] = rssi_pkt_buf[1] + alpha * delta_d_x;
	rssi_pkt_buf[2] = rssi_pkt_buf[2] + alpha * delta_d_y;

}

static float my_sqrt2(const float number)
{
	
	const float ACCURACY=0.001;
	float lower, upper, guess;

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
	packetbuf_copyfrom(rssi_pkt_buf, 4*sizeof(float));
    broadcast_send(&broadcast);
	//printf("broadcast msg sent\n");
  }
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
