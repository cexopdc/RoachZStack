clear all;
close all;
%delete(instrfindall)
<<<<<<< HEAD
port = serial('COM13','BaudRate',115200);
=======
port = serial('COM3','BaudRate',38400);
>>>>>>> origin/moth_muscles
fopen(port);

% transmit values in as 4 character (decimal) strings (for parse code to func)
% pad with 0s at front if shorter value is required
pinCombo = 'P'; 
posOnTime = '0100'; % time for positive stimulation
negOnTime = posOnTime;
negOffTime = '0050';
posOffTime = negOffTime;
stimCycleCount = '0003'; % numer of positive/neg stimulations
<<<<<<< HEAD
% current max value of 99
9
=======
% current max value of 999
>>>>>>> origin/moth_muscles
silenceTime = '3000';
totalCycleCount = '0005';
amplitude = 2; % will not be used for this iteration

msg = [pinCombo, posOnTime, posOffTime, negOnTime, negOffTime, stimCycleCount, silenceTime,totalCycleCount];

fwrite(port, msg); 
fclose(port);
delete(port);
<<<<<<< HEAD
clear port;
=======
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
>>>>>>> origin/moth_muscles
