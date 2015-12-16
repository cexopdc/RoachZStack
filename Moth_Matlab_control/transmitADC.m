function transmitADC(port,adcTime)
% transmit run time for cc2530 ADC
% use 4 digit value such as '1000' or '0500'
port = serial(port,'BaudRate',115200);
fopen(port);

type = 'Y'; % for the adc transmit 'Y'
msg = [type, adcTime];

fwrite(port, msg)
fclose(port);
delete(port);
clear port;