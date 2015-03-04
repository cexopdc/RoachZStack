    %close all; clear all; clc;
    %rng default;
    %rng (6);
    % Configure topology-related parameters
    clear all;
    num_node = 100;
    dis_std_ratio = 0.2;
    beacon_ratio = 0.2;
    confidence_interval_matrix = [];
    for i=1:10
        Topology_setup;
        [average_loc_error_kick,confidence_interval] = kick_loc;
        confidence_interval_matrix = [confidence_interval_matrix;confidence_interval];
    end
   