#include "AD5933.h"
#include "hal_i2c.h"

void testAD5933(void)
{
  AD5933_Init();

  /* Writes data into a register. */
  AD5933_SetRegisterValue(0x80, 0x77, 1);
  
  uint8 byte1 = AD5933_GetRegisterValue(0x80, 1);
  
  Status_t status = SUCCESS;
}


