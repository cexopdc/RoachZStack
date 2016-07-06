/* spi_master.h
 *
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

#if !defined spi_master_h
    #define  spi_master_h
    #include <stdlib.h>   //added for 'size_t'
    #include <stddef.h>   //added for 'size_t'
    #include <stdint.h>
    #include <stdbool.h> //fgong_testing

    typedef enum
    {
        spi_phaseLow,
        spi_phaseHigh,
    } VPSpi_Phase;

    typedef enum
    {
        spi_polarityLow,
        spi_polarityHigh,
    } VPSpi_Polarity;

    typedef struct
    {
        uint8_t        spiBusId;
        uint16_t       clkFreq_kHz;
        VPSpi_Phase    phase;
        VPSpi_Polarity polarity; 
        unsigned int   chipSelectDioNumber; 
    } Spi_Config;




    #ifdef __cplusplus
        extern "C"
        {
    #endif



    typedef void             (*Spi_Callback)(unsigned int channel, void* arg, const void* data, size_t size);
        // if not NULL, called as characters are received from the serial hardware



    void spi_init    (void);
        /* call once before any other spi_ function
         */


    bool spi_open    (unsigned int channel);
        /* Attempt to lock the SPI port associated with channel;
         * if the lock was obtained, assert the slave-select associated with channel;
         * return true if the lock was attained.
         */

    bool spi_configureChannel(
                                unsigned int        channel//, -Removed all this because didn't think they were necessary -tmagcaya
                                // Spi_Callback        spiCallback_, // must have this or both rxBuf_ and txBuf_
                                // void*               spiArg_,
                                // void*               rxBuf_,
                                // size_t              rxBufSize_,  // if rxBuf_ must be >= 1
                                // void*               txBuf_,      // if NULL, write blocks until all characters are sent
                                // size_t              txBufSize_   // if txBuf_ must be >= 1
                                );

    void spi_close   (unsigned int channel);
        /* Deassert the slave-select associated with channel;
         * unlock the SPI port associated with channel.
         */

    
    void spi_transfer(unsigned int channel, const void* txBuffer, void* rxBuffer, size_t size);
        /* If txBuffer is non-null, transmit txSize bytes from txBuffer;
         * else, transmit size zero bytes instead.
         * If rxBuffer is non-null, simultaneously receive rxSize bytes into rxBuffer;
         * else, ignore the simultaneously received data.
         * The transmission and reception take place on the SPI port associated with channel, which must
         * have been successfully locked first.
         * (This is a blocking function; i.e., it does not return until the transfer is completed.)
         */


    void spi_write   (unsigned int channel, const void* buffer, size_t size);
        /* Transmit size bytes from txBuffer, ignoring simultaneously received data.
         * The transmission and reception take place on the SPI port associated with channel, which must
         * have been successfully locked first.
         * (This is a blocking function; i.e., it does not return until the transfer is completed.)
         */

    void spi_read    (unsigned int channel, void* buffer, size_t size);
        /* Transmit size zero bytes and simultaneously receive size bytes into buffer.
         * The transmission and reception take place on the SPI port associated with channel, which must
         * have been successfully locked first.
         * (This is a blocking function; i.e., it does not return until the transfer is completed.)
         */



    #ifdef __cplusplus
        } // extern "C"
    #endif



#endif
