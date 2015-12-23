%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A gets a broadcast from its neighbor B containing
% B's loc, A will update its own loc and std.
function [A,dis_std] = kick_loc_kalman_2nodes_2531(A,B,rssi)
    % if A has no est yet, it will use B as its current est. 
    global STD_INITIAL;
    %global RSSI_DIS_MEAN_STD;
    % got the dis and dis_std from the mapping.
    %dis = RSSI_DIS_MEAN_STD(-rssi-41,1);
    %dis_std = RSSI_DIS_MEAN_STD(-rssi-41,2);
    global RSSI_DIS;
    min_rssi = RSSI_DIS(end,1);
    max_rssi = RSSI_DIS(1,1);
    % if rssi out of calibration range, treat it as boundary values.
    if rssi > max_rssi
        rssi = max_rssi;
    end
    if rssi < min_rssi
        return;
    end
    dis = RSSI_DIS(RSSI_DIS(:,1)==rssi,2);
    dis_std = RSSI_DIS(RSSI_DIS(:,1)==rssi,3);
    if dis_std <0.01
        dis_std = 0.01;
    end
    if isequal(A.cov,[STD_INITIAL^2 0;0 STD_INITIAL^2])
        if ~isequal(B.cov,[STD_INITIAL^2 0;0 STD_INITIAL^2]) % if B also has no est, do nothing
            A.est_x = B.est_x;
            A.est_y = B.est_y;
            A.cov = B.cov + [dis^2 0;0 dis^2] + [dis_std^2 0;0 dis_std^2];
            % store the current helper_node info
            A.helper_node.est_x = B.est_x;
            A.helper_node.est_y = B.est_y;
            A.helper_node.cov = B.cov;
            A.helper_node.dis = dis;
            A.helper_node.dis_std = dis_std;
        end
    % if A has an est already, it will add a kick factor to its current est.
    else
        if isequal(B.cov,[STD_INITIAL^2 0;0 STD_INITIAL^2]) || (A.est_x == B.est_x && A.est_y == B.est_y) 
            % if B also has no est, do nothing; if A and B have same est, do
            % nothing. FOR STATIC SYSTEM, and we're assuming the RSSI
            % measurement is fixed at the beginning.
        else
            A = kick_kalman_2nodes_cal(A,B,dis,dis_std);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function: calculate the kick
function A = kick_kalman_2nodes_cal(A,B,dis,dis_std)

    % calculate delta_d
    delta_d = (A.helper_node.dis)^2 - dis^2  - (est_DIST(A.helper_node,A))^2 + (est_DIST(A,B))^2;
    % calculate H_i and H_j 
    [H_i,H_j,H_k] = two_node_jacobian(A,A.helper_node,B);
    % set cov_d=(DIS_STD_RATIO * d)^2, hence in accordance with std_d = DIS_STD_RATIO * d
    %cov_d = (DIS_STD_RATIO * d)^2;
    % cov of measurement (d_ij)^2-(d_ik)^2
    cov_measurement = (2*(dis_std)^4+4*(dis * dis_std)^2) + ...
        (2*A.helper_node.dis_std^4+4*(A.helper_node.dis*A.helper_node.dis_std)^2);
    % calculate K, commented the original one and use the simplified one
    %K = A.cov*transpose(H_i)/(H_i*A.cov*transpose(H_i) + H_j*B.cov*transpose(H_j) + cov_d)
    K = A.cov*transpose(H_i)/(H_i*A.cov*transpose(H_i) + H_j*A.helper_node.cov*transpose(H_j) + H_k*B.cov*transpose(H_k) + cov_measurement);
    % calculate kick.pos, which will add to the current pos.
    kick.pos = K * delta_d;
    % calculate the post covariance of node A
    kick.cov = (eye(2,2) - K*H_i) * A.cov;
    
    A.est_x = A.est_x + kick.pos(1);
    A.est_y = A.est_y + kick.pos(2);
    A.cov = kick.cov;
    
    % update the current helper_node info
    A.helper_node.est_x = B.est_x;
    A.helper_node.est_y = B.est_y;
    A.helper_node.cov = B.cov;
    A.helper_node.dis = dis;
    A.helper_node.dis_std = dis_std;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, to calculate the distance between two nodes using est
% position
function est_dist=est_DIST(A,B)
    est_dist=sqrt((A.est_x-B.est_x)^2+(A.est_y-B.est_y)^2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%