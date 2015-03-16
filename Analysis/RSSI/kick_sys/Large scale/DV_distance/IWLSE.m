% Iterative Weight Least Squares Estiamtion
% 1. get distances to available beacons, along with std (the bias factor).
% 2. do a LS lateration to get the initial est and std.
% 3. Each node do a IWLSE lateration with neighbor nodes.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  N-hop multilateration algorithm
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [average_loc_error, coverage] = IWLSE
    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global TRANS_RANGE;
    global STD_INITIAL;
    STD_INITIAL = 10000;   % initial std for unknown
    
    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE
        Node(i).sched=rand;    % time scheduling of the system, set to random
        Node(i).correction=0;   % intiailize the correction to be 0

        if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
            Node(i).est_pos = Node(i).pos;
            Node(i).dv_vector=[Node(i).id 0 0];  % initialize accessible dv vector, itself.
            Node(i).well_determined=1; % set beacon as well-determined.
            Node(i).std=0;
        else                            % unknown
            Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
            Node(i).dv_vector=[];  % initialize accessible dv vector to none
            Node(i).well_determined=0; % set unknowns as not well-determined.
            Node(i).std=STD_INITIAL;
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
    
    % find well-determined unknowns, and apply lateration using beacons for initial
    % localization
    for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if ~isempty(Node(i).dv_vector)
            beacon_list = Node(i).dv_vector(:,1)';
            if length(beacon_list)>2
                Node(i).well_determined=1;
                Node(i) = beacon_lateration(Node(i));
            end
        end
    end
    
    % Refinement phase: well-determined unknowns using neighbor info. to
    % localize, using weighted least-square
    for time = 0:STAGE_NUMBER
        for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
            if Node(i).well_determined==1
                if length(Node(i).neighbor)>2
                    Node(i) = neighbor_lateration(Node(i));
                end
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
% sub-function, to calculate the distance between two nodes using est
% position
function est_dist=est_DIST(A,B)
    est_dist=sqrt((A.est_pos(1)-B.est_pos(1))^2+(A.est_pos(2)-B.est_pos(2))^2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node U calulate initial est using beacon info. to do lateration.
function U = beacon_lateration(U)
    global Node;
    % initialize matrix A and b.
    A=[];
    b=[];
    beacon_list = U.dv_vector(:,1)'; 
    
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
        l = ((U.est_pos - Node(beacon_index).est_pos)/est_DIST(U,Node(beacon_index)))';
        w = 1/sqrt(U.dv_vector(counter,3)^2 + Node(beacon_index).std^2);
        A = [A; l*w];
        b = [b;(tmp_dv_vector(counter) - est_DIST(U,Node(beacon_index)))*w];
    end
    % solve the system using least-square
    U.est_pos = U.est_pos + (transpose(A)*A)^(-1)*transpose(A)*b;
    C = (transpose(A)*A)^(-1);
    U.std = sqrt(0.5*(sum(C(:))));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node U calulate its own position using least-square lateration with its neighors only.
function U = neighbor_lateration(U)
    global Node;
    global WGN_DIST;
    global DIS_STD_RATIO;
    % initialize matrix A and b.
    A=[];
    b=[];
    
    neighbor_array = U.neighbor;
    
    for neighbor_index = neighbor_array
        l = ((U.est_pos - Node(neighbor_index).est_pos)/est_DIST(U,Node(neighbor_index)))';
        w = 1/sqrt((WGN_DIST(neighbor_index,U.id)*DIS_STD_RATIO)^2 + Node(neighbor_index).std^2);
        A = [A; l*w];
        b = [b;(WGN_DIST(neighbor_index,U.id) - est_DIST(U,Node(neighbor_index)))*w]; 
    end
    % solve the system using least-square
    % if the matrix is not ill-conditioned, update est_pos.
    if rcond(transpose(A)*A)>0.01
        U.est_pos = U.est_pos + (transpose(A)*A)^(-1)*transpose(A)*b;
        C = (transpose(A)*A)^(-1);
        U.std = sqrt(0.5*(sum(C(:))));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current distance
% to all the beacons it can reach.
function  A = broadcast(A)
    global Node;
    global WGN_DIST;
    global DIS_STD_RATIO;
    % if beacon has no correction yet and has access to other beacon, then
    % calculate a correction.
    if A.correction == 0 && strcmp(A.attri,'beacon')  && size(A.dv_vector,1)>1
        tmp_id = A.dv_vector(2,1);
        A.correction = A.dv_vector(2,2)/DIST(A,Node(tmp_id)); 
    end
    
    % if A has beacon dv_vector to broadcast
    if ~isempty(A.dv_vector)
        beacon_list = A.dv_vector(:,1)';
        % iterate all neighbors
        for neighbor_index = A.neighbor
            %  if A has correction, and the neighbor doesn't have it,
            %  forward the correction.
            if A.correction ~= 0 && Node(neighbor_index).correction == 0
                Node(neighbor_index).correction = A.correction;
            end
            
            for beacon_index = beacon_list
                % if beacon not in neighbor's talbe, add directly
                if isempty(Node(neighbor_index).dv_vector) 
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    beacon_neighbor_dist = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    % update the dist_std 
                    beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                    Node(neighbor_index).dv_vector = [Node(neighbor_index).dv_vector; beacon_index beacon_neighbor_dist beacon_neighbor_dist_std];
                elseif ~ismember(beacon_index,Node(neighbor_index).dv_vector(:,1))
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    beacon_neighbor_dist = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    % update the dist_std 
                    beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                    Node(neighbor_index).dv_vector = [Node(neighbor_index).dv_vector; beacon_index beacon_neighbor_dist  beacon_neighbor_dist_std];
                % if beacon is already in neighbor's table, compare and
                % update accordingly.
                else
                    beacon_neighbor_dist = Node(neighbor_index).dv_vector(find(Node(neighbor_index).dv_vector(:,1)==beacon_index),2);
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    if beacon_neighbor_dist > beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id)
                        Node(neighbor_index).dv_vector(find(Node(neighbor_index).dv_vector(:,1)==beacon_index),2) = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                        % update the dist_std 
                        beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                        Node(neighbor_index).dv_vector(find(Node(neighbor_index).dv_vector(:,1)==beacon_index),3) = beacon_neighbor_dist_std;
                    end  
                end
            end
        end
    end
end


    
    