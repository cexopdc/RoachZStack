#include "commands.h"

stimCommand* parseCommand(uint8* buf, uint8 len)
{
  stimCommand* cmd = osal_mem_alloc(sizeof(stimCommand));
  if (cmd != NULL)
  {
    cmd->direction = buf[0];
    cmd->posOn = *(uint16*) (buf+1);
    cmd->posOff = *(uint16*) (buf+3);
    cmd->negOn = *(uint16*) (buf+5);
    cmd->negOff = *(uint16*) (buf+7);
    //byte h = buf[1];
    //byte l = buf[2];
    //cmd->duration = (buf[1]<<8)+buf[2];
   //h = buf[3];
   // l = buf[4];
    cmd->repeats = *(uint16*) (buf+9);
  } 
  return cmd;
  
}