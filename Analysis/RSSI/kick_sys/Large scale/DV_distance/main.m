%function [loc_error_intuitive,loc_error_kalman] = main
function [average_loc_error_array,coverage,avg_connectivity] = main(num_node,dis_std_ratio,beacon_ratio)
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
    [average_loc_error_DV_distance, coverage] = DV_distance;
    [average_loc_error_N_hop_lateration, coverage] = N_hop_lateration;
    average_loc_error_array = [average_loc_error_kick average_loc_error_DV_distance average_loc_error_N_hop_lateration];
end

%node_analysis(node_stat,'intuitive');
%store the final resulting errors for all the unknowns
%{
loc_error_intuitive=[];
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    loc_error_intuitive =[loc_error_intuitive sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end
%}

%{
figure;
node_id = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE;
bar(node_id,loc_error_intuitive/TRANS_RANGE,'FaceColor',[0.2,0.2,0.5])
average_loc_error_intuitive = mean(loc_error_intuitive)/TRANS_RANGE
max_loc_error_intuitive = max(loc_error_intuitive)/TRANS_RANGE
filtered_average_loc_error_intuitive = mean(loc_error_intuitive(loc_error_intuitive<1.5*TRANS_RANGE))/TRANS_RANGE
%coverage_intuitive = length(loc_error_intuitive(loc_error_intuitive<0.2*TRANS_RANGE))/NUM_NODE
%}

%{
% reset unknown nodes
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE   
    Node(i).est_pos = [0;0];
    Node(i).std = 0;
end

%node_stat = kick_loc('kalman');
node_stat = kick_loc_two_node;
node_analysis(node_stat,'kalman');
%store the final resulting errors for all the unknowns
loc_error_kalman=[];
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    loc_error_kalman =[loc_error_kalman sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end



%plot the final resulting errors in both algorithm
figure;
node_id = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE;
plot(node_id,loc_error_intuitive,node_id,loc_error_kalman);
legend('intuitive','kalman');


loc_error = [loc_error_intuitive;loc_error_kalman];
figure;
width1 = 0.5;
bar(node_id,loc_error_intuitive/TRANS_RANGE,width1,'FaceColor',[0.2,0.2,0.5])

%average_loc_error_intuitive = mean(loc_error_intuitive)/TRANS_RANGE
%max_loc_error_intuitive = max(loc_error_intuitive)/TRANS_RANGE
%filtered_average_loc_error_intuitive = mean(loc_error_intuitive(loc_error_intuitive<0.2*TRANS_RANGE))/TRANS_RANGE
%coverage_intuitive = length(loc_error_intuitive(loc_error_intuitive<0.2*TRANS_RANGE))/NUM_NODE
%bar(node_id,loc_error_intuitive');

hold on
width2 = width1/2;
bar(node_id,loc_error_kalman/TRANS_RANGE,width2,'FaceColor',[0,0.7,0.7],'EdgeColor',[0,0.7,0.7]);
hold off
%average_loc_error_kalman = mean(loc_error_kalman)/TRANS_RANGE
%max_loc_error_kalman = max(loc_error_kalman)/TRANS_RANGE
%filtered_average_loc_error_kalman = mean(loc_error_kalman(loc_error_kalman<0.2*TRANS_RANGE))/TRANS_RANGE
%coverage_kalman = length(loc_error_kalman(loc_error_kalman<0.2*TRANS_RANGE))/NUM_NODE
legend('intuitive','Two\_Node\_kalman');
xlabel('Node ID');
ylabel('Relative error');
%}

