
#ifndef COMMANDS_H
#define COMMANDS_H

#include "AF.h"
#include "OnBoard.h"


typedef struct
{
  byte direction;
  uint16 repeats;
  uint16 duration;
} stimCommand;

extern stimCommand* parseCommand(uint8* buf, uint8 len);

#endif