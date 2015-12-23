function final_error_mean_offline = main_process(topo,mapping_method)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mapping_method: 1. direct mapping
%                 2. fitting
%                 3. fitting with proportional std model
%                 4. weighted fitting with proportional std model
%
%clear all;close all;
global DEMO_MODE;
DEMO_MODE = 0; % demo mode to show animations of the algorithm process
global PAUSE_TIME; % used for animation
PAUSE_TIME=0;%0.0001;
global DIS_MAP;
DIS_MAP = zeros(15,15); %DIS for RSSI received at i from j is DIS_MAP(i,j)
global DIS_STD_MAP;
DIS_STD_MAP = zeros(15,15); %DIS_STD for RSSI received at i from j is DIS_STD_MAP(i,j)
topo_setup;
log_matrix = load(strcat('grass_topo',num2str(topo),'.txt')); % load txt to get log_matrix of n*7  (time, node id, neighbor id, rssi value, est x,est y,est std);
% initialize error_matrix and time_array for each node
for i=1:NUM_NODE
    Node(i).error_matrix = [];
    Node(i).time_array = []; 
end

if DEMO_MODE == 1
    hFigure = figure;
    hold on;box on;axis([-2 Length -2 Width]); %the frame of the plot
    % Enlarge figure to full screen.
    set(gca, 'FontSize', 16,'XTick',-2:1:10,'YTick',-2:1:10);
    axis square
    set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
    
    % take a look at the generated topology
    global h;
    global h_est;
    global frame_index;
    global h_line;
    frame_index = 0;
     for i=1:NUM_NODE
        if i<round(NUM_NODE*BEACON_RATIO)+1
            h(i) = plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',10,'MarkerEdgeColor','g');
        else
            Node(i).est_x = Width*0.5;
            Node(i).est_y = Length*0.5; % set initial est_pos at center.
            h(i) = plot(Node(i).x,Node(i).y,'ko','MarkerFace','r','MarkerSize',10,'MarkerEdgeColor','r');
            h_est(i) = plot(Node(i).est_x,Node(i).est_y,'kx','MarkerFace','r','MarkerSize',10,'MarkerEdgeColor','r');
            h_line(i) = line([Node(i).x,Node(i).est_x],[Node(i).y,Node(i).est_y],'Color','k','LineStyle',':'); 
        end
        text(Node(i).x+0.05,Node(i).y,num2str(i));
     end
     
     drawnow;
     pause(PAUSE_TIME)
     thisFrame = getframe(gcf);
     % Write this frame out to a new video file.
     % writeVideo(writerObj, thisFrame);
     frame_index = frame_index + 1;

     clear myMovie;
     %myMovie(100) = struct('cdata',[], 'colormap', []);
     myMovie(frame_index) = thisFrame;
end

