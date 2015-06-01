clear all;close all;
topo_setup;
% Node A's real position for comparison purpose
A.x = 0.4;
A.y = 1.4;

% load txt to get log_matrix of n*9  (time tick, neighbor id, rssi value, neighbor est x,neighbor est y,neighbor est std, est x, est y, est std);
log_matrix = load('topo_trial.txt');

% initialize A's est info. error_matrix and time_array for each node
A.est_x = 1.5;
A.est_y = 1.5;
A.std = STD_INITIAL;

error_online = sqrt((A.est_x - A.x)^2 + (A.est_y - A.y)^2);
error_offline = sqrt((A.est_x - A.x)^2 + (A.est_y - A.y)^2);
A.error_matrix = [error_online;error_offline];
A.time_array = [0]; 

% process all the log message by time sequence
for i = 1:length(log_matrix)
    B.est_x = log_matrix(i,4);
    B.est_y = log_matrix(i,5);
    B.std = log_matrix(i,6);

    rssi = round(log_matrix(i,3));
    A = kick_loc_2531(A,B,rssi);
    
    % record data for time-evolving result
    error_online = sqrt((A.x - log_matrix(i,7))^2 + (A.y - log_matrix(i,8))^2);
    error_offline = sqrt((A.x - A.est_x)^2 + (A.y - A.est_y)^2);
    A.error_matrix = [A.error_matrix [error_online;error_offline]];
    A.time_array = [A.time_array log_matrix(i,1)];
end

figure
h = plot(A.time_array,A.error_matrix);
h(1).Color = [1 0 0];
h(2).Color = [0 1 0];
xlabel('time (tick)');
ylabel('error (m)');
legend('online','offline');

% 3d plot for all nodes
%{
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
%}

