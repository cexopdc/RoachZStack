global STD_INITIAL;
STD_INITIAL = 10000;   % initial std for unknown
global NUM_NODE;
NUM_NODE = 15; % number of total nodes   %%%%%%%%%%%%%
global BEACON_RATIO;
BEACON_RATIO = 1/3; %%%%%%%%%%%%%%%%%%%%%
global Node;
global Length;
Length = 10;
global Width;
Width = 10;

% calibrated rssi_distance mapping from -42 to -87 dBm. The mapping between
% rssi value and matrix row index is: index = -RSSI -41. (diff from C array implementation)

global RSSI_DIS;
if mapping_method == 1
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/oval_grass/on_wolfbot/interp_dist_mean_std_diff_rssi.txt');
elseif mapping_method == 2
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/oval_grass/on_wolfbot/rssi_dis_fitting.txt');
elseif mapping_method == 3
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/oval_grass/on_wolfbot/rssi_dis_weighted_fitting.txt');
end
% compute the linear fitting of distance and std.
RSSI_DIS = lin_dis_std(RSSI_DIS);

for i=1:15
    Node(i).id = i;
end
% the beacons are fixed
Node(1).x = 8.87;
Node(1).y = 8.95;
Node(1).est_x = 8.87;
Node(1).est_y = 8.95;
Node(1).std = 0;
Node(1).attri = 'beacon';

Node(2).x = 0.76;
Node(2).y = 5.17;
Node(2).est_x = 0.76;
Node(2).est_y = 5.17;
Node(2).std = 0;
Node(2).attri = 'beacon';

Node(3).x = 8.36;
Node(3).y = 1.82;
Node(3).est_x = 8.36;
Node(3).est_y = 1.82;
Node(3).std = 0;
Node(3).attri = 'beacon';

Node(4).x = 3.13;
Node(4).y = 1.98;
Node(4).est_x = 3.13;
Node(4).est_y = 1.98;
Node(4).std = 0;
Node(4).attri = 'beacon';

Node(5).x = 3.35;
Node(5).y = 8.71;
Node(5).est_x = 3.35;
Node(5).est_y = 8.71;
Node(5).std = 0;
Node(5).attri = 'beacon';
%  topology 1
if topo == 1
Node(6).x = 7.84;
Node(6).y = 3.67;
Node(6).est_x = 5.0;
Node(6).est_y = 5.0;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 2.90;
Node(7).y = 4.00;
Node(7).est_x = 5.0;
Node(7).est_y = 5.0;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 2.60;
Node(8).y = 6.51;
Node(8).est_x = 5.0;
Node(8).est_y = 5.0;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 5.39;
Node(9).y = 2.10;
Node(9).est_x = 5.0;
Node(9).est_y = 5.0;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 6.85;
Node(10).y = 6.66;
Node(10).est_x = 5.0;
Node(10).est_y = 5.0;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x = 4.73;
Node(11).y = 5.00;
Node(11).est_x = 5.0;
Node(11).est_y = 5.0;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 3.81;
Node(12).y = 3.13;
Node(12).est_x = 5.0;
Node(12).est_y = 5.0;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 5.44;
Node(13).y = 5.45;
Node(13).est_x = 5.0;
Node(13).est_y = 5.0;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 4.42;
Node(14).y = 7.15;
Node(14).est_x = 5.0;
Node(14).est_y = 5.0;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 6.06;
Node(15).y = 3.72;
Node(15).est_x = 5.0;
Node(15).est_y = 5.0;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';

elseif topo == 2
Node(6).x = 7.84;
Node(6).y = 3.67;
Node(6).est_x = 5.0;
Node(6).est_y = 5.0;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 7.05;
Node(7).y = 5.03;
Node(7).est_x = 5.0;
Node(7).est_y = 5.0;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 1.90;
Node(8).y = 3.96;
Node(8).est_x = 5.0;
Node(8).est_y = 5.0;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 5.39;
Node(9).y = 2.10;
Node(9).est_x = 5.0;
Node(9).est_y = 5.0;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 1.53;
Node(10).y = 7.00;
Node(10).est_x = 5.0;
Node(10).est_y = 5.0;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x = 2.88;
Node(11).y = 7.29;
Node(11).est_x = 5.0;
Node(11).est_y = 5.0;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 3.81;
Node(12).y = 3.13;
Node(12).est_x = 5.0;
Node(12).est_y = 5.0;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 3.91;
Node(13).y = 4.90;
Node(13).est_x = 5.0;
Node(13).est_y = 5.0;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 7.58;
Node(14).y = 6.57;
Node(14).est_x = 5.0;
Node(14).est_y = 5.0;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 6.06;
Node(15).y = 3.72;
Node(15).est_x = 5.0;
Node(15).est_y = 5.0;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';

