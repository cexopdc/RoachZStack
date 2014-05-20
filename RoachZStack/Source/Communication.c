#include "hal_i2c.h"

/*! Initializes the I2C communication peripheral. */
char I2C_Init(char addr, long clockFreq)
{
  HalI2CInit(addr, i2cClock_123KHZ);
  return 0;
}

/*! Writes data to a slave device. */
char I2C_Write(char slaveAddress,
               unsigned char* dataBuffer,
               char bytesNumber,
               char stopBit)
{
  return HalI2CWrite(bytesNumber, dataBuffer);
}

/*! Reads data from a slave device. */
char I2C_Read(char slaveAddress,
              unsigned char* dataBuffer,
              char bytesNumber,
              char stopBit)
{
  return HalI2CRead(bytesNumber, dataBuffer);
}