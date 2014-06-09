#ifdef IMPEDANCE

#include "sampler.h"
#include "hal_lcd.h"
#include "hal_led.h"
#include "hal_dma.h"
#include "hal_sleep.h"
#include "OSAL.h"
#include "bcomdef.h"
#include "edemaband.h"
#include "edemaProfile.h"
#include "stdio.h"
#include "hal_i2c.h"
#include "AD5933.h"
#include <math.h>
#ifdef BIPHASIC_STIM
#include "Stimulator.h"
#endif

#define MSG_SIZE 60

#define SPDT_BV                        BV(0)
#define SPDT_SBIT                      P2_0
#define SPDT_DDR                       P2DIR

// Task ID not initialized
#define NO_TASK_ID 0xFF

// Registered keys task ID, initialized to NOT USED.
uint8 Sampler_TaskID = NO_TASK_ID;    // Task ID for internal task/event processing.


static bool isEnabled;


/*********************************************************************
* @fn      RoachZStack_Init
*
* @brief   This is called during OSAL tasks' initialization.
*
* @param   task_id - the Task ID assigned by OSAL.
*
* @return  none
*/
void Sampler_Init( uint8 task_id )
{
  Sampler_TaskID = task_id;   
  isEnabled = FALSE;
  SPDT_DDR |= SPDT_BV;
}


#define SAMPLER_MODE_GAIN 0
#define SAMPLER_MODE_IMP  1
#define SAMPLER_MODE_RAW  2

typedef uint8 samplerMode_t;
samplerMode_t mode = 0;

uint8 sweepIncs = 0;
uint8 incCounter = 0;

extern unsigned long currentSysClk;
extern unsigned char currentClockSource;
extern unsigned char currentGain;
extern unsigned char currentRange;

signed short realData;
signed short imagData;
double magnitude;
double value;
unsigned long calibrationImpedance;


union {
  struct{
    double gains[NUM_FREQ];
    double imps[NUM_FREQ];
  } magnitudes;
  struct{
    signed long real[NUM_FREQ];
    signed long imag[NUM_FREQ];
  } complex;
  double raw[NUM_FREQ * 2];
} data;
double mean_gain = 0;
double mean_imp = 0;


