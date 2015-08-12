%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  N-hop multilateration algorithm
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [average_loc_error,std_loc_error, coverage,tol_flop,break_stage,tol_msg_sent,tol_bytes_sent] = N_hop_lateration
    global Length;
    global Width;
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global STAGE_NUMBER;
    global STAGE_FLAG;
    global TRANS_RANGE;
    global FLOP_COUNT_FLAG;
    flops(0); %%start global flop count at 0
    
    % set nodes est coordinates, time scheduling
    for i=1:NUM_NODE
        Node(i).msg_count = 0;
        Node(i).bytes_count = 0;
        if (i <= round(NUM_NODE*BEACON_RATIO)) % beacon
            Node(i).est_pos = Node(i).pos;
            Node(i).well_determined=1; % set beacon as well-determined.
        else                            % unknown
            Node(i).est_pos = [Width*0.5;Length*0.5]; % set initial est_pos at center.
            Node(i).well_determined=0; % set unknowns as not well-determined.
        end
    end

    % find well-determined unknowns, and apply min_max for initial
    % localization
    for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if FLOP_COUNT_FLAG == 1
            addflops(2);
        end
        if ~isempty(Node(i).dv_vector)
            beacon_list = Node(i).dv_vector(:,1)';
            if length(beacon_list)>2
                Node(i).well_determined=1;
                Node(i) = min_max(Node(i));
            end
        end
    end
    
    % initial loc_error %
    loc_error_prev = [];
    for i=round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        node_loc_error = sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)/TRANS_RANGE;
        if size(Node(i).dv_vector,1) > 2
            loc_error_prev = [loc_error_prev node_loc_error];
        end
    end
    avg_loc_error_prev = mean(loc_error_prev);
    
    % Refinement phase: well-determined unknowns using neighbor info. to
    % localize, using least-square
    for time = 0:STAGE_NUMBER
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % this part solely for msg collection purpose.
        %
        for i = 1:NUM_NODE
            Node(i).msg_count = Node(i).msg_count + 1;
            Node(i).bytes_count = Node(i).bytes_count + 1*2;  % x,y          
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i = round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
            if FLOP_COUNT_FLAG == 1
                addflops(2);
            end
            if Node(i).well_determined==1
                if length(Node(i).neighbor)>2
                    Node(i) = lateration(Node(i));
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
% sub-function, node U calulate its own position using simple min_max.
function U = min_max(U)
    global Node;
    global FLOP_COUNT_FLAG;
    % The intersections of the bounding box are: [max(x_i-d_i),max(y_i-d_i)],[min(x_i+d_i),max(y_i+d_i)]
    tmp_dv_vector = U.dv_vector;
    % initialize x_minus_d_arrary,y_minus_d_arrary,x_plus_d_arrary,y_plus_d_arrary
    x_minus_d_arrary = [];
    y_minus_d_arrary = [];
    x_plus_d_arrary = [];
    y_plus_d_arrary = [];
    for i = 1:1:length(tmp_dv_vector)
        if FLOP_COUNT_FLAG == 1
            addflops(4*1);
        end
        x_minus_d_arrary = [x_minus_d_arrary Node(tmp_dv_vector(i,1)).pos(1)-tmp_dv_vector(i,2)];
        y_minus_d_arrary = [y_minus_d_arrary Node(tmp_dv_vector(i,1)).pos(2)-tmp_dv_vector(i,2)];
        x_plus_d_arrary = [x_plus_d_arrary Node(tmp_dv_vector(i,1)).pos(1)+tmp_dv_vector(i,2)];
        y_plus_d_arrary = [y_plus_d_arrary Node(tmp_dv_vector(i,1)).pos(2)+tmp_dv_vector(i,2)];
    end
    if FLOP_COUNT_FLAG == 1
        addflops(size(x_minus_d_arrary,2)*2*2 + 1 + flops_div);
    end
    bottom_left_corner = [max(x_minus_d_arrary) max(y_minus_d_arrary)];
    top_right_corner = [min(x_plus_d_arrary) min(y_plus_d_arrary)];
    new_est = (bottom_left_corner + top_right_corner)/2;
    U.est_pos = new_est';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node U calulate its own position using least-square lateration with its neighors only.
function U = lateration(U)
    global Node;
    global WGN_DIST;
    global FLOP_COUNT_FLAG;
    % initialize matrix A and b.
    A=[];
    b=[];
    
    neighbor_array = U.neighbor;
    n= neighbor_array(end); % the last neighbor 
    for neighbor_index = neighbor_array
        if FLOP_COUNT_FLAG == 1
            addflops(2);
        end
        if neighbor_index ~= n
            A=[A;2*(Node(neighbor_index).est_pos(1)-Node(n).est_pos(1)) 2*(Node(neighbor_index).est_pos(2)-Node(n).est_pos(2))];
            if FLOP_COUNT_FLAG == 1
                addflops(4);
            end
            b=[b;(Node(neighbor_index).est_pos(1))^2 - (Node(n).est_pos(1))^2 + (Node(neighbor_index).est_pos(2))^2 - (Node(n).est_pos(2))^2 + WGN_DIST(n,U.id)^2 - WGN_DIST(neighbor_index,U.id)^2];
            if FLOP_COUNT_FLAG == 1
                addflops(6*flops_pow(2) + 5*1);
            end
        end
    end
    % solve the system using least-square
    % if the matrix is not ill-conditioned, update est_pos.
    if rcond(transpose(A)*A)>0.1
        U.est_pos = (transpose(A)*A)^(-1)*transpose(A)*b;
    end
    if FLOP_COUNT_FLAG == 1
        addflops(flops_mul(transpose(A),A) + flops_inv(size(A,2)) + flops_mul(size(A,2),size(A,1),size(A,2))  + size(A,1)*size(A,2));
    end
end
