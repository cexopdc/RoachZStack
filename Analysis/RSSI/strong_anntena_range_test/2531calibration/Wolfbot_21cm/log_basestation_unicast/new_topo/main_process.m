function final_error_mean_offline = main_process(topo,mapping_method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mapping_method: 1. direct mapping
%                 2. fitting
%                 3. weighted fitting
%                 4. cut 3m direct mapping
%                 5. cut 3m fitting
%                 6. cut 3m weighted fitting
%
%clear all;close all;
global DIS_MAP;
DIS_MAP = zeros(15,15); %DIS for RSSI received at i from j is DIS_MAP(i,j)
topo_setup;
log_matrix = load(strcat('new_topo',num2str(topo),'.txt')); % load txt to get log_matrix of n*7  (time, node id, neighbor id, rssi value, est x,est y,est std);
% initialize error_matrix and time_array for each node
for i=1:NUM_NODE
    Node(i).error_matrix = [];
    Node(i).time_array = []; 
end

% process all the log message by time sequence
%
for i = 1:length(log_matrix)
    A = Node(log_matrix(i,2));
    B = Node(round(log_matrix(i,3)));
    rssi = round(log_matrix(i,4));   
    
    Node(log_matrix(i,2)) = kick_loc_2531(A,B,rssi);
    %Node(log_matrix(i,2)) = kick_loc_2531_beacon_only(A,B,rssi);
    % record data for time-evolving result
    error_online = sqrt((Node(log_matrix(i,2)).x - log_matrix(i,5))^2 + (Node(log_matrix(i,2)).y - log_matrix(i,6))^2);
    error_offline = sqrt((Node(log_matrix(i,2)).x - Node(log_matrix(i,2)).est_x)^2 + (Node(log_matrix(i,2)).y - Node(log_matrix(i,2)).est_y)^2);
    Node(log_matrix(i,2)).error_matrix = [Node(log_matrix(i,2)).error_matrix [error_online;error_offline]];
    Node(log_matrix(i,2)).time_array = [Node(log_matrix(i,2)).time_array log_matrix(i,1)];
end
%

%{
for i = 1:length(log_matrix)
    A = Node(log_matrix(i,2));
    B = Node(round(log_matrix(i,3)));
    rssi = round(log_matrix(i,4));
    min_rssi = RSSI_DIS(end,1);
    max_rssi = RSSI_DIS(1,1);
    % if rssi larger than upper boundary, treat it as boundary value, if smaller than lower boundary, treat it as bad quality and
    % discard.
    if rssi > max_rssi
        rssi = max_rssi;
    end
    if rssi < min_rssi
        rssi = min_rssi;
    end
    dis = RSSI_DIS(RSSI_DIS(:,1)==rssi,2);
    dis_std = RSSI_DIS(RSSI_DIS(:,1)==rssi,3);
    if dis_std <0.01
        dis_std = 0.01;
    end
    
    if DIS_MAP(A.id,B.id) == 0 
        DIS_MAP(A.id,B.id) = dis;
    end
end

for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    %Node(i) = DV_distance(Node(i));
    Node(i) = min_max(Node(i));
end

for time=1:10
    for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        Node(i) = N_hop_refine(Node(i));
    end
end

aggr_error = [];
for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    error = sqrt((Node(i).est_x - Node(i).x)^2 + (Node(i).est_y - Node(i).y)^2);
    aggr_error = [aggr_error error];
end
final_error_mean_offline = mean(aggr_error);
%}

%
%figure; hold on;
final_error_array=[];
for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    node_id = i.*ones(1,length(Node(i).time_array));
%    plot3(node_id,Node(i).time_array,Node(i).error_matrix(2,:));
    final_error_array = [final_error_array Node(i).error_matrix(:,end)];
end

%{
set(gca,'xtick',round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE)
set(gca,'ydir','reverse')
xlabel('node\_ID');
ylabel('time (tick)');
zlabel('error (m)');
view(-36,50)
filename = strcat('time_evolving_topo',num2str(topo),'_method',num2str(mapping_method));
savefig(filename);
exportfig(gcf,strcat(filename,'.eps'),'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
%}

final_mean_error = mean(final_error_array,2);
%offline error only
final_error_mean_offline = final_mean_error(2,1);
%

end
