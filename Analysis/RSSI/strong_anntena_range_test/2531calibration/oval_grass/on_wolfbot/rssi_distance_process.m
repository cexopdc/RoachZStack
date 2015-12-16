delete 'diff_spot_mean_std*.txt';
figure(1);
hold on;

%aggregate rssi from 1 to 10m.
aggr_mean_rssi=[];
aggr_std_rssi=[];

for i=1.0:1:10.0
    aggr_input = []; % aggregate input for 5 random spots.
    for j=1:1:5
        input = load(strcat(char(vpa(i,2)),'m_',num2str(j),'.txt')); 
        input = input(1:500,:);

        mean_rssi = mean(input);
        std_rssi = std(input);

        mean_rssi = num2str(mean_rssi);
        std_rssi = num2str(std_rssi);
        mean_std = [mean_rssi '	' std_rssi];
        aggr_input = [aggr_input;input];
        ouput_file = strcat('diff_spot_mean_std_',char(vpa(i,2)),'m.txt');
        dlmwrite(ouput_file, mean_std, 'delimiter','', '-append');
    end

    
    mean_std = load(ouput_file);
    rho_mean = mean_std(:,1)';
    rho_std = mean_std(:,2)';
    x = i;
    for j=1:1:5
        h(1)=plot(x,rho_mean(1,j),'ro','markersize', 5);
        h_error=errorbar(x,rho_mean(1,j),rho_std(1,j),'r','markersize', 5); %set(h,'linestyle','none');
    end
    %get the mean and std for aggr_input
    aggr_mean_rssi = [aggr_mean_rssi;mean(aggr_input)];
    aggr_std_rssi = [aggr_std_rssi;std(aggr_input)];
    
end

%plot(x,mean_aggr,'b*','markersize', 10);
x = 1.0:1:10.0;
aggr_mean_rssi = aggr_mean_rssi';
aggr_std_rssi = aggr_std_rssi';
h(2)=plot(x,aggr_mean_rssi,'bo','markersize', 5);
h_error=errorbar(x,aggr_mean_rssi,aggr_std_rssi,'bo','markersize', 5); %set(h,'linestyle','none');
xlabel('distance (m)');
ylabel('RSSI');
xlim([0 10.5]);
legend(h(1:2),'Each spot','Aggregate of 5 spot');
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'result_fig/dis_vs_RSSI_5_spot.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');




