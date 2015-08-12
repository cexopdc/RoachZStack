% Iterative Weight Least Squares Estiamtion
% 1. get distances to available beacons, along with std (the bias factor).
% 2. do a LS lateration to get the initial est and std.
% 3. Each node do a IWLSE lateration with neighbor nodes.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  N-hop multilateration algorithm
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [average_loc_error, std_loc_error, coverage,tol_flop,break_stage,tol_msg_sent,tol_bytes_sent] = IWLSE
    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global STAGE_FLAG;
    global TRANS_RANGE;
    global STD_INITIAL;
    STD_INITIAL = 10000;   % initial std for unknown
    global FLOP_COUNT_FLAG;
    flops(0); %%start global flop count at 0
    
    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE
        Node(i).correction=0;   % intiailize the correction to be 0
        Node(i).msg_count = 0;
        Node(i).bytes_count = 0;

        if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
            Node(i).est_pos = Node(i).pos;
            Node(i).well_determined=1; % set beacon as well-determined.
            Node(i).std=0;
        else                            % unknown
            Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
            Node(i).well_determined=0; % set unknowns as not well-determined.
            Node(i).std=STD_INITIAL;
        end
    end

    
    % Obtain corrections for each beacon
    for i= 1:round(NUM_NODE*BEACON_RATIO)
        % if beacon has access to other beacon, then
        % calculate a correction.
        if size(Node(i).dv_vector,1)>1
            tol_DIS = 0;
            tol_dis = sum(Node(i).dv_vector(:,2));
            if FLOP_COUNT_FLAG == 1
                addflops(size(Node(i).dv_vector,1));
            end
            for beacon_index = Node(i).dv_vector(:,1)'
                tol_DIS = tol_DIS + DIST(Node(i),Node(beacon_index));
                if FLOP_COUNT_FLAG == 1
                    addflops(1);
                end
            end
            Node(i).correction = tol_dis/tol_DIS;
            if FLOP_COUNT_FLAG == 1
                    addflops(flops_div);
            end
        end
    end
    
    % Obtain corrections for each unknown
    for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if FLOP_COUNT_FLAG == 1
            addflops(2);
        end
        if ~isempty(Node(i).dv_vector)
            % find the nearest beacon for the 
            if FLOP_COUNT_FLAG == 1
                    addflops(size(Node(i).dv_vector,1));
            end
            sorted_dv = sortrows(Node(i).dv_vector,2);
            nearest_beacon = sorted_dv(1,1);
            Node(i).correction = Node(nearest_beacon).correction;
        end
    end
    
    % find well-determined unknowns, and apply lateration using beacons for initial
    % localization
    for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if FLOP_COUNT_FLAG == 1
            addflops(2);
        end
        if ~isempty(Node(i).dv_vector)
            beacon_list = Node(i).dv_vector(:,1)';
            if FLOP_COUNT_FLAG == 1
                addflops(2);
            end
            if length(beacon_list)>2
                Node(i).well_determined=1;
                Node(i) = beacon_lateration(Node(i));
            end
        end
    end
    
    % Refinement phase: well-determined unknowns using neighbor info. to
    % localize, using weighted least-square
    
    % initial loc_error %
    loc_error_prev = [];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
        if size(Node(i).dv_vector,1) > 2
            loc_error_prev = [loc_error_prev node_loc_error];
        end
    end
    avg_loc_error_prev = mean(loc_error_prev);
    
    for time = 0:STAGE_NUMBER
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % this part solely for msg collection purpose.
        %
        for i = 1:NUM_NODE
            Node(i).msg_count = Node(i).msg_count + 1;
            Node(i).bytes_count = Node(i).bytes_count + 1*3;  % x,y,std          
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
            if Node(i).well_determined==1
                if length(Node(i).neighbor)>2
                    Node(i) = neighbor_lateration(Node(i));
                end
            end
        end
        
        % current loc_error %
        loc_error_cur = [];
        for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
            node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
            if size(Node(i).dv_vector,1) > 2
                loc_error_cur = [loc_error_cur node_loc_error];
            end
        end
        avg_loc_error_cur = mean(loc_error_cur);
        if abs(avg_loc_error_cur - avg_loc_error_prev) <= 0.05
            if STAGE_FLAG == 0
                %fprintf('kick_loc stage: %d\n',time);
                break;
            end
        end
        avg_loc_error_prev = avg_loc_error_cur;
    end
    
    % collect localization stats
    loc_error=[];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if Node(i).well_determined==1
            loc_error =[loc_error sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
        end
    end

    if ~isempty(loc_error)
        average_loc_error = mean(loc_error)/TRANS_RANGE;
        std_loc_error = std(loc_error)/TRANS_RANGE;
        max_loc_error = max(loc_error)/TRANS_RANGE;
        coverage = length(loc_error)/(NUM_NODE*(1-BEACON_RATIO));
    else
        average_loc_error = 0;
        std_loc_error = 0;
        coverage = 0;
    end

    if FLOP_COUNT_FLAG == 1
        tol_flop = flops;
    else
        tol_flop = 0;
    end
    
    break_stage = time;

    %calculate the cumulative msg sent and bytes sent
    tol_msg_sent = 0;
    tol_bytes_sent = 0;
    for i=1:NUM_NODE
        tol_msg_sent = tol_msg_sent + Node(i).msg_count;
        tol_bytes_sent = tol_bytes_sent + Node(i).bytes_count;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using est
% position
function est_dist=est_DIST(A,B)
    global FLOP_COUNT_FLAG;
    est_dist=sqrt((A.est_pos(1)-B.est_pos(1))^2+(A.est_pos(2)-B.est_pos(2))^2);
    if FLOP_COUNT_FLAG == 1
        addflops(3*1 + flops_sqrt + 2*flops_pow(2));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node U calulate initial est using beacon info. to do lateration.
function U = beacon_lateration(U)
    global Node;
    global FLOP_COUNT_FLAG;
    % initialize matrix A and b.
    A=[];
    b=[];
    beacon_list = U.dv_vector(:,1)'; 
    
    tmp_dv_vector = U.dv_vector(:,2)';
    %
    % use correction to correct the distance_vector
    if FLOP_COUNT_FLAG == 1
        addflops(2);
    end
    if U.correction ~= 0
        tmp_dv_vector = tmp_dv_vector/U.correction;
        if FLOP_COUNT_FLAG == 1
            addflops(flops_div);
        end 
    end
    %
    
    counter = 0; % counter for sequence to access dv_vector
    
    for beacon_index = beacon_list
        counter = counter + 1; 
        if FLOP_COUNT_FLAG == 1
            addflops(1);
        end
        if FLOP_COUNT_FLAG == 1
            addflops(2);
        end
        l = ((U.est_pos - Node(beacon_index).est_pos)/est_DIST(U,Node(beacon_index)))';
        if FLOP_COUNT_FLAG == 1
            addflops(2*(1 + flops_div));
        end
        w = 1/sqrt(U.dv_vector(counter,3)^2 + Node(beacon_index).std^2);
        if FLOP_COUNT_FLAG == 1
            addflops(2*flops_pow(2) + flops_sqrt + flops_div);
        end
        A = [A; l*w];
        if FLOP_COUNT_FLAG == 1
            addflops(2*1);
        end
        b = [b;(tmp_dv_vector(counter) - est_DIST(U,Node(beacon_index)))*w];
        if FLOP_COUNT_FLAG == 1
            addflops(2);
        end
    end
    % solve the system using least-square
    U.est_pos = U.est_pos + (transpose(A)*A)^(-1)*transpose(A)*b;
    if FLOP_COUNT_FLAG == 1
        addflops(flops_mul(transpose(A),A) + flops_inv(size(A,2)) + flops_mul(size(A,2),size(A,1),size(A,2))  + size(A,1)*size(A,2) + 4);
    end
    C = (transpose(A)*A)^(-1);
    U.std = sqrt(0.5*(sum(C(:))));
    if FLOP_COUNT_FLAG == 1
        addflops(3+1+flops_sqrt);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node U calulate its own position using least-square lateration with its neighors only.
function U = neighbor_lateration(U)
    global Node;
    global WGN_DIST;
    global DIS_STD_RATIO;
    global FLOP_COUNT_FLAG;
    % initialize matrix A and b.
    A=[];
    b=[];
    
    neighbor_array = U.neighbor;
    
    for neighbor_index = neighbor_array
        l = ((U.est_pos - Node(neighbor_index).est_pos)/est_DIST(U,Node(neighbor_index)))';
        if FLOP_COUNT_FLAG == 1
            addflops(2*(1 + flops_div));
        end
        w = 1/sqrt((WGN_DIST(neighbor_index,U.id)*DIS_STD_RATIO)^2 + Node(neighbor_index).std^2);
        if FLOP_COUNT_FLAG == 1
            addflops(flops_div + flops_sqrt + 1 + flops_pow(2));
        end
        A = [A; l*w];
        if FLOP_COUNT_FLAG == 1
            addflops(1*2);
        end
        b = [b;(WGN_DIST(neighbor_index,U.id) - est_DIST(U,Node(neighbor_index)))*w]; 
        if FLOP_COUNT_FLAG == 1
            addflops(1*2);
        end
    end
    % solve the system using least-square
    % if the matrix is not ill-conditioned, update est_pos.
    if rcond(transpose(A)*A)>0.01
        U.est_pos = U.est_pos + (transpose(A)*A)^(-1)*transpose(A)*b;
        if FLOP_COUNT_FLAG == 1
            addflops(flops_mul(transpose(A),A) + flops_inv(size(A,2)) + flops_mul(size(A,2),size(A,1),size(A,2))  + size(A,1)*size(A,2) + 4);
        end
        C = (transpose(A)*A)^(-1);
        U.std = sqrt(0.5*(sum(C(:))));
        if FLOP_COUNT_FLAG == 1
            addflops(3+1+flops_sqrt);
        end
    end
end




    
    