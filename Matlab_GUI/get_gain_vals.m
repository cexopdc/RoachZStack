function gains = get_gain_vals()
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% dn = 0:1:255;
% Rg = (100000)*dn./256 + 180;
% gain = 1 + floor(50000./Rg);
% gain = sort(gain, 'ascend');
% temp = remove_dups(gain);
% temp = num2str(temp);
% temp = regexp(temp, ' ', 'split');
%gains = regexp(temp, ' ', 'split'); % This is used for MATLAB R2012a
% gains = num2str(gains);
%gains = strsplit(temp, ' ');
gains = cellstr(['001'; '002'; '003'; ...
                '004'; '005'; '006'; ...
                '007'; '008'; '009'; ...
                '010'; '011'; '012'; ...
                '013'; '014'; '016'; ...
                '018'; '020'; '024'; ...
                '029'; '037'; '053'; '088';  '278']);
end



