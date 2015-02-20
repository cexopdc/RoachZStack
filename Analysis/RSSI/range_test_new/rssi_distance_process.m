delete 'mean_std_0.2m_3.0m.txt';

for i=0.2:0.2:3.0
    input = load(strcat(char(vpa(i,2)),'m'));
    input = input(1:1000,:);
    
    mean_rssi = mean(input);
    std_rssi = std(input);
    
    mean_rssi = num2str(mean_rssi);
    std_rssi = num2str(std_rssi);
    mean_std = [mean_rssi '	' std_rssi];
    
    dlmwrite('mean_std_0.2m_3.0m.txt', mean_std, 'delimiter','', '-append');
end

mean_std = load('mean_std_0.2m_3.0m.txt');
rho_mean = mean_std(:,1)';
rho_std = mean_std(:,2)';

figure
x = 0.2:0.2:3.0;
plot(x,rho_mean,'b');
xlim([0 3.2]);
xlabel('distance (m)');
ylabel('RSSI');
hold on;
h=errorbar(x,rho_mean,rho_std,'r'); set(h,'linestyle','none')