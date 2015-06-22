%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current distance
% to all the beacons it can reach.
function  A = dv_vector_update(A)
    global Node;
    global WGN_DIST;
    global DIS_STD_RATIO;
    
    % if A has beacon dv_vector to broadcast
    if ~isempty(A.dv_vector)
        beacon_list = A.dv_vector(:,1)';
        % iterate all neighbors
        for neighbor_index = A.neighbor
            for beacon_index = beacon_list
                % if beacon not in neighbor's talbe, add directly
                if isempty(Node(neighbor_index).dv_vector) 
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    beacon_neighbor_dist = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    % update the dist_std 
                    beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                    Node(neighbor_index).dv_vector = [Node(neighbor_index).dv_vector; beacon_index beacon_neighbor_dist beacon_neighbor_dist_std];
                elseif ~ismember(beacon_index,Node(neighbor_index).dv_vector(:,1))
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    beacon_neighbor_dist = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                    % update the dist_std 
                    beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                    Node(neighbor_index).dv_vector = [Node(neighbor_index).dv_vector; beacon_index beacon_neighbor_dist  beacon_neighbor_dist_std];
                % if beacon is already in neighbor's table, compare and
                % update accordingly.
                else
                    beacon_neighbor_dist = Node(neighbor_index).dv_vector(find(Node(neighbor_index).dv_vector(:,1)==beacon_index),2);
                    beacon_node_dist = A.dv_vector(find(A.dv_vector(:,1)==beacon_index),2); 
                    if beacon_neighbor_dist > beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id)
                        Node(neighbor_index).dv_vector(find(Node(neighbor_index).dv_vector(:,1)==beacon_index),2) = beacon_node_dist + WGN_DIST(A.id,Node(neighbor_index).id);
                        % update the dist_std 
                        beacon_neighbor_dist_std = sqrt((beacon_node_dist*DIS_STD_RATIO)^2 + (WGN_DIST(A.id,Node(neighbor_index).id)*DIS_STD_RATIO)^2);
                        Node(neighbor_index).dv_vector(find(Node(neighbor_index).dv_vector(:,1)==beacon_index),3) = beacon_neighbor_dist_std;
                    end  
                end
            end
        end
    end
end