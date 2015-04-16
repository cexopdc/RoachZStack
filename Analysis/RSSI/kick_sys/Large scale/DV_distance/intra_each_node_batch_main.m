close all; clear all; clc;
rng default;

aggregate_intuitive=[];
aggregate_kalman=[];
aggregate_kalman_2nodes=[];
aggregate_connectivity_counter=0;
for i=1:10
    [loc_error_intuitive,loc_error_kalman,loc_error_kalman_2nodes,connectivity_counter] = intra_each_node_main(50,0.2,0.2);
    aggregate_intuitive=[aggregate_intuitive loc_error_intuitive];
    aggregate_kalman=[aggregate_kalman loc_error_kalman];
    aggregate_kalman_2nodes=[aggregate_kalman_2nodes loc_error_kalman_2nodes];
    aggregate_connectivity_counter = aggregate_connectivity_counter + connectivity_counter;
end
global TRANS_RANGE;
global NUM_NODE;
mean_intuitive = mean(aggregate_intuitive)/TRANS_RANGE;
max_intuitive = max(aggregate_intuitive)/TRANS_RANGE;
mean_kalman = mean(aggregate_kalman)/TRANS_RANGE;
max_kalman = max(aggregate_kalman)/TRANS_RANGE;
mean_kalman_2nodes = mean(aggregate_kalman_2nodes)/TRANS_RANGE;
max_kalman_2nodes = max(aggregate_kalman_2nodes)/TRANS_RANGE;

aggregate_connectivity_counter/(NUM_NODE*10);


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