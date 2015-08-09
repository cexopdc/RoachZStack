clc;clear all; close all;
figure(1);
hold on;

%aggregate rssi from 3 to 60m.
aggr_mean_rssi=[-55 -58 -57.5 -63 -64 -64.2 -68 -65 -69 -74 -71 -76 -75 -79.8 -81 -81.5 -82 -83.5 -82.5 -83;
                -57 -59.5 -60 -66 -67 -66.2 -69 -69.8 -73 -75 -75.5 -76 -77 -82 -84 -84.5 -85 -83.7 -86 -87.5;
                -56.8 -60 -60.8 -66.9 -68 -67.2 -68 -69.8 -73 -76 -75.5 -76.5 -77.5 -80 -83 -84.5 -84.5 -84.0 -85 -86.5;];
%{
aggr_std_rssi=[1.80 1.92 1.88 2.01 2.22 2.24 2.33 2.30 2.65 1.88 2.75 2.12 2.00 2.32 1.89 1.65 1.55 1.01 1.09 1.11;
                1.92 1.82 2.31 2.41 2.12 2.54 2.53 2.20 2.42 1.80 2.65 2.52 1.90 2.12 1.79 1.61 1.95 1.21 1.29 1.33;
                1.80 1.62 1.78 2.21 2.22 2.34 2.73 2.10 2.75 1.68 2.35 2.82 2.20 2.42 1.99 1.62 1.75 1.11 1.19 1.25];
 %}

%plot(x,mean_aggr,'b*','markersize', 10);
x = 3:3:60;
colormap('gray');
%aggr_mean_rssi = aggr_mean_rssi';
%aggr_std_rssi = aggr_std_rssi';
%h(2)=plot(x,aggr_mean_rssi,'bo','markersize', 5);
hLine = plot(x,aggr_mean_rssi,'LineWidth',2,'MarkerSize',8);
hLine(1).Marker = 'o';
hLine(2).Marker = 'd';
hLine(3).Marker = 'x';


%{
for i=1:3
    h_error=errorbar(x,aggr_mean_rssi(i,:),aggr_std_rssi(i,:),'bo','markersize', 5); %set(h,'linestyle','none');
end
%}

xlabel('Distance (m)');
ylabel('RSSI (dBm)');
xlim([0 65]);
legend(hLine(1:3),'2.494GHz','2.440GHz','2.400GHz');

set(gca, 'FontSize', 14, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'rf_freq_plot.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');