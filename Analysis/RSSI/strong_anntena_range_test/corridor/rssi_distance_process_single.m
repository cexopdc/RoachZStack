delete 'mean_std_0.3m_66.0m.txt';
clc;clear all; close all;
for i=0.3:0.3:5.1
    input = load(strcat(sprintf('%0.1f',i),'m_4.txt'));
    input = input(1:1000,:);
    
    mean_rssi = mean(input);
    std_rssi = std(input);
    
    mean_rssi = num2str(mean_rssi);
    std_rssi = num2str(std_rssi);
    mean_std = [mean_rssi '	' std_rssi];
    
    dlmwrite('mean_std_0.3m_66.0m.txt', mean_std, 'delimiter','', '-append');
end

for i=6.0:0.9:15.0
    input = load(strcat(sprintf('%0.1f',i),'m_4.txt'));
    input = input(1:1000,:);
    
    mean_rssi = mean(input);
    std_rssi = std(input);
    
    mean_rssi = num2str(mean_rssi);
    std_rssi = num2str(std_rssi);
    mean_std = [mean_rssi '	' std_rssi];
    
    dlmwrite('mean_std_0.3m_66.0m.txt', mean_std, 'delimiter','', '-append');
end

for i=18.0:3.0:66.0
    input = load(strcat(sprintf('%0.1f',i),'m_4.txt'));
    input = input(1:1000,:);
    
    mean_rssi = mean(input);
    std_rssi = std(input);
    
    mean_rssi = num2str(mean_rssi);
    std_rssi = num2str(std_rssi);
    mean_std = [mean_rssi '	' std_rssi];
    
    dlmwrite('mean_std_0.3m_66.0m.txt', mean_std, 'delimiter','', '-append');
end

mean_std = load('mean_std_0.3m_66.0m.txt');
rho_mean = mean_std(:,1)';
rho_std = mean_std(:,2)';

figure
%x = 0.3:0.3:15.0;
%rho_mean =rho_mean(1,1:50);
%rho_std =rho_std(1,1:50);
x = [0.3:0.3:5.1 6.0:0.9:15.0 18.0:3.0:66.0];
plot(x,rho_mean,'b');
xlim([0 69.2]);
xlabel('distance (m)');
ylabel('RSSI');
hold on;
h=errorbar(x,rho_mean,rho_std,'b'); set(h,'linestyle','none');