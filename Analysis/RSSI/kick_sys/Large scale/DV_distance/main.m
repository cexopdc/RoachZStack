function [average_loc_error_array, coverage, avg_connectivity] = main(num_node,dis_std_ratio,beacon_ratio)
    if nargin < 3
        disp('Please give num_node,dis_std_ratio,beacon_ratio');
        return;
    end
    %close all; clear all; clc;
    %rng default;
    %rng (6);

    while 1
        % Configure topology-related parameters
        Topology_setup;
        [average_loc_error_N_hop_lateration, coverage] = N_hop_lateration;
        if average_loc_error_N_hop_lateration < 100 % if error is not too humongous, break; 
            [average_loc_error_kick,confidence_interval] = kick_loc;
            [average_loc_error_kick_kalman,confidence_interval] = kick_loc_kalman;
            [average_loc_error_kick_kalman_2nodes,confidence_interval]=kick_loc_kalman_2nodes;
            [average_loc_error_DV_distance, coverage] = DV_distance;
            [average_loc_error_IWLSE, coverage] = IWLSE;
            break;
        end
    end
        average_loc_error_array = [average_loc_error_kick average_loc_error_kick_kalman average_loc_error_kick_kalman_2nodes...
            average_loc_error_DV_distance average_loc_error_N_hop_lateration average_loc_error_IWLSE];
end