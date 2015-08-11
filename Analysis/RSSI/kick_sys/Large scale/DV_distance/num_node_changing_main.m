close all; clear all; clc;
rng default;

start_point = 20;
end_point = 200; 
num_trials = 100;  %%%%%%%%%%%%
error_matrix=[];
std_matrix=[];
aggregate_error_matrix=[];
aggregate_std_matrix=[];
connectivity_array=[];
coverage_matrix = [];
aggregate_flop_matrix=[];
aggregate_stage_matrix=[];
flop_matrix=[];
stage_matrix=[];
for i=start_point:20:end_point % number of nodes
    aggregate_error=[];
    aggregate_std=[];
    aggregate_connectivity_counter=0;
    aggregate_coverage = 0;
    aggregate_flop = [];
    aggregate_stage = [];
    fprintf('i=%f\n',i);
    for j=1:num_trials % number of trials
        [average_loc_error_array,std_loc_error_array,coverage,avg_connectivity,tol_flop_arrary,break_stage_arrary] = main(i,100,20,0.2,0.2); %%%%%%%%%
        aggregate_error=[aggregate_error;average_loc_error_array];
        aggregate_std=[aggregate_std;std_loc_error_array];        
        aggregate_connectivity_counter = aggregate_connectivity_counter + avg_connectivity;
        aggregate_coverage = aggregate_coverage + coverage;
        aggregate_flop = [aggregate_flop;tol_flop_arrary];
        aggregate_stage = [aggregate_stage;break_stage_arrary];
    end
    aggregate_error_matrix = [aggregate_error_matrix;aggregate_error];
    aggregate_std_matrix = [aggregate_std_matrix;aggregate_std];
    aggregate_flop_matrix = [aggregate_flop_matrix;aggregate_flop];
    aggregate_stage_matrix = [aggregate_stage_matrix;aggregate_stage];
    % if running CRLB_ONLY
    if size(aggregate_std_matrix,2) == 1 
        error_matrix = [error_matrix;0];
        std_matrix = [std_matrix;mean(nonzeros(aggregate_std(:,1)))];
    % running other 6 algorithms
    else
        error_matrix = [error_matrix;mean(nonzeros(aggregate_error(:,1))) mean(nonzeros(aggregate_error(:,2))) mean(nonzeros(aggregate_error(:,3))) ...
            mean(nonzeros(aggregate_error(:,4))) mean(nonzeros(aggregate_error(:,5))) mean(nonzeros(aggregate_error(:,6)))]; 
        std_matrix = [std_matrix;mean(nonzeros(aggregate_std(:,1))) mean(nonzeros(aggregate_std(:,2))) mean(nonzeros(aggregate_std(:,3))) ...
            mean(nonzeros(aggregate_std(:,4))) mean(nonzeros(aggregate_std(:,5))) mean(nonzeros(aggregate_std(:,6))) mean(nonzeros(aggregate_std(:,7)))];
        flop_matrix = [flop_matrix;mean(aggregate_flop,1)];
        stage_matrix = [stage_matrix;mean(aggregate_stage,1)];
    end
    connectivity_array = [connectivity_array aggregate_connectivity_counter/num_trials];
    coverage_matrix = [coverage_matrix aggregate_coverage/num_trials];
    if (i==100) && (j==100)
        save FLOP_num_node_20_to_100_100trials_no_break_stage.mat; % Remember to change the file name
    end
end

error_matrix = error_matrix';
std_matrix = std_matrix';
flop_matrix = flop_matrix';
stage_matrix = stage_matrix';

save FLOP_num_node_20_to_200_100trials_no_break_stage.mat; % Remember to change the file name


figure;
x = start_point:20:end_point;
plot(x,error_matrix,'-*');
xlabel('Number of nodes');
ylabel('Relative error') % left y-axis
legend('kick','kick\_kalman','kick\_kalman\_2nodes','DV-distance','N-hop-lateration','IWLSE','CRLB');

figure;
x = start_point:20:end_point;
coverage_matrix = [ones(1,length(coverage_matrix));coverage_matrix;coverage_matrix;coverage_matrix];
h = plot(x,coverage_matrix);
h(1).Marker = 'o';
h(2).Marker = '*';
h(3).Marker = 's';
h(4).Marker = 'd';
xlabel('Number of nodes');
ylabel('Coverage');
legend('kick','kick\_kalman','kick\_kalman\_2nodes','DV-distance','N-hop-lateration','IWLSE','CRLB');