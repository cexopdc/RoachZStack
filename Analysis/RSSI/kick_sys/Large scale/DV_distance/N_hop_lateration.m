%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  N-hop multilateration algorithm
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [average_loc_error, coverage] = N_hop_lateration
    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global TRANS_RANGE;
    
    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE
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
    
    %the system runs 
    for time = 0:STAGE_NUMBER
        for index = sched_array
            Node(index) = broadcast(Node(index));
        end
    end
    
    % find well-determined unknowns, and apply min_max for initial
    % localization
    for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if ~isempty(Node(i).dv_vector)
            beacon_list = Node(i).dv_vector(:,1)';
            if length(beacon_list)>2
                Node(i).well_determined=1;
                Node(i) = min_max(Node(i));
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
    
    % Refinement phase: well-determined unknowns using neighbor info. to
    % localize, using least-square
    for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if Node(i).well_determined==1
            if length(Node(i).neighbor)>2
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
% sub-function, node U calulate its own position using simple min_max.
function U = min_max(U)
    global Node;
    
    % The intersections of the bounding box are: [max(x_i-d_i),max(y_i-d_i)],[min(x_i+d_i),max(y_i+d_i)]
    tmp_dv_vector = U.dv_vector;
    % initialize x_minus_d_arrary,y_minus_d_arrary,x_plus_d_arrary,y_plus_d_arrary
    x_minus_d_arrary = [];
    y_minus_d_arrary = [];
    x_plus_d_arrary = [];
    y_plus_d_arrary = [];
    for i = 1:1:length(tmp_dv_vector)
        x_minus_d_arrary = [x_minus_d_arrary Node(tmp_dv_vector(i,1)).pos(1)-tmp_dv_vector(i,2)];
        y_minus_d_arrary = [y_minus_d_arrary Node(tmp_dv_vector(i,1)).pos(2)-tmp_dv_vector(i,2)];
        x_plus_d_arrary = [x_plus_d_arrary Node(tmp_dv_vector(i,1)).pos(1)+tmp_dv_vector(i,2)];
        y_plus_d_arrary = [y_plus_d_arrary Node(tmp_dv_vector(i,1)).pos(2)+tmp_dv_vector(i,2)];
    end
    bottom_left_corner = [max(x_minus_d_arrary) max(y_minus_d_arrary)];
    top_right_corner = [min(x_plus_d_arrary) min(y_plus_d_arrary)];
    new_est = (bottom_left_corner + top_right_corner)/2;
    U.est_pos = new_est';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node U calulate its own position using least-square lateration with its neighors only.
function U = lateration(U)
    global Node;
    global WGN_DIST;
    % initialize matrix A and b.
    A=[];
    b=[];
    
    neighbor_array = U.neighbor;
    n= neighbor_array(end); % the last neighbor 
    for neighbor_index = neighbor_array
        if neighbor_index ~= n
            A=[A;2*(Node(neighbor_index).est_pos(1)-Node(n).est_pos(1)) 2*(Node(neighbor_index).est_pos(2)-Node(n).est_pos(2))];
            b=[b;(Node(neighbor_index).est_pos(1))^2 - (Node(n).est_pos(1))^2 + (Node(neighbor_index).est_pos(2))^2 - (Node(n).est_pos(2))^2 + WGN_DIST(n,U.id)^2 - WGN_DIST(neighbor_index,U.id)^2];
        end
    end
    % solve the system using least-square
    % if the matrix is not ill-conditioned, update est_pos.
    if rcond(transpose(A)*A)>0.1
        U.est_pos = (transpose(A)*A)^(-1)*transpose(A)*b;
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
                % if beacon not in neighbor's talbe, add directly
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
                




