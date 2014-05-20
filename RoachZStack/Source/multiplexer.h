#ifndef __MULTIPLEXER_H__
#define __MULTIPLEXER_H__

#include "stdio.h"
#include "bcomdef.h"

void InitMultiplexers();
void SetMEnabled(bool enabled);
void SetM1Input(uint8 channel);
void SetM2Input(uint8 channel);

#endif