clear all; close all;
load intra_batch_iteration_error_30nodes_100runs_mul_coverage.mat;

hold on;
h0 = cdfplot(aggregate_error_kick_0_beacon);
set(h0,'color','magenta','LineStyle',':');
h1 = cdfplot(aggregate_error_kick_1_beacon);
set(h1,'color','magenta');
h2 = cdfplot(aggregate_error_kick_2_beacon);
set(h2,'color','magenta');
h3 = cdfplot(aggregate_error_kick_3_more_beacon);
set(h3,'color','magenta');

h4 = cdfplot(aggregate_error_kick_kalman_0_beacon);
set(h4,'color','g','LineStyle',':');
h5 = cdfplot(aggregate_error_kick_kalman_1_beacon);
set(h5,'color','g');
h6 = cdfplot(aggregate_error_kick_kalman_2_beacon);
set(h6,'color','g');
h7 = cdfplot(aggregate_error_kick_kalman_3_more_beacon);
set(h7,'color','g');


h8 = cdfplot(aggregate_error_kick_kalman_2nodes_0_beacon);
set(h8,'color','cyan','LineStyle',':');
h9 = cdfplot(aggregate_error_kick_kalman_2nodes_1_beacon);
set(h9,'color','cyan');
h9 = cdfplot(aggregate_error_kick_kalman_2nodes_2_beacon);
set(h9,'color','cyan');
h10 = cdfplot(aggregate_error_kick_kalman_2nodes_3_more_beacon);
set(h10,'color','cyan');

