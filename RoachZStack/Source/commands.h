
#ifndef COMMANDS_H
#define COMMANDS_H

#include "AF.h"
#include "OnBoard.h"


typedef struct
{
  byte direction;
  uint16 repeats;
  uint16 posOn;
  uint16 posOff;
  uint16 negOn; //for biphasic stimulation
  uint16 negOff;
} stimCommand;

extern stimCommand* parseCommand(uint8* buf, uint8 len);

#endif