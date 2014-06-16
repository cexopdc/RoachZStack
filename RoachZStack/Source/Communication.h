/*! Initializes the I2C communication peripheral. */
char I2C_Init(char addr, long clockFreq);

/*! Writes data to a slave device. */
char I2C_Write(char slaveAddress,
               unsigned char* dataBuffer,
               char bytesNumber,
               char stopBit);

/*! Reads data from a slave device. */
char I2C_Read(char slaveAddress,
              unsigned char* dataBuffer,
              char bytesNumber,
              char stopBit);