set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','LineWidth'),'LineWidth',2);
xlabel('Relative Distance Error');
ylabel('Probability');
xlim([0 3.0]);
legend([h0 h4 h8 h1 h5 h9],{'KI (0 beacon)','KK (0 beacon)','KK2 (0 beacon)','KI (1 beacon, 2 beacon, 3 beacon)','KK (1 beacon, 2 beacon, 3 beacon)','KK2 (1 beacon, 2 beacon, 3 beacon)'},'location','best','FontSize',14)
title('');
exportfig(gcf,'multi_coverage_CDF_intra_30_nodes.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


mean_KI_iteration_error_0_beacon = mean(aggregate_KI_iteration_error_0_beacon,1);
mean_KI_iteration_error_1_beacon = mean(aggregate_KI_iteration_error_1_beacon,1);
mean_KI_iteration_error_2_beacon = mean(aggregate_KI_iteration_error_2_beacon,1);
mean_KI_iteration_error_3_more_beacon = mean(aggregate_KI_iteration_error_3_more_beacon,1);

mean_KK_iteration_error_0_beacon = mean(aggregate_KK_iteration_error_0_beacon,1);
mean_KK_iteration_error_1_beacon = mean(aggregate_KK_iteration_error_1_beacon,1);
mean_KK_iteration_error_2_beacon = mean(aggregate_KK_iteration_error_2_beacon,1);
mean_KK_iteration_error_3_more_beacon = mean(aggregate_KK_iteration_error_3_more_beacon,1);

mean_KK2_iteration_error_0_beacon = mean(aggregate_KK2_iteration_error_0_beacon,1);
mean_KK2_iteration_error_1_beacon = mean(aggregate_KK2_iteration_error_1_beacon,1);
mean_KK2_iteration_error_2_beacon = mean(aggregate_KK2_iteration_error_2_beacon,1);
mean_KK2_iteration_error_3_more_beacon = mean(aggregate_KK2_iteration_error_3_more_beacon,1);

mean_KI_iteration_coverage_0_beacon = mean(aggregate_KI_iteration_coverage_0_beacon,1);
mean_KI_iteration_coverage_1_beacon = mean(aggregate_KI_iteration_coverage_1_beacon,1);
mean_KI_iteration_coverage_2_beacon = mean(aggregate_KI_iteration_coverage_2_beacon,1);
mean_KI_iteration_coverage_3_more_beacon = mean(aggregate_KI_iteration_coverage_3_more_beacon,1);

mean_KK_iteration_coverage_0_beacon = mean(aggregate_KK_iteration_coverage_0_beacon,1);
mean_KK_iteration_coverage_1_beacon = mean(aggregate_KK_iteration_coverage_1_beacon,1);
mean_KK_iteration_coverage_2_beacon = mean(aggregate_KK_iteration_coverage_2_beacon,1);
mean_KK_iteration_coverage_3_more_beacon = mean(aggregate_KK_iteration_coverage_3_more_beacon,1);

mean_KK2_iteration_coverage_0_beacon = mean(aggregate_KK2_iteration_coverage_0_beacon,1);
mean_KK2_iteration_coverage_1_beacon = mean(aggregate_KK2_iteration_coverage_1_beacon,1);
mean_KK2_iteration_coverage_2_beacon = mean(aggregate_KK2_iteration_coverage_2_beacon,1);
mean_KK2_iteration_coverage_3_more_beacon = mean(aggregate_KK2_iteration_coverage_3_more_beacon,1);

mean_iteration_error_0_beacon = [mean_KI_iteration_error_0_beacon;mean_KK_iteration_error_0_beacon;mean_KK2_iteration_error_0_beacon];
mean_iteration_coverage_0_beacon = mean_KI_iteration_coverage_0_beacon;
figure
[hAx,hLine1,hLine2] = plotyy(0:20,mean_iteration_error_0_beacon,0:20,mean_iteration_coverage_0_beacon);
hLine1(1).LineStyle = '-';
hLine1(1).Color = 'magenta';
hLine1(2).LineStyle = '-';
hLine1(2).Color = 'g';
hLine1(3).LineStyle = '-';
hLine1(3).Color = 'cyan';
hLine2.LineStyle = '-';
hLine1(1).Marker = '*';
hLine1(2).Marker = '+';
hLine1(3).Marker = 'x';
hLine2.Marker = 'o';
xlabel('Number of iterations');
ylabel(hAx(1),'Relative Distance Error') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
legend('KI','KK','KK2','Coverage');
ylim(hAx(2),([0 1]));
ylim(hAx(1),([0 2]));
hAx(1).YTick = 0:0.5:2;
hAx(2).YTick = 0:0.5:1;
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','LineWidth'),'LineWidth',2);
exportfig(gcf,'iteration_intra_30_nodes_0_beacon.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


mean_iteration_error_1_beacon = [mean_KI_iteration_error_1_beacon;mean_KK_iteration_error_1_beacon;mean_KK2_iteration_error_1_beacon];
mean_iteration_coverage_1_beacon = mean_KI_iteration_coverage_1_beacon;
figure
[hAx,hLine1,hLine2] = plotyy(0:20,mean_iteration_error_1_beacon,0:20,mean_iteration_coverage_1_beacon);
hLine1(1).LineStyle = '-';
hLine1(1).Color = 'magenta';
hLine1(2).LineStyle = '-';
hLine1(2).Color = 'g';
hLine1(3).LineStyle = '-';
hLine1(3).Color = 'cyan';
hLine2.LineStyle = '-';
hLine1(1).Marker = '*';
hLine1(2).Marker = '+';
hLine1(3).Marker = 'x';
hLine2.Marker = 'o';
xlabel('Number of iterations');
ylabel(hAx(1),'Relative Distance Error') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
legend('KI','KK','KK2','Coverage');
ylim(hAx(2),([0 1]));
ylim(hAx(1),([0 2]));
hAx(1).YTick = 0:0.5:2;
hAx(2).YTick = 0:0.5:1;
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','LineWidth'),'LineWidth',2);
exportfig(gcf,'iteration_intra_30_nodes_1_beacon.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');





mean_iteration_error_2_beacon = [mean_KI_iteration_error_2_beacon;mean_KK_iteration_error_2_beacon;mean_KK2_iteration_error_2_beacon];
mean_iteration_coverage_2_beacon = mean_KI_iteration_coverage_2_beacon;
figure
[hAx,hLine1,hLine2] = plotyy(0:20,mean_iteration_error_2_beacon,0:20,mean_iteration_coverage_2_beacon);
hLine1(1).LineStyle = '-';
hLine1(1).Color = 'magenta';
hLine1(2).LineStyle = '-';
hLine1(2).Color = 'g';
hLine1(3).LineStyle = '-';
hLine1(3).Color = 'cyan';
hLine2.LineStyle = '-';
hLine1(1).Marker = '*';
hLine1(2).Marker = '+';
hLine1(3).Marker = 'x';
hLine2.Marker = 'o';
xlabel('Number of iterations');
ylabel(hAx(1),'Relative Distance Error') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
legend('KI','KK','KK2','Coverage');
ylim(hAx(2),([0 1]));
ylim(hAx(1),([0 2]));
hAx(1).YTick = 0:0.5:2;
hAx(2).YTick = 0:0.5:1;
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','LineWidth'),'LineWidth',2);
exportfig(gcf,'iteration_intra_30_nodes_2_beacon.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


mean_iteration_error_3_more_beacon = [mean_KI_iteration_error_3_more_beacon;mean_KK_iteration_error_3_more_beacon;mean_KK2_iteration_error_3_more_beacon];
mean_iteration_coverage_3_more_beacon = mean_KI_iteration_coverage_3_more_beacon;
figure
[hAx,hLine1,hLine2] = plotyy(0:20,mean_iteration_error_3_more_beacon,0:20,mean_iteration_coverage_3_more_beacon);
hLine1(1).LineStyle = '-';
hLine1(1).Color = 'magenta';
hLine1(2).LineStyle = '-';
hLine1(2).Color = 'g';
hLine1(3).LineStyle = '-';
hLine1(3).Color = 'cyan';
hLine2.LineStyle = '-';
hLine1(1).Marker = '*';
hLine1(2).Marker = '+';
hLine1(3).Marker = 'x';
hLine2.Marker = 'o';
xlabel('Number of iterations');
ylabel(hAx(1),'Relative Distance Error') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
legend('KI','KK','KK2','Coverage');
ylim(hAx(2),([0 1]));
ylim(hAx(1),([0 2]));
hAx(1).YTick = 0:0.5:2;
hAx(2).YTick = 0:0.5:1;
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','LineWidth'),'LineWidth',2);
exportfig(gcf,'iteration_intra_30_nodes_3_beacon.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


%{
figure
plot(0:20,mean_KI_iteration_error_0_beacon,'magenta',0:20,mean_KK_iteration_error_0_beacon,'g',0:20,mean_KK2_iteration_error_0_beacon,'cyan');
legend('KI   (0 beacon)','KK  (0 beacon)','KK2 (0 beacon)')
xlim([1 20]);
ylim([0 inf]);
xlabel('Number of iterations');
ylabel('Relative Distance Error');

figure
plot(0:20,mean_KI_iteration_error_1_beacon,'magenta',0:20,mean_KK_iteration_error_1_beacon,'g',0:20,mean_KK2_iteration_error_1_beacon,'cyan');
legend('KI   (1 beacon)','KK  (1 beacon)','KK2 (1 beacon)')
xlim([1 20]);
ylim([0 inf]);
xlabel('Number of iterations');
ylabel('Relative Distance Error');

figure
plot(0:20,mean_KI_iteration_error_2_beacon,'magenta',0:20,mean_KK_iteration_error_2_beacon,'g',0:20,mean_KK2_iteration_error_2_beacon,'cyan');
legend('KI   (2 beacon)','KK  (1 beacon)','KK2 (2 beacon)')
xlim([1 20]);
ylim([0 inf]);
xlabel('Number of iterations');
ylabel('Relative Distance Error');

figure
plot(0:20,mean_KI_iteration_error_3_more_beacon,'magenta',0:20,mean_KK_iteration_error_3_more_beacon,'g',0:20,mean_KK2_iteration_error_3_more_beacon,'cyan');
legend('KI   (3 or more beacon)','KK  (3 or more beacon)','KK2 (3 or more beacon)')
xlim([1 20]);
ylim([0 inf]);
xlabel('Number of iterations');
ylabel('Relative Distance Error');
%}





