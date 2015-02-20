delete 'mean_std_1m.txt';

for i=0:10:350
    input = load(strcat('1m_',num2str(i),'degree.txt'));
    input = input(1:1000,:);
    
    mean_rssi = mean(input);
    std_rssi = std(input);
    
    mean_rssi = num2str(mean_rssi);
    std_rssi = num2str(std_rssi);
    mean_std = [mean_rssi '	' std_rssi];
    
    dlmwrite('mean_std_1m.txt', mean_std, 'delimiter','', '-append');
end

theta = 0:pi/18:(2*pi-pi/18);
mean_std = load('mean_std_1m.txt');
rho_mean = mean_std(:,1)';
rho_std = mean_std(:,2)';

max_mean = max(rho_mean)
min_mean = min(rho_mean)
max_std = max(rho_std)
min_std = min(rho_std)

figure
subplot(1,2,1)
%set the range of the mean in the polar plot
Range_mean = [-80 -60];

polar2(theta,rho_mean,R)
lh=legend('mean');
set(lh,'location', 'Best');
title('Polar plot of mean rssi','FontSize',14)

hold on
subplot(1,2,2)
%set the range of the std in the polar plot
Range_std = [0 1.23];
polar2(theta,rho_std,Range_std,'r')
lh=legend('std');
set(lh,'location', 'Best');
%set(lh,'FontSize',18);
title('Polar plot of rssi std','FontSize',14)

figure
x = 0:10:350;
plot(x,rho_mean,'b');
xlim([0 360]);
xlabel('Angle');
ylabel('RSSI');
hold on;
h=errorbar(x,rho_mean,rho_std,'r'); set(h,'linestyle','none')

%{
figure
bar(x,rho_mean)
hold on;
h=errorbar(x,rho_mean,rho_std,'c'); set(h,'linestyle','none')
%}