elseif topo == 3
Node(6).x = 8.58;
Node(6).y = 7.40;
Node(6).est_x = 5.0;
Node(6).est_y = 5.0;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 7.84;
Node(7).y = 3.67;
Node(7).est_x = 5.0;
Node(7).est_y = 5.0;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 8.31;
Node(8).y = 3.35;
Node(8).est_x = 5.0;
Node(8).est_y = 5.0;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 1.96;
Node(9).y = 3.58;
Node(9).est_x = 5.0;
Node(9).est_y = 5.0;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 1.53;
Node(10).y = 7.00;
Node(10).est_x = 5.0;
Node(10).est_y = 5.0;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x = 5.53;
Node(11).y = 4.51;
Node(11).est_x = 5.0;
Node(11).est_y = 5.0;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 5.70;
Node(12).y = 2.60;
Node(12).est_x = 5.0;
Node(12).est_y = 5.0;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 2.99;
Node(13).y = 6.89;
Node(13).est_x = 5.0;
Node(13).est_y = 5.0;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 7.58;
Node(14).y = 6.57;
Node(14).est_x = 5.0;
Node(14).est_y = 5.0;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 3.48;
Node(15).y = 3.90;
Node(15).est_x = 5.0;
Node(15).est_y = 5.0;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';

elseif topo == 4
Node(6).x = 8.58;
Node(6).y = 7.40;
Node(6).est_x = 5.0;
Node(6).est_y = 5.0;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 2.88;
Node(7).y = 5.49;
Node(7).est_x = 5.0;
Node(7).est_y = 5.0;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 8.31;
Node(8).y = 3.35;
Node(8).est_x = 5.0;
Node(8).est_y = 5.0;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 7.60;
Node(9).y = 5.45;
Node(9).est_x = 5.0;
Node(9).est_y = 5.0;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 1.53;
Node(10).y = 7.00;
Node(10).est_x = 5.0;
Node(10).est_y = 5.0;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x = 7.44;
Node(11).y = 5.24;
Node(11).est_x = 5.0;
Node(11).est_y = 5.0;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 5.70;
Node(12).y = 2.60;
Node(12).est_x = 5.0;
Node(12).est_y = 5.0;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 4.91;
Node(13).y = 5.25;
Node(13).est_x = 5.0;
Node(13).est_y = 5.0;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 7.58;
Node(14).y = 6.57;
Node(14).est_x = 5.0;
Node(14).est_y = 5.0;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 4.68;
Node(15).y = 3.85;
Node(15).est_x = 5.0;
Node(15).est_y = 5.0;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';

elseif topo == 5
Node(6).x = 8.58;
Node(6).y = 7.40;
Node(6).est_x = 5.0;
Node(6).est_y = 5.0;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 4.16;
Node(7).y = 6.35;
Node(7).est_x = 5.0;
Node(7).est_y = 5.0;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 8.31;
Node(8).y = 3.35;
Node(8).est_x = 5.0;
Node(8).est_y = 5.0;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 3.51;
Node(9).y = 3.41;
Node(9).est_x = 5.0;
Node(9).est_y = 5.0;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 7.07;
Node(10).y = 5.53;
Node(10).est_x = 5.0;
Node(10).est_y = 5.0;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x = 7.44;
Node(11).y = 5.24;
Node(11).est_x = 5.0;
Node(11).est_y = 5.0;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 4.95;
Node(12).y = 3.03;
Node(12).est_x = 5.0;
Node(12).est_y = 5.0;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 4.91;
Node(13).y = 5.25;
Node(13).est_x = 5.0;
Node(13).est_y = 5.0;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 7.58;
Node(14).y = 6.57;
Node(14).est_x = 5.0;
Node(14).est_y = 5.0;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 6.07;
Node(15).y = 4.62;
Node(15).est_x = 5.0;
Node(15).est_y = 5.0;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';
end

%take a look at the generated topology
%{
figure
hold on;box on;axis([0 10 0 10]); %the frame of the plot
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
 exportfig(gcf,strcat('topo',num2str(topo),'.eps'),'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
%}