#include "commands.h"

stimCommand* parseCommand(uint8* buf, uint8 len)
{
  stimCommand* cmd = osal_mem_alloc(sizeof(stimCommand));
  if (cmd != NULL)
  {
    cmd->direction = buf[0];
    cmd->posOn = *(uint16*) (buf+1);
    cmd->repeats = *(uint16*) (buf+2);
  } 
  return cmd;
  
}