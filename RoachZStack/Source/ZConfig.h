

#define RZS_ADC_VALUE     0xE0    // ZCL OTA Completion Indication
#define RZS_ADC_READ     0xE1    // ZCL OTA Completion Indication
typedef struct
{
  osal_event_hdr_t hdr;
  uint8 value;
} adcMsg_t;