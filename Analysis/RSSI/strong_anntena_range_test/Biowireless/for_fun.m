clc;clear all; close all;
figure(1);
hold on;

%aggregate rssi from 3 to 60m.
aggr_mean_rssi=[-64.06 -68.32 -70.72 -73.95 -75.19 -74.23 -78.00 -79.13 -80.28 -82.97 -81.27 -84.25 -84.92 -85.25 -84.93 -86.05 -87.95 -90.16 -91.16 -89.16;
                -66.06 -70.32 -72.72 -76.95 -80.19 -77.23 -81.00 -84.13 -85.38 -84.57 -84.17 -86.65 -86.72 -90.05 -90.93 -89.25 -92.95 -93.16 -93.26 -93.06;
                -65.62 -71.75 -73.62 -75.45 -77.29 -76.13 -79.50 -80.93 -83.08 -83.17 -83.97 -85.05 -85.02 -86.15 -88.93 -88.45 -90.95 -91.36 -92.21 -91.98]
%plot(x,mean_aggr,'b*','markersize', 10);
x = 1:1:20;
colormap('gray');
%aggr_mean_rssi = aggr_mean_rssi';
%aggr_std_rssi = aggr_std_rssi';
%h(2)=plot(x,aggr_mean_rssi,'bo','markersize', 5);
hLine = plot(x,aggr_mean_rssi,'LineWidth',4,'MarkerSize',8);
hLine(1).Marker = 'o';
hLine(1).Color = [0,0,0];
hLine(2).Marker = 'd';
hLine(2).Color = [0,0,0] + 0.5;
hLine(2).LineStyle = ':';
hLine(3).Marker = 'x';
hLine(3).Color = [0,0,0] + 0.75;
hLine(3).LineStyle = '--';


%{
for i=1:3
    h_error=errorbar(x,aggr_mean_rssi(i,:),aggr_std_rssi(i,:),'bo','markersize', 5); %set(h,'linestyle','none');
end
%}

xlabel('Distance (m)');
ylabel('RSSI (dBm)');
ax = gca;
ax.XTick = 0:2:20;
%xlim([0 25]);
legend(hLine(1:3),'2.494GHz','2.440GHz','2.400GHz','FontSize', 16);

set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'for_fun.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');