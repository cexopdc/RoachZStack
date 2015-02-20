/**
 * \addtogroup rime
 * @{
 */

/**
 * \defgroup rimeRunicast_FGONG 
 * @{
 *
 * The stubborn single-hop unicast primitive (stunicast) repeatedly
 * sends a packet to a single-hop neighbor using the unicast
 * primitive.  The stunicast primitive sends and resends the packet
 * until an upper layer primitive or protocol cancels the
 * transmission.  While it is possible for applications and protocols
 * that use Rime to use the stubborn single-hop unicast primitive
 * directly, the stunicast primitive is primarily used by the reliable
 * single-hop unicast (runicast) primitive.
 *
 * Before the stunicast primitive sends a packet, it allocates a queue
 * buffer, to which the application data and packet attributes is
 * copied, and sets a timer.  When the timer expires, the stunicast
 * primitive copies the queue buffer to the Rime buffer and sends the
 * packet using the unicast primitive.  The stunicast primitive sets the
 * number of retransmissions for a packet as a packet attribute on 
 * outgoing packets.
 *
 * \section channels Channels
 *
 * The stunicast module uses 1 channel.
 *
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
 *         Runicast header file
 * \author
 *         fgong
 */

#ifndef __RRUNICAST_H__
#define __RRUNICAST_H__

#include "sys/ctimer.h"
#include "net/rime/unicast.h"
#include "net/queuebuf.h"

struct Runicast_conn;

#define RRUNICAST_ATTRIBUTES  UNICAST_ATTRIBUTES

struct Runicast_callbacks {
  void (* recv)(struct Runicast_conn *c, const rimeaddr_t *from);
  void (* sent)(struct Runicast_conn *c, int status, uint8_t num_tx);
};

struct Runicast_conn {
  struct unicast_conn c;
  struct queuebuf *buf;
  const struct Runicast_callbacks *u;
  rimeaddr_t receiver;
  uint8_t rxmit;
  uint8_t max_rxmit;
};

void Runicast_open(struct Runicast_conn *c, uint16_t channel,
	       const struct Runicast_callbacks *u);
void Runicast_close(struct Runicast_conn *c);

int Runicast_send(struct Runicast_conn *c, const rimeaddr_t *receiver, uint8_t max_retransmissions);

rimeaddr_t *Runicast_receiver(struct Runicast_conn *c);

#endif /* __RRUNICAST_H__ */
/** @} */
/** @} */
