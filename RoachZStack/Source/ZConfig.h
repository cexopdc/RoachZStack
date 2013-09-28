

#define RZS_ADC_VALUE     0xE0    // ZCL OTA Completion Indication
#define RZS_ADC_READ     0xE1    // ZCL OTA Completion Indication
#define RZS_DO_HANDSHAKE     0xE2    // ZCL OTA Completion Indication
#define BUFFER_SIZE 64
typedef struct
{
  osal_event_hdr_t hdr;
  uint8 buffer[BUFFER_SIZE];
} adcMsg_t;