clc;clear all; close all;
figure(1);
hold on;

aggr_mean_rssi=[-55 -58 -57.5 -63 -64 -64.2 -68 -65 -69 -74 -71 -76 -75 -79.8 -81 -81.5 -82 -83.5 -82.5 -83];

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
b0=[-42,20];
fun=inline('b(1)-b(2).*log10(x)','b','x');
x1=3:3:60;
y1=aggr_mean_rssi;
[b,r,j]=nlinfit(x1,y1,fun,b0);
b=real(b);
y2=b(1)-b(2).*log10(x1);
plot(x1,y1,'b*',x1,y2,'-r','LineWidth',2,'MarkerSize',6);

xlabel('Distance (m)');
ylabel('RSSI (dBm)');
legend('Original data','After fitting');

set(gca, 'FontSize', 14, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'nonlinfit_plot_new.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');