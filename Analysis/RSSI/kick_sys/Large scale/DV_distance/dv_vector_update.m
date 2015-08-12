%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current distance
% to all the beacons it can reach.
function  A = dv_vector_update(A)
    global Node;
    global WGN_DIST;
    global DIS_STD_RATIO;
    global FLOP_COUNT_FLAG;
    global IWLSE_extra_flops;
    
    % if A has beacon dv_vector to broadcast
    if ~isempty(A.dv_vector)
        beacon_list = A.dv_vector(:,1)';
        % a msg sent to neighbor
        A.msg_count_dv_vector_update = A.msg_count_dv_vector_update + 1;
        % each beacon entry includes: a beacon (x,y), distance to that
        % beacon, and hop number(implicitly, for hop constraint purpose.) and for IWLSE, also dist_std 
        A.bytes_count_dv_vector_update = A.bytes_count_dv_vector_update + 4;
        % iterate all neighbors
        for neighbor_index = A.neighbor
            for beacon_index = beacon_list
                % if beacon not in neighbor's table, add directly
                if isempty(Node(neighbor_index).dv_vector)  
                    beacon_node_dist = A.dv_vector(A.dv_vector(:,1)==beacon_index,2); 
                    
                    beacon_neighbor_dist = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    if FLOP_COUNT_FLAG == 1
                        addflops(1);
                    end
                    % for hop constraint, implicitly
                    if FLOP_COUNT_FLAG == 1
                        addflops(2);
                    end
                    % update the dist_std 
                    beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                    IWLSE_extra_flops = IWLSE_extra_flops + 1 + flops_sqrt;
                    Node(neighbor_index).dv_vector = [Node(neighbor_index).dv_vector; beacon_index beacon_neighbor_dist beacon_neighbor_dist_std];
                if FLOP_COUNT_FLAG == 1
                    addflops(size(Node(neighbor_index).dv_vector(:,1),2));
                end    
                elseif ~any(Node(neighbor_index).dv_vector(:,1)==beacon_index) %~ismember(beacon_index,Node(neighbor_index).dv_vector(:,1))
                    beacon_node_dist = A.dv_vector(A.dv_vector(:,1)==beacon_index,2); 
                    beacon_neighbor_dist = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    if FLOP_COUNT_FLAG == 1
                        addflops(1);
                    end
                    % for hop constraint, implicitly
                    if FLOP_COUNT_FLAG == 1
                        addflops(2);
                    end
                    % update the dist_std 
                    beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                    IWLSE_extra_flops = IWLSE_extra_flops + 1 + flops_sqrt;
                    Node(neighbor_index).dv_vector = [Node(neighbor_index).dv_vector; beacon_index beacon_neighbor_dist  beacon_neighbor_dist_std];
                % if beacon is already in neighbor's table, compare and
                % update accordingly.
                else
                    beacon_neighbor_dist = Node(neighbor_index).dv_vector(Node(neighbor_index).dv_vector(:,1)==beacon_index,2);
                    beacon_node_dist = A.dv_vector(A.dv_vector(:,1)==beacon_index,2); 
                    % for hop constraint, implicitly
                    if FLOP_COUNT_FLAG == 1
                        addflops(2);
                    end
                    if FLOP_COUNT_FLAG == 1
                        addflops(3);
                    end
                    if beacon_neighbor_dist > beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id)
                        Node(neighbor_index).dv_vector(Node(neighbor_index).dv_vector(:,1)==beacon_index,2) = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                        if FLOP_COUNT_FLAG == 1
                            addflops(1);
                        end
                        % update the dist_std 
                        beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                        IWLSE_extra_flops = IWLSE_extra_flops + 1 + flops_sqrt;
                        Node(neighbor_index).dv_vector(Node(neighbor_index).dv_vector(:,1)==beacon_index,3) = beacon_neighbor_dist_std;
                    end  
                end
            end
        end
    end
end