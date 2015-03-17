%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  DV-distance algorithm
% 
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [average_loc_error, coverage] = DV_distance
    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global TRANS_RANGE;
    
    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE
        Node(i).sched=rand;    % time scheduling of the system, set to random
        Node(i).correction=0;   % intiailize the correction to be 0

        if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
            Node(i).est_pos = Node(i).pos;
            Node(i).dv_vector=[Node(i).id 0];  % initialize accessible dv vector, itself.
            Node(i).well_determined=1; % set beacon as well-determined.
        else                            % unknown
            Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
            Node(i).dv_vector=[];  % initialize accessible dv vector to none
            Node(i).well_determined=0; % set unknowns as not well-determined.
        end
    end

    % sort the time schedule of all the nodes
    tmp_sched = [];
    for i=1:NUM_NODE
        tmp_sched = [tmp_sched;[Node(i).sched Node(i).id]];
    end
    tmp_sched = sortrows(tmp_sched);
    sched_array = tmp_sched(:,2)';
    
    %the system runs to obtain DV
    for time = 0:STAGE_NUMBER
        for index = sched_array
            Node(index) = broadcast(Node(index));
        end
    end

    % Obtain corrections for each beacon
    for i= 1:round(NUM_NODE*BEACON_RATIO)
        % if beacon has access to other beacon, then
        % calculate a correction.
        if size(Node(i).dv_vector,1)>1
            tol_DIS = 0;
            tol_dis = sum(Node(i).dv_vector(:,2));
            for beacon_index = Node(i).dv_vector(:,1)'
                tol_DIS = tol_DIS + DIST(Node(i),Node(beacon_index));
            end
            Node(i).correction = tol_dis/tol_DIS;
        end
    end
    
    % Obtain corrections for each unknown
    for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if ~isempty(Node(i).dv_vector)
            % find the nearest beacon for the correction
            sorted_dv = sortrows(Node(i).dv_vector,2);
            nearest_beacon = sorted_dv(1,1);
            Node(i).correction = Node(nearest_beacon).correction;
        end
    end
    
    %Node position - lateration
    for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if ~isempty(Node(i).dv_vector)
            beacon_list = Node(i).dv_vector(:,1)';
            if length(beacon_list)>2
                Node(i).well_determined=1;
                Node(i) = lateration(Node(i));
            end
        end
    end
    
    % collect localization stats
    loc_error=[];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if Node(i).well_determined==1
            loc_error =[loc_error sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
        end
    end
    
    if ~isempty(loc_error)
        average_loc_error = mean(loc_error)/TRANS_RANGE;
        max_loc_error = max(loc_error)/TRANS_RANGE;
        coverage = length(loc_error)/(NUM_NODE*(1-BEACON_RATIO));
    else
        average_loc_error = 0;
        coverage = 0;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current distance
% to all the beacons it can reach.
function  A = broadcast(A)
    global Node;
    global WGN_DIST;
    
    % if A has beacon dv_vector to broadcast
    if ~isempty(A.dv_vector)
        beacon_list = A.dv_vector(:,1)';
        % iterate all neighbors
        for neighbor_index = A.neighbor        
            for beacon_index = beacon_list
                % if beacon not in neighbor's table, add directly
                if isempty(Node(neighbor_index).dv_vector) 
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    beacon_neighbor_dist = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    Node(neighbor_index).dv_vector = [Node(neighbor_index).dv_vector; beacon_index beacon_neighbor_dist];
                elseif ~ismember(beacon_index,Node(neighbor_index).dv_vector(:,1))
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    beacon_neighbor_dist = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    Node(neighbor_index).dv_vector = [Node(neighbor_index).dv_vector; beacon_index beacon_neighbor_dist];
                % if beacon is already in neighbor's table, compare and
                % update accordingly.
                else
                    beacon_neighbor_dist = Node(neighbor_index).dv_vector(find(Node(neighbor_index).dv_vector(:,1)==beacon_index),2);
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    if beacon_neighbor_dist > beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id)
                        Node(neighbor_index).dv_vector(find(Node(neighbor_index).dv_vector(:,1)==beacon_index),2)   = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    end  
                end
            end
        end
    end
end
                

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node U calulate its own position using least-square lateration.
function U = lateration(U)
    global Node;
    % initialize matrix A and b.
    A=[];
    b=[];
    beacon_list = U.dv_vector(:,1)';
    n= beacon_list(end); % the last beacon 
    
    tmp_dv_vector = U.dv_vector(:,2)';
    %
    % use correction to correct the distance_vector
    if U.correction ~= 0
        tmp_dv_vector = tmp_dv_vector/U.correction;
    end
    %
    
    counter = 0; % counter for sequence to access dv_vector
    
    for beacon_index = beacon_list
        counter = counter + 1;
        if beacon_index ~= n
            A=[A;2*(Node(beacon_index).est_pos(1)-Node(n).est_pos(1)) 2*(Node(beacon_index).est_pos(2)-Node(n).est_pos(2))];
            b=[b;(Node(beacon_index).est_pos(1))^2 - (Node(n).est_pos(1))^2 + (Node(beacon_index).est_pos(2))^2 - (Node(n).est_pos(2))^2 + tmp_dv_vector(size(tmp_dv_vector,2))^2 - tmp_dv_vector(counter)^2
];
        end
    end
    % solve the system using least-square
    U.est_pos = (transpose(A)*A)^(-1)*transpose(A)*b;
end
    




