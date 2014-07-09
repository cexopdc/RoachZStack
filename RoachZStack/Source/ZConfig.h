

#define RZS_ADC_VALUE     0xE0
#define RZS_ADC_PROCESS   0x01
#define BUFFER_SIZE_BYTES 45
#define BUFFER_SIZE (BUFFER_SIZE_BYTES)
typedef struct
{
  osal_event_hdr_t hdr;
  uint8 buffer[BUFFER_SIZE];
  uint8 size;
} adcMsg_t;