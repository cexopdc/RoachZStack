/*
 * Copyright (c) 2016, VPI Engineering
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
 * $Id: cc2530_spi.c,v 1.3 2010/01/25 23:13:04 brycel-l Exp $
 */

/**
 * \file
 *         Implementation of spi API on CC253x
 * \author
 *         Bryce Lembke <brycel@vpieng.com>
 */

#include "cc2530_spi.h"
#include <stdint.h>

#if defined (SPI1_ALT1)

#define SPI1_MODE              (0 << 1)
#define SPI1_PxSEL             P0SEL
#define SPI1_PxDIR             P0DIR
#define SPI1_MISO_PIN          (1 << 2)
#define SPI1_MOSI_PIN          (1 << 3)
#define SPI1_CLK_PIN           (1 << 5)

#elif defined (SPI1_ALT2)

#define SPI1_MODE              (1 << 1)
#define SPI1_PxSEL             P1SEL
#define SPI1_PxDIR             P1DIR
#define SPI1_MISO_PIN          (1 << 4)
#define SPI1_MOSI_PIN          (1 << 5)
#define SPI1_CLK_PIN           (1 << 3)

#endif
#if defined (SPI2_ALT1)

#define SPI2_MODE              (0 << 1)
#define SPI2_PxSEL             P0SEL
#define SPI2_PxDIR             P0DIR
#define SPI2_MISO_PIN          (1 << 5)
#define SPI2_MOSI_PIN          (1 << 4)
#define SPI2_CLK_PIN           (1 << 3)

#elif defined (SPI2_ALT2)

#define SPI2_MODE              (1 << 1)
#define SPI2_PxSEL             P1SEL
#define SPI2_PxDIR             P1DIR
#define SPI2_MISO_PIN          (1 << 7)
#define SPI2_MOSI_PIN          (1 << 6)
#define SPI2_CLK_PIN           (1 << 5)

#endif

#define SPI_TRANSFER_MSB_FIRST 0x20
#define SPI_TRANSFER_MSB_LAST  0x00

/*---------------------------------------------------------------------------*/
/**
 * Initialize SPI bus(es)
 */
void spi_init1(const uint8_t spi_id)/*__banked*/
{
#if (defined SPI1_ALT1 || defined SPI1_ALT2)
  if(spi_id == SPI1) {
    PERCFG |= SPI1_MODE;
    SPI1_PxSEL |= SPI1_MISO_PIN;
    SPI1_PxSEL |= SPI1_MOSI_PIN;
    SPI1_PxSEL |= SPI1_CLK_PIN;

    /* Configure peripheral */
    U0UCR  = UART_FLUSH;            /* Flush and goto IDLE state. 8-N-1. */
    U0CSR  = UART_SPI_MODE | UART_RECEIVE_ENABLE;   /* SPI mode, master. */
  }
#endif
  
#if (defined SPI2_ALT1 || defined SPI2_ALT2)
  if(spi_id == SPI2) {
    PERCFG |= SPI2_MODE;
    SPI2_PxSEL |= SPI2_MISO_PIN;
    SPI2_PxSEL |= SPI2_MOSI_PIN;
    SPI2_PxSEL |= SPI2_CLK_PIN;

    /* Configure peripheral */
    U1UCR  = UART_FLUSH;           /* Flush and goto IDLE state. 8-N-1.  */
    U1CSR  = UART_SPI_MODE | UART_RECEIVE_ENABLE;   /* SPI mode, master. */
  }
#endif
}

typedef struct {
  uint8_t exponent;
  uint8_t mantissa;
} clk_config;

/* Assumes 32MHz System Clock */
static clk_config clk_cfgs[] =
{
  {11, 154}, /* <1 MHz (use 100 kHz) */
  {15, 0},   /* 1 MHz */
  {16, 0},   /* 2 MHz */
  {16, 128}, /* 3 MHz */
  {17, 0},   /* 4 MHz */
  {17, 64},  /* 5 MHz */
  {17, 128}, /* 6 MHz */
  {17, 192}, /* 7 MHz */
  {18, 0},   /* 8 MHz */
};

/*---------------------------------------------------------------------------*/
/**
 * Configure the spi channel
 *
 * config - parameters for that channel
 */
void spi_config(const SpiConfig* config)
{
  if(config && config->clk_freq_MHz < sizeof(clk_cfgs) / sizeof(clk_config)) {
#if (defined SPI1_ALT1 || defined SPI1_ALT2)
    if(config->spi_id == SPI1) {
      U0GCR  = (SPI_TRANSFER_MSB_FIRST
                | config->phase
                | config->polarity
                | clk_cfgs[config->clk_freq_MHz].exponent);
      U0BAUD = clk_cfgs[config->clk_freq_MHz].mantissa;
    }
#endif
      
#if (defined SPI2_ALT1 || defined SPI2_ALT2)
    if(config->spi_id == SPI2) {
      U1GCR  = (SPI_TRANSFER_MSB_FIRST
                | config->phase
                | config->polarity
                | clk_cfgs[config->clk_freq_MHz].exponent);
      U1BAUD = clk_cfgs[config->clk_freq_MHz].mantissa;
    }
#endif
  }
}

