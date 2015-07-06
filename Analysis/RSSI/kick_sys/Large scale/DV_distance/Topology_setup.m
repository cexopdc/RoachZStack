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
global LOCALIZABLE_ID; % IDs of localizable nodes
LOCALIZABLE_ID = [];
global sched_array; %sorted global schedule array
%M_measurement; % M distance measurements info for CRLB
%theta_array; % theta array for CRLB
%set nodes coordinates,id, attribute


% sort the time schedule of all the nodes
tmp_sched = [];
% set break_flag to 0, break when CRLB is not ill-conditioned.
break_flag = 0;
while 1
    theta_array_index = 0;
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
            % set theta array for CRLB
            theta_array_index = theta_array_index + 1;
            theta_array(theta_array_index).id = i;
            theta_array(theta_array_index).axis = 'x';
            theta_array_index = theta_array_index + 1;
            theta_array(theta_array_index).id = i;
            theta_array(theta_array_index).axis = 'y';
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

    % set M measurements info
    M_counter = 0;
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        for j = 1:i-1
            if DIST(Node(i),Node(j))<=TRANS_RANGE
                M_counter = M_counter + 1;

                %store M_measurement info for CRLB
                M_measurement(M_counter).id = M_counter;
                M_measurement(M_counter).src = i;
                M_measurement(M_counter).dst = j;
                M_measurement(M_counter).dis = DIST(Node(i),Node(j));
                M_measurement(M_counter).std = DIS_STD_RATIO*DIST(Node(i),Node(j));
            end
        end
    end

    % calculate CRLB
    % calculate G_prime_theta
    M = length(M_measurement);
    A = length(theta_array)/2;
    G_prime_theta = zeros(M,2*A);
    for m=1:M
        for n=1:2*A
            i = M_measurement(m).src;
            j = M_measurement(m).dst;
            i_prime = theta_array(n).id;
            i_prime_axis = theta_array(n).axis;
            if (i_prime == i) && strcmp(i_prime_axis,'x')
                G_prime_theta(m,n) = (Node(i).pos(1) - Node(j).pos(1))/M_measurement(m).dis;
            elseif (i_prime == j) && strcmp(i_prime_axis,'x')
                G_prime_theta(m,n) = (Node(j).pos(1) - Node(i).pos(1))/M_measurement(m).dis;
            elseif (i_prime == i) && strcmp(i_prime_axis,'y')
                G_prime_theta(m,n) = (Node(i).pos(2) - Node(j).pos(2))/M_measurement(m).dis;
            elseif (i_prime == j) && strcmp(i_prime_axis,'y')
                G_prime_theta(m,n) = (Node(j).pos(2) - Node(i).pos(2))/M_measurement(m).dis;
            else
                G_prime_theta(m,n) = 0;
            end
        end
    end
    % calculate W for measurement error matrix
    W = zeros(M,M);
    for i=1:M
        for j=1:M
            if i == j 
               W(i,j) = 1/((M_measurement(i).std)^2); 
            else 
                W(i,j) = 0;
            end
        end
    end
    % calculate FIM:J
    FIM_J = transpose(G_prime_theta) * W * G_prime_theta;
        
    % check if the matrix is ill-conditioned
    if rcond(FIM_J)>1*10^-10 
        % calculate CRLB
        CRLB = inv(FIM_J);
        %average_loc_error_CRLB = mean(CRLB_loc_error)/TRANS_RANGE;
        break_flag = 1;
    end 
 
    if break_flag == 1
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
        
        break;
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



