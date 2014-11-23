clear all;
close all;

fclose(instrfind)
port = serial('COM4','BaudRate',115200);
fopen(port);

t1 = 100; % positive stimulation time
N = 5; % number of positive stimulations
T = 500; % total stimulation cycle length
K = 2; % number of stimulation cycles
A = 1;

%transmit 6 bytes of data for all variables except the pin combo
pinCombo = 'A'; 
posOnTime = dec2hex(t1,2); % time for positive stimulation
negOnTime = posOnTime;
negOffTime = negOnTime;
posOffTime = posOnTime;
stimCycleCount = dec2hex(N,2); % numer of positive/neg stimulations
totalCycleTime = dec2hex(T,2);
totalCycleCount = dec2hex(K,2);
amplitude = dec2hex(A,6); % will not be used for this iteration


% rx as "aA 000064 000005 0001F4 000002"
msg = [pinCombo, posOnTime, negOnTime, posOffTime, negOffTime, stimCycleCount];%,totalCycleTime,totalCycleCount]; 
% msg = ['A',t1,N,T,K];

fwrite(port, msg); 

fclose(port);