%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% With 5 diff spots for each distance, there're some RSSI values that
% haven't been picked up. Hence, we need to interpolate those RSSI values
% with distance mean and std. 

rssi_mean_std = load('cut_3m_dist_mean_std_diff_rssi.txt');
rssi_list = rssi_mean_std(:,1)';
for i=2:(rssi_mean_std(1,1) - rssi_mean_std(end,1) + 1)
    if rssi_mean_std(i,1) ~= rssi_mean_std(i-1,1)-1
        tmp_row = [rssi_mean_std(i-1,1)-1 (rssi_mean_std(i-1,2)+rssi_mean_std(i,2))/2  (rssi_mean_std(i-1,3)+rssi_mean_std(i,3))/2];

        rssi_mean_std = [rssi_mean_std(1:(i-1),:);tmp_row;rssi_mean_std(i:end,:)];
    end
end
dlmwrite('cut_3m_interp_dist_mean_std_diff_rssi.txt', rssi_mean_std, 'delimiter','\t');
        