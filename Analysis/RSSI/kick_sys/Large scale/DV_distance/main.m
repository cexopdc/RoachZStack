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
            [loc_error_kick] = kick_loc;
            if isempty(loc_error_kick)
                average_loc_error_kick = 0;
            else
                average_loc_error_kick = mean(loc_error_kick); % only need 3 or more beacon stats for inter-comparison
            end
            [loc_error_kick_kalman] = kick_loc_kalman;
            if isempty(loc_error_kick_kalman)
                average_loc_error_kick_kalman = 0;
            else
                average_loc_error_kick_kalman = mean(loc_error_kick_kalman); % only need 3 or more beacon stats for inter-comparison
            end
            [loc_error_kick_kalman_2nodes]=kick_loc_kalman_2nodes;
            if isempty(loc_error_kick_kalman_2nodes)
                average_loc_error_kick_kalman_2nodes = 0;
            else
                average_loc_error_kick_kalman_2nodes = mean(loc_error_kick_kalman_2nodes); % only need 3 or more beacon stats for inter-comparison
            end
            [average_loc_error_DV_distance, coverage] = DV_distance;
            [average_loc_error_IWLSE, coverage] = IWLSE;
            % calculate CRLB average error, remove non-localizable nodes.
            tmp_CRLB_loc_error = [];
            for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
                if size(Node(i).dv_vector,2) > 2
                    tmp_CRLB_loc_error = [tmp_CRLB_loc_error CRLB_loc_error(i-round(NUM_NODE*BEACON_RATIO))];
                end
            end
            if isempty(tmp_CRLB_loc_error)
                average_loc_error_CRLB = 0;
            else
                average_loc_error_CRLB = mean(tmp_CRLB_loc_error)/TRANS_RANGE;
            end
               
            break;
        end
    end 
        average_loc_error_array = [average_loc_error_kick average_loc_error_kick_kalman average_loc_error_kick_kalman_2nodes...
            average_loc_error_DV_distance average_loc_error_N_hop_lateration average_loc_error_IWLSE average_loc_error_CRLB];
end