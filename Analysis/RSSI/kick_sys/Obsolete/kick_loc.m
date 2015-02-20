%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Kick Localization System
% 
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function kick_loc
global Node;

%initial node stats for analysis
node4_stat = [];
node5_stat = [];
node6_stat = [];

% sort the time schedule of all the nodes
tmp_sched = [];
for i=1:6
    tmp_sched = [tmp_sched;[Node(i).sched Node(i).id]];
end
tmp_sched = sortrows(tmp_sched);
sched_array = tmp_sched(:,2)'

%the system runs 
global STAGE_NUMBER;
for time = 0:STAGE_NUMBER
    node4_stat = [node4_stat;[Node(4).est_x Node(4).est_y] Node(4).std];
    node5_stat = [node5_stat;[Node(5).est_x Node(5).est_y] Node(5).std];
    node6_stat = [node6_stat;[Node(6).est_x Node(6).est_y] Node(6).std];
    for index = sched_array
        broadcast(Node(index));
    end
    %{
    fprintf('Node 4 (x,y) = (%f,%f), std = %f\n',Node(4).est_x,Node(4).est_y,Node(4).std);
    fprintf('Node 5 (x,y) = (%f,%f), std = %f\n',Node(5).est_x,Node(5).est_y,Node(5).std);
    fprintf('Node 6 (x,y) = (%f,%f), std = %f\n',Node(6).est_x,Node(6).est_y,Node(6).std);
    %}
end

node_analysis(node4_stat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using real
% position
function dist=DIST(A,B)
dist=sqrt((A.x-B.x)^2+(A.y-B.y)^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using est
% position
function est_dist=est_DIST(A,B)
est_dist=sqrt((A.est_x-B.est_x)^2+(A.est_y-B.est_y)^2);
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
        Node(neighbor_index) = update_loc(Node(neighbor_index),A,d);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A gets a broadcast from its neighbor B containing
% B's loc and their distance, A will update its own loc and std.
function A = update_loc(A,B,d)
% if A has no est yet, it will use B as its current est. 
global STD_INITIAL;
if A.std == STD_INITIAL
    if B.std ~= STD_INITIAL % if B also has no est, do nothing
        A.est_x = B.est_x;
        A.est_y = B.est_y;
        A.std = sqrt((B.std)^2 + d^2);
    end
% if A has an est already, it will add a kick factor to its current est.
else
    if (B.std == STD_INITIAL) || (A.est_x == B.est_x && A.est_y == B.est_y) 
        % if B also has no est, do nothing; if A and B have same est, do
        % nothing.
    else
        kick = cal_kick(A,B,d);
        A.est_x = A.est_x + kick.x;
        A.est_y = A.est_y + kick.y;
        A.std = kick.std;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, calculate kick factor of node A from B's broadcast.
function kick = cal_kick(A,B,d)
delta_d.x = (est_DIST(A,B) - d)*(B.est_x - A.est_x)/est_DIST(A,B);
delta_d.y = (est_DIST(A,B) - d)*(B.est_y - A.est_y)/est_DIST(A,B);
% we set std_d=0.2d for now
std_d = 0.2*d;
% calculate the std of the update
std_update = sqrt(std_d^2 + B.std^2);
% calculate the alpha factor
alpha = A.std/(A.std + std_update);
% calculate the new std of node A
kick.std = alpha*std_update + (1 - alpha)*A.std;
% calculate the kick factor of node A
kick.x = alpha * delta_d.x;
kick.y = alpha * delta_d.y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
