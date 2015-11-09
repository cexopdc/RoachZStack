function U = min_max(U)
    global Node;
    global DIS_MAP;
    % The intersections of the bounding box are: [max(x_i-d_i),max(y_i-d_i)],[min(x_i+d_i),max(y_i+d_i)]
    tmp_dv_vector = [DIS_MAP(U.id,1) DIS_MAP(U.id,2) DIS_MAP(U.id,3) DIS_MAP(U.id,4) DIS_MAP(U.id,5)];
    % initialize x_minus_d_arrary,y_minus_d_arrary,x_plus_d_arrary,y_plus_d_arrary
    x_minus_d_arrary = [];
    y_minus_d_arrary = [];
    x_plus_d_arrary = [];
    y_plus_d_arrary = [];
    for i = 1:1:length(tmp_dv_vector)
        x_minus_d_arrary = [x_minus_d_arrary Node(i).x-tmp_dv_vector(i)];
        y_minus_d_arrary = [y_minus_d_arrary Node(i).y-tmp_dv_vector(i)];
        x_plus_d_arrary = [x_plus_d_arrary Node(i).x+tmp_dv_vector(i)];
        y_plus_d_arrary = [y_plus_d_arrary Node(i).y+tmp_dv_vector(i)];
    end
    bottom_left_corner = [max(x_minus_d_arrary) max(y_minus_d_arrary)];
    top_right_corner = [min(x_plus_d_arrary) min(y_plus_d_arrary)];
    new_est = (bottom_left_corner + top_right_corner)/2;
    new_est = new_est';
    U.est_x = new_est(1);
    U.est_y = new_est(2);
end