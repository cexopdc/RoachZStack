#include "clock.h"
#include "spi.h"
#include "hal_spi.h"
#include "hal_board.h"
#include "ioCC2530.h"
#include "hal_types.h"
#include "hal_lcd.h"
#include "hal_defs.h"
#include "hal_mcu.h"

#define MISO_PIN 7
#define MOSI_PIN 6
#define SCK_PIN 5
#define CS_PIN 4

uint8 rxBufferSlave;
uint8 rxBufferMaster;

void spi_master_init(void)
{
// Master Mode
PERCFG |= 0x02; // PERCFG.U1CFG = 1
P1SEL |= 0xE0; // P1_7, P1_6, and P1_5 are peripherals
P1SEL &= ~0x10; // P1_4 is GPIO (SSN)
P1DIR |= 0x10; // SSN is set as output

/*
// Slave Mode
PERCFG |= 0x02; // PERCFG.U1CFG = 1
P1SEL |= 0xF0; // P1_7, P1_6, P1_5, and P1_4 are peripherals 
*/

// Set baud rate to max (system clock frequency / 8)
// Assuming a 32 MHz crystal (CC2530F256),
// max baud rate = 32 MHz / 8 = 4 MHz.
U1BAUD = 0x00; // BAUD_M = 0
U1GCR |= 0x11; // BAUD_E = 17


// SPI Master Mode
U1CSR &= ~0xA0;

/*
// SPI Slave Mode
U1CSR &= ~0x80;
U1CSR |= 0x20; 
*/

// Configure phase, polarity, and bit order
U1GCR &= ~0xC0; // CPOL = CPHA = 0
U1GCR |= 0x20; // ORDER = 1

/*
//1st priority: USART 1
P2DIR &= ~0xC0;
P2DIR |= ~0x40;
*/

}

void spi_slave_init(void)
{

// Slave Mode
PERCFG |= 0x02; // PERCFG.U1CFG = 1
P1SEL |= 0xF0; // P1_7, P1_6, P1_5, and P1_4 are peripherals 


// Set baud rate to max (system clock frequency / 8)
// Assuming a 32 MHz crystal (CC2530F256),
// max baud rate = 32 MHz / 8 = 4 MHz.
U1BAUD = 0x00; // BAUD_M = 0
U1GCR |= 0x11; // BAUD_E = 17


// SPI Slave Mode
U1CSR &= ~0x80;
U1CSR |= 0x20; 


// Configure phase, polarity, and bit order
U1GCR &= ~0xC0; // CPOL = CPHA = 0
U1GCR |= 0x20; // ORDER = 1

/*
//1st priority: USART 1
P2DIR &= ~0xC0;
P2DIR |= ~0x40;
*/

}


/*
void SPI_Init()
{
  
  // Setup SPI
  PERCFG |= 0x1 << 1;     // UART 1 in Alt 2
  P1SEL |= 0x1 << SCK_PIN;    // Set pins as output
  P1SEL |= 0x1 << MOSI_PIN;
  P1SEL |= 0x1 << MISO_PIN;
  P1SEL &= ~(0x1 << CS_PIN);     // CS for slave

  P2DIR = 0x80;

  // Set baud rate to max (system clock frequency / 8) 
  // Assuming a 32 MHz crystal (CC1110Fx/CC2510Fx), 
  // max baud rate = 32 MHz / 4096 = 976 hz. 
  U1BAUD = 0x00; // BAUD_M = 0 
  U1GCR |= 0x03; // BAUD_E = 8
  
  // SPI Master Mode or SPI Slave Mode
  U1CSR |= 0x20;
  
  // Configure phase, polarity, and bit order 
  U1GCR &= ~0x80; // CPOL = 0; CPHA = 1
  U1GCR |= 0x20; // ORDER = 1 
  
  
  P1 |= (0x1<<CS_PIN);
}
*/

void SPI_Write(int len, int txBufferMaster)
{
// SPI Master  
for (int i = 0; i <= len; i++)
{
 P1_4 = 0;
 U1DBUF = txBufferMaster;
 while (!U1TX_BYTE);
 P1_4 = 1;
 U1TX_BYTE = 0;
}
}

/*
{
  P1_4 = 0;
  //for (int i = 0; i < len; i++) 
  //{ 
   U1DBUF = buffer; 
   while (!U1TX_BYTE); 
   U1TX_BYTE = 0;
 //} 
  //P1 |= (0x1<<CS_PIN);
  
  P1_4 = 1;
}
*/

void SPI_Read()
{ 
  
// SPI Slave

 while (!U1RX_BYTE);
 rxBufferSlave = U1DBUF;
 U1RX_BYTE = 0;
 
}
//sDataReceived = TRUE; 
/*
  uint8 buffer;
 
   while (!U1RX_BYTE) 
   buffer = U1DBUF;
   U1RX_BYTE = 0;
 
  return (buffer);

}
*/

void main()
{
  
  U1UCR = 0x80; // Flushes the UArT1 to Idle State
  //unsigned int i;
  halMcuWaitMs(100);
  halLcdInit();
  halMcuWaitMs(100);
  halLcdClear();
  halMcuWaitMs(100);
  spi_master_init();
  halMcuWaitMs(100);
  //halLcdDisplayValue(uint8 line, char XDATA *pLeft, int32 value, char XDATA *pRight);
  halLcdWriteLine(1, "Master Tx");
  halMcuWaitMs(100);
  //halLcdWriteLine(HAL_LCD_LINE_2, "IMU:     ");
  SPI_Write(0,0x8f);
  halMcuWaitMs(100);
  //halLcdWriteLine(HAL_LCD_LINE_3, "done");

  halLcdWriteLine(2, "It's Done!");
  halMcuWaitMs(100);

}
