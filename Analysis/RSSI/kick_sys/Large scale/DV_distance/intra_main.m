function [average_loc_error_array] = intra_main(num_node,dis_std_ratio,beacon_ratio)
    if nargin < 3
        disp('Please give num_node,dis_std_ratio,beacon_ratio');
        return;
    end
    %close all; clear all; clc;
    %rng default;
    %rng (6);
    % Configure topology-related parameters
    Topology_setup;
    [average_loc_error_kick,confidence_interval] = kick_loc;
    [average_loc_error_kick_kalman,confidence_interval] = kick_loc_kalman;
    %[average_loc_error_kick_kalman_remove,confidence_interval] = kick_loc_kalman_remove;
    [average_loc_error_kick_kalman_2nodes,confidence_interval]=kick_loc_kalman_2nodes;
    %[average_loc_error_kick_loc_kalman_2nodes_remove,confidence_interval]=kick_loc_kalman_2nodes_remove;
    %[average_loc_error_kick_loc_kalman_change_var,confidence_interval]=kick_loc_kalman_change_var;
    %average_loc_error_array = [average_loc_error_kick average_loc_error_kick_kalman ...
    %   average_loc_error_kick_kalman_remove average_loc_error_kick_loc_kalman_2nodes average_loc_error_kick_loc_kalman_2nodes_remove average_loc_error_kick_loc_kalman_change_var];
    average_loc_error_array = [average_loc_error_kick average_loc_error_kick_kalman average_loc_error_kick_kalman_2nodes];
end