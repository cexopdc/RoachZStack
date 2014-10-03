function cmd = send_gain_event(gain)
% Given a list of ina's to program with list of gains, sends gain_event
% to the microcontroller with appropriate gain values and which inas to
% program

% 'id' - specific ina, integer from [0,5]
% 'gain' - gain, integer from [1, 10000] (right now, max is around 3000)

%g  = cell2mat(gain);
%echeck = cell2mat(gain); Used for 2013a
echeck = gain;
if(length(echeck) < 6) 
    cmd = 0;
    return;
end

id  = ['0';'1';'2';'3';'4';'5'];

i = 1;
while(i < 7)
   g = char(gain(i));
   if length(g) < 4
       temp = addzero(length(g));
       g_new = [temp,g];
   else
       g_new = g;
   end
   cmd(i,:) = ['C', g_new, id(i), 'N'];
   i = i+1;
end

end


function y = addzero(len)
max = 4;
y='';
for i = drange(1:max-len)
    y = ['0',y];
end
end