#include "multiplexer.h"
#include "hal_board.h"

#define M1_A0 P0_1
#define M1_A1 P0_2

#define M2_A0 P0_3
#define M2_A1 P0_4
#define M_EN P0_0

void InitMultiplexers()
{
  P0SEL &= ~0x1F;
  P0DIR |= 0x1F;
  SetMEnabled(false);
}

void SetMEnabled(bool enabled)
{
  M_EN = enabled?1:0;
}


void SetM1Input(uint8 channel)
{
  M1_A1 = channel / 2;
  M1_A0 = channel % 2;
}


void SetM2Input(uint8 channel)
{
  M2_A1 = channel / 2;
  M2_A0 = channel % 2;
}