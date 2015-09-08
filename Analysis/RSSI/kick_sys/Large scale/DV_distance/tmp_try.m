clear all; close all;
load intra_batch_iteration_error_30nodes_100runs_mul_coverage.mat;
vector_aggregate_error_kick = aggregate_error_kick_3_more_beacon(:)';
vector_aggregate_error_kick_kalman = aggregate_error_kick_kalman_3_more_beacon(:)';
vector_aggregate_error_kick_kalman_2nodes = aggregate_error_kick_kalman_2nodes_3_more_beacon(:)';


figure;
h1 = cdfplot(vector_aggregate_error_kick);
hold on;
h2 = cdfplot(vector_aggregate_error_kick_kalman);
h3 = cdfplot(vector_aggregate_error_kick_kalman_2nodes);
xlim([0 3.0]);
set(h1,'LineStyle','-','LineWidth', 5);
set(h2,'LineStyle',':','LineWidth', 5);
set(h3,'LineStyle','--','LineWidth',5);

legend('KI','KK','KK2','location','best')
xlabel('Relative Distance Error');
ylabel('Probability');
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
title('');
exportfig(gcf,'CDF_intra_sparse_topo.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


mean_KI_iteration_error_3_more_beacon = mean(aggregate_KI_iteration_error_3_more_beacon,1);
mean_KK_iteration_error_3_more_beacon = mean(aggregate_KK_iteration_error_3_more_beacon,1);
mean_KK2_iteration_error_3_more_beacon = mean(aggregate_KK2_iteration_error_3_more_beacon,1);
mean_KI_iteration_coverage_3_more_beacon = mean(aggregate_KI_iteration_coverage_3_more_beacon,1);


mean_iteration_error_3_more_beacon = [mean_KI_iteration_error_3_more_beacon;mean_KK_iteration_error_3_more_beacon;mean_KK2_iteration_error_3_more_beacon];
mean_iteration_coverage_3_more_beacon = mean_KI_iteration_coverage_3_more_beacon;
figure
[hAx,hLine1,hLine2] = plotyy(0:20,mean_iteration_error_3_more_beacon,0:20,mean_iteration_coverage_3_more_beacon);
hLine1(1).LineStyle = '-';
hLine1(2).LineStyle = ':';
hLine1(3).LineStyle = '--';
set(hLine1,'LineWidth',5);
hLine2.LineStyle = '-.';
hLine2.Marker = '.';
set(hLine2,'LineWidth',5);
xlabel('Number of iterations');
ylabel(hAx(1),'Relative Distance Error') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
legend('KI','KK','KK2','Coverage');
ylim(hAx(2),([0 1]));
ylim(hAx(1),([0 1]));
hAx(1).YTick = 0:0.2:1;
hAx(2).YTick = 0:0.2:1;
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca, 'FontSize', 16, 'LineWidth', 2);
%set(findall(gcf,'-property','LineWidth'),'LineWidth',5);
exportfig(gcf,'iteration_intra_sparse_topo.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
