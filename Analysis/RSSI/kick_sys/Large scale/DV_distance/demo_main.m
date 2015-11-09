% Localization initialization
%function demo_main(seed)
%clear all; close all;
rng default;
rng (7); %9,13,16,18,19,20,24,26,27,30
global Length;
Length=50; % area space, unit: meter
global Width;       
Width=50;  % area space, unit: meter
global NUM_NODE;
NUM_NODE=5; % number of total nodes
global BEACON_RATIO;
BEACON_RATIO=0.5; 
global TRANS_RANGE;
TRANS_RANGE = 20;       % transmission range 20 meters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DIS_STD_RATIO; 
DIS_STD_RATIO = 0.05;  % the distance measurement error ratio
global WGN_DIST; % the measurement distance with WGN, which is fixed during multiple stages.
global STAGE_NUMBER;
STAGE_NUMBER=10;      % number of stages
global STAGE_FLAG;
STAGE_FLAG = 1;
global HOP_CONSTRAINT
HOP_CONSTRAINT = 10; % number of hop constraint for dv update
global Node;
global sched_array; %sorted global schedule array
global PAUSE_TIME; % used for animation
PAUSE_TIME=0.0001;

%set nodes coordinates,id, attribute

% sort the time schedule of all the nodes
tmp_sched = [];
for i=1:NUM_NODE
    %Node(i).pos = [Width*rand;Length*rand]; % node i position, 2 by 1 matrix [x;y]
    Node(i).id = i;         % node ID
    Node(i).sched=rand;    % time scheduling of the system, set to random
    tmp_sched = [tmp_sched;[Node(i).sched Node(i).id]];
    Node(i).msg_count_dv_vector_update = 0;
    Node(i).bytes_count_dv_vector_update = 0;

    if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
        Node(i).attri = 'beacon';
        Node(i).dv_vector=[Node(i).id 0 0];  % initialize accessible dv vector, itself.
    else                            % unknown
        Node(i).attri = 'unknown';
        Node(i).dv_vector=[];  % initialize accessible dv vector to none
    end
end
tmp_sched = sortrows(tmp_sched);
sched_array = tmp_sched(:,2)';

%{
% Example topology
Node(1).pos = [20;36.8];
Node(2).pos = [7.2;9.2];
Node(3).pos = [36;8.8];
Node(4).pos = [23.2;26.4];
Node(5).pos = [14.4;16.8];
Node(6).pos = [30;14.8];
for i=1:NUM_NODE
    Node(i).pos = Node(i).pos + [10;10];
end
Node(1).est_pos = Node(1).pos;
Node(2).est_pos = Node(2).pos;
Node(3).est_pos = Node(3).pos;
%}

%
% Example 2 topology
Node(1).pos = [25;43];
Node(1).est_pos = Node(1).pos;
Node(2).pos = [10;20];
Node(2).est_pos = Node(2).pos;
Node(3).pos = [44;14];
Node(3).est_pos = Node(3).pos;
Node(4).pos = [25.5;30];
Node(5).pos = [36;23];
for i=1:NUM_NODE
    Node(i).pos = Node(i).pos + [-5;-10];
end
Node(1).est_pos = Node(1).pos;
Node(2).est_pos = Node(2).pos;
Node(3).est_pos = Node(3).pos;
%

% set the measurement distance with WGN, which is fixed during multiple stages.
for i=1:NUM_NODE
    for j=1:NUM_NODE
        WGN_DIST(i,j)=DIST(Node(i),Node(j)) + DIS_STD_RATIO*DIST(Node(i),Node(j))*randn;
    end
end

%calculate neighbor array, and calculate connectivity
hFigure = figure;
hold on;box on;axis([0 Length 0 Width]); %the frame of the plot

% Enlarge figure to full screen.
set(gca, 'FontSize', 16,'XTick',0:10:50,'YTick',0:10:50);
axis square
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

connectivity_counter = 0;
for i=1:NUM_NODE
    Node(i).neighbor = []; %initialize the neighbor array
    tmp_array = [1:NUM_NODE];
    tmp_array(tmp_array==i)=[]; % delete node i itself
    for j=tmp_array
        if DIST(Node(i),Node(j))<=TRANS_RANGE
            connectivity_counter = connectivity_counter + 1;

            Node(i).neighbor = [Node(i).neighbor j];
            % draw a line between neighbor nodes on the plot
            line([Node(i).pos(1),Node(j).pos(1)],[Node(i).pos(2),Node(j).pos(2)],'Color','k','LineStyle',':','LineWidth',2); 
        end
    end
end
avg_connectivity = connectivity_counter/NUM_NODE;

