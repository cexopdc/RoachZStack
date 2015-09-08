close all; clear all; clc;
rng default;

start_point = 0.05;
end_point = 0.50;
num_trials = 50;  %%%%%%%%%%%%
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
aggregate_msg_matrix = [];
aggregate_bytes_matrix = [];
msg_matrix = [];
bytes_matrix = [];
for i=start_point:0.05:end_point % number of nodes
    aggregate_error=[];
    aggregate_std=[];
    aggregate_connectivity_counter=0;
    aggregate_coverage = 0;
    aggregate_flop = [];
    aggregate_stage = [];
    aggregate_msg = [];
    aggregate_bytes = [];
    fprintf('i=%f\n',i);
    for j=1:num_trials % number of trials
        [average_loc_error_array,std_loc_error_array,coverage,avg_connectivity,tol_flop_arrary,break_stage_arrary,tol_msg_sent_arrary,tol_bytes_sent_arrary]...
            = main(0,100,100,20,0.2,i); %%%%%%%%%
        aggregate_error=[aggregate_error;average_loc_error_array];
        aggregate_std=[aggregate_std;std_loc_error_array];        
        aggregate_connectivity_counter = aggregate_connectivity_counter + avg_connectivity;
        aggregate_coverage = aggregate_coverage + coverage;
        aggregate_flop = [aggregate_flop;tol_flop_arrary];
        aggregate_stage = [aggregate_stage;break_stage_arrary];
        aggregate_msg = [aggregate_msg;tol_msg_sent_arrary];
        aggregate_bytes = [aggregate_bytes;tol_bytes_sent_arrary];
    end
    aggregate_error_matrix = [aggregate_error_matrix;aggregate_error];
    aggregate_std_matrix = [aggregate_std_matrix;aggregate_std];
    aggregate_flop_matrix = [aggregate_flop_matrix;aggregate_flop];
    aggregate_stage_matrix = [aggregate_stage_matrix;aggregate_stage];
    aggregate_msg_matrix = [aggregate_msg_matrix;aggregate_msg];
    aggregate_bytes_matrix = [aggregate_bytes_matrix;aggregate_bytes];
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
        msg_matrix = [msg_matrix;mean(aggregate_msg,1)];
        bytes_matrix = [bytes_matrix;mean(aggregate_bytes,1)];
    end
    connectivity_array = [connectivity_array aggregate_connectivity_counter/num_trials];
    coverage_matrix = [coverage_matrix aggregate_coverage/num_trials];
end

error_matrix = error_matrix';
std_matrix = std_matrix';
flop_matrix = flop_matrix';
stage_matrix = stage_matrix';
msg_matrix = msg_matrix';
bytes_matrix = bytes_matrix';

save flop_results/FLOP_std_0.05_to_0.5_100nodes_50trials_no_stage.mat; 
