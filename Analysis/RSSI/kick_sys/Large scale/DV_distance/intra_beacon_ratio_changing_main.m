close all; clear all; clc;
rng default;

start_point = 0.03;
end_point = 0.30;
num_trials = 10;
aggregate_error_matrix=[];
error_matrix=[];
connectivity_array=[];
coverage_matrix = [];
for i=start_point:0.03:end_point % number of nodes
    aggregate_error=[];
    aggregate_connectivity_counter=0;
    aggregate_coverage = 0;
    fprintf('i=%f\n',i);
    for j=1:num_trials % number of trials
        average_loc_error_array = intra_main(100,0.2,i);
        aggregate_error=[aggregate_error;average_loc_error_array];
    end
    aggregate_error_matrix = [aggregate_error_matrix;aggregate_error];
    error_matrix = [error_matrix;mean(aggregate_error)]; 
end

error_matrix = error_matrix';

save intra_beacon_ratio_0.03_to_0.3.mat;

figure;
x = start_point:0.03:end_point;
plot(x,error_matrix,'*-');
xlabel('Beacon ratio');
ylabel('Relative error');
legend('kick','kick\_kalman','kick\_kalman\_2nodes');

