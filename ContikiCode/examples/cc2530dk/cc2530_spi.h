/*
 * Copyright (c) 2011, VPI Engineering
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
 * $Id: cc2530_spi.h,v 1.3 2010/01/25 23:13:04 brycel-l Exp $
 */

/**
 * \file
 *         A brief description of what this file is.
 * \author
 *         Bryce Lembke <brycel@vpieng.com>
 */

#ifndef CC2530_SPI_H
#define CC2530_SPI_H

#include "contiki-conf.h"
#include "cc253x.h"
#include <stdint.h>


/*****************************************************************************
 * CONSTANTS AND DEFINES
 */

#define SPI2_ALT2 // Change this for different pin configuration used to be SPI1_ALT2

#define SPI1 1
#define SPI2 2

#define SPI_CLOCK_POL_LO       0x00
#define SPI_CLOCK_POL_HI       0x80
#define SPI_CLOCK_PHA_0        0x00
#define SPI_CLOCK_PHA_1        0x40

#define TX_BYTE              (1 << 1)
#define RX_BYTE              (1 << 2)
#define UART_FLUSH           (1 << 7)
#define UART_RECEIVE_ENABLE  (1 << 6)
#define UART_SPI_MODE        (0 << 7)

#define NOP()                ASM(nop);

/* SPI1 */
#define SPI_ADDR              0x70c1
#define SPI_TXBUF             (U0DBUF)
#define SPI_RXBUF             (U0DBUF)
#define SPI_WAITFORTxREADY()  (U0CSR &= ~TX_BYTE);
/* TODO  shouldn't need the extra NOPs, if so, how many NOPs 4 is too few. Works now, if need faster performance, investigate */
#define SPI_WAITFOREOTx()     while((U0CSR & TX_BYTE) != TX_BYTE);NOP();NOP();NOP();NOP();NOP();NOP();NOP();NOP();
/* TODO  shouldn't need the extra NOPs, if so, how many NOPs 4 is too few. Works now, if need faster performance, investigate */
#define SPI_WAITFOREORx()     while((U0CSR & TX_BYTE) != TX_BYTE);NOP();NOP();NOP();NOP();NOP();NOP();NOP();
#define SPI_BAUD_EXP_OFFSET   15
#define SPI_BAUD_MANTISSA     83

/* SPI2 */
#define SPI2_ADDR              0x70f9
#define SPI2_TXBUF             (U1DBUF)
#define SPI2_RXBUF             (U1DBUF)
#define SPI2_WAITFORTxREADY()  (U1CSR &= ~TX_BYTE);
/* TODO  shouldn't need the extra NOPs, if so, how many NOPs 4 is too few. Works now, if need faster performance, investigate */
#define SPI2_WAITFOREOTx()     while((U1CSR & TX_BYTE) != TX_BYTE);NOP();NOP();NOP();NOP();NOP();NOP();NOP();NOP();
/* TODO  shouldn't need the extra NOPs, if so, how many NOPs 4 is too few. Works now, if need faster performance, investigate */
#define SPI2_WAITFOREORx()     while((U1CSR & TX_BYTE) != TX_BYTE);NOP();NOP();NOP();NOP();NOP();NOP();NOP();
#define SPI2_BAUD_EXP_OFFSET   15
#define SPI2_BAUD_MANTISSA     83

/* SPI bus 1 */

/* Write one character to SPI */
#define SPI_WRITE(data)                          \
do {                                             \
  SPI_WAITFORTxREADY();                          \
  SPI_TXBUF = (data);                            \
  SPI_WAITFOREOTx();                             \
} while(0)

/* Read one character from SPI */
#define SPI_READ(data)                           \
do {                                             \
  SPI_WAITFORTxREADY();                          \
  SPI_TXBUF = 0xff;                              \
  SPI_WAITFOREORx();                             \
  (data) = SPI_RXBUF;                            \
} while(0)

/* Write one, read one character from SPI */
#define SPI_XFER(tx, rx)                         \
do {                                             \
  SPI_WAITFORTxREADY();                          \
  SPI_TXBUF = (tx);                              \
  SPI_WAITFOREORx();                             \
  (rx) = SPI_RXBUF;                              \
} while(0)

/* SPI bus 2 */

/* Write one character to SPI2 */
#define SPI2_WRITE(data)                         \
do {                                             \
  SPI2_WAITFORTxREADY();                         \
  SPI2_TXBUF = (data);                           \
  SPI2_WAITFOREOTx();                            \
} while(0)

/* Read one character from SPI2 */
#define SPI2_READ(data)                          \
do {                                             \
  SPI2_WAITFORTxREADY();                         \
  SPI2_TXBUF = 0xff;                             \
  SPI2_WAITFOREORx();                            \
  (data) = SPI2_RXBUF;                           \
} while(0)

/* Write one, read one character from SPI2 */
#define SPI2_XFER(tx, rx)                        \
do {                                             \
  SPI2_WAITFORTxREADY();                         \
  SPI2_TXBUF = (tx);                             \
  SPI2_WAITFOREORx();                            \
  (rx) = SPI2_RXBUF;                             \
} while(0)

typedef struct {
  uint8_t spi_id;
  uint8_t phase;
  uint8_t polarity;
  uint8_t clk_freq_MHz;
  uint8_t cs;
}SpiConfig;

void spi_init1(const uint8_t spi_id);  //used to be just spi_init but I got weird errors mixing this one with others -Tmagcaya

void spi_config(const SpiConfig* config);

#endif

