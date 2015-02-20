close all; clear all; clc;
rng default;

global TRANS_RANGE;
global NUM_NODE;
start_point = 0.03;
end_point = 0.30;
loc_error_array=[];
for i=start_point:0.03:end_point % number of nodes
    aggregate_error=[];
    for j=1:10 % number of trials
        [loc_error,connectivity_counter] = main(100,0.2,i); 
        aggregate_error=[aggregate_error loc_error];
    end
    mean_loc_error = mean(aggregate_error)/TRANS_RANGE;
    loc_error_array = [loc_error_array mean_loc_error];
end

figure;
x = start_point:0.03:end_point;
plot(x,loc_error_array,'*-');
xlabel('Beacon ratio');
ylabel('Relative error');