port = serial('COM4','BaudRate',115200);
fopen(port);

% STIMULATION TRANSMIT SECTION
% transmit values in as 4 character (decimal) strings (for parse code to func)
% pad with 0s at front if shorter value is required
pinCombo = 'P'; 
posOnTime = '0100'; % time for positive stimulation
negOnTime = posOnTime;
negOffTime = '0050';
posOffTime = negOffTime;
stimCycleCount = '0003'; % numer of positive/neg stimulations
silenceTime = '1000';
totalCycleCount = '0010';
amplitude = 2; % will not be used for this iteration

type = 'X'; % Y for ADC, X for stimulation
msg = [type,pinCombo, posOnTime, posOffTime, negOnTime, negOffTime, stimCycleCount, silenceTime,totalCycleCount];

fwrite(port, msg)
fclose(port);
delete(port);
clear port;