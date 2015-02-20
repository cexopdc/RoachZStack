clc;clear all; close all;
dist_rssi_aggr=[];

%i=[0.3:0.3:5.1 6.0:0.9:15.0 18.0:3.0:66.0];
%i=[0.3:0.3:5.1 6.0:0.9:15.0 18.0:3.0:30.0];
for i = [0.3:0.3:5.1 6.0:0.9:15.0 18.0:3.0:30.0];
    for j=1:1:5
        input = load(strcat(sprintf('%0.1f',i),'m_',num2str(j),'.txt'));
        input = input(1:1000,:);
        current_dist_rssi = [i*ones(1000,1) input];
        dist_rssi_aggr = [dist_rssi_aggr;current_dist_rssi];
    end
end

dlmwrite('dist_rssi_aggr.txt', dist_rssi_aggr, 'delimiter','\t');%, '-append');