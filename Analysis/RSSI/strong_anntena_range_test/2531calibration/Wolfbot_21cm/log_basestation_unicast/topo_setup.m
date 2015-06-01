global STD_INITIAL;
STD_INITIAL = 10000;   % initial std for unknown
global NUM_NODE;
NUM_NODE = 10; % number of total nodes   %%%%%%%%%%%%%
global BEACON_RATIO;
BEACON_RATIO = 0.4; %%%%%%%%%%%%%%%%%%%%%

% calibrated rssi_distance mapping from -42 to -87 dBm. The mapping between
% rssi value and matrix row index is: index = -RSSI -41. (diff from C array implementation)

global RSSI_DIS_MEAN_STD;
RSSI_DIS_MEAN_STD = [
    % if std of a dis is 0, treat it as 0.01. 
                        [0.20,0.01]; % -42
                        [0.37,0.20]; % -43
                        [0.38,0.10]; % -44
                        [0.40,0.01]; % -45
                        [0.21,0.05]; % -46
                        [0.79,0.06]; % -47
                        [0.41,0.07]; % -48
                        [0.20,0.01]; % -49
                        [0.35,0.05]; % -50
                        [0.50,0.10]; % -51
                        [0.40,0.01]; % -52
                        [0.40,0.01]; % -53
                        [0.65,0.12]; % -54
                        [0.89,0.25]; % -55
                        [1.29,0.29]; % -56
                        [1.12,0.22]; % -57
                        [1.29,0.48]; % -58
                        [1.37,0.40]; % -59
                        [1.48,0.35]; % -60
                        [1.40,0.79]; % -61
                        [2.21,0.50]; % -62
                        [2.12,0.64]; % -63
                        [2.07,0.65]; % -64
                        [2.07,6.61]; % -65
                        [2.16,0.57]; % -66
                        [2.21,0.46]; % -67
                        [2.12,0.61]; % -68
                        [2.17,0.61]; % -69
                        [2.32,0.44]; % -70
                        [2.51,0.27]; % -71
                        [2.62,0.21]; % -72
                        [2.70,0.17]; % -73
                        [2.65,0.33]; % -74
                        [2.30,0.50]; % -75
                        [2.59,0.19]; % -76
                        [2.63,0.19]; % -77
                        [2.66,0.20]; % -78
                        [2.64,0.23]; % -79
                        [2.61,0.23]; % -80
                        [2.61,0.23]; % -81
                        [2.50,0.18]; % -82
                        [2.44,0.14]; % -83
                        [2.44,0.15]; % -84
                        [2.42,0.10]; % -85
                        [2.60,0.31]; % -86
                        [3.00,0.01]; % -87
                    ];

%  topology 1
Node(1).x = 0.2;
Node(1).y = 0.2;
Node(1).est_x = 0.2;
Node(1).est_y = 0.2;
Node(1).std = 0;
Node(1).attri = 'beacon';

Node(2).x = 2.6;
Node(2).y = 0.2;
Node(2).est_x = 2.6;
Node(2).est_y = 0.2;
Node(2).std = 0;
Node(2).attri = 'beacon';

Node(3).x = 0.4;
Node(3).y = 2.8;
Node(3).est_x = 0.4;
Node(3).est_y = 2.8;
Node(3).std = 0;
Node(3).attri = 'beacon';

Node(4).x = 2.8;
Node(4).y = 2.8;
Node(4).est_x = 2.8;
Node(4).est_y = 2.8;
Node(4).std = 0;
Node(4).attri = 'beacon';

Node(5).x = 1.2;
Node(5).y = 0.8;
Node(5).est_x = 1.5;
Node(5).est_y = 1.5;
Node(5).std = STD_INITIAL;
Node(5).attri = 'unknown';

Node(6).x = 1.8;
Node(6).y = 1.6;
Node(6).est_x = 1.5;
Node(6).est_y = 1.5;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 0.8;
Node(7).y = 2.2;
Node(7).est_x = 1.5;
Node(7).est_y = 1.5;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 2.2;
Node(8).y = 2.4;
Node(8).est_x = 1.5;
Node(8).est_y = 1.5;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

%
%topo1_b toggle
Node(9).x = 0.6;
Node(9).y = 1.4;
Node(9).est_x = 1.5;
Node(9).est_y = 1.5;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 2.4;
Node(10).y = 1.2;
Node(10).est_x = 1.5;
Node(10).est_y = 1.5;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';
%

%{
%  topology 2
Node(1).x = 1.2;
Node(1).y = 1.2;
Node(1).est_x = 1.2;
Node(1).est_y = 1.2;
Node(1).std = 0;
Node(1).attri = 'beacon';

Node(2).x = 2.6;
Node(2).y = 1.2;
Node(2).est_x = 2.6;
Node(2).est_y = 1.2;
Node(2).std = 0;
Node(2).attri = 'beacon';

Node(3).x = 2.4;
Node(3).y = 2.4;
Node(3).est_x = 2.4;
Node(3).est_y = 2.4;
Node(3).std = 0;
Node(3).attri = 'beacon';

Node(4).x = 1.0;
Node(4).y = 1.8;
Node(4).est_x = 1.0;
Node(4).est_y = 1.8;
Node(4).std = 0;
Node(4).attri = 'beacon';

Node(5).x = 1.0;
Node(5).y = 0.6;
Node(5).est_x = 1.5;
Node(5).est_y = 1.5;
Node(5).std = STD_INITIAL;
Node(5).attri = 'unknown';

Node(6).x = 2.8;
Node(6).y = 0.4;
Node(6).est_x = 1.5;
Node(6).est_y = 1.5;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 2.6;
Node(7).y = 2.8;
Node(7).est_x = 1.5;
Node(7).est_y = 1.5;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 0.2;
Node(8).y = 2.6;
Node(8).est_x = 1.5;
Node(8).est_y = 1.5;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

%
%topo2_b toggle
Node(9).x = 0.4;
Node(9).y = 1.4;
Node(9).est_x = 1.5;
Node(9).est_y = 1.5;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 2.0;
Node(10).y = 1.6;
Node(10).est_x = 1.5;
Node(10).est_y = 1.5;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';
%}


% take a look at the generated topology
figure
hold on;box on;axis([0 3 0 3]); %the frame of the plot
 for i=1:NUM_NODE
    if i<round(NUM_NODE*BEACON_RATIO)+1
        h1 = plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',8);
    else
        h2 = plot(Node(i).x,Node(i).y,'ko','MarkerFace','r','MarkerSize',8);
    end
    %text(Node(i).pos(1)+2,Node(i).pos(2),strcat('Node',num2str(i)));
    text(Node(i).x+0.05,Node(i).y,strcat('Node',num2str(i),' (',num2str(Node(i).x),',',num2str(Node(i).y),')'),'FontWeight','bold');
 end
 legend([h1,h2],'beacon','unknown');