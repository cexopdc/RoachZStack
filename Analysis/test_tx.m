clear all;
close all;
%delete(instrfindall)

port = serial('COM13','BaudRate',115200);
fopen(port);

% ADC READ SECTION
% type = 'Y';
adcTime = '0900';

% STIMULATION TRANSMIT SECTION
% transmit values in as 4 character (decimal) strings (for parse code to func)
% pad with 0s at front if shorter value is required
% type = 'X';
pinCombo = 'P'; 
posOnTime = '0100'; % time for positive stimulation
negOnTime = posOnTime;
negOffTime = '0050';
posOffTime = negOffTime;
stimCycleCount = '0003'; % numer of positive/neg stimulations
silenceTime = '1000';
totalCycleCount = '0005';
amplitude = 2; % will not be used for this iteration

type = 'X'; % Y for ADC, X for stimulation
if type == 'X'
    msg = [type,pinCombo, posOnTime, posOffTime, negOnTime, negOffTime, stimCycleCount, silenceTime,totalCycleCount];
else
    msg = [type,adcTime];
end
fwrite(port, msg)
fclose(port);
delete(port);
clear port;

%     case 'A':
%       LEFT_1_SBIT = 0;
%       RIGHT_1_SBIT = 0;
%       LEFT_2_SBIT = 0;
%       RIGHT_2_SBIT = 0;
%       break;
%     case 'B':
%       LEFT_1_SBIT = 1;
%       RIGHT_1_SBIT = 0;
%       LEFT_2_SBIT = 0;
%       RIGHT_2_SBIT = 0;
%       break;
%     case 'C':
%       LEFT_1_SBIT = 0;
%       RIGHT_1_SBIT = 1;
%       LEFT_2_SBIT = 0;
%       RIGHT_2_SBIT = 0;
%       break;
%      case 'D':
%       LEFT_1_SBIT = 1;
%       RIGHT_1_SBIT = 1;
%       LEFT_2_SBIT = 0;
%       RIGHT_2_SBIT = 0;
%       break;
%       case 'E':
%       LEFT_1_SBIT = 0;
%       RIGHT_1_SBIT = 0;
%       LEFT_2_SBIT = 1;
%       RIGHT_2_SBIT = 0;
%       break;
%     case 'F':
%       LEFT_1_SBIT = 1;
%       RIGHT_1_SBIT = 0;
%       LEFT_2_SBIT = 1;
%       RIGHT_2_SBIT = 0;
%       break;
%     case 'G':
%       LEFT_1_SBIT = 0;
%       RIGHT_1_SBIT = 1;
%       LEFT_2_SBIT = 1;
%       RIGHT_2_SBIT = 0;
%       break;
%      case 'H':
%       LEFT_1_SBIT = 1;
%       RIGHT_1_SBIT = 1;
%       LEFT_2_SBIT = 1;
%       RIGHT_2_SBIT = 0;
%       break;
%     case 'I':
%       LEFT_1_SBIT = 0;
%       RIGHT_1_SBIT = 0;
%       LEFT_2_SBIT = 0;
%       RIGHT_2_SBIT = 1;
%       break;
%     case 'J':
%       LEFT_1_SBIT = 1;
%       RIGHT_1_SBIT = 0;
%       LEFT_2_SBIT = 0;
%       RIGHT_2_SBIT = 1;
%       break;
%     case 'K':
%       LEFT_1_SBIT = 0;
%       RIGHT_1_SBIT = 1;
%       LEFT_2_SBIT = 0;
%       RIGHT_2_SBIT = 1;
%       break;
%      case 'L':
%       LEFT_1_SBIT = 1;
%       RIGHT_1_SBIT = 1;
%       LEFT_2_SBIT = 0;
%       RIGHT_2_SBIT = 1;
%       break;
%     case 'M':
%       LEFT_1_SBIT = 0;
%       RIGHT_1_SBIT = 0;
%       LEFT_2_SBIT = 1;
%       RIGHT_2_SBIT = 1;
%       break;
%     case 'N':
%       LEFT_1_SBIT = 1;
%       RIGHT_1_SBIT = 0;
%       LEFT_2_SBIT = 1;
%       RIGHT_2_SBIT = 1;
%       break;
%     case 'O':
%       LEFT_1_SBIT = 0;
%       RIGHT_1_SBIT = 1;
%       LEFT_2_SBIT = 1;
%       RIGHT_2_SBIT = 1;
%       break;
%      case 'P':
%       LEFT_1_SBIT = 1;
%       RIGHT_1_SBIT = 1;
%       LEFT_2_SBIT = 1;
%       RIGHT_2_SBIT = 1;
%       break;
