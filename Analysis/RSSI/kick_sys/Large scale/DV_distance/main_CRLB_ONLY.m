function [average_loc_error_array,std_loc_error_array, coverage, avg_connectivity] = main_CRLB_ONLY(num_node,area_space,trans_range,beacon_ratio,dis_std_ratio)
    if nargin < 5
        disp('Please give num_node,area_space,trans_range,beacon_ratio,dis_std_ratio');
        return;
    end
    %close all; clear all; clc;
    %rng default;
    %rng (6);

        % Configure topology-related parameters
        Topology_setup; %%%%%%%%%%%
        % calculate RMS error,, remove non-localizable nodes.
        aggr_error=0;
        for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
                if size(Node(i).dv_vector,1) > 2
                    j = i-round(NUM_NODE*BEACON_RATIO);
                    aggr_error = aggr_error + CRLB(2*j-1,2*j-1) + CRLB(2*j,2*j);
                end
        end
        std_loc_error_CRLB = sqrt(aggr_error/A)/TRANS_RANGE;
        std_loc_error_array = [std_loc_error_CRLB];
        average_loc_error_array = [];
        coverage=0; % we don't use it here
        avg_connectivity=0; % we don't use it here
end