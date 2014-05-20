#include "commands.h"

stimCommand* parseCommand(uint8* buf, uint8 len)
{
  stimCommand* cmd = osal_mem_alloc(sizeof(stimCommand));
  if (cmd != NULL)
  {
    cmd->direction = buf[0];
    uint8 h = buf[1];
    uint8 l = buf[2];
    cmd->duration = (h<<8)+l;
    h = buf[3];
    l = buf[4];
    cmd->repeats = (h<<8)+l;
  } 
  return cmd;
  
}