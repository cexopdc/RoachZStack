function rssi_process(input_file)
if nargin < 1
    disp('Please give one input file');
    return;
end

%get the first 1000 values
input = load(input_file);
input = input(1:1000,:);

%calculate statisctics 
max_rssi = max(input);
min_rssi = min(input);
mean_rssi = mean(input)
std_rssi = std(input)

%{
mean_rssi = num2str(mean_rssi);
std_rssi = num2str(std_rssi);
mean_std = [input_file '	' mean_rssi '	' std_rssi];

dlmwrite('mean_std_1m.txt', mean_std, 'delimiter','', '-append');
%}

%plot the histogram of rssi
xcenters = min_rssi:max_rssi;
hist(input,xcenters);