% process all the log message by time sequence
%{
for i = 1:length(log_matrix)/3 %%%%%%%%%%%%%%
    A = Node(log_matrix(i,2));
    B = Node(round(log_matrix(i,3)));
    rssi = round(log_matrix(i,4));   
    
    %check if RSSI in bound
    global RSSI_DIS;
    min_rssi = RSSI_DIS(end,1);
    max_rssi = RSSI_DIS(1,1);
    % if rssi out of calibration range, treat it as boundary values.
    if rssi > max_rssi
        rssi = max_rssi;
    end
    if rssi < min_rssi
        continue;
    end
    
    if DEMO_MODE == 1
        % Create a uicontrol of type "text"
        mTextBox0 = uicontrol('style','text');
        mTextBox1 = uicontrol('style','text');
        mTextBox2 = uicontrol('style','text');
        mTextBox3 = uicontrol('style','text');
        mTextBox4 = uicontrol('style','text');
        mTextBox5 = uicontrol('style','text');
        
        % To move the the Text Box around you can set and get the position of Text Box itself
        set(mTextBox0,'String',strcat('LOG Sequence:',{'  '},num2str(i)),'Position',[60,700,300,40],'FontSize',20)
        set(mTextBox1,'String',strcat('Tx STD:',{'  '},num2str(B.std)),'Position',[60,600,300,40],'FontSize',20)
        set(mTextBox2,'String',strcat('Rx STD:',{'  '},num2str(A.std)),'Position',[60,500,300,40],'FontSize',20)
        set(mTextBox3,'String',strcat('Distance STD:',{'  '}),'Position',[60,400,300,40],'FontSize',20)
        set(mTextBox4,'String',strcat('Rx updated STD:',{'  '}),'Position',[60,300,300,40],'FontSize',20)
        set(mTextBox5,'String',strcat('RSSI:',{'  '},num2str(rssi)),'Position',[60,200,300,40],'FontSize',20)
        
        set(h(A.id),'XData',A.x,'YData',A.y,'MarkerSize',25)
        set(h(B.id),'XData',B.x,'YData',B.y,'Marker','*','MarkerSize',25)
        tmp_x = A.est_x;
        tmp_y = A.est_y;
        drawnow;
        pause(PAUSE_TIME)
        thisFrame = getframe(gcf);
        % Write this frame out to a new video file.
        % writeVideo(writerObj, thisFrame);
        frame_index = frame_index + 1;
        myMovie(frame_index) = thisFrame;
    end
    
    
    
    %[Node(log_matrix(i,2)),dis_std] = kick_loc_2531(A,B,rssi);
    %[Node(log_matrix(i,2)),dis_std] = kick_loc_kalman_2531(A,B,rssi);
    [Node(log_matrix(i,2)),dis_std] = kick_loc_kalman_2nodes_2531(A,B,rssi);
    A = Node(log_matrix(i,2));
    
    % after the calculation, update the demo figure
    if DEMO_MODE == 1
        
        set(mTextBox3,'String',strcat('Distance STD:',{'  '},num2str(dis_std)),'Position',[60,400,300,40],'FontSize',20)
        set(mTextBox4,'String',strcat('Rx updated STD:',{'  '},num2str(A.std)),'Position',[60,300,300,40],'FontSize',20)
        
        h_tmp = plot(tmp_x,tmp_y,'kx','MarkerSize',25);
        h_tmp_line = line([A.x tmp_x],[A.y tmp_y],'Color','k','LineStyle',':'); 
        if ~(A.est_x == tmp_x && A.est_y == tmp_y)
            set(h_est(A.id),'XData',A.est_x,'YData',A.est_y,'MarkerSize',25,'LineWidth',2)
            set(h_line(A.id),'XData',[A.x A.est_x],'YData',[A.y A.est_y]);
        end
        drawnow;
         pause(PAUSE_TIME)
         thisFrame = getframe(gcf);
         % Write this frame out to a new video file.
         % writeVideo(writerObj, thisFrame);
         frame_index = frame_index + 1;
         myMovie(frame_index) = thisFrame;
         
        delete(h_tmp);
        delete(h_tmp_line);
        
        % after update, nodes back to normal size
        set(h(A.id),'MarkerSize',10)
        set(h_est(A.id),'MarkerSize',10)
        set(h(B.id),'MarkerSize',10,'Marker','o')
        
        
        drawnow;
         pause(PAUSE_TIME)
         thisFrame = getframe(gcf);
         % Write this frame out to a new video file.
         % writeVideo(writerObj, thisFrame);
         frame_index = frame_index + 1;
         myMovie(frame_index) = thisFrame;
        
    end
    
    %Node(log_matrix(i,2)) = kick_loc_2531_beacon_only(A,B,rssi);
    % record data for time-evolving result
    error_online = sqrt((Node(log_matrix(i,2)).x - log_matrix(i,5))^2 + (Node(log_matrix(i,2)).y - log_matrix(i,6))^2);
    error_offline = sqrt((Node(log_matrix(i,2)).x - Node(log_matrix(i,2)).est_x)^2 + (Node(log_matrix(i,2)).y - Node(log_matrix(i,2)).est_y)^2);
    Node(log_matrix(i,2)).error_matrix = [Node(log_matrix(i,2)).error_matrix [error_online;error_offline]];
    Node(log_matrix(i,2)).time_array = [Node(log_matrix(i,2)).time_array log_matrix(i,1)];
end
%}

%
for i = 1:length(log_matrix)
    A = Node(log_matrix(i,2));
    B = Node(round(log_matrix(i,3)));
    rssi = round(log_matrix(i,4));
    
    %check if RSSI in bound
    global RSSI_DIS;
    min_rssi = RSSI_DIS(end,1);
    max_rssi = RSSI_DIS(1,1);
    % if rssi out of calibration range, treat it as boundary values.
    if rssi > max_rssi
        rssi = max_rssi;
    end
    if rssi < min_rssi
        continue;
    end
    
    dis = RSSI_DIS(RSSI_DIS(:,1)==rssi,2);
    dis_std = RSSI_DIS(RSSI_DIS(:,1)==rssi,3);
    if dis_std <0.01
        dis_std = 0.01;
    end
    
    if DIS_MAP(A.id,B.id) == 0 
        DIS_MAP(A.id,B.id) = dis;
    end
    if DIS_STD_MAP(A.id,B.id) == 0 
        DIS_STD_MAP(A.id,B.id) = dis_std;
    end
