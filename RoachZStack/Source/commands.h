
#ifndef COMMANDS_H
#define COMMANDS_H

#include "OnBoard.h"


typedef struct
{
  uint8 direction;
  int16 repeats;
  int16 posOn;
  int16 posOff;
  int16 negOn; //for biphasic stimulation
  int16 negOff;
} stimCommand;

extern stimCommand* parseCommand(uint8* buf, uint8 len);
extern int16 convert(uint8* buf, int16 size, int8 offset);


#endif