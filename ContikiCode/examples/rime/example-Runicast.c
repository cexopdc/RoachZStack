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
 *         Simplified reliable single-hop unicast example (NOT SEEM TO WORK YET)
 * \author
 *         fgong
 */

#include <stdio.h>

#include "contiki.h"
#include "net/rime.h"
//#include "net/rime/Runicast.h"

#include "lib/list.h"
#include "lib/memb.h"

#include "dev/button-sensor.h"
#include "dev/leds.h"
#include "net/mac/mac.h" /*for MAC-return values_fgong*/

#define MAX_RETRANSMISSIONS 4 
#define NUM_HISTORY_ENTRIES 4

/*---------------------------------------------------------------------------*/
PROCESS(test_runicast_process, "fgongRunicast test");
AUTOSTART_PROCESSES(&test_runicast_process);
/*---------------------------------------------------------------------------*/
/* OPTIONAL: Sender history.
 * Detects duplicate callbacks at receiving nodes.
 * Duplicates appear when ack messages are lost. */
struct history_entry {
  struct history_entry *next;
  rimeaddr_t addr;
  uint8_t seq;
};
LIST(history_table);
MEMB(history_mem, struct history_entry, NUM_HISTORY_ENTRIES);
/*---------------------------------------------------------------------------*/
static void
recv_Runicast(struct Runicast_conn *c, const rimeaddr_t *from)
{
  printf("runicast message received from %d.%d\n",
	 from->u8[0], from->u8[1]);
}
/*
static void
sent_runicast(struct runicast_conn *c, const rimeaddr_t *to, uint8_t retransmissions)
{
  printf("runicast message sent to %d.%d, retransmissions %d\n",
	 to->u8[0], to->u8[1], retransmissions);
}
*/
static void
sent_Runicast(struct Runicast_conn *c, int status, uint8_t retransmissions)
{
  printf("runicast message sent\n");
}
/*
static void
timedout_runicast(struct Runicast_conn *c, const rimeaddr_t *to, uint8_t retransmissions)
{
  printf("runicast message timed out when sending to %d.%d, retransmissions %d\n",
	 to->u8[0], to->u8[1], retransmissions);
}
*/
/*
static void
timedout_runicast(struct runicast_conn *c, const rimeaddr_t *to, uint8_t retransmissions)
{
  printf("runicast message timed out\n");
}
*/
/*
static const struct runicast_callbacks runicast_callbacks = {recv_runicast,
							     sent_runicast,
							     timedout_runicast};
*/
static const struct Runicast_callbacks RRunicast_callbacks = {recv_Runicast,
                                                             sent_Runicast}; //fgong_DEBUG_timeout

static struct Runicast_conn Runicast;
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(test_runicast_process, ev, data)
{
  PROCESS_EXITHANDLER(Runicast_close(&Runicast);)

  PROCESS_BEGIN();

  Runicast_open(&Runicast, 144, &RRunicast_callbacks);

  /* OPTIONAL: Sender history */
  list_init(history_table);
  memb_init(&history_mem);

  /* Receiver node: do nothing */
  if(rimeaddr_node_addr.u8[0] == 1 &&
     rimeaddr_node_addr.u8[1] == 0) {
    PROCESS_WAIT_EVENT_UNTIL(0);
  }

  while(1) {
    static struct etimer et;

    etimer_set(&et, 2*CLOCK_SECOND);
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

      rimeaddr_t recv;

      packetbuf_copyfrom("Hello", 5);
      recv.u8[0] = 1;
      recv.u8[1] = 0;

      printf("%u.%u: sending Runicast to address %u.%u\n",
	     rimeaddr_node_addr.u8[0],
	     rimeaddr_node_addr.u8[1],
	     recv.u8[0],
	     recv.u8[1]);

      Runicast_send(&Runicast, &recv, MAX_RETRANSMISSIONS);
  }

  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
