function  [loc_error_intuitive,loc_error_kalman,loc_error_kalman_2nodes,connectivity_counter] = intra_each_node_main(num_node,dis_std_ratio,beacon_ratio)
if nargin < 3
    disp('Please give num_node,dis_std_ratio,beacon_ratio');
    return;
end
%close all; clear all; clc;
%rng default;
%rng (6);
% Configure topology-related parameters
Topology_setup_no_CRLB;

[average_loc_error_kick,confidence_interval] = kick_loc;
loc_error_intuitive=[];
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    loc_error_intuitive =[loc_error_intuitive sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end

[average_loc_error_kick_kalman,confidence_interval] = kick_loc_kalman;
loc_error_kalman=[];
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    loc_error_kalman =[loc_error_kalman sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end

[average_loc_error_kick_kalman_2nodes,confidence_interval]=kick_loc_kalman_2nodes;
loc_error_kalman_2nodes=[];
for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    loc_error_kalman_2nodes =[loc_error_kalman_2nodes sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end


%{
%plot the final resulting errors in 3 algorithm
figure;
node_id = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE;
h = plot(node_id,loc_error_intuitive/TRANS_RANGE,node_id,loc_error_kalman/TRANS_RANGE,node_id,loc_error_kalman_2nodes/TRANS_RANGE);
h(1).Marker = 'o';
h(2).Marker = '*';
h(3).Marker = 's';
legend('KickLoc Intuitive','KickLoc Kalman','KickLoc Kalman 2 nodes');
xlabel('Node ID');
ylabel('Relative error');

loc_error = [loc_error_intuitive;loc_error_kalman;loc_error_kalman_2nodes];

%{
figure;
width1 = 0.5;
bar(node_id,loc_error_intuitive/TRANS_RANGE,width1,'FaceColor','r')

hold on
width2 = width1/3;
bar(node_id,loc_error_kalman/TRANS_RANGE,width2,'FaceColor','g','EdgeColor','g');
hold on
width3 = width1*2/3;
bar(node_id,loc_error_kalman_2nodes/TRANS_RANGE,width3,'FaceColor','k','EdgeColor','k');
hold off
legend('intuitive','Kalman','Two\_Node\_kalman');
xlabel('Node ID');
ylabel('Relative error');
%}
figure;
bar(node_id,loc_error'/TRANS_RANGE);
legend('intuitive','Kalman','Two\_Node\_kalman');
xlabel('Node ID');
ylabel('Relative error');

avg_connectivity
average_loc_error_intuitive = mean(loc_error_intuitive)/TRANS_RANGE
max_loc_error_intuitive = max(loc_error_intuitive)/TRANS_RANGE
filtered_average_loc_error_intuitive = mean(loc_error_intuitive(loc_error_intuitive<0.2*TRANS_RANGE))/TRANS_RANGE
coverage_intuitive = length(loc_error_intuitive(loc_error_intuitive<0.2*TRANS_RANGE))/NUM_NODE

average_loc_error_kalman = mean(loc_error_kalman)/TRANS_RANGE
max_loc_error_kalman = max(loc_error_kalman)/TRANS_RANGE
filtered_average_loc_error_kalman = mean(loc_error_kalman(loc_error_kalman<0.2*TRANS_RANGE))/TRANS_RANGE
coverage_kalman = length(loc_error_kalman(loc_error_kalman<0.2*TRANS_RANGE))/NUM_NODE

average_loc_error_kalman_2nodes = mean(loc_error_kalman_2nodes)/TRANS_RANGE
max_loc_error_kalman_2nodes = max(loc_error_kalman_2nodes)/TRANS_RANGE
filtered_average_loc_error_kalman_2nodes = mean(loc_error_kalman_2nodes(loc_error_kalman_2nodes<0.2*TRANS_RANGE))/TRANS_RANGE
coverage_kalman_2nodes = length(loc_error_kalman_2nodes(loc_error_kalman_2nodes<0.2*TRANS_RANGE))/NUM_NODE
%}
