%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization System
% 
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function kick_loc
global Node;
global NUM_NODE;
global STAGE_NUMBER;

%initial node stats for analysis
node4_stat = [];
node5_stat = [];
node6_stat = [];

% sort the time schedule of all the nodes
tmp_sched = [];
for i=1:NUM_NODE
    tmp_sched = [tmp_sched;[Node(i).sched Node(i).id]];
end
tmp_sched = sortrows(tmp_sched);
sched_array = tmp_sched(:,2)';

%the system runs 
for time = 0:STAGE_NUMBER
    %
    Node(4).std = sqrt(sum(sum(Node(4).cov))/2);
    Node(5).std = sqrt(sum(sum(Node(5).cov))/2);
    Node(6).std = sqrt(sum(sum(Node(6).cov))/2);
    %}
    %Node(4).std = [sqrt(Node(4).cov(1,1));sqrt(Node(4).cov(2,2))];
     node4_stat = [node4_stat [Node(4).est_pos;Node(4).std]];
%    node5_stat = [node5_stat [Node(5).est_pos;Node(5).std]];
%    node6_stat = [node6_stat [Node(6).est_pos;Node(6).std]];
    for index = sched_array
        broadcast(Node(index));
    end
    %{
    fprintf('Node 4 (x,y) = (%f,%f), std = %f\n',Node(4).est_x,Node(4).est_y,Node(4).std);
    fprintf('Node 5 (x,y) = (%f,%f), std = %f\n',Node(5).est_x,Node(5).est_y,Node(5).std);
    fprintf('Node 6 (x,y) = (%f,%f), std = %f\n',Node(6).est_x,Node(6).est_y,Node(6).std);
    %}
end

node_analysis(node4_stat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using real
% position
function dist=DIST(A,B)
dist=sqrt((A.pos(1)-B.pos(1))^2+(A.pos(2)-B.pos(2))^2);
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
function broadcast(A)
global Node;
neighbor_array = A.neighbor;
for neighbor_index = neighbor_array
    %if the neighbor is an unknown, update; if a beacon, do nothing.
    if strcmp(Node(neighbor_index).attri,'unknown');
        d = DIST(A,Node(neighbor_index));
        % choose kalman update algorithm
        Node(neighbor_index) = kalman_update_loc(Node(neighbor_index),A,d);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A gets a broadcast from its neighbor B containing
% B's loc and their distance, A will update its own loc and cov.
function A = kalman_update_loc(A,B,d)
% if A has no est yet, it will use B as its current est. 
global COV_INITIAL;

if isequal(A.cov,COV_INITIAL)
    if (~isequal(B.cov,COV_INITIAL)) % if B also has no est, do nothing
        A.est_pos = B.est_pos;
% we set cov_d=0.04d^2, hence std_d =0.2 for now
        A.cov = B.cov + [d^2 0;0 d^2] + [0.04*d^2 0;0 0.04*d^2];
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function kick = kalman_cal_kick(A,B,d)
% calculate delta_d
delta_d = d - est_DIST(A,B);
% calculate H_i and H_j
[H_i,H_j] = jacobian(A,B);
% we set cov_d=0.04d^2, hence std_d =0.2 for now
cov_d = 0.04 * d^2;
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
function A = update_loc(A,B,d)
% if A has no est yet, it will use B as its current est. 
global STD_INITIAL;
if A.std == STD_INITIAL
    if B.std ~= STD_INITIAL % if B also has no est, do nothing
        A.est_pos = B.est_pos;
        %A.cov = B.cov + [d^2 0;0 d^2];
        A.std = sqrt((B.std)^2 + d^2);
    end
% if A has an est already, it will add a kick factor to its current est.
else
    if (B.std == STD_INITIAL) || isequal(A.est_pos,B.est_pos) 
        % if B also has no est, do nothing; if A and B have same est, do
        % nothing.
    else
        kick = cal_kick(A,B,d);
        A.est_pos = A.est_pos + kick.pos;
        A.std = kick.std;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function kick = cal_kick(A,B,d)
delta_d = (est_DIST(A,B) - d)*(B.est_pos - A.est_pos)/est_DIST(A,B);
% we set std_d=0.2d for now
std_d = 0.2*d;
% calculate the std of the update
std_update = sqrt(std_d^2 + B.std^2);
% calculate the alpha factor
alpha = A.std/(A.std + std_update);
% calculate the new std of node A
kick.std = alpha*std_update + (1 - alpha)*A.std;
% calculate the kick factor of node A
kick.pos = alpha * delta_d;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
