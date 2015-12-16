delete(instrfindall)

% use the COM port that matches the arduino uno
s=serial('COM5','BAUD', 9600); % Make sure the baud rate and COM port is 
                              % same as in Arduino IDE
fopen(s);
pause(2); %minimum required for arduino to receive message

% structure message as string
% send either b or f to choose direction (back, forward)
% and then an int to select speed
direction = 'f';
speed = '100';
msg = strcat(direction,speed)
fprintf(s,msg); 
delete(instrfindall)


