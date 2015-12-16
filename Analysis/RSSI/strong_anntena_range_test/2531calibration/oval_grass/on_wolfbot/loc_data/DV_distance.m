%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function, node U calulate its own position using least-square lateration.
function U = DV_distance(U)
    global Node;
    global DIS_MAP;
    % initialize matrix A and b.
    A=[];
    b=[];
    beacon_list = [1 2 3 4 5];
    n= beacon_list(end); % the last beacon 
   
    tmp_dv_vector = [DIS_MAP(U.id,1) DIS_MAP(U.id,2) DIS_MAP(U.id,3) DIS_MAP(U.id,4) DIS_MAP(U.id,5)];
    
    counter = 0; % counter for sequence to access dv_vector
    
    for beacon_index = beacon_list
        counter = counter + 1;
        if beacon_index ~= n
            A=[A;2*(Node(beacon_index).est_x-Node(n).est_x) 2*(Node(beacon_index).est_y-Node(n).est_y)];
            b=[b;(Node(beacon_index).est_x)^2 - (Node(n).est_x)^2 + (Node(beacon_index).est_y)^2 - (Node(n).est_y)^2 + tmp_dv_vector(size(tmp_dv_vector,2))^2 - tmp_dv_vector(counter)^2
];
        end
    end
    % solve the system using least-square
    est_pos = (transpose(A)*A)^(-1)*transpose(A)*b; 
    U.est_x = est_pos(1);
    U.est_y = est_pos(2);
end