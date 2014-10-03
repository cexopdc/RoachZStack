function cmd = send_current_event(A, Th, per) %dir)
% Sends a command to uC to perform a bi-phasic current stimulation

% 'A' - command to let uC know this is current event
% 'amp' - amplitude of current as an integer
% 'hold' - hold time as an integer (for now it's in milliseconds, later to
%           be microseconds
% 'direct' - select lines of current mux; Tells which stim pad to go to

amp = str2num(A);
amp = floor(1000*amp);

% if length(Th) == 1
%     holdt = ['00', Th];
% else if length(Th) == 2
%     holdt = ['0', Th];
% else if length(Th) >= 3
%         holdt = Th(1:3);
%     end
% end

% It is assumed that the number of cycles will not exceed 99
if length(per) == 1
    period = ['0', per];
else if length(per) > 2
        period = per(1:2);
    else
        period = per;
    end
end

if length(Th) == 1
    holdt = ['00', Th];
else if length(Th) == 2
        holdt = ['0', Th];
    else
        holdt = Th(1:3);
    end
end

% idx = 0;
% while(idx < 4)
%     if(dir(idx+1) == 1) 
%         break;
%     end
%     idx = idx + 1;
% end
% direct = idx;

% amp    = regexprep( num2str(A) ,'[^\w'']','');
% 
% for i = 0:3-length(amp)
%     amp = ['0', amp];
% end

%direct = regexprep( num2str(direct) ,'[^\w'']','');

%cmd = ['A', amp, holdt, direct, 'N'];
cmd = ['A', period, holdt, 'N'];
end