/*********************************************************************
* @fn      RoachZStack_ProcessEvent
*
* @brief   Generic Application Task event processor.
*
* @param   task_id  - The OSAL assigned task ID.
* @param   events   - Bit map of events to process.
*
* @return  Event flags of all unprocessed events.
*/
UINT16 Sampler_ProcessEvent( uint8 task_id, UINT16 events )
{
  
  if (events & SAMPLER_START_SWEEP)
  {
    
    if (isEnabled)
    {
      
      AD5933_Init();
      AD5933_SetSystemClk(AD5933_CONTROL_INT_SYSCLK, AD5933_INTERNAL_SYS_CLK);
      
      #if defined BIPHASIC_STIM || defined VOLT_MONITOR
        BI_IMP_SBIT = 1;
      #endif
      
      unsigned long incFreq = 0;
      unsigned long startFreq = 0;
      unsigned char range = 0;
      unsigned char gain = 0;
      unsigned char electrodes = 0;
      EdemaProfile_GetParameter( EDEMAPROFILE_STARTFREQ, &startFreq );
      EdemaProfile_GetParameter( EDEMAPROFILE_INCFREQ, &incFreq );
      EdemaProfile_GetParameter( EDEMAPROFILE_RANGE, &range );
      EdemaProfile_GetParameter( EDEMAPROFILE_GAIN, &gain );
      EdemaProfile_GetParameter( EDEMAPROFILE_ELECTRODES, &electrodes );
      
      // Set SPDT Switch for AD5933
      SPDT_SBIT = (electrodes == 0) ? 0 : 1 ;
      
      AD5933_ConfigSweep(startFreq, incFreq, NUM_FREQ);
      AD5933_SetRangeAndGain(range, gain);
      AD5933_StartSweep();
      incCounter = 0;
      calibrationImpedance = 497000;
      sweepIncs = NUM_FREQ;
      osal_set_event(Sampler_TaskID, SAMPLER_START_INC);      
      /*for (int i = 0; i < 50; i++)
      {
        data.magnitudes.imps[i] = AD5933_CalculateImpedance(5.15e-8, AD5933_FUNCTION_INC_FREQ);
      }
      EdemaProfile_SetParameter( EDEMAPROFILE_SWEEPDATA, sizeof(data.magnitudes.gains), data.magnitudes.gains );*/
      
    }
    return events ^ SAMPLER_START_SWEEP;
  }
  
  if (events & SAMPLER_START_INC)
  {
    
    AD5933_SetRegisterValue(AD5933_REG_CONTROL_HB,
                            AD5933_CONTROL_FUNCTION(AD5933_FUNCTION_INC_FREQ) |
                            AD5933_CONTROL_RANGE(currentRange) | 
                            AD5933_CONTROL_PGA_GAIN(currentGain),    
                            1);
    osal_set_event(Sampler_TaskID, SAMPLER_INC_SWEEP);
    return events ^ SAMPLER_START_INC;
  }
  
  if (events & SAMPLER_INC_SWEEP)
  {
       
    unsigned long status = AD5933_GetRegisterValue(AD5933_REG_STATUS,1);
    if((status & AD5933_STAT_DATA_VALID) == 0)
    {
        osal_set_event(Sampler_TaskID, SAMPLER_INC_SWEEP);
    }
    else
    {
      osal_set_event(Sampler_TaskID, SAMPLER_CALC_IMP);
    }
    return events ^ SAMPLER_INC_SWEEP;
  }
  
  if (events & SAMPLER_CALC_IMP)
  {
    realData = AD5933_GetRegisterValue(AD5933_REG_REAL_DATA,2);
    imagData = AD5933_GetRegisterValue(AD5933_REG_IMAG_DATA,2);
    
    if(mode == SAMPLER_MODE_GAIN)
    {
      magnitude = sqrt((realData * realData) + (imagData * imagData));
      value = 1 / (magnitude * calibrationImpedance);
      data.magnitudes.gains[incCounter] = value;
      mean_gain += value;
    }
    else if (mode == SAMPLER_MODE_IMP)
    {
      magnitude = sqrt((realData * realData) + (imagData * imagData));
      value = 1 / (magnitude * data.magnitudes.gains[incCounter]);
      //value = 1 / (magnitude * mean_gain);
      data.magnitudes.imps[incCounter] = value;
      mean_imp += value;
    }
    else
    {
      data.complex.real[incCounter] = realData;
      data.complex.imag[incCounter] = imagData;
    }
    incCounter++;
    if (incCounter >= sweepIncs)
    {
      osal_set_event(Sampler_TaskID, SAMPLER_STOP_SWEEP);
    }
    else
    {
      osal_set_event(Sampler_TaskID, SAMPLER_START_INC);
    }
    
    return events ^ SAMPLER_CALC_IMP;
  }
  
  if (events & SAMPLER_STOP_SWEEP)
  {
    if(mode == SAMPLER_MODE_GAIN)
    {
      mean_gain /= NUM_FREQ;
      EdemaProfile_SetParameter( EDEMAPROFILE_SWEEPDATA, sizeof(data.magnitudes.gains), data.magnitudes.gains );
    }
    else if (mode == SAMPLER_MODE_IMP)
    {
      mean_imp /= NUM_FREQ;
      EdemaProfile_SetParameter( EDEMAPROFILE_SWEEPDATA, sizeof(data.magnitudes.imps), data.magnitudes.imps );
    }
    else
    {
      EdemaProfile_SetParameter( EDEMAPROFILE_SWEEPDATA, sizeof(data.complex.real), data.complex.real );
      EdemaProfile_SetParameter( EDEMAPROFILE_SWEEPDATA2, sizeof(data.complex.imag), data.complex.imag );
    }  
    uint8 done = 1;
    EdemaProfile_SetParameter( EDEMAPROFILE_SWEEP_DONE, 1, &done );
    AD5933_SetRegisterValue(AD5933_REG_CONTROL_HB,
                        AD5933_CONTROL_FUNCTION(AD5933_FUNCTION_POWER_DOWN) |
                        AD5933_CONTROL_RANGE(currentRange) | 
                        AD5933_CONTROL_PGA_GAIN(currentGain),
                        1);
    AD5933_Reset();
    //SetMEnabled(false);
    
    return events ^ SAMPLER_STOP_SWEEP;
  }
  
  return events;
}

void Sampler_SetState( int cmd )
{
  isEnabled = true;
  if( cmd == 1)
  {
    mode = SAMPLER_MODE_GAIN;
  }
  else if( cmd == 0)
  {
    mode = SAMPLER_MODE_IMP;
  }
  else 
  {
    mode = SAMPLER_MODE_RAW;
  }
  osal_set_event(Sampler_TaskID, SAMPLER_START_SWEEP );
  
  return;
}

#endif