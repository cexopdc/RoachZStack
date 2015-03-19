close all; clear all; clc;
rng default;

aggregate_error=[];
aggregate_connectivity_counter=0;
aggregate_coverage = 0;
num_trials = 10;
for i=1:num_trials
    fprintf('i=%f\n',i);
    average_loc_error_array = intra_main(100,0.2,0.2);
    aggregate_error=[aggregate_error;average_loc_error_array];
end
mean_error_arrary = mean(aggregate_error);