end

for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    Node(i) = DV_distance(Node(i));
    %Node(i) = min_max(Node(i));
end

%{
for time=1:10
    for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        Node(i) = N_hop_refine(Node(i));
    end
end
%}

%
for time=1:10
    for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        Node(i) = IWLSE_refine(Node(i));
    end
end
%

aggr_error = [];
for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    error = sqrt((Node(i).est_x - Node(i).x)^2 + (Node(i).est_y - Node(i).y)^2);
    aggr_error = [aggr_error error];
end
final_error_mean_offline = mean(aggr_error);
%}

%{
%figure; hold on;
final_error_array=[];
for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
    node_id = i.*ones(1,length(Node(i).time_array));
%    plot3(node_id,Node(i).time_array,Node(i).error_matrix(2,:));
    if ~isempty(Node(i).error_matrix)
        final_error_array = [final_error_array Node(i).error_matrix(:,end)];
    end
end

%{
set(gca,'xtick',round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE)
set(gca,'ydir','reverse')
xlabel('node\_ID');
ylabel('time (tick)');
zlabel('error (m)');
view(-36,50)
filename = strcat('time_evolving_topo',num2str(topo),'_method',num2str(mapping_method));
savefig(filename);
exportfig(gcf,strcat(filename,'.eps'),'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
%}

final_mean_error = mean(final_error_array,2);
%offline error only
final_error_mean_offline = final_mean_error(2,1);
%}

%Graphical result with mean and std
%{
figure
hold on;box on;axis([-2 10 -2 10]); %the frame of the plot
 for i=1:NUM_NODE
    if i<round(NUM_NODE*BEACON_RATIO)+1
        h1 = plot(Node(i).x,Node(i).y,'ko','MarkerFace','g','MarkerSize',8);
    else
        h2 = plot(Node(i).x,Node(i).y,'ko','MarkerFace','r','MarkerSize',8);
        plot(Node(i).est_x,Node(i).est_y,'kx');
        line([Node(i).x,Node(i).est_x],[Node(i).y,Node(i).est_y],'Color','k','LineStyle',':'); 
        %circle([Node(i).est_x,Node(i).est_y],3*Node(i).std,1000,'k:');
    end
    %text(Node(i).pos(1)+2,Node(i).pos(2),strcat('Node',num2str(i)));
    %text(Node(i).x+0.05,Node(i).y,strcat('Node',num2str(i),' (',num2str(Node(i).x),',',num2str(Node(i).y),')'),'FontWeight','bold');
    text(Node(i).x+0.05,Node(i).y,num2str(i));
 end
 legend([h1,h2],'beacon','unknown');
 filename = strcat('final_mean_result_topo',num2str(topo),'_method',num2str(mapping_method));
 exportfig(gcf,strcat('final_mean_std_result/',filename,'.eps'),'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
%}

if DEMO_MODE == 1
    drawnow;
     pause(PAUSE_TIME)
     thisFrame = getframe(gcf);
     % Write this frame out to a new video file.
     % writeVideo(writerObj, thisFrame);
     frame_index = frame_index + 1;
     myMovie(frame_index) = thisFrame;

    output = strcat('animation/','myMovie_topo',num2str(topo),'_method',num2str(mapping_method),'_third.mat');
    save(output,'myMovie','-v7.3');
    %message = sprintf('Done creating movie\nDo you want to play it?');
    %button = questdlg(message, 'Continue?', 'Yes', 'No', 'Yes');
    drawnow;	% Refresh screen to get rid of dialog box remnants.
    %print(strcat('5node_animation/','myMovie_',num2str(seed)),'-dpng');
    close(hFigure);
    output = strcat('animation/','myMovie_topo',num2str(topo),'_method',num2str(mapping_method),'_third');
    myVideo = VideoWriter(output,'MPEG-4');
    myVideo.FrameRate = 4;  % Default 30
    open(myVideo);
    writeVideo(myVideo, myMovie);
    close(myVideo);
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
end

end
