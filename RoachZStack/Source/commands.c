#include "commands.h"

stimCommand* parseCommand(uint8* buf, uint8 len)
{
  stimCommand* cmd = osal_mem_alloc(sizeof(stimCommand));
  
  cmd->direction = buf[0];
  byte h = buf[1];
  byte l = buf[2];
  cmd->duration = (h<<8)+l;
  h = buf[3];
  l = buf[4];
  cmd->repeats = (h<<8)+l;
  
  return cmd;
  
}