function RSSI_DIS = lin_dis_std(RSSI_DIS)
%lin_dis_std compute the linear fitting of distance and std.
%   take in the RSSI_DIS as input, and perform a linear fitting to get the
%   fitted dis std. output is the updated RSSI_DIS
    %RSSI_DIS = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Wolfbot_21cm/cut_3m_rssi_dis_weighted_fitting.txt');
    dis = RSSI_DIS(:,2);
    std = RSSI_DIS(:,3);
    Dis = [ones(length(dis),1) dis];
    b = Dis\std;
    std_fitted = Dis*b;
    RSSI_DIS(:,3) = std_fitted;
    
    %{
    RSSI_DIS_original = load('/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/2531calibration/Wolfbot_21cm/cut_3m_interp_dist_mean_std_diff_rssi.txt');
    x1 = RSSI_DIS_original(:,1);
    y1 = RSSI_DIS_original(:,2);
    plot(x1,y1,'b*',x1,dis,'-r','LineWidth',2,'MarkerSize',6);
    ylabel('distance (m)'); 
    xlabel('RSSI');
    legend('original data','Nonlinear Regression');
    hold on;
    errorbar(x1,y1,std,'bo','markersize', 5);
    errorbar(x1,dis,std_fitted,'r','markersize', 5);
    title('RSSI vs Distance weighted fitting (std fitted)');
    exportfig(gcf,'rssi_dis_weighted_std_fitting.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

    %{
    scatter(dis,std)
    hold on
    plot(dis,std_fitted)
    %}
    
    %}
    
end

