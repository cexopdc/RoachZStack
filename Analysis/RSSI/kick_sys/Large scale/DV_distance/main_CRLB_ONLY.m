function [average_loc_error_array, coverage, avg_connectivity] = main(num_node,area_space,trans_range,beacon_ratio,dis_std_ratio)
    if nargin < 5
        disp('Please give num_node,area_space,trans_range,beacon_ratio,dis_std_ratio');
        return;
    end
    %close all; clear all; clc;
    %rng default;
    %rng (6);

        % Configure topology-related parameters
        Topology_setup; %%%%%%%%%%%
        % calculate CRLB average error, remove non-localizable nodes.
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
        average_loc_error_array = [average_loc_error_CRLB];
        coverage=0; % we don't use it here
        avg_connectivity=0; % we don't use it here
end