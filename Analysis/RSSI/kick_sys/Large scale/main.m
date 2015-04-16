%function [loc_error_intuitive,loc_error_kalman] = main
function [loc_error_intuitive,connectivity_counter] = main(num_node,dis_std_ratio,beacon_ratio)
if nargin < 3
    disp('Please give num_node,dis_std_ratio,beacon_ratio');
    return;
end
%close all; clear all; clc;
rng default;
rng (6);
% Configure topology-related parameters
Topology_setup;

%run the intuitive algorithm
node_stat = kick_loc('intuitive');
%node_analysis(node_stat,'intuitive');
%store the final resulting errors for all the unknowns
loc_error_intuitive=[];
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    loc_error_intuitive =[loc_error_intuitive sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end

%{
figure;
node_id = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE;
bar(node_id,loc_error_intuitive/TRANS_RANGE,'FaceColor',[0.2,0.2,0.5])
average_loc_error_intuitive = mean(loc_error_intuitive)/TRANS_RANGE
max_loc_error_intuitive = max(loc_error_intuitive)/TRANS_RANGE
filtered_average_loc_error_intuitive = mean(loc_error_intuitive(loc_error_intuitive<1.5*TRANS_RANGE))/TRANS_RANGE
%coverage_intuitive = length(loc_error_intuitive(loc_error_intuitive<0.2*TRANS_RANGE))/NUM_NODE
%}

%
% reset unknown nodes for kalman
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE   
    Node(i).est_pos = [0;0];
    Node(i).std = 0;
end

node_stat = kick_loc('kalman');
%store the final resulting errors for all the unknowns
loc_error_kalman=[];
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    loc_error_kalman =[loc_error_kalman sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end

% reset unknown nodes for kalman two nodes
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE   
    Node(i).est_pos = [0;0];
    Node(i).std = 0;
end

%node_stat = kick_loc('kalman');
node_stat = kick_loc_two_node;
%store the final resulting errors for all the unknowns
loc_error_kalman_2nodes=[];
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    loc_error_kalman_2nodes =[loc_error_kalman_2nodes sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end



%plot the final resulting errors in 3 algorithm
figure;
node_id = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE;
plot(node_id,loc_error_intuitive,node_id,loc_error_kalman,node_id,loc_error_kalman_2nodes);
legend('KickLoc Intuitive','KickLoc Kalman','KickLoc Kalman 2 nodes');


loc_error = [loc_error_intuitive;loc_error_kalman;loc_error_kalman_2nodes];
figure;
width1 = 0.5;
bar(node_id,loc_error_intuitive/TRANS_RANGE,width1,'FaceColor',[0.2,0.2,0.5])

hold on
width2 = width1/3;
bar(node_id,loc_error_kalman/TRANS_RANGE,width2,'FaceColor',[0,0.7,0.7],'EdgeColor',[0,0.7,0.7]);
hold on
width3 = width1*2/3;
bar(node_id,loc_error_kalman_2nodes/TRANS_RANGE,width3,'FaceColor',[0,0.9,0.9],'EdgeColor',[0,0.9,0.9]);
hold off
legend('intuitive','Kalman','Two\_Node\_kalman');
xlabel('Node ID');
ylabel('Relative error');

average_loc_error_intuitive = mean(loc_error_intuitive)/TRANS_RANGE
max_loc_error_intuitive = max(loc_error_intuitive)/TRANS_RANGE
%filtered_average_loc_error_intuitive = mean(loc_error_intuitive(loc_error_intuitive<0.2*TRANS_RANGE))/TRANS_RANGE
%coverage_intuitive = length(loc_error_intuitive(loc_error_intuitive<0.2*TRANS_RANGE))/NUM_NODE
%bar(node_id,loc_error_intuitive');
average_loc_error_kalman = mean(loc_error_kalman)/TRANS_RANGE
max_loc_error_kalman = max(loc_error_kalman)/TRANS_RANGE
average_loc_error_kalman_2nodes = mean(loc_error_kalman_2nodes)/TRANS_RANGE
max_loc_error_kalman_2nodes = max(loc_error_kalman_2nodes)/TRANS_RANGE
%filtered_average_loc_error_kalman = mean(loc_error_kalman(loc_error_kalman<0.2*TRANS_RANGE))/TRANS_RANGE
%coverage_kalman = length(loc_error_kalman(loc_error_kalman<0.2*TRANS_RANGE))/NUM_NODE

%

