close all; clear all; clc;
rng default;
num_trials = 100;   %%%%%%%%%
% global variable to store per iteration state
global KI_iteration_error_array;
global KK_iteration_error_array;
global KK2_iteration_error_array;
global KI_iteration_coverage;
global KK_iteration_coverage;
global KK2_iteration_coverage;

aggregate_error_kick_0_beacon=[];
aggregate_error_kick_1_beacon=[];
aggregate_error_kick_2_beacon=[];
aggregate_error_kick_3_more_beacon=[];

aggregate_error_kick_kalman_0_beacon=[];
aggregate_error_kick_kalman_1_beacon=[];
aggregate_error_kick_kalman_2_beacon=[];
aggregate_error_kick_kalman_3_more_beacon=[];

aggregate_error_kick_kalman_2nodes_0_beacon=[];
aggregate_error_kick_kalman_2nodes_1_beacon=[];
aggregate_error_kick_kalman_2nodes_2_beacon=[];
aggregate_error_kick_kalman_2nodes_3_more_beacon=[];


aggregate_connectivity_counter=0;
aggregate_coverage_KI = 0;
aggregate_coverage_KK = 0;
aggregate_coverage_KK2 = 0;
aggregate_KI_iteration_error_0_beacon = [];
aggregate_KI_iteration_error_1_beacon = [];
aggregate_KI_iteration_error_2_beacon = [];
aggregate_KI_iteration_error_3_more_beacon = [];

aggregate_KK_iteration_error_0_beacon = [];
aggregate_KK_iteration_error_1_beacon = [];
aggregate_KK_iteration_error_2_beacon = [];
aggregate_KK_iteration_error_3_more_beacon = [];

aggregate_KK2_iteration_error_0_beacon = [];
aggregate_KK2_iteration_error_1_beacon = [];
aggregate_KK2_iteration_error_2_beacon = [];
aggregate_KK2_iteration_error_3_more_beacon = [];

aggregate_KI_iteration_coverage_0_beacon = [];
aggregate_KI_iteration_coverage_1_beacon = [];
aggregate_KI_iteration_coverage_2_beacon = [];
aggregate_KI_iteration_coverage_3_more_beacon = [];

aggregate_KK_iteration_coverage_0_beacon = [];
aggregate_KK_iteration_coverage_1_beacon = [];
aggregate_KK_iteration_coverage_2_beacon = [];
aggregate_KK_iteration_coverage_3_more_beacon = [];

aggregate_KK2_iteration_coverage_0_beacon = [];
aggregate_KK2_iteration_coverage_1_beacon = [];
aggregate_KK2_iteration_coverage_2_beacon = [];
aggregate_KK2_iteration_coverage_3_more_beacon = [];

