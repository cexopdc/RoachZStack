clear all; close all;
load intra_batch_iteration_error_200nodes_100runs.mat;
vector_aggregate_error_kick = aggregate_error_kick(:)';
vector_aggregate_error_kick_kalman = aggregate_error_kick_kalman(:)';
vector_aggregate_error_kick_kalman_2nodes = aggregate_error_kick_kalman_2nodes(:)';


figure;
h1 = cdfplot(vector_aggregate_error_kick);
hold on;
h2 = cdfplot(vector_aggregate_error_kick_kalman);
h3 = cdfplot(vector_aggregate_error_kick_kalman_2nodes);
xlim([0 2.0]);
set(h1,'LineStyle','-','LineWidth', 5);
set(h2,'LineStyle',':','LineWidth', 5);
set(h3,'LineStyle','--','LineWidth',5);

legend('KI','KK','KK2')
xlabel('Relative Distance Error');
ylabel('Probability');
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
title('');
exportfig(gcf,'CDF_intra_dense_topo.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


mean_KI_iteration_error = mean(aggregate_KI_iteration_error,1);
mean_KK_iteration_error = mean(aggregate_KK_iteration_error,1);
mean_KK2_iteration_error = mean(aggregate_KK2_iteration_error,1);

figure
h4 = plot(0:20,mean_KI_iteration_error,0:20,mean_KK_iteration_error,0:20,mean_KK2_iteration_error);
set(h4,{'LineStyle'},{'-',':','--'}','LineWidth', 5);
legend('KI','KK','KK2')
xlabel('Number of iterations');
ylabel('Relative Distance Error');
set(findall(gcf,'-property','FontSize'),'FontSize',16);
exportfig(gcf,'iteration_intra_dense_topo.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


