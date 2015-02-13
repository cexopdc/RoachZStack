
#ifndef COMMANDS_H
#define COMMANDS_H

#include "OnBoard.h"

typedef struct
{
  uint8 direction;
  int16 posOn;
  int16 posOff;
  int16 negOn; //for biphasic stimulation
  int16 negOff;
  int16 repeats; // number of posOn/negOn cycles
  int16 silence; // time within cycle after stimulation to wait
  int16 totalCount; // total number of stim cycles + silence time
  int16 stim; // this is to set if silence timer should be used, or posOn/NegOn
  int16 pulseCount; // hold number of pulses inside cycle constant to allow reset
} stimCommand;

extern stimCommand* parseCommand(uint8* buf, uint8 len);
extern int16 convert(uint8* buf, int16 size, int8 offset);


#endif