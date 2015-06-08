close all; clear all; clc;
rng default;
num_trials = 100;   %%%%%%%%%
% global variable to store per iteration state
global KI_iteration_error_array;
global KK_iteration_error_array;
global KK2_iteration_error_array;

aggregate_error_kick=[];
aggregate_error_kick_kalman=[];
aggregate_error_kick_kalman_2nodes=[];
aggregate_connectivity_counter=0;
aggregate_coverage_KI = 0;
aggregate_coverage_KK = 0;
aggregate_coverage_KK2 = 0;
aggregate_KI_iteration_error = [];
aggregate_KK_iteration_error = [];
aggregate_KK2_iteration_error = [];

for i=1:num_trials
    fprintf('i=%f\n',i);
    [loc_error_kick, loc_error_kick_kalman, loc_error_kick_kalman_2nodes,connectivity_counter,coverage] = intra_main(50,0.2,0.2); %%%%%%%
    aggregate_error_kick=[aggregate_error_kick loc_error_kick];
    aggregate_error_kick_kalman=[aggregate_error_kick_kalman loc_error_kick_kalman];
    aggregate_error_kick_kalman_2nodes=[aggregate_error_kick_kalman_2nodes loc_error_kick_kalman_2nodes];
    aggregate_KI_iteration_error=[aggregate_KI_iteration_error;KI_iteration_error_array];
    aggregate_KK_iteration_error=[aggregate_KK_iteration_error;KK_iteration_error_array];
    aggregate_KK2_iteration_error=[aggregate_KK2_iteration_error;KK2_iteration_error_array];
    aggregate_connectivity_counter = aggregate_connectivity_counter + connectivity_counter;
    aggregate_coverage_KI = aggregate_coverage_KI + coverage(1,1);
    aggregate_coverage_KK = aggregate_coverage_KK + coverage(1,2);
    aggregate_coverage_KK2 = aggregate_coverage_KK2 + coverage(1,3);
end

global NUM_NODE;
avg_connectivity = aggregate_connectivity_counter/(NUM_NODE*num_trials);
avg_coverage_KI = aggregate_coverage_KI/num_trials;
avg_coverage_KK = aggregate_coverage_KK/num_trials;
avg_coverage_KK2 = aggregate_coverage_KK2/num_trials;
save intra_batch_iteration_error_50nodes_100runs_BAD_REMOVER.mat; % Remember to change the file name

