%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization algorithm
% 
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function node_stat = kick_loc(algorithm)
if nargin < 1
    disp('Please choose an algorithm');
    return;
end

global Node;
global NUM_NODE;
global STAGE_NUMBER;
global BEACON_RATIO;
%initial node stats for analysis
node_stat = [];

% sort the time schedule of all the nodes
tmp_sched = [];
for i=1:NUM_NODE
    tmp_sched = [tmp_sched;[Node(i).sched Node(i).id]];
end
tmp_sched = sortrows(tmp_sched);
sched_array = tmp_sched(:,2)';

%the system runs 
for time = 0:STAGE_NUMBER
    if strcmp(algorithm,'kalman')
        Node(round(NUM_NODE*BEACON_RATIO)+1).std = sqrt(sum(sum(Node(round(NUM_NODE*BEACON_RATIO)+1).cov))/2);
        %Node(4).std = [sqrt(Node(4).cov(1,1));sqrt(Node(4).cov(2,2))];
    end
    node_stat  = [node_stat;[Node(round(NUM_NODE*BEACON_RATIO)+1).est_pos;Node(round(NUM_NODE*BEACON_RATIO)+1).std]'];
    for index = sched_array
        broadcast(Node(index),algorithm);
    end
    %{
    fprintf('Node 4 (x,y) = (%f,%f), std = %f\n',Node(4).est_x,Node(4).est_y,Node(4).std);
    fprintf('Node 5 (x,y) = (%f,%f), std = %f\n',Node(5).est_x,Node(5).est_y,Node(5).std);
    fprintf('Node 6 (x,y) = (%f,%f), std = %f\n',Node(6).est_x,Node(6).est_y,Node(6).std);
    %}
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to generate the distance measurement between 
% two nodes by adding WGN to real position
function wgn_dist = WGN_DIST(A,B,seed)
global DIS_STD_RATIO;
% we want to set the distance measurement error to be fixed at the
% beginning
rng(seed);
wgn_dist=DIST(A,B)+ DIS_STD_RATIO*DIST(A,B)*randn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using est
% position
function est_dist=est_DIST(A,B)
est_dist=sqrt((A.est_pos(1)-B.est_pos(1))^2+(A.est_pos(2)-B.est_pos(2))^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current loc
% and its neighbors will update accordingly.
function broadcast(A,algorithm)
global Node;
neighbor_array = A.neighbor;
for neighbor_index = neighbor_array
    %if the neighbor is an unknown, update; if a beacon, do nothing.
    if strcmp(Node(neighbor_index).attri,'unknown');
        % generate the measurement distance with WGN, which is fixed during
        % multiple stages, by passing the same seed.
        wgn_dist = WGN_DIST(A,Node(neighbor_index),DIST(A,Node(neighbor_index)));
        %wgn_dist = WGN_DIST(A,Node(neighbor_index);
        %wgn_dist = DIST(A,Node(neighbor_index)); 
        % choose kalman or intuitive update algorithm
        if strcmp(algorithm,'kalman')
            Node(neighbor_index) = kalman_update_loc(Node(neighbor_index),A,wgn_dist);
        else
            Node(neighbor_index) = intuitive_update_loc(Node(neighbor_index),A,wgn_dist);
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
else?
    if isequal(B.cov,COV_INITIAL) || isequal(A.est_pos,B.est_pos) 
        % if B also has no est, do nothing; if A and B have same est, do
        % nothing.
    else
        kick = kalman_cal_kick(A,B,d);
        A.est_pos = A.est_pos + kick.pos;
        A.cov = kick.cov;
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
