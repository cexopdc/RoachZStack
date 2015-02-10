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
 *         fgongReliable single-hop unicast example
 *	   For more detailed version, please refer to example-unicast-button_DEBUG.c 
 *         or example-unicast-button_contention_src_TEST.c
 * \author
 *         fgong
 */

#include "contiki.h"
#include "net/rime.h"

#include "dev/button-sensor.h"

#include "dev/leds.h"

#include <stdio.h>
#include "net/mac/mac.h" /*for MAC-return values_fgong*/
#define MAX_TRANSMISSION 10 
PROCESS(example_unicast_process, "Example Runicast");
AUTOSTART_PROCESSES(&example_unicast_process);
/*---------------------------------------------------------------------------*/
static rimeaddr_t addr;
static struct unicast_conn uc;
static uint8_t counter=MAX_TRANSMISSION;
static struct queuebuf *q;
static uint8_t tx_status=MAC_TX_OK;
static uint8_t pktSeqNo=0;
static uint16_t NRtimeOut=0, NRtx=0; //number of time out packets and total transmitted packets

static void
recv_uc(struct unicast_conn *c, const rimeaddr_t *from)
{
  printf("unicast message received from %d.%d, pkt=%s\n",
  	 from->u8[0], from->u8[1], (char *)packetbuf_dataptr());
}

static void
sent_by_uc(struct unicast_conn *c, int status, int num_tx)
{
	tx_status = (uint8_t)status;
}

static const struct unicast_callbacks unicast_callbacks = {recv_uc,sent_by_uc};

/*---------------------------------------------------------------------------*/
PROCESS_THREAD(example_unicast_process, ev, data)
{
  PROCESS_EXITHANDLER(unicast_close(&uc);)
    
  PROCESS_BEGIN();

  unicast_open(&uc, 146, &unicast_callbacks);
  pktSeqNo = (unsigned short)random_rand()%256; //randomize the initial sequence number
  while(1) {
    static struct etimer et;
    
    etimer_set(&et, 0.00001*CLOCK_SECOND);

    addr.u8[0] = 1;
    addr.u8[1] = 0;

    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

    packetbuf_copyfrom("Hello1", 6);
/*PREPARE RELIABLE TRANSMISSION*/
    pktSeqNo = pktSeqNo % 255 + 1;
    packetbuf_set_attr(PACKETBUF_ATTR_PACKET_ID, pktSeqNo);
    counter = MAX_TRANSMISSION;
    queuebuf_free(q); 
    q = queuebuf_new_from_packetbuf();
/*PREPARE DONE*/
    if(!rimeaddr_cmp(&addr, &rimeaddr_node_addr)) {
  	unicast_send(&uc, &addr);
	NRtx++;
	printf("Unicast message sent\n");
    }
/*HANDLE RELIABLE TRANSMISSION BELOW*/    
    while(counter>0){
	if(tx_status == MAC_TX_OK){
		printf("retransmission times: %u\n", MAX_TRANSMISSION-counter);
		break;
	}
	counter--;
	queuebuf_to_packetbuf(q);	
	unicast_send(&uc, &addr);
	NRtx++;
      	printf("msg resent,%u\n",tx_status);
    }
    if(!counter){
	printf("msg time out\n");
	NRtimeOut++;
    }
/*HANDLE RELIABLE TRANSMISSION DONE*/
  }
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