for i=1:num_trials
    fprintf('i=%f\n',i);
    [loc_error_kick, loc_error_kick_kalman, loc_error_kick_kalman_2nodes,connectivity_counter] = intra_main(30,0.2,0.2); %%%%%%%
    
    aggregate_error_kick_0_beacon=[aggregate_error_kick_0_beacon loc_error_kick.loc_error_0_beacon];
    aggregate_error_kick_1_beacon=[aggregate_error_kick_1_beacon loc_error_kick.loc_error_1_beacon];
    aggregate_error_kick_2_beacon=[aggregate_error_kick_2_beacon loc_error_kick.loc_error_2_beacon];
    aggregate_error_kick_3_more_beacon=[aggregate_error_kick_3_more_beacon loc_error_kick.loc_error_3_more_beacon];

    aggregate_error_kick_kalman_0_beacon=[aggregate_error_kick_kalman_0_beacon loc_error_kick_kalman.loc_error_0_beacon];
    aggregate_error_kick_kalman_1_beacon=[aggregate_error_kick_kalman_1_beacon loc_error_kick_kalman.loc_error_1_beacon];
    aggregate_error_kick_kalman_2_beacon=[aggregate_error_kick_kalman_2_beacon loc_error_kick_kalman.loc_error_2_beacon];
    aggregate_error_kick_kalman_3_more_beacon=[aggregate_error_kick_kalman_3_more_beacon loc_error_kick_kalman.loc_error_3_more_beacon];

    aggregate_error_kick_kalman_2nodes_0_beacon=[aggregate_error_kick_kalman_2nodes_0_beacon loc_error_kick_kalman_2nodes.loc_error_0_beacon];
    aggregate_error_kick_kalman_2nodes_1_beacon=[aggregate_error_kick_kalman_2nodes_1_beacon loc_error_kick_kalman_2nodes.loc_error_1_beacon];
    aggregate_error_kick_kalman_2nodes_2_beacon=[aggregate_error_kick_kalman_2nodes_2_beacon loc_error_kick_kalman_2nodes.loc_error_2_beacon];
    aggregate_error_kick_kalman_2nodes_3_more_beacon=[aggregate_error_kick_kalman_2nodes_3_more_beacon loc_error_kick_kalman_2nodes.loc_error_3_more_beacon];

    
    aggregate_KI_iteration_error_0_beacon=[aggregate_KI_iteration_error_0_beacon;KI_iteration_error_array(1,:)];
    aggregate_KI_iteration_error_1_beacon=[aggregate_KI_iteration_error_1_beacon;KI_iteration_error_array(2,:)];
    aggregate_KI_iteration_error_2_beacon=[aggregate_KI_iteration_error_2_beacon;KI_iteration_error_array(3,:)];
    aggregate_KI_iteration_error_3_more_beacon=[aggregate_KI_iteration_error_3_more_beacon;KI_iteration_error_array(4,:)];
    
    aggregate_KK_iteration_error_0_beacon=[aggregate_KK_iteration_error_0_beacon;KK_iteration_error_array(1,:)];
    aggregate_KK_iteration_error_1_beacon=[aggregate_KK_iteration_error_1_beacon;KK_iteration_error_array(2,:)];
    aggregate_KK_iteration_error_2_beacon=[aggregate_KK_iteration_error_2_beacon;KK_iteration_error_array(3,:)];
    aggregate_KK_iteration_error_3_more_beacon=[aggregate_KK_iteration_error_3_more_beacon;KK_iteration_error_array(4,:)];

    aggregate_KK2_iteration_error_0_beacon=[aggregate_KK2_iteration_error_0_beacon;KK2_iteration_error_array(1,:)];
    aggregate_KK2_iteration_error_1_beacon=[aggregate_KK2_iteration_error_1_beacon;KK2_iteration_error_array(2,:)];
    aggregate_KK2_iteration_error_2_beacon=[aggregate_KK2_iteration_error_2_beacon;KK2_iteration_error_array(3,:)];
    aggregate_KK2_iteration_error_3_more_beacon=[aggregate_KK2_iteration_error_3_more_beacon;KK2_iteration_error_array(4,:)];
    
    aggregate_KI_iteration_coverage_0_beacon=[aggregate_KI_iteration_coverage_0_beacon;KI_iteration_coverage(1,:)];
    aggregate_KI_iteration_coverage_1_beacon=[aggregate_KI_iteration_coverage_1_beacon;KI_iteration_coverage(2,:)];
    aggregate_KI_iteration_coverage_2_beacon=[aggregate_KI_iteration_coverage_2_beacon;KI_iteration_coverage(3,:)];
    aggregate_KI_iteration_coverage_3_more_beacon=[aggregate_KI_iteration_coverage_3_more_beacon;KI_iteration_coverage(4,:)];
    
    aggregate_KK_iteration_coverage_0_beacon=[aggregate_KK_iteration_coverage_0_beacon;KK_iteration_coverage(1,:)];
    aggregate_KK_iteration_coverage_1_beacon=[aggregate_KK_iteration_coverage_1_beacon;KK_iteration_coverage(2,:)];
    aggregate_KK_iteration_coverage_2_beacon=[aggregate_KK_iteration_coverage_2_beacon;KK_iteration_coverage(3,:)];
    aggregate_KK_iteration_coverage_3_more_beacon=[aggregate_KK_iteration_coverage_3_more_beacon;KK_iteration_coverage(4,:)];

    aggregate_KK2_iteration_coverage_0_beacon=[aggregate_KK2_iteration_coverage_0_beacon;KK2_iteration_coverage(1,:)];
    aggregate_KK2_iteration_coverage_1_beacon=[aggregate_KK2_iteration_coverage_1_beacon;KK2_iteration_coverage(2,:)];
    aggregate_KK2_iteration_coverage_2_beacon=[aggregate_KK2_iteration_coverage_2_beacon;KK2_iteration_coverage(3,:)];
    aggregate_KK2_iteration_coverage_3_more_beacon=[aggregate_KK2_iteration_coverage_3_more_beacon;KK2_iteration_coverage(4,:)];
    
    aggregate_connectivity_counter = aggregate_connectivity_counter + connectivity_counter;
end

global NUM_NODE;
global BEACON_RATIO;
avg_connectivity = aggregate_connectivity_counter/(NUM_NODE*num_trials);
avg_coverage_KI_0_beacon = length(aggregate_error_kick_0_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KI_1_beacon = length(aggregate_error_kick_1_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KI_2_beacon = length(aggregate_error_kick_2_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KI_3_more_beacon = length(aggregate_error_kick_3_more_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));

avg_coverage_KK_0_beacon = length(aggregate_error_kick_kalman_0_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KK_1_beacon = length(aggregate_error_kick_kalman_1_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KK_2_beacon = length(aggregate_error_kick_kalman_2_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KK_3_more_beacon = length(aggregate_error_kick_kalman_3_more_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));

avg_coverage_KK2_0_beacon = length(aggregate_error_kick_kalman_2nodes_0_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KK2_1_beacon = length(aggregate_error_kick_kalman_2nodes_1_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KK2_2_beacon = length(aggregate_error_kick_kalman_2nodes_2_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));
avg_coverage_KK2_3_more_beacon = length(aggregate_error_kick_kalman_2nodes_3_more_beacon)/(num_trials*(NUM_NODE*(1-BEACON_RATIO)));

save intra_batch_iteration_error_30nodes_100runs_mul_coverage.mat; % Remember to change the file name
