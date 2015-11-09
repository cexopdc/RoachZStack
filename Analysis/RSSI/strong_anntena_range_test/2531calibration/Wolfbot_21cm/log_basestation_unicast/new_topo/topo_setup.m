global STD_INITIAL;
STD_INITIAL = 10000;   % initial std for unknown
global NUM_NODE;
NUM_NODE = 15; % number of total nodes   %%%%%%%%%%%%%
global BEACON_RATIO;
BEACON_RATIO = 1/3; %%%%%%%%%%%%%%%%%%%%%
global Node;

% calibrated rssi_distance mapping from -42 to -87 dBm. The mapping between
% rssi value and matrix row index is: index = -RSSI -41. (diff from C array implementation)

global RSSI_DIS;
if mapping_method == 1
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Wolfbot_21cm/interp_dist_mean_std_diff_rssi.txt');
elseif mapping_method == 2
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Wolfbot_21cm/rssi_dis_fitting.txt');
elseif mapping_method == 3
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Wolfbot_21cm/rssi_dis_weighted_fitting.txt');
elseif mapping_method == 4
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Wolfbot_21cm/cut_3m_interp_dist_mean_std_diff_rssi.txt');
elseif mapping_method == 5
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Wolfbot_21cm/cut_3m_rssi_dis_fitting.txt');
elseif mapping_method == 6
    RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Wolfbot_21cm/cut_3m_rssi_dis_weighted_fitting.txt');
end
% compute the linear fitting of distance and std.
RSSI_DIS = lin_dis_std(RSSI_DIS);

for i=1:15
    Node(i).id = i;
end
% the beacons are fixed
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
Node(5).est_x = 1.2;
Node(5).est_y = 0.8;
Node(5).std = 0;
Node(5).attri = 'beacon';
%  topology 1
if topo == 1
Node(6).x = 1.55;
Node(6).y = 1.53;
Node(6).est_x = 1.5;
Node(6).est_y = 1.5;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 0.62;
Node(7).y = 1.85;
Node(7).est_x = 1.5;
Node(7).est_y = 1.5;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 2.10;
Node(8).y = 1.47;
Node(8).est_x = 1.5;
Node(8).est_y = 1.5;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 1.47;
Node(9).y = 2.10;
Node(9).est_x = 1.5;
Node(9).est_y = 1.5;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 1.02;
Node(10).y = 2.47;
Node(10).est_x = 1.5;
Node(10).est_y = 1.5;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x = 0.19;
Node(11).y = 2.34;
Node(11).est_x = 1.5;
Node(11).est_y = 1.5;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 2.42;
Node(12).y = 2.32;
Node(12).est_x = 1.5;
Node(12).est_y = 1.5;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 0.79;
Node(13).y = 1.20;
Node(13).est_x = 1.5;
Node(13).est_y = 1.5;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 2.44;
Node(14).y = 1.23;
Node(14).est_x = 1.5;
Node(14).est_y = 1.5;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 1.86;
Node(15).y = 2.20;
Node(15).est_x = 1.5;
Node(15).est_y = 1.5;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';

elseif topo == 2
Node(6).x = 1.24;
Node(6).y = 1.38;
Node(6).est_x = 1.5;
Node(6).est_y = 1.5;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 1.55;
Node(7).y = 2.41;
Node(7).est_x = 1.5;
Node(7).est_y = 1.5;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 1.98;
Node(8).y = 0.96;
Node(8).est_x = 1.5;
Node(8).est_y = 1.5;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 1.57;
Node(9).y = 1.70;
Node(9).est_x = 1.5;
Node(9).est_y = 1.5;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 1.02;
Node(10).y = 2.50;
Node(10).est_x = 1.5;
Node(10).est_y = 1.5;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x = 0.65;
Node(11).y = 1.34;
Node(11).est_x = 1.5;
Node(11).est_y = 1.5;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 2.48;
Node(12).y = 1.95;
Node(12).est_x = 1.5;
Node(12).est_y = 1.5;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 1.16;
Node(13).y = 1.86;
Node(13).est_x = 1.5;
Node(13).est_y = 1.5;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 2.29;
Node(14).y = 1.48;
Node(14).est_x = 1.5;
Node(14).est_y = 1.5;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 1.84;
Node(15).y = 2.20;
Node(15).est_x = 1.5;
Node(15).est_y = 1.5;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';

