%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  N-hop multilateration algorithm
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function N_hop_lateration
    global NUM_NODE;
    global Node;
    global BEACON_RATIO;
    global DV_vector;
    DV_vector = ones(NUM_NODE)*10000; % initialize the DV_vector matrix

    %Phase 1: Collaborative subtree
    
    
    %Phase 2.1: get distance vectors for all the unknown nodes
    for i=1:NUM_NODE
        DV_vector(i,i) = 0;
        if strcmp(Node(i).attri,'beacon')
            Node(i) = broadcast(Node(i),Node(i));
        end
    end                 

    %Phase 2: Node position - lateration
    for i= round(NUM_NODE*BEACON_RATIO)+1:NUM_NODE
        if length(Node(i).beacon_array)>2
            Node(i) = lateration(Node(i));
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current distance
% to beacon B and its neighbors will update accordingly.
function  boolean = isCollaborative(node,callerID,isInitiator)
    if isInitiator == true 
        limit = 3;
    else
        limit = 2;
    end
    count = beaconCount(node);
    if count >= limit 
        return true;
    end
    for each unknown neighbor i not previously visited
        if isCollaborative(i,node,false)
            count = count + 1;
        end
        if count == limit
            return true;
        end
    end
    return false;
end
     


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A broadcasts to its neighbors its current distance
% to beacon B and its neighbors will update accordingly.
function  A = broadcast(A,B)
    global DV_vector;
    global Node;
    global WGN_DIST;
    % store B into A's beacon array if not already stored.
    if ~any(A.beacon_array==B.id)
        A.beacon_array = [A.beacon_array B.id];
    end
    neighbor_array = A.neighbor;
    for neighbor_index = neighbor_array
        if DV_vector(B.id,neighbor_index) > (DV_vector(B.id,A.id) + WGN_DIST(A.id,Node(neighbor_index).id))   
            DV_vector(B.id,neighbor_index) = DV_vector(B.id,A.id) + WGN_DIST(A.id,Node(neighbor_index).id);
            Node(neighbor_index) = broadcast(Node(neighbor_index),B);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node U calulate its own position using least-square lateration.
function U = lateration(U)
    global Node;
    global DV_vector;
    % initialize matrix A and b.
    A=[];
    b=[];
    n= U.beacon_array(end); % the last beacon 
    for beacon_index = U.beacon_array
        if beacon_index ~= n
            A=[A;2*(Node(beacon_index).pos(1)-Node(n).pos(1)) 2*(Node(beacon_index).pos(2)-Node(n).pos(2))];
            b=[b;(Node(beacon_index).pos(1))^2 - (Node(n).pos(1))^2 + (Node(beacon_index).pos(2))^2 - (Node(n).pos(2))^2 + DV_vector(n,U.id)^2 - DV_vector(beacon_index,U.id)^2];
        end
    end
    % solve the system using least-square
    U.est_pos = (transpose(A)*A)^(-1)*transpose(A)*b;
end
    

