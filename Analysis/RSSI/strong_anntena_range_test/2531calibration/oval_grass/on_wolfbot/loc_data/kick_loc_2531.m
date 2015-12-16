%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function, node A gets a broadcast from its neighbor B containing
% B's loc, A will update its own loc and std.
function [A,dis_std] = kick_loc_2531(A,B,rssi)
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
    if A.std == STD_INITIAL
        if B.std ~= STD_INITIAL % if B also has no est, do nothing
            A = kick_cal(A,B,dis,dis_std);
        end
    % if A has an est already, it will add a kick factor to its current est.
    else
        if (B.std == STD_INITIAL) || (A.est_x == B.est_x && A.est_y == B.est_y) 
            % if B also has no est, do nothing; if A and B have same est, do
            % nothing. FOR STATIC SYSTEM, and we're assuming the RSSI
            % measurement is fixed at the beginning.
        else
            A = kick_cal(A,B,dis,dis_std);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub-function: calculate the kick
function A = kick_cal(A,B,dis,dis_std)
    %calculate est_d
	est_d = sqrt((A.est_x - B.est_x)^2 + (A.est_y - B.est_y)^2);
    %calculate delta_d
    delta_d_x = (est_d - dis) * (B.est_x - A.est_x)/est_d;
    delta_d_y = (est_d - dis) * (B.est_y - A.est_y)/est_d;
    %calculate the std of the update
    std_update = sqrt(dis_std^2 + (B.std)^2);
    %calculate the alpha factor
    alpha = A.std/(A.std + std_update);
    % update the est_std
    A.std = alpha*std_update + (1 - alpha)*A.std;
    % update the est
    A.est_x = A.est_x + alpha * delta_d_x;
    A.est_y = A.est_y + alpha * delta_d_y;
end