clc;clear all; close all;
delete 'mean_std*.txt';
figure(1);
hold on;
k=1; % counter for the legend
for j=[0 50 100]
    for i=1.0:1:30
        input = load(strcat(sprintf('%0.1f',i),'m_',num2str(j),'cm.txt'));
        input = input(1:1000,:);

        mean_rssi = mean(input);
        std_rssi = std(input);

        mean_rssi = num2str(mean_rssi);
        std_rssi = num2str(std_rssi);
        mean_std = [mean_rssi '	' std_rssi];

        output = strcat('mean_std_',num2str(j),'cm.txt');
        dlmwrite(output, mean_std, 'delimiter','', '-append');
    end
    mean_std = load(output);
    rho_mean = mean_std(:,1)';
    rho_std = mean_std(:,2)';
    x = 1.0:1:30;
    xlim([0 30.2]);
    xlabel('distance (m)');
    ylabel('RSSI');
    if j == 0 
        h(k)=plot(x,rho_mean,'b');
        hold on;
        %h_error=errorbar(x,rho_mean,rho_std,'b'); 
        k = k+1;
    elseif j == 50
        h(k)=plot(x,rho_mean,'r');
        hold on;
        %h_error=errorbar(x,rho_mean,rho_std,'r'); 
        k = k+1;
    else 
        h(k)=plot(x,rho_mean,'y');
        hold on;
        %h_error=errorbar(x,rho_mean,rho_std,'y'); 
        k = k+1;   
    end
end

%
mean_std = load('0cm_0cm_mean_std.txt');
rho_mean = mean_std(:,1)';
rho_std = mean_std(:,2)';
x = [0.3:0.3:15.0 15.9:0.9:30.3];
h(4) = plot(x,rho_mean);
%}
legend(h(1:4),'0cm','50cm','100cm','both 0cm');
