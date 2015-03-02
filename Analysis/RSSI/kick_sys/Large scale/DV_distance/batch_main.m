close all; clear all; clc;
rng default;

aggregate_error=[];
aggregate_connectivity_counter=0;
aggregate_coverage = 0;
for i=1:10
    [average_loc_error_array,coverage,avg_connectivity] = main(100,0.2,0.2);
    aggregate_error=[aggregate_error;average_loc_error_array];
    aggregate_connectivity_counter = aggregate_connectivity_counter + avg_connectivity;
    aggregate_coverage = aggregate_coverage + coverage;
end
global TRANS_RANGE;
global NUM_NODE;
mean_error_arrary = mean(aggregate_error);
avg_connectivity = aggregate_connectivity_counter/10;
avg_coverage = aggregate_coverage/10;


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