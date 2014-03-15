#include "spi.h"
#include "OnBoard.h"

#define MISO_PIN 4
#define MOSI_PIN 5
#define SCK_PIN 3
#define CS_PIN 0

void SPI_Init()
{
  
  // Setup SPI
  PERCFG |= 0x1 << 0;     // UART 0 in Alt 2
  P1SEL |= 0x1 << SCK_PIN;    // Set pins as output
  P1SEL |= 0x1 << MOSI_PIN;
  P1SEL |= 0x1 << MISO_PIN;
  P1SEL &= ~(0x1 << CS_PIN);     // CS for slave

  P2DIR = 0x80;

  // Set baud rate to max (system clock frequency / 8) 
  // Assuming a 32 MHz crystal (CC1110Fx/CC2510Fx), 
  // max baud rate = 32 MHz / 8 = 4 MHz. 
  U0BAUD = 0x00; // BAUD_M = 0 
  U0GCR |= 0x11; // BAUD_E = 17
  
  // SPI Master Mode
  U0CSR &= ~0xA0;
  
  // Configure phase, polarity, and bit order 
  U0GCR &= ~0xC0; // CPOL = 0; CPHA = 0
  U0GCR |= 0x20; // ORDER = 1 
  
  
  P1 |= (0x1<<CS_PIN);
}

void SPI_Write(uint8 len, uint8* buffer)
{
  P1 &= ~(0x1<<CS_PIN);
  for (int i = 0; i <= len; i++) 
  { 
   U0DBUF = buffer[i]; 
   while (!(U0CSR & 0x02)); 
   U0CSR &= ~0x02;
  } 
  P1 |= (0x1<<CS_PIN);
}