function U = IWLSE_refine(U)
    global Node;
    global DIS_MAP;
    global DIS_STD_MAP;
    % initialize matrix A and b.
    A=[];
    b=[];
    
    neighbor_array = [];
    for i=1:15
        if i~=U.id
            neighbor_array = [neighbor_array i];
        end
    end
    
    for neighbor_index = neighbor_array
        l=[(U.est_x-Node(neighbor_index).est_x)/sqrt((U.est_x-Node(neighbor_index).est_x)^2+(U.est_y-Node(neighbor_index).est_y)^2) (U.est_y-Node(neighbor_index).est_y)/sqrt((U.est_x-Node(neighbor_index).est_x)^2+(U.est_y-Node(neighbor_index).est_y)^2)];
        w=1/sqrt(DIS_STD_MAP(U.id,neighbor_index)^2 + Node(neighbor_index).std^2);
        A=[A;l*w];
        b=[b;(DIS_MAP(U.id,neighbor_index) - sqrt((U.est_x-Node(neighbor_index).est_x)^2+(U.est_y-Node(neighbor_index).est_y)^2))*w];
    end
    % solve the system using least-square
    % if the matrix is not ill-conditioned, update est_pos.
    if rcond(transpose(A)*A)>0.1
        est_pos = (transpose(A)*A)^(-1)*transpose(A)*b;
        U.est_x = U.est_x + est_pos(1);
        U.est_y = U.est_y + est_pos(2);
        C = (transpose(A)*A)^(-1);
        U.std = sqrt(0.5*(sum(C(:))));
    end
end