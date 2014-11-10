
#ifndef COMMANDS_H
#define COMMANDS_H

#include "OnBoard.h"


typedef struct
{
  uint8 direction; // pin combo
  uint16 repeats; // number of beats
  uint16 posOn; // time of positive signal
} stimCommand;

extern stimCommand* parseCommand(uint8* buf, uint8 len);

#endif