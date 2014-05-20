
#ifndef COMMANDS_H
#define COMMANDS_H

#include "OnBoard.h"


typedef struct
{
  uint8 direction;
  uint16 repeats;
  uint16 duration;
} stimCommand;

extern stimCommand* parseCommand(uint8* buf, uint8 len);

#endif