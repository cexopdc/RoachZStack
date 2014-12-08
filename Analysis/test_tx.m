clear all;
close all;

% fclose(instrfind)
port = serial('COM5','BaudRate',115200);
fopen(port);

% transmit values in as 4 character (decimal) strings (for parse code to func)
% pad with 0s at front if shorter value is required
pinCombo = 'A'; 
posOnTime = '0100'; % time for positive stimulation
negOnTime = posOnTime;
negOffTime = '0050';
posOffTime = negOffTime;
stimCycleCount = '0005'; % numer of positive/neg stimulations
silenceTime = '0500';
totalCycleCount = '0020';
amplitude = 2; % will not be used for this iteration

msg = [pinCombo, posOnTime, posOffTime, negOnTime, negOffTime, stimCycleCount, silenceTime,totalCycleCount];

fwrite(port, msg); 
fclose(port);