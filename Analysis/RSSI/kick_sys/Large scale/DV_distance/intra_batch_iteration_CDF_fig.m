clear all; close all;
load intra_batch_iteration_error_50nodes_100runs_BAD_REMOVER.mat;
vector_aggregate_error_kick = aggregate_error_kick(:)';
vector_aggregate_error_kick_kalman = aggregate_error_kick_kalman(:)';
vector_aggregate_error_kick_kalman_2nodes = aggregate_error_kick_kalman_2nodes(:)';

cdfplot(vector_aggregate_error_kick);
hold on;
cdfplot(vector_aggregate_error_kick_kalman);
cdfplot(vector_aggregate_error_kick_kalman_2nodes);
legend('KI','KK','KK2')
xlabel('Relative Distance Error');
ylabel('Probability');
xlim([0 4.0]);
title('');

mean_KI_iteration_error = mean(aggregate_KI_iteration_error,1);
mean_KK_iteration_error = mean(aggregate_KK_iteration_error,1);
mean_KK2_iteration_error = mean(aggregate_KK2_iteration_error,1);

figure
plot(0:20,mean_KI_iteration_error,0:20,mean_KK_iteration_error,0:20,mean_KK2_iteration_error);
legend('KI','KK','KK2')
xlabel('Number of iterations');
ylabel('Relative Distance Error');