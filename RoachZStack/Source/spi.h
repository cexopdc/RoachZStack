#ifndef SPI_H
#define SPI_H

#ifdef __cplusplus
extern "C"
{
#endif
  
#include "ZComDef.h"

extern void SPI_Init(void);
extern void SPI_Write(uint8 len, uint8* buffer);

#ifdef __cplusplus
}
#endif

#endif