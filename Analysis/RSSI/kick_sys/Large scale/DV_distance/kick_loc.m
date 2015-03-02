%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization algorithm
% 
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function kick_loc

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
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        %if Node(i).well_determined==1
            loc_error =[loc_error sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
        %end
    end

    average_loc_error = mean(loc_error)/TRANS_RANGE
    max_loc_error = max(loc_error)/TRANS_RANGE
    coverage = length(loc_error)/(NUM_NODE*(1-BEACON_RATIO))
    
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
    if A.std == STD_INITIAL
        if B.std ~= STD_INITIAL % if B also has no est, do nothing
            A.est_pos = B.est_pos;
            % set std_d = DIS_STD_RATIO*d
            A.std = sqrt((B.std)^2 + d^2 + (DIS_STD_RATIO*d)^2);
        end
    % if A has an est already, it will add a kick factor to its current est.
    else
        if (B.std == STD_INITIAL) || isequal(A.est_pos,B.est_pos) 
            % if B also has no est, do nothing; if A and B have same est, do
            % nothing.
        else
            kick = intuitive_cal_kick(A,B,d);
            A.est_pos = A.est_pos + kick.pos;
            A.std = kick.std;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function kick = intuitive_cal_kick(A,B,d)
    delta_d = (est_DIST(A,B) - d)*(B.est_pos - A.est_pos)/est_DIST(A,B);
    % set std_d = DIS_STD_RATIO*d
    global DIS_STD_RATIO;
    std_d = DIS_STD_RATIO*d;
    % calculate the std of the update
    std_update = sqrt(std_d^2 + B.std^2);
    % calculate the alpha factor
    alpha = A.std/(A.std + std_update);
    % calculate the new std of node A
    kick.std = alpha*std_update + (1 - alpha)*A.std;
    % calculate the kick factor of node A
    kick.pos = alpha * delta_d;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
