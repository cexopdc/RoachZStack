close all; clear all; clc;
rng default;

global TRANS_RANGE;
global NUM_NODE;
start_point = 0.05;
end_point = 0.50;
loc_error_array=[];
for i=start_point:0.05:end_point % number of nodes
    aggregate_error=[];
    for j=1:10 % number of trials
        [loc_error,connectivity_counter] = main(100,i,0.2); % main(num_node,dis_std_ratio,beacon_ratio)
        aggregate_error=[aggregate_error loc_error];
    end
    mean_loc_error = mean(aggregate_error)/TRANS_RANGE;
    loc_error_array = [loc_error_array mean_loc_error];
end

figure;
x = start_point:0.05:end_point;
plot(x,loc_error_array,'*-');
xlabel('Measurement error Std');
ylabel('Relative error') 