%
% take a look at the generated topology
global h;
global h_est;
global frame_index;
frame_index = 0;
 for i=1:NUM_NODE
    if i<round(NUM_NODE*BEACON_RATIO)+1
        h(i) = plot(Node(i).pos(1),Node(i).pos(2),'ko','MarkerFace','g','MarkerSize',28,'MarkerEdgeColor','none');
    else
        Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
        %hreal(i) = plot(Node(i).pos(1),Node(i).pos(2),'kx','MarkerFace','r','MarkerSize',8,'MarkerEdgeColor','r');
        %h(i) = plot(Node(i).est_pos(1),Node(i).est_pos(2),'ko','MarkerFace','r','MarkerSize',8,'MarkerEdgeColor','none');
    end
    %text(Node(i).pos(1)+2,Node(i).pos(2),strcat('Node',num2str(i)));
    %text(Node(i).pos(1)+1,Node(i).pos(2),num2str(i),'FontWeight','bold','FontSize',18);
 end
 
 text(Node(1).pos(1)+2,Node(1).pos(2),'B1','FontWeight','bold','FontSize',24);
 text(Node(2).pos(1)+2,Node(2).pos(2),'B2','FontWeight','bold','FontSize',24);
 text(Node(3).pos(1)+2,Node(3).pos(2),'B3','FontWeight','bold','FontSize',24);
 text(Node(4).pos(1)+2,Node(4).pos(2),'U1','FontWeight','bold','FontSize',24);
 text(Node(5).pos(1)+2,Node(5).pos(2),'U2','FontWeight','bold','FontSize',24);
 
 h_est(4) = plot(Node(4).est_pos(1),Node(4).est_pos(2),'kx','MarkerFace','r','MarkerSize',28,'MarkerEdgeColor','r');
 h(4) = plot(Node(4).pos(1),Node(4).pos(2),'ko','MarkerFace','r','MarkerSize',28,'MarkerEdgeColor','none');
 h_est(5) = plot(Node(5).est_pos(1),Node(5).est_pos(2),'kx','MarkerFace','b','MarkerSize',28,'MarkerEdgeColor','b');
 h(5) = plot(Node(5).pos(1),Node(5).pos(2),'ko','MarkerFace','b','MarkerSize',28,'MarkerEdgeColor','none');
 %h_est(6) = plot(Node(6).est_pos(1),Node(6).est_pos(2),'kx','MarkerFace','m','MarkerSize',18,'MarkerEdgeColor','m');
 %h(6) = plot(Node(6).pos(1),Node(6).pos(2),'ko','MarkerFace','m','MarkerSize',18,'MarkerEdgeColor','none');
 
 %legend([h(1) hreal(4) h(4)],'Beacon','Unknown','Unknown\_estimation');

 %exportfig(gcf,'dense_topo.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
 
 drawnow;
 pause(PAUSE_TIME)
 thisFrame = getframe(gcf);
 % Write this frame out to a new video file.
 % writeVideo(writerObj, thisFrame);
 frame_index = frame_index + 1;
 
 clear myMovie;
 %myMovie(100) = struct('cdata',[], 'colormap', []);
 myMovie(frame_index) = thisFrame;
% establish dv_vector for each node.
%the system runs
flops(0); %%start global flop count at 0
global FLOP_COUNT_FLAG;
global IWLSE_extra_flops;
IWLSE_extra_flops = 0;
for time = 0:HOP_CONSTRAINT
    for index = sched_array
        Node(index) = dv_vector_update(Node(index));
    end
end

if FLOP_COUNT_FLAG == 1
    tol_flop_dv_vector_update = flops;
else
    tol_flop_dv_vector_update = 0;
end

%calculate the cumulative msg sent and bytes sent
tol_msg_sent_dv_vector_update = 0;
tol_bytes_sent_dv_vector_update = 0;
for i=1:NUM_NODE
    tol_msg_sent_dv_vector_update = tol_msg_sent_dv_vector_update + Node(i).msg_count_dv_vector_update;
    tol_bytes_sent_dv_vector_update = tol_bytes_sent_dv_vector_update + Node(i).bytes_count_dv_vector_update;
end
   
%{
[loc_error_kick,tol_flop_kick,break_stage_kick,tol_msg_sent_kick,tol_bytes_sent_kick,myMovie] = kick_loc_demo(myMovie);
% plot final std
h4_circle = circle(Node(4),Node(4).est_pos,3*Node(4).std,360,':');
set(h4_circle,'Color','r');
h5_circle = circle(Node(5),Node(5).est_pos,3*Node(4).std,360,':');
set(h5_circle,'Color','b');
%h6_circle = circle(Node(6),Node(6).est_pos,3*Node(4).std,360,':');
%set(h6_circle,'Color','m');
%}

%
[loc_error,tol_flop,break_stage,tol_msg_sent,tol_bytes_sent,myMovie]=kick_loc_kalman_demo(myMovie);
% plot the ellipse std.
h4_circle = ellipse(Node(4));
set(h4_circle,'Color','r');

h5_circle = ellipse(Node(5));
set(h5_circle,'Color','b');

%h6_circle = ellipse(Node(6));
%set(h6_circle,'Color','m');
%}

drawnow;
 pause(PAUSE_TIME)
 thisFrame = getframe(gcf);
 % Write this frame out to a new video file.
 % writeVideo(writerObj, thisFrame);
 frame_index = frame_index + 1;
 myMovie(frame_index) = thisFrame;

%output = strcat('5node_animation/','myMovie_',num2str(seed),'.mat');
%save(output,'myMovie');
save('5node_animation/myMovie_7_KK.mat','myMovie');
%message = sprintf('Done creating movie\nDo you want to play it?');
%button = questdlg(message, 'Continue?', 'Yes', 'No', 'Yes');
drawnow;	% Refresh screen to get rid of dialog box remnants.
%print(strcat('5node_animation/','myMovie_',num2str(seed)),'-dpng');
close(hFigure);
movie2avi(myMovie,'5node_animation/demo7_KK.avi','fps',2,'quality',100)
%{
if strcmpi(button, 'No')
   return;
end
hFigure = figure;
%Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
title('Playing the movie we created', 'FontSize', 15);
% Get rid of extra set of axes that it makes for some reason.
axis off;
% Play the movie.
movie(myMovie);
uiwait(helpdlg('Done with demo!'));
close(hFigure);
%}
%end