elseif topo == 3
Node(6).x = 0.63;
Node(6).y = 1.44;
Node(6).est_x = 1.5;
Node(6).est_y = 1.5;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 2.31;
Node(7).y = 1.96;
Node(7).est_x = 1.5;
Node(7).est_y = 1.5;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 2.40;
Node(8).y = 1.54;
Node(8).est_x = 1.5;
Node(8).est_y = 1.5;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 1.86;
Node(9).y = 1.43;
Node(9).est_x = 1.5;
Node(9).est_y = 1.5;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 0.52;
Node(10).y = 2.02;
Node(10).est_x = 1.5;
Node(10).est_y = 1.5;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x = 1.79;
Node(11).y = 1.08;
Node(11).est_x = 1.5;
Node(11).est_y = 1.5;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 2.25;
Node(12).y = 2.48;
Node(12).est_x = 1.5;
Node(12).est_y = 1.5;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 1.16;
Node(13).y = 1.83;
Node(13).est_x = 1.5;
Node(13).est_y = 1.5;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 2.50;
Node(14).y = 1.06;
Node(14).est_x = 1.5;
Node(14).est_y = 1.5;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 1.51;
Node(15).y = 2.33;
Node(15).est_x = 1.5;
Node(15).est_y = 1.5;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';

elseif topo == 4
Node(6).x = 0.62;
Node(6).y = 1.42;
Node(6).est_x = 1.5;
Node(6).est_y = 1.5;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 2.37;
Node(7).y = 2.44;
Node(7).est_x = 1.5;
Node(7).est_y = 1.5;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 2.54;
Node(8).y = 1.78;
Node(8).est_x = 1.5;
Node(8).est_y = 1.5;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 1.00;
Node(9).y = 2.31;
Node(9).est_x = 1.5;
Node(9).est_y = 1.5;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 1.15;
Node(10).y = 1.46;
Node(10).est_x = 1.5;
Node(10).est_y = 1.5;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x =0.73;
Node(11).y = 1.00;
Node(11).est_x = 1.5;
Node(11).est_y = 1.5;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 1.63;
Node(12).y = 2.55;
Node(12).est_x = 1.5;
Node(12).est_y = 1.5;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 1.17;
Node(13).y = 1.84;
Node(13).est_x = 1.5;
Node(13).est_y = 1.5;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 2.30;
Node(14).y = 1.11;
Node(14).est_x = 1.5;
Node(14).est_y = 1.5;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 2.17;
Node(15).y = 1.59;
Node(15).est_x = 1.5;
Node(15).est_y = 1.5;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';

elseif topo == 5
Node(6).x = 1.72;
Node(6).y = 1.82;
Node(6).est_x = 1.5;
Node(6).est_y = 1.5;
Node(6).std = STD_INITIAL;
Node(6).attri = 'unknown';

Node(7).x = 1.69;
Node(7).y = 2.38;
Node(7).est_x = 1.5;
Node(7).est_y = 1.5;
Node(7).std = STD_INITIAL;
Node(7).attri = 'unknown';

Node(8).x = 2.62;
Node(8).y = 1.58;
Node(8).est_x = 1.5;
Node(8).est_y = 1.5;
Node(8).std = STD_INITIAL;
Node(8).attri = 'unknown';

Node(9).x = 1.48;
Node(9).y = 1.34;
Node(9).est_x = 1.5;
Node(9).est_y = 1.5;
Node(9).std = STD_INITIAL;
Node(9).attri = 'unknown';

Node(10).x = 0.94;
Node(10).y = 1.53;
Node(10).est_x = 1.5;
Node(10).est_y = 1.5;
Node(10).std = STD_INITIAL;
Node(10).attri = 'unknown';

Node(11).x =0.74;
Node(11).y = 0.99;
Node(11).est_x = 1.5;
Node(11).est_y = 1.5;
Node(11).std = STD_INITIAL;
Node(11).attri = 'unknown';

Node(12).x = 1.31;
Node(12).y = 1.93;
Node(12).est_x = 1.5;
Node(12).est_y = 1.5;
Node(12).std = STD_INITIAL;
Node(12).attri = 'unknown';

Node(13).x = 0.74;
Node(13).y = 2.07;
Node(13).est_x = 1.5;
Node(13).est_y = 1.5;
Node(13).std = STD_INITIAL;
Node(13).attri = 'unknown';

Node(14).x = 2.50;
Node(14).y = 0.99;
Node(14).est_x = 1.5;
Node(14).est_y = 1.5;
Node(14).std = STD_INITIAL;
Node(14).attri = 'unknown';

Node(15).x = 2.26;
Node(15).y = 1.40;
Node(15).est_x = 1.5;
Node(15).est_y = 1.5;
Node(15).std = STD_INITIAL;
Node(15).attri = 'unknown';
end

% take a look at the generated topology
%{
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
 exportfig(gcf,strcat('topo',num2str(topo),'.eps'),'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
%}