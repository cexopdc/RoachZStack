%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization algorithm
%  Using Kalman Filter, change of variables
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [average_loc_error,confidence_interval]=kick_loc_kalman_change_var
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
        Node(i).sched=rand;    % time scheduling of the system, set to random

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
            broadcast(Node(index));
        end
    end
    
    % collect localization stats
    loc_error=[];
    CI1_counter = 0; % confidence interval counter for 1 std
    CI2_counter = 0; % confidence interval counter for 2 std
    CI3_counter = 0; % confidence interval counter for 3 std
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        %if Node(i).well_determined==1
            
            %Node(i).std = sqrt(sum(sum(Node(i).cov))/2);
            Node(i).std = sqrt(Node(i).cov(1,1)+Node(i).cov(2,2));
            node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2);
            loc_error =[loc_error node_loc_error];
            % check if the std actually bounds the error.
            if node_loc_error <= Node(i).std
                CI1_counter = CI1_counter + 1;            
            end
            if node_loc_error <= 2*Node(i).std
                CI2_counter = CI2_counter + 1;            
            end
            if node_loc_error <= 3*Node(i).std
                CI3_counter = CI3_counter + 1;            
            end
        %end

    end
    CI_counter = [CI1_counter CI2_counter CI3_counter];
    confidence_interval = CI_counter/(NUM_NODE*(1-BEACON_RATIO));
    average_loc_error = mean(loc_error)/TRANS_RANGE;
    max_loc_error = max(loc_error)/TRANS_RANGE;
    coverage = length(loc_error)/(NUM_NODE*(1-BEACON_RATIO));
    
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
            Node(neighbor_index) = kalman_update_loc_change_var(Node(neighbor_index),A,wgn_dist);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A gets a broadcast from its neighbor B containing
% B's loc and their measurement distance, A will update its own loc and cov.
function A = kalman_update_loc_change_var(A,B,d)
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
            A = kalman_cal_kick_change_var(A,B,d);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function A = kalman_cal_kick_change_var(A,B,d)
    % calculate delta_z
    delta_z = d^2 - est_DIST(A,B)^2;
    % calculate the variance of beta_i: P
    var_beta1 = 2*(A.cov(1,1)+B.cov(1,1))^2 + 4*(A.est_pos(1)-B.est_pos(1))^2*(A.cov(1,1)+B.cov(1,1));
    var_beta2 = 2*(A.cov(2,2)+B.cov(2,2))^2 + 4*(A.est_pos(2)-B.est_pos(2))^2*(A.cov(2,2)+B.cov(2,2));
    P = [var_beta1 0; 0 var_beta2];
    % set H
    H = [1 1];
    % calculate the new measurement noise variance R
    global DIS_STD_RATIO;
    R = 2*(DIS_STD_RATIO * d)^4 + 4*d^2*(DIS_STD_RATIO * d)^2;
    % calculate K
    K = P*transpose(H)/(H*P*transpose(H) + R);
    % calculate the original beta
    beta = [(A.est_pos(1)-B.est_pos(1))^2;(A.est_pos(2)-B.est_pos(2))^2];
    % update beta
    beta = beta + K * delta_z;
    % update the variance of beta_i: P
    P = (eye(2,2) - K*H) * P;
    % use updated beta to update A's est_pos
    A.est_pos(1) = sqrt(beta(1,1)) + B.est_pos(1);
    A.est_pos(2) = sqrt(beta(2,1)) + B.est_pos(2);
    % use updated P to update A's cov
    var_x = P(1,1)/(4*beta(1,1)) + B.cov(1,1);
    var_y = P(2,2)/(4*beta(2,1)) + B.cov(2,2);
    A.cov = [var_x 0;0 var_y];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    