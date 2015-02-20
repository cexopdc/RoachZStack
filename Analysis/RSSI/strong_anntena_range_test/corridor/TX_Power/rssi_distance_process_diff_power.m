clc;clear all; close all;
delete 'mean_std*.txt';
figure(1);
hold on;
k=1; % counter for the legend
for j=[4.5 -3 -10]
    for i=3.0:3:60
        if (j == -10) && (i == 60)
            ;
        else
            input = load(strcat(sprintf('%0.1f',i),'m_',num2str(j),'dbm.txt'));
            input = input(1:1000,:);

            mean_rssi = mean(input);
            std_rssi = std(input);

            mean_rssi = num2str(mean_rssi);
            std_rssi = num2str(std_rssi);
            mean_std = [mean_rssi '	' std_rssi];

            output = strcat('mean_std_',num2str(j),'dbm.txt');
            dlmwrite(output, mean_std, 'delimiter','', '-append');
        end
    end
    if j == -10
        mean_std = load(output);
        rho_mean = mean_std(:,1)';
        rho_std = mean_std(:,2)';
        x = 3.0:3:57;
        h(k)=plot(x,rho_mean,'b');
        xlim([0 60.2]);
        xlabel('distance (m)');
        ylabel('RSSI');
        hold on;
        h_error = errorbar(x,rho_mean,rho_std,'b'); 
    else
        mean_std = load(output);
        rho_mean = mean_std(:,1)';
        rho_std = mean_std(:,2)';
        x = 3.0:3:60;
        if j == 4.5
            h(k)=plot(x,rho_mean,'r');
            k = k+1;
            xlim([0 60.2]);
            xlabel('distance (m)');
            ylabel('RSSI');
            hold on;
            h_error = errorbar(x,rho_mean,rho_std,'r'); 
        else 
            h(k)=plot(x,rho_mean,'y');
            k = k+1;
            xlim([0 60.2]);
            xlabel('distance (m)');
            ylabel('RSSI');
            hold on;
            h_error = errorbar(x,rho_mean,rho_std,'y'); 
        end
    end
    %h=errorbar(x,rho_mean,rho_std); set(h,'linestyle','none');
end
legend(h(1:3),'4.5dBm','-3dBm','-10dBm');