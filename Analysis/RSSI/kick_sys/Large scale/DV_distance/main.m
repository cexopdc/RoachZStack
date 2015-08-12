function [average_loc_error_array,std_loc_error_array, coverage, avg_connectivity,...
    tol_flop_arrary,break_stage_arrary,tol_msg_sent_arrary,tol_bytes_sent_arrary] = main(stage_flag,num_node,area_space,trans_range,beacon_ratio,dis_std_ratio)
    if nargin < 6
        disp('Please give stage_flag,num_node,area_space,trans_range,beacon_ratio,dis_std_ratio');
        return;
    end
    %close all; clear all; clc;
    %rng default;
    %rng (6);
    
    global FLOP_COUNT_FLAG;
    FLOP_COUNT_FLAG = 1;

    while 1
        % Configure topology-related parameters
        Topology_setup_no_CRLB; %%%%%%%%%%%
        [average_loc_error_N_hop_lateration,std_loc_error_N_hop_lateration,coverage,tol_flop_N_hop_lateration,break_stage_N_hop_lateration,tol_msg_sent_N_hop_lateration,tol_bytes_sent_N_hop_lateration] = N_hop_lateration;
        if average_loc_error_N_hop_lateration < 20 % if error is not too humongous, break; 
            [loc_error_kick,tol_flop_kick,break_stage_kick,tol_msg_sent_kick,tol_bytes_sent_kick] = kick_loc;
            if isempty(loc_error_kick)
                average_loc_error_kick = 0;
                std_loc_error_kick = 0;
            else
                average_loc_error_kick = mean(loc_error_kick); % only need 3 or more beacon stats for inter-comparison
                std_loc_error_kick = std(loc_error_kick);
            end
            [loc_error_kick_kalman,tol_flop_kick_kalman,break_stage_kick_kalman,tol_msg_sent_kick_kalman,tol_bytes_sent_kick_kalman] = kick_loc_kalman;
            if isempty(loc_error_kick_kalman)
                average_loc_error_kick_kalman = 0;
                std_loc_error_kick_kalman = 0;
            else
                average_loc_error_kick_kalman = mean(loc_error_kick_kalman); % only need 3 or more beacon stats for inter-comparison
                std_loc_error_kick_kalman = std(loc_error_kick_kalman);
            end
            [loc_error_kick_kalman_2nodes,tol_flop_kick_kalman_2nodes,break_stage_kick_kalman_2nodes,tol_msg_sent_kick_kalman_2nodes,tol_bytes_sent_kick_kalman_2nodes]=kick_loc_kalman_2nodes;
            if isempty(loc_error_kick_kalman_2nodes)
                average_loc_error_kick_kalman_2nodes = 0;
                std_loc_error_kick_kalman_2nodes = 0;
            else
                average_loc_error_kick_kalman_2nodes = mean(loc_error_kick_kalman_2nodes); % only need 3 or more beacon stats for inter-comparison
                std_loc_error_kick_kalman_2nodes = std(loc_error_kick_kalman_2nodes);
            end
            [average_loc_error_DV_distance, std_loc_error_DV_distance, coverage,tol_flop_DV_distance] = DV_distance;
            [average_loc_error_IWLSE,std_loc_error_IWLSE, coverage,tol_flop_IWLSE,break_stage_IWLSE,tol_msg_sent_IWLSE,tol_bytes_sent_IWLSE] = IWLSE;
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
        % need to combine flops from DV_vector_update and algorithm.
        tol_flop_DV_distance = tol_flop_DV_distance + tol_flop_dv_vector_update;
        tol_flop_N_hop_lateration = tol_flop_N_hop_lateration + tol_flop_dv_vector_update;
        tol_flop_IWLSE = tol_flop_IWLSE + tol_flop_dv_vector_update + IWLSE_extra_flops;
        
        tol_flop_arrary = [tol_flop_kick tol_flop_kick_kalman tol_flop_kick_kalman_2nodes ...
            tol_flop_DV_distance tol_flop_N_hop_lateration tol_flop_IWLSE];
        break_stage_arrary = [break_stage_kick break_stage_kick_kalman break_stage_kick_kalman_2nodes ...
            break_stage_N_hop_lateration break_stage_IWLSE];
        
        % need to combine msg and bytes sent from DV_vector_update and
        % algorithm
        tol_msg_sent_DV_distance = tol_msg_sent_dv_vector_update;
        tol_bytes_sent_DV_distance = tol_bytes_sent_dv_vector_update;
        tol_msg_sent_N_hop_lateration = tol_msg_sent_N_hop_lateration + tol_msg_sent_dv_vector_update;
        tol_bytes_sent_N_hop_lateration = tol_bytes_sent_N_hop_lateration + tol_bytes_sent_dv_vector_update;
        tol_msg_sent_IWLSE = tol_msg_sent_IWLSE + tol_msg_sent_dv_vector_update;
        tol_bytes_sent_IWLSE = tol_bytes_sent_IWLSE + tol_bytes_sent_dv_vector_update;
         
        tol_msg_sent_arrary = [tol_msg_sent_kick tol_msg_sent_kick_kalman tol_msg_sent_kick_kalman_2nodes ...
            tol_msg_sent_DV_distance tol_msg_sent_N_hop_lateration tol_msg_sent_IWLSE];
        tol_bytes_sent_arrary = [tol_bytes_sent_kick tol_bytes_sent_kick_kalman tol_bytes_sent_kick_kalman_2nodes ...
            tol_bytes_sent_DV_distance tol_bytes_sent_N_hop_lateration tol_bytes_sent_IWLSE];
end