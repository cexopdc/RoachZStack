% Localization initialization
%clear all;
global Length;
Length=area_space; % area space, unit: meter
global Width;       
Width=area_space;  % area space, unit: meter
global NUM_NODE;
NUM_NODE=num_node; % number of total nodes
global BEACON_RATIO;
BEACON_RATIO=beacon_ratio; 
global TRANS_RANGE;
TRANS_RANGE = trans_range;       % transmission range 20 meters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DIS_STD_RATIO; 
DIS_STD_RATIO = dis_std_ratio;  % the distance measurement error ratio
global WGN_DIST; % the measurement distance with WGN, which is fixed during multiple stages.
global STAGE_NUMBER;
STAGE_NUMBER=20;      % number of stages
global Node;
global sched_array; %sorted global schedule array

%M_measurement; % M distance measurements info for CRLB
%theta_array; % theta array for CRLB
%set nodes coordinates,id, attribute

    % sort the time schedule of all the nodes
    tmp_sched = [];
    for i=1:NUM_NODE
        Node(i).pos = [Width*rand;Length*rand]; % node i position, 2 by 1 matrix [x;y]
        Node(i).id = i;         % node ID
        Node(i).sched=rand;    % time scheduling of the system, set to random
        tmp_sched = [tmp_sched;[Node(i).sched Node(i).id]];

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
    Node(1).est_pos = Node(1).pos;
    Node(2).pos = [7.2;9.2];
    Node(2).est_pos = Node(2).pos;
    Node(3).pos = [36;8.8];
    Node(3).est_pos = Node(3).pos;
    Node(4).pos = [23.2;26.4];
    Node(5).pos = [14.4;16.8];
    Node(6).pos = [30;14.8];
    %}

    %{
    % Example 2 topology
    Node(1).pos = [6.84192070101789;37.5423145732737];
    Node(1).est_pos = Node(1).pos;
    Node(2).pos = [17.6253872304336;37.6767572124513];
    Node(2).est_pos = Node(2).pos;
    Node(3).pos = [18.0778283704154;33.5878968287868];
    Node(3).est_pos = Node(3).pos;
    Node(4).pos = [22.1554826316510;27.2026212033344];
    Node(5).pos = [9.57162424774182;23.1569396983637];
    Node(6).pos = [16.2710704086090;4.50460564100187];
    %}

    % set the measurement distance with WGN, which is fixed during multiple stages.
    for i=1:NUM_NODE
        for j=1:NUM_NODE
            WGN_DIST(i,j)=DIST(Node(i),Node(j)) + DIS_STD_RATIO*DIST(Node(i),Node(j))*randn;
        end
    end

    %calculate neighbor array, and calculate connectivity
    %figure
    %hold on;box on;axis([0 Length 0 Width]); %the frame of the plot
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
                %line([Node(i).pos(1),Node(j).pos(1)],[Node(i).pos(2),Node(j).pos(2)],'Color','k','LineStyle',':'); 
            end
        end
    end
    avg_connectivity = connectivity_counter/NUM_NODE;

    % establish dv_vector for each node.
    %the system runs 
    for time = 0:STAGE_NUMBER
        for index = sched_array
            Node(index) = dv_vector_update(Node(index));
        end
    end
    


    
%{
% take a look at the generated topology
 for i=1:NUM_NODE
    if i<round(NUM_NODE*BEACON_RATIO)+1
        plot(Node(i).pos(1),Node(i).pos(2),'ko','MarkerFace','g','MarkerSize',8);
    else
        plot(Node(i).pos(1),Node(i).pos(2),'ko','MarkerFace','r','MarkerSize',8);
    end
    %text(Node(i).pos(1)+2,Node(i).pos(2),strcat('Node',num2str(i)));
    text(Node(i).pos(1)+1,Node(i).pos(2),num2str(i),'FontWeight','bold');
 end
%}



