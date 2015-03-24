close all; clear all; clc;
rng default;

start_point = 20;
end_point = 200; 
num_trials = 10; 
error_matrix=[];
aggregate_error_matrix=[];
connectivity_array=[];
coverage_matrix = [];
for i=start_point:10:end_point % number of nodes
    aggregate_error=[];
    aggregate_connectivity_counter=0;
    aggregate_coverage = 0;
    fprintf('i=%f\n',i);
    for j=1:num_trials % number of trials
        average_loc_error_array = intra_main(i,0.2,0.2);
        aggregate_error=[aggregate_error;average_loc_error_array];
    end
    aggregate_error_matrix = [aggregate_error_matrix;aggregate_error];
    error_matrix = [error_matrix;mean(aggregate_error)]; 
end

error_matrix = error_matrix';

save intra_num_node_20_to_200.mat; % Remember to change the file name

figure;
x = start_point:10:end_point;
plot(x,error_matrix,'-*');
xlabel('Number of nodes');
ylabel('Relative error') % left y-axis
legend('kick','kick\_kalman','kick\_kalman\_2nodes');
