/**
 * \addtogroup rimeRunicast_FGONG
 * @{
 */

/*
 * Copyright (c) 2006, Swedish Institute of Computer Science.
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
 *         Simplified Reliable unicast
 * \author
 *         fgong
 */

#include "net/rime/Runicast.h"
#include "net/rime.h"
#include <string.h>
#define DEBUG 0 
#if DEBUG
#include <stdio.h>
#include "net/mac/mac.h" /*for MAC-return values_fgong*/
#define PRINTF(...) printf(__VA_ARGS__)
#else
#define PRINTF(...)
#endif

#ifndef FACTOR //fgong_DEBUG: in order to set the timer interval, since the send function parameter does not have interval field, instead of passing into new parameters, manually change it here.
#define FACTOR 0.02 //fgong_DEBUG: this factor should be the same value as in runicast.c
#endif
/*---------------------------------------------------------------------------*/
static void
recv_from_uc(struct unicast_conn *uc, const rimeaddr_t *from)
{
  register struct Runicast_conn *c = (struct Runicast_conn *)uc;
  PRINTF("%d.%d: Runicast: recv_from_uc from %d.%d\n",
	 rimeaddr_node_addr.u8[0],rimeaddr_node_addr.u8[1],
	from->u8[0], from->u8[1]);
  if(c->u->recv != NULL) {
    c->u->recv(c, from);
  }
}
/*---------------------------------------------------------------------------*/
static void
sent_by_uc(struct unicast_conn *uc, int status, uint8_t num_tx)
{
  register struct Runicast_conn *c = (struct Runicast_conn *)uc;
  PRINTF("%d.%d: Runicast: recv_from_uc from %d.%d\n",
	 rimeaddr_node_addr.u8[0],rimeaddr_node_addr.u8[1],
         packetbuf_addr(PACKETBUF_ADDR_SENDER)->u8[0],
         packetbuf_addr(PACKETBUF_ADDR_SENDER)->u8[1]);
  if(status != MAC_TX_OK){  //retransmit if the TX is not OK
    if(c->rxmit < c->max_rxmit){  //if the MAX-retransmission times is not reached
      queuebuf_to_packetbuf(c->buf);
      c->rxmit++;
      unicast_send(&c->c, &c->receiver); 
    }
    else{
      if(c->u->timedout) {
        c->u->timedout(c, Runicast_receiver(&c->c), c->rxmit); 
      }
      c->rxmit = 0;
    }
  }
  else{ //When transmission is successful
    if(c->u->sent != NULL) {
      c->u->sent(c, status, c->rxmit);
    }
  }
}
/*---------------------------------------------------------------------------*/
static const struct unicast_callbacks Runicast = {recv_from_uc,
                                                   sent_by_uc};
/*---------------------------------------------------------------------------*/
void
Runicast_open(struct Runicast_conn *c, uint16_t channel,
	  const struct Runicast_callbacks *u)
{
  unicast_open(&c->c, channel, &Runicast);
  c->u = u;
}
/*---------------------------------------------------------------------------*/
void
Runicast_close(struct Runicast_conn *c)
{
  unicast_close(&c->c);
}
/*---------------------------------------------------------------------------*/
rimeaddr_t *
Runicast_receiver(struct Runicast_conn *c)
{
  return &c->receiver;
}
/*---------------------------------------------------------------------------*/
int
Runicast_send(struct Runicast_conn *c, const rimeaddr_t *receiver, uint8_t max_retransmissions)
{
  if(c->buf != NULL) {
    queuebuf_free(c->buf);
  }
  c->buf = queuebuf_new_from_packetbuf();
  if(c->buf == NULL) {
    return 0;
  }
  rimeaddr_copy(&c->receiver, receiver);
  c->max_rxmit = max_retransmissions;
  c->rxmit = 0;

  PRINTF("%d.%d: Runicast_send_stubborn to %d.%d\n",
	 rimeaddr_node_addr.u8[0],rimeaddr_node_addr.u8[1],
	 c->receiver.u8[0],c->receiver.u8[1]);
  unicast_send(&c->c, &c->receiver);
  
  return 1;
  
}
/*---------------------------------------------------------------------------*/
/** @} */
