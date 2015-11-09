function U = N_hop_refine(U)
    global Node;
    global DIS_MAP;
    % initialize matrix A and b.
    A=[];
    b=[];
    
    neighbor_array = [];
    for i=1:15
        if i~=U.id
            neighbor_array = [neighbor_array i];
        end
    end
    
    n= neighbor_array(end); % the last neighbor 
    for neighbor_index = neighbor_array
        if neighbor_index ~= n
            A=[A;2*(Node(neighbor_index).est_x-Node(n).est_x) 2*(Node(neighbor_index).est_y-Node(n).est_y)];
            b=[b;(Node(neighbor_index).est_x)^2 - (Node(n).est_x)^2 + (Node(neighbor_index).est_y)^2 - (Node(n).est_y)^2 + DIS_MAP(U.id,n)^2 - DIS_MAP(U.id,neighbor_index)^2];
        end
    end
    % solve the system using least-square
    % if the matrix is not ill-conditioned, update est_pos.
    if rcond(transpose(A)*A)>0.1
        est_pos = (transpose(A)*A)^(-1)*transpose(A)*b;
        U.est_x = est_pos(1);
        U.est_y = est_pos(2);
    end
end