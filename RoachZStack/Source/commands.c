#include "commands.h"
#include <stdlib.h>
#include <stdio.h> //not included 

//inputs buffer and breaks out specific sized chunk at each offset
// this string is then converted to an int and returned
int16 convert(uint8* buf, int16 size, int8 offset) {
  char* num = osal_mem_alloc(size);
  uint8 i;
  
  for(i = 0; i < size; i++) {
    num[i] = buf[i+offset];
  }
  int value = atoi(num);
  osal_mem_free(num);
  return value; 
}

// requires a string buffer with the values for each element of the struct
// to be set in this specific order. Each value will be 4 digits long. 
// the first item of the buffer will be a char for the pin combo
// the 0th item will be the type of command (stimulation in this case)
stimCommand* parseCommand(uint8* buf, uint8 len)
{
  stimCommand* cmd = osal_mem_alloc(sizeof(stimCommand));
  if (cmd != NULL)
  {
    cmd->direction = buf[1];
    cmd->posOn = convert(buf,4,2);
    cmd->posOff = convert(buf,4,6);
    cmd->negOn = convert(buf,4,10);
    cmd->negOff = convert(buf,4,14);
    cmd->repeats = convert(buf,4,18);
    cmd->silence = convert(buf,4,22);
    cmd->totalCount = convert(buf,4,26);
    cmd->stim = 1; // start stimulation cycles immediately
    cmd->pulseCount = convert(buf,4,18);//cmd->repeats;
  } 
  return cmd;
  
}