clear all; close all;
load intra_batch_iteration_error_50nodes_100runs_mul_coverage.mat;

h1 = cdfplot(aggregate_error_kick_1_beacon);
set(h1,'color','magenta');
hold on;
h2 = cdfplot(aggregate_error_kick_2_beacon);
set(h2,'color','magenta');
h3 = cdfplot(aggregate_error_kick_3_more_beacon);
set(h3,'color','magenta');

h4 = cdfplot(aggregate_error_kick_kalman_1_beacon);
set(h4,'color','g');
h5 = cdfplot(aggregate_error_kick_kalman_2_beacon);
set(h5,'color','g');
h6 = cdfplot(aggregate_error_kick_kalman_3_more_beacon);
set(h6,'color','g');

h7 = cdfplot(aggregate_error_kick_kalman_2nodes_1_beacon);
set(h7,'color','cyan');
h8 = cdfplot(aggregate_error_kick_kalman_2nodes_2_beacon);
set(h8,'color','cyan');
h9 = cdfplot(aggregate_error_kick_kalman_2nodes_3_more_beacon);
set(h9,'color','cyan');

legend([h1 h4 h7],{'KI   (1 beacon, 2 beacon, 3 or more beacon)','KK  (1 beacon, 2 beacon, 3 or more beacon)','KK2 (1 beacon, 2 beacon, 3 or more beacon)'})
xlabel('Relative Distance Error');
ylabel('Probability');
xlim([0 2.0]);
title('');



mean_KI_iteration_error_1_beacon = mean(aggregate_KI_iteration_error_1_beacon,1);
mean_KI_iteration_error_2_beacon = mean(aggregate_KI_iteration_error_2_beacon,1);
mean_KI_iteration_error_3_more_beacon = mean(aggregate_KI_iteration_error_3_more_beacon,1);

mean_KK_iteration_error_1_beacon = mean(aggregate_KK_iteration_error_1_beacon,1);
mean_KK_iteration_error_2_beacon = mean(aggregate_KK_iteration_error_2_beacon,1);
mean_KK_iteration_error_3_more_beacon = mean(aggregate_KK_iteration_error_3_more_beacon,1);

mean_KK2_iteration_error_1_beacon = mean(aggregate_KK2_iteration_error_1_beacon,1);
mean_KK2_iteration_error_2_beacon = mean(aggregate_KK2_iteration_error_2_beacon,1);
mean_KK2_iteration_error_3_more_beacon = mean(aggregate_KK2_iteration_error_3_more_beacon,1);

figure
plot(0:20,mean_KI_iteration_error_3_more_beacon,'magenta',0:20,mean_KK_iteration_error_3_more_beacon,'g',0:20,mean_KK2_iteration_error_3_more_beacon,'cyan');
legend('KI   (1 beacon, 2 beacon, 3 or more beacon)','KK  (1 beacon, 2 beacon, 3 or more beacon)','KK2 (1 beacon, 2 beacon, 3 or more beacon)')
xlim([1 20]);
xlabel('Number of iterations');
ylabel('Relative Distance Error');




