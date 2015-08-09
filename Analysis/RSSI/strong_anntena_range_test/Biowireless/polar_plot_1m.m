close all; clear all;
cd /Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Angle/no_tube_flat;

theta = 0:pi/9:2*pi;
theta_q = 0:pi/18:2*pi;
mean_std = load('mean_std_1m.txt');
rho_mean = mean_std(:,1)';
[m,n] = size(rho_mean);
rho_mean = rho_mean + 10*ones(m,n);
rho_mean_interp = interp1(theta,rho_mean,theta_q);


max_mean = max(rho_mean_interp)
min_mean = min(rho_mean_interp)

figure
%set the range of the mean in the polar plot
Range_mean = [-70 -45];

H1 = polar2(theta_q,rho_mean_interp,Range_mean);
H1.LineWidth = 2;
%title('Polar plot of mean rssi','FontSize',14)

hold on
cd /Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Angle/with_tube_tilt;
theta = 0:pi/9:2*pi;
theta_q = 0:pi/18:2*pi;
mean_std = load('mean_std_1m.txt');
rho_mean = mean_std(:,1)';
rho_mean_interp = interp1(theta,rho_mean,theta_q);


max_mean = max(rho_mean_interp)
min_mean = min(rho_mean_interp)

%set the range of the mean in the polar plot
Range_mean = [-80 -45];

H2 = polar2(theta_q,rho_mean_interp,Range_mean);
H2.LineStyle = '-.';
H2.LineWidth = 2;
lh=legend([H1,H2],'Indoor','In chamber','fontsize',14);
set(lh,'location', 'Best');
set(gca, 'FontSize', 14, 'LineWidth', 2);
%title('Polar plot of mean rssi','FontSize',14)
exportfig(gcf,'polar_plot.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

