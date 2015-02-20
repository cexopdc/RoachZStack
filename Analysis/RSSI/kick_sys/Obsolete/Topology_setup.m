close all; clear all; clc;
% Localization initialization
Length=100; % area space, unit: meter
Width=100;  % area space, unit: meter
num_node=6; % number of total nodes
beacon_ratio=0.5; 
TRANS_RANGE=20;       % transmission range 20 meters
global STAGE_NUMBER;
STAGE_NUMBER=10;      % number of stages
global STD_INITIAL;
STD_INITIAL = 10000;   % initial std for unknown
global Node;
% set nodes coordinates
Node(1).x=20; 
Node(1).y=36.8;
Node(1).id=1;
Node(2).x=7.2; 
Node(2).y=9.2;
Node(2).id=2;
Node(3).x=36; 
Node(3).y=8.8;
Node(3).id=3;
Node(4).x=23.2; 
Node(4).y=26.4;
Node(4).id=4;
Node(5).x=14.4; 
Node(5).y=16.8;
Node(5).id=5;
Node(6).x=30; 
Node(6).y=14.8;
Node(6).id=6;
% set nodes est coordinates and std
Node(1).est_x=20; 
Node(1).est_y=36.8;
Node(1).std=0;

Node(2).est_x=7.2; 
Node(2).est_y=9.2;
Node(2).std=0;

Node(3).est_x=36; 
Node(3).est_y=8.8;
Node(3).std=0;

Node(4).est_x=0; 
Node(4).est_y=0;
Node(4).std=STD_INITIAL;

Node(5).est_x=0; 
Node(5).est_y=0;
Node(5).std=STD_INITIAL;

Node(6).est_x=0; 
Node(6).est_y=0;
Node(6).std=STD_INITIAL;

%set node attribute: unknown or beacon, neighbor array
Node(1).attri = 'beacon';
Node(2).attri = 'beacon';
Node(3).attri = 'beacon';
Node(4).attri = 'unknown';
Node(5).attri = 'unknown';
Node(6).attri = 'unknown';

% time scheduling of the system, set to random
Node(1).sched=rand;
Node(2).sched=rand;
Node(3).sched=rand;
Node(4).sched=rand;
Node(5).sched=rand;
Node(6).sched=rand;

%calculate neighbor array
for i=1:num_node
    Node(i).neighbor = []; %initialize the neighbor array
    tmp_array = [1:num_node];
    tmp_array(tmp_array==i)=[]; % delete node i itself
    for j=tmp_array
        if DIST(Node(i),Node(j))<=TRANS_RANGE
            Node(i).neighbor = [Node(i).neighbor j];
        end
    end
end

kick_loc;

