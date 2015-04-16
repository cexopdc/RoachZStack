%{
clc;clear all; close all;
dist_rssi_aggr = load('dist_rssi_aggr.txt');
sorted_dist_rssi_aggr = sortrows(dist_rssi_aggr(),-2); 
num_rssi = length(sorted_dist_rssi_aggr);
previous_rssi = 0; 
rssi_list = []; % List of rssi values in descending order
for i=1:num_rssi
    current_rssi = sorted_dist_rssi_aggr(i,2);
    if current_rssi < previous_rssi
        rssi_list = [rssi_list current_rssi];
        dlmwrite(strcat('dist_rssi_',sprintf('%0.1f',current_rssi),'.txt'), sorted_dist_rssi_aggr(i,:), 'delimiter','\t');%, '-append');
    end
    if current_rssi == previous_rssi
        dlmwrite(strcat('dist_rssi_',sprintf('%0.1f',current_rssi),'.txt'), sorted_dist_rssi_aggr(i,:), 'delimiter','\t','-append');
    end
    previous_rssi = current_rssi;
end

max_rssi = max(sorted_dist_rssi_aggr(:,2))
min_rssi = min(sorted_dist_rssi_aggr(:,2))
%

delete 'dist_mean_std_diff_rssi.txt';
for i = rssi_list 
    current_dist_rssi = load(strcat('dist_rssi_',sprintf('%0.1f',i),'.txt'));
    mean_dist = mean(current_dist_rssi(:,1));
    std_dist = std(current_dist_rssi(:,1));
    rssi_mean_std = [i mean_dist std_dist];
    dlmwrite('dist_mean_std_diff_rssi.txt', rssi_mean_std, 'delimiter','\t', '-append');
end
%}
rssi_mean_std = load('dist_mean_std_diff_rssi.txt');
rho_mean = rssi_mean_std(:,2)';
rho_std = rssi_mean_std(:,3)';

figure
x = rssi_mean_std(:,1)';
plot(x,rho_mean,'b');
ylim([0 40]);
ylabel('distance (m)');
xlabel('RSSI');
hold on;
h=errorbar(x,rho_mean,rho_std,'b'); set(h,'linestyle','none');