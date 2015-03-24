close all; clear all; clc;
rng default;

aggregate_error=[];
aggregate_connectivity_counter=0;
aggregate_coverage = 0;
num_trials = 10;
for i=1:num_trials
    fprintf('i=%f\n',i);
    [average_loc_error_array,coverage,avg_connectivity] = inter_main(100,0.2,0.2);
    aggregate_error=[aggregate_error;average_loc_error_array];
    aggregate_connectivity_counter = aggregate_connectivity_counter + avg_connectivity;
    aggregate_coverage = aggregate_coverage + coverage;
end
mean_error_arrary = mean(aggregate_error);
avg_connectivity = aggregate_connectivity_counter/num_trials;
avg_coverage = aggregate_coverage/num_trials;


%{
aggregate_intuitive=[];
aggregate_kalman=[];
for i=1:10
    [loc_error_intuitive,loc_error_kalman] = main;
    aggregate_intuitive=[aggregate_intuitive loc_error_intuitive];
    aggregate_kalman=[aggregate_kalman loc_error_kalman];
end
global TRANS_RANGE;
mean_intuitive = mean(aggregate_intuitive)/TRANS_RANGE
max__intuitive = max(aggregate_intuitive)/TRANS_RANGE
mean_kalman = mean(aggregate_kalman)/TRANS_RANGE
max__kalman = max(aggregate_kalman)/TRANS_RANGE
%}