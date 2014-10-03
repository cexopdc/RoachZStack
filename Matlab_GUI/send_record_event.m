function  [y, chans] = send_record_event( Uij )
% Aij = [5 11 16 21 27 32; 
%        2 7 12 17 23 28; 
%        4 9 14 20 26 31; 
%        3 8 13 18 24 29];

% 'B' is the command for uC to recognize that this is a recording event
% 'select line' is an integer from [0,3] to tell uC which select line from
%               ADG is to be recorded
% 'channel id'  are the ADC channels to turn on and record from

% cmd = 'B' + 'select line' + 'channel id'

sum    = [0; 0; 0; 0];
select = [0; 0; 0; 0];
chans = []; record = 0;
idx = 1; jidx = 1; max = 0;

for j = 1:4
    for i = 1:6
        sum(jidx) = sum(jidx) + Uij(j,i);
        if Uij(j,i)
            chans(jidx,idx) = i-1;
            idx = idx+1;
        end
    end
    idx = 1;
    if sum(jidx) > 0
        record = record + 1;
        select(jidx) = j-1;
        if sum(jidx) > max
            max = sum(jidx);
        end
        jidx = jidx + 1;
    else 
        sum(jidx)    = '';
        select(jidx) = '';
    end
end

for i = 0:length(sum)-1
    temp     = num2str(chans(i+1 , 1:sum(i+1) ));
    temp     = regexprep( temp ,'[^\w'']','');
    str      = filler(max-length(temp));
    cmd(i+1,:) = ['B', num2str(select(i+1)), temp, str];
end
y = cmd;
end

% filler returns a string 'NNN...' in order to keep cmd as a square matrix
function str = filler(num)
    str = '';
    for i = 1:num
        str = [str, 'N'];
    end
end

