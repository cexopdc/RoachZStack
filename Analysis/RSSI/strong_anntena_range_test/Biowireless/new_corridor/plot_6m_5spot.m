%aggregate rssi from 0.2 to 3.0m.
mean_matrix = [];
std_matrix = [];
for i=1:1:6
    mean_arrary = [];
    std_arrary = [];
    for j=1:1:5
        input = load(strcat(num2str(i),'m_',num2str(j),'.txt'));
        input = input(1:500,:);
        mean_rssi = mean(input);
        std_rssi = std(input);
        mean_arrary = [mean_arrary mean_rssi];
        std_arrary = [std_arrary std_rssi];
    end
    mean_matrix = [mean_matrix;mean_arrary];
    std_matrix = [std_matrix;std_arrary];
end
h = barwitherr(std_matrix,mean_matrix);
set(gca,'XTickLabel',{'1m','2m','3m','4m','5m','6m'})
set(gca,'YLim',[-100 -50]);
legend('Spot 1','Spot 2','Spot 3','Spot 4','Spot 5')
ylabel('RSSI (dBm)')
%set(h(1),'FaceColor','k');
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'6m_5spot.emf','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');