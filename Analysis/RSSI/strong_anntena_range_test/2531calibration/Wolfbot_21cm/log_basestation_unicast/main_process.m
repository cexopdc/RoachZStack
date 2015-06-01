clear all;close all;
topo_setup;
log_matrix = load('topo2b_3_log.txt'); % load txt to get log_matrix of n*7  (time, node id, neighbor id, rssi value, est x,est y,est std);
% initialize error_matrix and time_array for each node
for i=1:NUM_NODE
    Node(i).error_matrix = [];
    Node(i).time_array = []; 
end

% process all the log message by time sequence
for i = 1:length(log_matrix)
    A = Node(log_matrix(i,2));
    B = Node(round(log_matrix(i,3)));
    rssi = round(log_matrix(i,4));
    Node(log_matrix(i,2)) = kick_loc_2531(A,B,rssi);
    
    % record data for time-evolving result
    error_online = sqrt((Node(log_matrix(i,2)).x - log_matrix(i,5))^2 + (Node(log_matrix(i,2)).y - log_matrix(i,6))^2);
    error_offline = sqrt((Node(log_matrix(i,2)).x - Node(log_matrix(i,2)).est_x)^2 + (Node(log_matrix(i,2)).y - Node(log_matrix(i,2)).est_y)^2);
    Node(log_matrix(i,2)).error_matrix = [Node(log_matrix(i,2)).error_matrix [error_online;error_offline]];
    Node(log_matrix(i,2)).time_array = [Node(log_matrix(i,2)).time_array log_matrix(i,1)];
end

figure
%co = get(gca,'ColorOrder'); % Initial
% Change to new colors.
set(gca, 'ColorOrder', [1 0 0; 0 1 0], 'NextPlot', 'replacechildren');
%co = get(gca,'ColorOrder'); % Verify it changed
hold on; grid on;
%all nodes final error array
final_error_array=[];
for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    node_id = i.*ones(1,length(Node(i).time_array));
    plot3(node_id,Node(i).time_array,Node(i).error_matrix);
    final_error_array = [final_error_array Node(i).error_matrix(:,end)];
end
final_mean_error = mean(final_error_array,2);

set(gca,'xtick',round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE)
set(gca,'ydir','reverse')
xlabel('node\_ID');
ylabel('time (tick)');
zlabel('error (m)');
legend('online','offline');
view(-36,50)

