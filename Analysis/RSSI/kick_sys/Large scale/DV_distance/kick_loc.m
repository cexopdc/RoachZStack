%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization algorithm
% 
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [loc_error,tol_flop,break_stage,tol_msg_sent,tol_bytes_sent]=kick_loc

    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global STAGE_FLAG;
    global TRANS_RANGE;
    global sched_array;
    global STD_INITIAL;
    STD_INITIAL = 10000;   % initial std for unknown
    global FLOP_COUNT_FLAG;
    flops(0); %%start global flop count at 0

    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE
        Node(i).msg_count = 0;
        Node(i).bytes_count = 0;
        if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
            Node(i).est_pos = Node(i).pos;
            Node(i).well_determined=1; % set beacon as well-determined.
            Node(i).std=0;
        else                            % unknown
            Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
            Node(i).well_determined=0; % set unknowns as not well-determined.
            Node(i).std=STD_INITIAL;
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
% sub-function, to generate the distance measurement between 
% two nodes by adding WGN to real position
%function wgn_dist = WGN_DIST(A,B,seed)
%global DIS_STD_RATIO;
% we want to set the distance measurement error to be fixed at the
% beginning
%rng(seed);
%wgn_dist=DIST(A,B)+ DIS_STD_RATIO*DIST(A,B)*randn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    Node(A.id).bytes_count = Node(A.id).bytes_count + 3; % x,y,std
    for neighbor_index = neighbor_array
        %if the neighbor is an unknown, update; if a beacon, do nothing.
        if strcmp(Node(neighbor_index).attri,'unknown');
            wgn_dist = WGN_DIST(A.id,Node(neighbor_index).id);
            %wgn_dist = WGN_DIST(A,Node(neighbor_index);
            %wgn_dist = DIST(A,Node(neighbor_index)); 
           Node(neighbor_index) = intuitive_update_loc(Node(neighbor_index),A,wgn_dist);        
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A gets a broadcast from its neighbor B containing
% B's loc and their distance, A will update its own loc and std.
function A = intuitive_update_loc(A,B,d)
    % if A has no est yet, it will use B as its current est. 
    global STD_INITIAL;
    global DIS_STD_RATIO;
    global FLOP_COUNT_FLAG;
    if FLOP_COUNT_FLAG == 1
        addflops(2);
    end
    if A.std == STD_INITIAL
        if FLOP_COUNT_FLAG == 1
            addflops(2);
        end
        if B.std ~= STD_INITIAL % if B also has no est, do nothing
            A.est_pos = B.est_pos;
            % set std_d = DIS_STD_RATIO*d
            A.std = sqrt((B.std)^2 + d^2 + (DIS_STD_RATIO*d)^2);
            if FLOP_COUNT_FLAG == 1
                addflops(flops_sqrt + 3*flops_pow + 2);
            end
        end
    % if A has an est already, it will add a kick factor to its current est.
    else
        if FLOP_COUNT_FLAG == 1
                addflops(2 + 2 + 2);
         end
        if (B.std == STD_INITIAL) || isequal(A.est_pos,B.est_pos) 
            % if B also has no est, do nothing; if A and B have same est, do
            % nothing. FOR STATIC SYSTEM, and we're assuming the RSSI
            % measurement is fixed at the beginning.
        else
            kick = intuitive_cal_kick(A,B,d);
            A.est_pos = A.est_pos + kick.pos;
            if FLOP_COUNT_FLAG == 1
                addflops(1);
            end
            A.std = kick.std;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function kick = intuitive_cal_kick(A,B,d)
    global FLOP_COUNT_FLAG;
    delta_d = (est_DIST(A,B) - d)*(B.est_pos - A.est_pos)/est_DIST(A,B);
    if FLOP_COUNT_FLAG == 1
        addflops(3*1 + flops_div);
    end
    % set std_d = DIS_STD_RATIO*d
    global DIS_STD_RATIO;
    std_d = DIS_STD_RATIO*d;
    % calculate the std of the update
    std_update = sqrt(std_d^2 + B.std^2);
    if FLOP_COUNT_FLAG == 1
        addflops(flops_sqrt + flops_pow(2)*2 + 1);
    end
    % calculate the alpha factor
    alpha = A.std/(A.std + std_update);
    if FLOP_COUNT_FLAG == 1
        addflops(1 + flops_div);
    end
    % calculate the new std of node A
    kick.std = alpha*std_update + (1 - alpha)*A.std;
    if FLOP_COUNT_FLAG == 1
        addflops(4*1);
    end
    % calculate the kick factor of node A
    kick.pos = alpha * delta_d;
    if FLOP_COUNT_FLAG == 1
        addflops(1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
