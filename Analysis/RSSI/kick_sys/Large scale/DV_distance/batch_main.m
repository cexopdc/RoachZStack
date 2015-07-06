close all; clear all; clc;
rng default;

aggregate_error=[];
aggregate_std=[];
aggregate_connectivity_counter=0;
aggregate_coverage = 0;
num_trials = 100; %%%%%%%%%%%%%%
for i=1:num_trials
    fprintf('i=%f\n',i);
    [average_loc_error_array,std_loc_error_array,coverage,avg_connectivity] = main(100,100,20,0.2,0.2); %%%%%%%%%
    aggregate_error=[aggregate_error;average_loc_error_array];
    aggregate_std=[aggregate_std;std_loc_error_array];
    aggregate_connectivity_counter = aggregate_connectivity_counter + avg_connectivity;
    aggregate_coverage = aggregate_coverage + coverage;
end
mean_error_arrary = mean(aggregate_error);
mean_std_arrary = mean(aggregate_std);
avg_connectivity = aggregate_connectivity_counter/num_trials;
avg_coverage = aggregate_coverage/num_trials;
save batch_main_100node_100trials.mat; % Remember to change the file name
