%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization algorithm
%  Using Kalman Filter
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [loc_error,tol_flop,break_stage,tol_msg_sent,tol_bytes_sent]=kick_loc_kalman
    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global STAGE_FLAG;
    global TRANS_RANGE;
    global sched_array;
    global FLOP_COUNT_FLAG;
    flops(0); %%start global flop count at 0
    global STD_INITIAL;
    STD_INITIAL = 10000;   % initial std for unknown
    global COV_INITIAL;
    COV_INITIAL = [STD_INITIAL^2 0; 0 STD_INITIAL^2];   % initial cov for unknown
    
    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE
        Node(i).msg_count = 0;
        Node(i).bytes_count = 0;
        if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
            Node(i).est_pos = Node(i).pos;
            Node(i).well_determined = 1; % set beacon as well-determined.
            Node(i).cov = [0 0;0 0]; 
        else                            % unknown
            Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
            Node(i).well_determined = 0; % set unknowns as not well-determined.
            Node(i).cov = COV_INITIAL;
        end
    end
    
    % initial loc_error %
    loc_error_prev = [];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
        if size(Node(i).dv_vector,1) > 2
            loc_error_prev = [loc_error_prev node_loc_error];
        end
    end
    avg_loc_error_prev = mean(loc_error_prev);
    
    %the system runs 
    for time = 1:STAGE_NUMBER
        for index = sched_array
            broadcast(Node(index));
        end
     
        % current loc_error %
        loc_error_cur = [];
        for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
            node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
            if size(Node(i).dv_vector,1) > 2
                loc_error_cur = [loc_error_cur node_loc_error];
            end
        end
        avg_loc_error_cur = mean(loc_error_cur);
        if abs(avg_loc_error_cur - avg_loc_error_prev) <= 0.05
            if STAGE_FLAG == 0
                %fprintf('kick_loc stage: %d\n',time);
                break;
            end
        end
        avg_loc_error_prev = avg_loc_error_cur;
    end
    
    % collect localization stats
    % initialize error
    loc_error_3_more_beacon = [];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
        if size(Node(i).dv_vector,1) > 2
            loc_error_3_more_beacon = [loc_error_3_more_beacon node_loc_error];
        end
    end
    loc_error = loc_error_3_more_beacon;  
    
    if FLOP_COUNT_FLAG == 1
        tol_flop = flops;
    else
        tol_flop = 0;
    end
    
    break_stage = time;
    
    %calculate the cumulative msg sent and bytes sent
    tol_msg_sent = 0;
    tol_bytes_sent = 0;
    for i=1:NUM_NODE
        tol_msg_sent = tol_msg_sent + Node(i).msg_count;
        tol_bytes_sent = tol_bytes_sent + Node(i).bytes_count;
    end
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using est
% position
function est_dist=est_DIST(A,B)
    global FLOP_COUNT_FLAG;
    est_dist=sqrt((A.est_pos(1)-B.est_pos(1))^2+(A.est_pos(2)-B.est_pos(2))^2);
    if FLOP_COUNT_FLAG == 1
        addflops(flops_sqrt + 2*flops_pow(2) + 3*1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current loc
% and its neighbors will update accordingly.
function broadcast(A)
    global Node;
    global WGN_DIST;
    neighbor_array = A.neighbor;
    % a broadcast msg is sent 
    Node(A.id).msg_count = Node(A.id).msg_count + 1;
    Node(A.id).bytes_count = Node(A.id).bytes_count + 6; % x,y,covariance
    for neighbor_index = neighbor_array
        %if the neighbor is an unknown, update; if a beacon, do nothing.
        if strcmp(Node(neighbor_index).attri,'unknown');
            wgn_dist = WGN_DIST(A.id,Node(neighbor_index).id);
            %wgn_dist = WGN_DIST(A,Node(neighbor_index);
            %wgn_dist = DIST(A,Node(neighbor_index)); 
            Node(neighbor_index) = kalman_update_loc(Node(neighbor_index),A,wgn_dist);
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
    global FLOP_COUNT_FLAG;
    if FLOP_COUNT_FLAG == 1
        addflops(4*2);
    end
    if isequal(A.cov,COV_INITIAL)
        if FLOP_COUNT_FLAG == 1
            addflops(4*2);
        end
        if (~isequal(B.cov,COV_INITIAL)) % if B also has no est, do nothing
            A.est_pos = B.est_pos;
    % set cov_d=(DIS_STD_RATIO * d)^2, hence in accordance with std_d = DIS_STD_RATIO * d
            A.cov = B.cov + [d^2 0;0 d^2] + [(DIS_STD_RATIO * d)^2 0;0 (DIS_STD_RATIO * d)^2];
            if FLOP_COUNT_FLAG == 1
                addflops(2*flops_pow + 4*2);
            end
        end

    % if A has an est already, it will add a kick factor to its current est.
    else
        if FLOP_COUNT_FLAG == 1
                addflops(4*2 + 4*2 + 4*2);
         end
        if isequal(B.cov,COV_INITIAL) || isequal(A.est_pos,B.est_pos) 
            % if B also has no est, do nothing; if A and B have same est, do
            % nothing.
        else
            kick = kalman_cal_kick(A,B,d);
            A.est_pos = A.est_pos + kick.pos;
            if FLOP_COUNT_FLAG == 1
                addflops(4);
            end
            A.cov = kick.cov;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function kick = kalman_cal_kick(A,B,d)
    global FLOP_COUNT_FLAG;
    % calculate delta_d
    delta_d = d - est_DIST(A,B);
    if FLOP_COUNT_FLAG == 1
        addflops(1);
    end
    % calculate H_i and H_j
    [H_i,H_j] = jacobian(A,B);
    % set cov_d=(DIS_STD_RATIO * d)^2, hence in accordance with std_d = DIS_STD_RATIO * d
    global DIS_STD_RATIO;
    cov_d = (DIS_STD_RATIO * d)^2;
    % calculate K, commented the original one and use the simplified one
    %K = A.cov*transpose(H_i)/(H_i*A.cov*transpose(H_i) + H_j*B.cov*transpose(H_j) + cov_d)
    K = A.cov*transpose(H_i)/(H_i*(A.cov + B.cov)*transpose(H_i) + cov_d);
    if FLOP_COUNT_FLAG == 1
        addflops(flops_mul(A.cov,transpose(H_i)) + 4 + flops_mul(H_i,A.cov) + flops_mul(1,2,1) + 1 + flops_div);
    end
    % calculate kick.pos, which will add to the current pos.
    kick.pos = K * delta_d;
    if FLOP_COUNT_FLAG == 1
        addflops(2);
    end
    % calculate the post covariance of node A
    kick.cov = (eye(2,2) - K*H_i) * A.cov;
    if FLOP_COUNT_FLAG == 1
        addflops(4 + flops_mul(2,2,2));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    