%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization algorithm
%  Using Kalman Filter
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [loc_error]=kick_loc_kalman
    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global TRANS_RANGE;
    global STD_INITIAL;
    STD_INITIAL = 10000;   % initial std for unknown
    global COV_INITIAL;
    COV_INITIAL = [STD_INITIAL^2 0; 0 STD_INITIAL^2];   % initial cov for unknown
    
    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE
        if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
            Node(i).est_pos = Node(i).pos;
            Node(i).well_determined = 1; % set beacon as well-determined.
            Node(i).cov = [0 0;0 0]; 
            Node(i).beacon_list = [i]; % set beacon_list for each beacon as itself.
        else                            % unknown
            Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
            Node(i).well_determined = 0; % set unknowns as not well-determined.
            Node(i).cov = COV_INITIAL;
            Node(i).beacon_list = []; % set beacon_list for each unknown as empty.
        end
    end
    
    % sort the time schedule of all the nodes
    tmp_sched = [];
    for i=1:NUM_NODE
        tmp_sched = [tmp_sched;[Node(i).sched Node(i).id]];
    end
    tmp_sched = sortrows(tmp_sched);
    sched_array = tmp_sched(:,2)';
    
   % global variable to store per iteration state
    global KK_iteration_error_array;
    KK_iteration_error_array = [];
    global KK_iteration_coverage;
    KK_iteration_coverage = [];
    % initial error
    loc_error_0_beacon = [];
    loc_error_1_beacon = [];
    loc_error_2_beacon = [];
    loc_error_3_more_beacon = [];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
        %if Node(i).well_determined==1
        if length(Node(i).beacon_list) == 0
            loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
        end
        if length(Node(i).beacon_list) == 1
            loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
            loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
        end
        if length(Node(i).beacon_list) == 2
            loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
            loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
            loc_error_2_beacon = [loc_error_2_beacon node_loc_error];
        end
        if length(Node(i).beacon_list) > 2
            loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
            loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
            loc_error_2_beacon = [loc_error_2_beacon node_loc_error];
            loc_error_3_more_beacon = [loc_error_3_more_beacon node_loc_error];
        end
    end
    if isempty(loc_error_0_beacon)
        average_loc_error_0_beacon = 0;
    else
        average_loc_error_0_beacon = mean(loc_error_0_beacon);
    end
    if isempty(loc_error_1_beacon)
        average_loc_error_1_beacon = 0;
    else
        average_loc_error_1_beacon = mean(loc_error_1_beacon);
    end
    if isempty(loc_error_2_beacon)
        average_loc_error_2_beacon = 0;
    else
        average_loc_error_2_beacon = mean(loc_error_2_beacon);
    end
    if isempty(loc_error_3_more_beacon)
        average_loc_error_3_more_beacon = 0;
    else
        average_loc_error_3_more_beacon = mean(loc_error_3_more_beacon);
    end
    average_loc_error = [average_loc_error_0_beacon;average_loc_error_1_beacon;average_loc_error_2_beacon;average_loc_error_3_more_beacon];
    coverage_0_beacon = length(loc_error_0_beacon)/(NUM_NODE*(1-BEACON_RATIO));
    coverage_1_beacon = length(loc_error_1_beacon)/(NUM_NODE*(1-BEACON_RATIO));
    coverage_2_beacon = length(loc_error_2_beacon)/(NUM_NODE*(1-BEACON_RATIO));
    coverage_3_more_beacon = length(loc_error_3_more_beacon)/(NUM_NODE*(1-BEACON_RATIO));
    KK_iteration_coverage = [KK_iteration_coverage [coverage_0_beacon;coverage_1_beacon;coverage_2_beacon;coverage_3_more_beacon]];
    KK_iteration_error_array = [KK_iteration_error_array average_loc_error];
    
    %the system runs 
    for time = 1:STAGE_NUMBER
        for index = sched_array
            broadcast(Node(index));
        end
        % initial error
        loc_error_0_beacon = [];
        loc_error_1_beacon = [];
        loc_error_2_beacon = [];
        loc_error_3_more_beacon = [];
        for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
            %if Node(i).well_determined==1
            node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
            %if Node(i).well_determined==1
            if length(Node(i).beacon_list) == 0
                loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
            end
            if length(Node(i).beacon_list) == 1
                loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
                loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
            end
            if length(Node(i).beacon_list) == 2
                loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
                loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
                loc_error_2_beacon = [loc_error_2_beacon node_loc_error];
            end
            if length(Node(i).beacon_list) > 2
                loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
                loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
                loc_error_2_beacon = [loc_error_2_beacon node_loc_error];
                loc_error_3_more_beacon = [loc_error_3_more_beacon node_loc_error];
            end
        end
        if isempty(loc_error_0_beacon)
            average_loc_error_0_beacon = 0;
        else
            average_loc_error_0_beacon = mean(loc_error_0_beacon);
        end
        if isempty(loc_error_1_beacon)
            average_loc_error_1_beacon = 0;
        else
            average_loc_error_1_beacon = mean(loc_error_1_beacon);
        end
        if isempty(loc_error_2_beacon)
            average_loc_error_2_beacon = 0;
        else
            average_loc_error_2_beacon = mean(loc_error_2_beacon);
        end
        if isempty(loc_error_3_more_beacon)
            average_loc_error_3_more_beacon = 0;
        else
            average_loc_error_3_more_beacon = mean(loc_error_3_more_beacon);
        end
        average_loc_error = [average_loc_error_0_beacon;average_loc_error_1_beacon;average_loc_error_2_beacon;average_loc_error_3_more_beacon];
        coverage_0_beacon = length(loc_error_0_beacon)/(NUM_NODE*(1-BEACON_RATIO));
        coverage_1_beacon = length(loc_error_1_beacon)/(NUM_NODE*(1-BEACON_RATIO));
        coverage_2_beacon = length(loc_error_2_beacon)/(NUM_NODE*(1-BEACON_RATIO));
        coverage_3_more_beacon = length(loc_error_3_more_beacon)/(NUM_NODE*(1-BEACON_RATIO));
        KK_iteration_coverage = [KK_iteration_coverage [coverage_0_beacon;coverage_1_beacon;coverage_2_beacon;coverage_3_more_beacon]];
        KK_iteration_error_array = [KK_iteration_error_array average_loc_error];
    end
    
    % collect localization stats
    % initialize error
    loc_error_0_beacon = [];
    loc_error_1_beacon = [];
    loc_error_2_beacon = [];
    loc_error_3_more_beacon = [];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
        %if Node(i).well_determined==1
        if length(Node(i).beacon_list) == 0
            loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
        end
        if length(Node(i).beacon_list) == 1
            loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
            loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
        end
        if length(Node(i).beacon_list) == 2
            loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
            loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
            loc_error_2_beacon = [loc_error_2_beacon node_loc_error];
        end
        if length(Node(i).beacon_list) > 2
            loc_error_0_beacon = [loc_error_0_beacon node_loc_error];
            loc_error_1_beacon = [loc_error_1_beacon node_loc_error];
            loc_error_2_beacon = [loc_error_2_beacon node_loc_error];
            loc_error_3_more_beacon = [loc_error_3_more_beacon node_loc_error];
        end
    end
    loc_error.loc_error_0_beacon = loc_error_0_beacon;
    loc_error.loc_error_1_beacon = loc_error_1_beacon;
    loc_error.loc_error_2_beacon = loc_error_2_beacon;
    loc_error.loc_error_3_more_beacon = loc_error_3_more_beacon;
    
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using est
% position
function est_dist=est_DIST(A,B)
    est_dist=sqrt((A.est_pos(1)-B.est_pos(1))^2+(A.est_pos(2)-B.est_pos(2))^2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current loc
% and its neighbors will update accordingly.
function broadcast(A)
    global Node;
    global WGN_DIST;
    neighbor_array = A.neighbor;
    for neighbor_index = neighbor_array
        %if the neighbor is an unknown, update; if a beacon, do nothing.
        if strcmp(Node(neighbor_index).attri,'unknown');
            wgn_dist = WGN_DIST(A.id,Node(neighbor_index).id);
            %wgn_dist = WGN_DIST(A,Node(neighbor_index);
            %wgn_dist = DIST(A,Node(neighbor_index)); 
            Node(neighbor_index) = kalman_update_loc(Node(neighbor_index),A,wgn_dist);
        end
    end
    %addition to the main body of the algorithm, we also track beacon_list.
    % if A has beacon_list to broadcast
    if ~isempty(A.beacon_list)
        for neighbor_index = A.neighbor
            for beacon_index = A.beacon_list
                % if beacon not in neighbor's table, add directly
                if ~ismember(beacon_index,Node(neighbor_index).beacon_list)
                    Node(neighbor_index).beacon_list = [Node(neighbor_index).beacon_list beacon_index];
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A gets a broadcast from its neighbor B containing
% B's loc and their measurement distance, A will update its own loc and cov.
function A = kalman_update_loc(A,B,d)
    % if A has no est yet, it will use B as its current est. 
    global COV_INITIAL;
    global DIS_STD_RATIO;
    if isequal(A.cov,COV_INITIAL)
        if (~isequal(B.cov,COV_INITIAL)) % if B also has no est, do nothing
            A.est_pos = B.est_pos;
    % set cov_d=(DIS_STD_RATIO * d)^2, hence in accordance with std_d = DIS_STD_RATIO * d
            A.cov = B.cov + [d^2 0;0 d^2] + [(DIS_STD_RATIO * d)^2 0;0 (DIS_STD_RATIO * d)^2];
        end

    % if A has an est already, it will add a kick factor to its current est.
    else
        if isequal(B.cov,COV_INITIAL) || isequal(A.est_pos,B.est_pos) 
            % if B also has no est, do nothing; if A and B have same est, do
            % nothing.
        else
            kick = kalman_cal_kick(A,B,d);
            A.est_pos = A.est_pos + kick.pos;
            A.cov = kick.cov;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function kick = kalman_cal_kick(A,B,d)
    % calculate delta_d
    delta_d = d - est_DIST(A,B);
    % calculate H_i and H_j
    [H_i,H_j] = jacobian(A,B);
    % set cov_d=(DIS_STD_RATIO * d)^2, hence in accordance with std_d = DIS_STD_RATIO * d
    global DIS_STD_RATIO;
    cov_d = (DIS_STD_RATIO * d)^2;
    % calculate K, commented the original one and use the simplified one
    %K = A.cov*transpose(H_i)/(H_i*A.cov*transpose(H_i) + H_j*B.cov*transpose(H_j) + cov_d)
    K = A.cov*transpose(H_i)/(H_i*(A.cov + B.cov)*transpose(H_i) + cov_d);
    % calculate kick.pos, which will add to the current pos.
    kick.pos = K * delta_d;
    % calculate the post covariance of node A
    kick.cov = (eye(2,2) - K*H_i) * A.cov;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    