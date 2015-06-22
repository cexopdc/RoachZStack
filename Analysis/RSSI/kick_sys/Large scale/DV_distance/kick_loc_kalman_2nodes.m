%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization algorithm
%  Using Kalman Filter, 2 nodes
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [loc_error]=kick_loc_kalman_2nodes
    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global TRANS_RANGE;
    global sched_array;
    global STD_INITIAL;
    STD_INITIAL = 10000;   % initial std for unknown
    global COV_INITIAL;
    COV_INITIAL = [STD_INITIAL^2 0; 0 STD_INITIAL^2];   % initial cov for unknown
    
    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE   
        % for algorithm two_node_kalman
        Node(i).helper_node.est_pos = 0;
        Node(i).helper_node.cov = 0;
        Node(i).helper_node.d = 0;
        
        if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
            Node(i).est_pos = Node(i).pos;
            Node(i).well_determined=1; % set beacon as well-determined.
            Node(i).cov=[0 0;0 0]; 
        else                            % unknown
            Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
            Node(i).well_determined=0; % set unknowns as not well-determined.
            Node(i).cov=COV_INITIAL;
        end
    end
    
    %the system runs 
    for time = 1:STAGE_NUMBER
        for index = sched_array
            broadcast(Node(index));
        end
    end
    
    % collect localization stats
    % initialize error
    loc_error_3_more_beacon = [];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
        if size(Node(i).dv_vector,2) > 2
            loc_error_3_more_beacon = [loc_error_3_more_beacon node_loc_error];
        end
    end
    loc_error = loc_error_3_more_beacon;  

    
end

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
            % generate the measurement distance with WGN
            wgn_dist = WGN_DIST(A.id,Node(neighbor_index).id);
            %wgn_dist = WGN_DIST(A,Node(neighbor_index);
            %wgn_dist = DIST(A,Node(neighbor_index)); 
            Node(neighbor_index) = two_node_kalman_update_loc(Node(neighbor_index),A,wgn_dist);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A gets a broadcast from its neighbor B containing
% B's loc and their measurement distance, A will update its own loc and cov.
function A = two_node_kalman_update_loc(A,B,d)
    % if A has no est yet, it will use B as its current est. 
    global COV_INITIAL;
    global DIS_STD_RATIO;
    if isequal(A.cov,COV_INITIAL)
        if (~isequal(B.cov,COV_INITIAL)) % if B also has no est, do nothing
            A.est_pos = B.est_pos;
    % set cov_d=(DIS_STD_RATIO * d)^2, hence in accordance with std_d = DIS_STD_RATIO * d
            A.cov = B.cov + [d^2 0;0 d^2] + [(DIS_STD_RATIO * d)^2 0;0 (DIS_STD_RATIO * d)^2];
            % store the current helper_node info
            A.helper_node.est_pos = B.est_pos;
            A.helper_node.cov = B.cov;
            A.helper_node.d = d;
        end

    % if A has an est already, it will add a kick factor to its current est.
    else
        if isequal(B.cov,COV_INITIAL) || isequal(A.est_pos,B.est_pos) 
            % if B also has no est, do nothing; if A and B have same est, do
            % nothing.
        else
            kick = two_node_kalman_cal_kick(A,B,d);
            A.est_pos = A.est_pos + kick.pos;
            A.cov = kick.cov;

            % update the current helper_node info
            A.helper_node.est_pos = B.est_pos;
            A.helper_node.cov = B.cov;
            A.helper_node.d = d;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function kick = two_node_kalman_cal_kick(A,B,d)
    % calculate delta_d
    delta_d = (A.helper_node.d)^2 - d^2  - (est_DIST(A.helper_node,A))^2 + (est_DIST(A,B))^2;
    % calculate H_i and H_j 
    [H_i,H_j,H_k] = two_node_jacobian(A,A.helper_node,B);
    % set cov_d=(DIS_STD_RATIO * d)^2, hence in accordance with std_d = DIS_STD_RATIO * d
    global DIS_STD_RATIO;
    %cov_d = (DIS_STD_RATIO * d)^2;
    % cov of measurement (d_ij)^2-(d_ik)^2
    cov_measurement = (2*(DIS_STD_RATIO * d)^4+4*(d * DIS_STD_RATIO * d)^2) + ...
        (2*(DIS_STD_RATIO * A.helper_node.d)^4+4*(A.helper_node.d*DIS_STD_RATIO * A.helper_node.d)^2);
    % calculate K, commented the original one and use the simplified one
    %K = A.cov*transpose(H_i)/(H_i*A.cov*transpose(H_i) + H_j*B.cov*transpose(H_j) + cov_d)
    K = A.cov*transpose(H_i)/(H_i*A.cov*transpose(H_i) + H_j*A.helper_node.cov*transpose(H_j) + H_k*B.cov*transpose(H_k) + cov_measurement);
    % calculate kick.pos, which will add to the current pos.
    kick.pos = K * delta_d;
    % calculate the post covariance of node A
    kick.cov = (eye(2,2) - K*H_i) * A.cov;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using est
% position
function est_dist=est_DIST(A,B)
    est_dist=sqrt((A.est_pos(1)-B.est_pos(1))^2+(A.est_pos(2)-B.est_pos(2))^2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    