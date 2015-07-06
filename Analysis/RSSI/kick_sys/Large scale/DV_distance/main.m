function [average_loc_error_array,std_loc_error_array, coverage, avg_connectivity] = main(num_node,area_space,trans_range,beacon_ratio,dis_std_ratio)
    if nargin < 5
        disp('Please give num_node,area_space,trans_range,beacon_ratio,dis_std_ratio');
        return;
    end
    %close all; clear all; clc;
    %rng default;
    %rng (6);

    while 1
        % Configure topology-related parameters
        Topology_setup_no_CRLB; %%%%%%%%%%%
        [average_loc_error_N_hop_lateration,std_loc_error_N_hop_lateration coverage] = N_hop_lateration;
        if average_loc_error_N_hop_lateration < 20 % if error is not too humongous, break; 
            [loc_error_kick] = kick_loc;
            if isempty(loc_error_kick)
                average_loc_error_kick = 0;
                std_loc_error_kick = 0;
            else
                average_loc_error_kick = mean(loc_error_kick); % only need 3 or more beacon stats for inter-comparison
                std_loc_error_kick = std(loc_error_kick);
            end
            [loc_error_kick_kalman] = kick_loc_kalman;
            if isempty(loc_error_kick_kalman)
                average_loc_error_kick_kalman = 0;
                std_loc_error_kick_kalman = 0;
            else
                average_loc_error_kick_kalman = mean(loc_error_kick_kalman); % only need 3 or more beacon stats for inter-comparison
                std_loc_error_kick_kalman = std(loc_error_kick_kalman);
            end
            [loc_error_kick_kalman_2nodes]=kick_loc_kalman_2nodes;
            if isempty(loc_error_kick_kalman_2nodes)
                average_loc_error_kick_kalman_2nodes = 0;
                std_loc_error_kick_kalman_2nodes = 0;
            else
                average_loc_error_kick_kalman_2nodes = mean(loc_error_kick_kalman_2nodes); % only need 3 or more beacon stats for inter-comparison
                std_loc_error_kick_kalman_2nodes = std(loc_error_kick_kalman_2nodes);
            end
            [average_loc_error_DV_distance, std_loc_error_DV_distance, coverage] = DV_distance;
            [average_loc_error_IWLSE,std_loc_error_IWLSE, coverage] = IWLSE;
            % calculate CRLB average error, remove non-localizable nodes.
            %{
            tmp_CRLB_loc_error = [];
            for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
                if size(Node(i).dv_vector,1) > 2
                    tmp_CRLB_loc_error = [tmp_CRLB_loc_error CRLB_loc_error(i-round(NUM_NODE*BEACON_RATIO))];
                end
            end
            if isempty(tmp_CRLB_loc_error)
                average_loc_error_CRLB = 0;
            else
                average_loc_error_CRLB = mean(tmp_CRLB_loc_error)/TRANS_RANGE;
            end
            %}
            std_loc_error_CRLB = 0; %%%%%%%%%%%%
            break;
        end
    end 
        average_loc_error_array = [average_loc_error_kick average_loc_error_kick_kalman average_loc_error_kick_kalman_2nodes...
            average_loc_error_DV_distance average_loc_error_N_hop_lateration average_loc_error_IWLSE];
        std_loc_error_array = [std_loc_error_kick std_loc_error_kick_kalman std_loc_error_kick_kalman_2nodes...
            std_loc_error_DV_distance std_loc_error_N_hop_lateration std_loc_error_IWLSE std_loc_error_CRLB];
end