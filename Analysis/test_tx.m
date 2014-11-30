clear all;
close all;

% fclose(instrfind)
port = serial('COM5','BaudRate',115200);
fopen(port);

t1 = 100; % positive stimulation time
N = 005; % number of positive stimulations
T = 500; % total stimulation cycle length
K = 2; % number of stimulation cycles
A = 1;

% transmit values in as 4 character strings (for parse code to func)
% pad with 0s at front if shorter value is required
pinCombo = 'B'; 
posOnTime = '0010'; % time for positive stimulation
negOnTime = posOnTime;
negOffTime = '0000';
posOffTime = negOffTime;
stimCycleCount = '0005'; % numer of positive/neg stimulations
totalCycleTime = dec2hex(T,2);
totalCycleCount = dec2hex(K,2);
amplitude = dec2hex(A,6); % will not be used for this iteration

msg = [pinCombo, posOnTime, posOffTime, negOnTime, negOffTime, stimCycleCount];

fwrite(port, msg); 

fclose(port);