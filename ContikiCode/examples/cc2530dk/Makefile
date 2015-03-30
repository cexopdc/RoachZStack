CONTIKI_PROJECT = example-unicast example-multihop example-broadcast hello-world blink-hello timer-test sensors-demo example-powertrace example-broadcast-button

#APPS+=powertrace
all: $(CONTIKI_PROJECT) 
DEFINES=NETSTACK_CONF_RDC=nullrdc_driver
HAVE_BANKING=1
DEFINES+=MODEL_CC2531=1

CONTIKI = ../..
include $(CONTIKI)/Makefile.include
