clc;clear all; close all;
figure(1);
hold on;

aggr_mean_rssi=[-64.06 -68.32 -70.72 -73.95 -75.19 -74.23 -78.00 -79.13 -80.28 -82.97 -81.27 -84.25 -84.92 -85.25 -84.93 -86.05 -87.95 -90.16 -91.16 -89.16];

%{
b0=[-42,1,1];
fun=inline('b(1)+b(2).*log(x./b(3))','b','x');
x1=3:3:60;
y1=aggr_mean_rssi;
[b,r,j]=nlinfit(x1,y1,fun,b0);
b=real(b);
y2=b(1)+b(2).*log(x1./b(3));
plot(x1,y1,'b*',x1,y2,'-r','LineWidth',2,'MarkerSize',6);
%}
b0=[-64.06,20];
fun=inline('b(1)-b(2).*log10(x)','b','x');
x1=1:1:20;
y1=aggr_mean_rssi;
[b,r,j]=nlinfit(x1,y1,fun,b0);
b=real(b);
y2=b(1)-b(2).*log10(x1);
plot(x1,y1,'b*',x1,y2,'-r','LineWidth',3,'MarkerSize',7);

xlabel('Distance (m)');
ylabel('RSSI (dBm)');
ax = gca;
ax.XTick = 0:2:20;
legend('Original data','After fitting','FontSize', 16);

set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'nonlinfit_plot_wolfbot.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');