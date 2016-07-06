/* spi_master.c
 *
 * Copyright 2016 by VPI Engineering
 * All rights are reserved.
 */
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
 */

#include <stdint.h>
#include <stdlib.h>   //added for 'size_t'
#include <stddef.h>   //added for 'size_t'
#include <stdbool.h>
#include <assert.h>
#include "spi_master.h"
#include "cc253x.h"
#include "cc2530_spi.h"
//#include <dev/cc2530_spi.h>

#define spiChannel_numChannels 2 // If modified change rows in spiConfigs table to match

static SpiConfig   configs[spiChannel_numChannels];
static unsigned int curChannel;

static Spi_Config spiConfigs[spiChannel_numChannels] =
{
    // BusId (0-1), Freq (kHz), Clk Phase,       Clk Polarity,       Chip Select //used to have an issue with 8000khz skipping.
    {  1,           1000,       spi_phaseHigh,  spi_polarityHigh,  (1 << 0) }, // P0_6 used to be 4
    {  1,           1000,       spi_phaseHigh,  spi_polarityHigh,  (1 << 7) }, // P0_7
};


void spi_init()
{
    #if defined SPI1_ALT1 || defined SPI1_ALT2
        spi_init1(SPI1);
    #endif

    #if defined SPI2_AL1 || defined SPI2_ALT2
        spi_init1(SPI2);
    #endif
}


bool spi_open(unsigned int channel)
{
    //assert(channel < spiChannel_numChannels);

    // Only change the configuration if the settings are different
    if( channel != curChannel && memcmp(&configs[channel], &configs[curChannel], sizeof(SpiConfig)) )
    {
        spi_config(&configs[channel]);
    }
    curChannel = channel;

    P0 &= ~configs[curChannel].cs;
                         
    return true;
}



bool spi_configureChannel(
                            unsigned int  channel//, -Removed all this because didn't think they were necessary -tmagcaya
                            //Spi_Callback spiCallback_, // must have this or both rxBuf_ and txBuf_
                            //void*        spiArg_,
                            //void*        rxBuf_,
                            //size_t       rxBufSize_,  // if rxBuf_ must be >= 1
                            //void*        txBuf_,      // if NULL, write blocks until all characters are sent
                            //size_t       txBufSize_   // if txBuf_ must be >= 1
                           )
{
    Spi_Config*  config;//there was a comma here before tmagcaya
    //assert(channel < spiChannel_numChannels);
    config = &spiConfigs[channel]; //there used to be a paranthesis at the end of the brackets here tmagcaya
    //assert(config);
    //assert(config->spiBusId == 0 || config->spiBusId == 1);
    
    configs[channel].spi_id       = (config->spiBusId == 0)              ? SPI1            : SPI2;
    configs[channel].clk_freq_MHz =  config->clkFreq_kHz / 1000;
    configs[channel].phase        = (config->phase    == spi_phaseLow)   ? SPI_CLOCK_PHA_0 : SPI_CLOCK_PHA_1;
    configs[channel].polarity     = (config->polarity == spi_polarityLow)? SPI_CLOCK_POL_LO: SPI_CLOCK_POL_HI;
    configs[channel].cs           =  config->chipSelectDioNumber;
    curChannel = channel;
    spi_config(&configs[channel]);

    // Initialize chip selects and make high (deasserted)
    P0SEL &= ~configs[channel].cs;
    P0DIR |=  configs[channel].cs;
    P0    |=  configs[channel].cs;
    
    return true;
}



void spi_close(unsigned int channel)
{
    //assert(channel < spiChannel_numChannels);
    P0 |= configs[curChannel].cs;
}



void spi_transfer(unsigned int channel, const void* txBuffer, void* rxBuffer, size_t size)
{
    uint8_t* tx = (uint8_t*)txBuffer;
    uint8_t* rx = (uint8_t*)rxBuffer;

    //assert(channel < spiChannel_numChannels);
    //assert(configs[channel].spi_id == SPI1 || configs[channel].spi_id == SPI2);
    //assert(txBuffer && rxBuffer);
    //assert(size > 0);

    // Note that the 'if' statements are outside the loop for speed of transfer
    // over the spi bus
    if( configs[channel].spi_id == SPI2 )
    {
        while( size-- > 0 )
        {
            SPI2_XFER(*tx++, *rx++);
        }
    }
    else
    {
        while( size-- > 0 )
        {
            SPI_XFER(*tx++, *rx++);
        }
    }
}



void spi_write(unsigned int channel, const void* buffer, size_t size)
{
    
    size_t i;
    const uint8_t* buf = buffer;

    //assert(channel < spiChannel_numChannels);
    //assert(configs[channel].spi_id == SPI1 || configs[channel].spi_id == SPI2);
    //assert(buffer);
    //assert(size > 0);
   

    // Note that the 'if' statements are outside the loop for speed of transfer
    // over the spi bus
    if( configs[channel].spi_id == SPI2 )
    {
        while( size-- > 0 )
        {
            SPI2_WRITE(*buf++);
        }
    }
    else
    {
        while( size-- > 0 )
        {
            SPI_WRITE(*buf++);
        }
    }
}



void spi_read(unsigned int channel, void* buffer, size_t size)
{
    size_t i;
    uint8_t* buf = buffer;

    //assert(channel < spiChannel_numChannels);
    //assert(configs[channel].spi_id == SPI1 || configs[channel].spi_id == SPI2);
    //assert(buffer);
    //assert(size > 0);


    // Note that the 'if' statements are outside the loop for speed of transfer
    // over the spi bus
    if( configs[channel].spi_id == SPI2 )
    {
        while( size-- > 0 )
        {
            SPI2_READ(*buf++);
        }
    }
    else
    {
        while( size-- > 0 )
        {
            SPI_READ(*buf++);
        }
    }
}



// EOF
