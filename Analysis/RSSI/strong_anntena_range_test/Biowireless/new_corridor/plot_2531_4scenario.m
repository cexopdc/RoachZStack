%clear all;close all;

cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/angle/small_fading_test/no_tube_flat;

mean_rssi = [];
std_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
    std_rssi = [std_rssi std(input)];
end

figure; hold on;
pos_id = 1:9;
%h = plot(pos_id,mean_rssi);
h_error=errorbar(pos_id,mean_rssi,std_rssi,'-','markersize', 5,'LineWidth', 2, 'color',[0 0.4470 0.7410]);
xlabel('Position ID');
ylabel('RSSI (dBm)');
legend('Indoor','location', 'Southeast');
%title('OUTSIDE CHAMBER: wifi\_no\_tube\_flat\_25Hz');
ylim([-90 -60]);
set(gca,'XTick',1:9);
%ylim([-50 -20]);
set(gca, 'box', 'on')
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/Biowireless/new_corridor/deep_fading_2530_plot_indoor.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/angle/small_fading_test/in_chamber/no_tube_flat;


mean_rssi = [];
std_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
    std_rssi = [std_rssi std(input)];
end

figure; hold on;
pos_id = 1:9;
%h = plot(pos_id,mean_rssi);
h_error=errorbar(pos_id,mean_rssi,std_rssi,'-','markersize', 5,'LineWidth', 2,'color',[0.8500    0.3250    0.0980]);
xlabel('Position ID');
ylabel('RSSI (dBm)');
legend('Anechoic chamber','location', 'Southeast');
%title('OUTSIDE CHAMBER: wifi\_no\_tube\_flat\_25Hz');
ylim([-90 -60]);
set(gca,'XTick',1:9);
%ylim([-50 -20]);
set(gca, 'box', 'on')
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/Biowireless/new_corridor/deep_fading_2530_plot_chamber.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test/outdoor/no_tube_flat/;
mean_rssi = [];
std_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
    std_rssi = [std_rssi std(input)];
end

figure; hold on;
pos_id = 1:9;
%h = plot(pos_id,mean_rssi);
h_error=errorbar(pos_id,mean_rssi,std_rssi,'-','markersize', 5,'LineWidth', 2,'color',[0.9290    0.6940    0.1250]);
xlabel('Position ID');
ylabel('RSSI (dBm)');
legend('Concrete field','location', 'Southeast');
%title('OUTSIDE CHAMBER: wifi\_no\_tube\_flat\_25Hz');
ylim([-90 -60]);
set(gca,'XTick',1:9);
%ylim([-50 -20]);
set(gca, 'box', 'on')
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/Biowireless/new_corridor/deep_fading_2530_plot_concrete_field.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');



cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test/grass/low/2530;
mean_rssi = [];
std_rssi = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
    std_rssi = [std_rssi std(input)];
end

figure; hold on;
pos_id = 1:9;
%h = plot(pos_id,mean_rssi);
h_error=errorbar(pos_id,mean_rssi,std_rssi,'-','markersize', 5,'LineWidth', 2,'color',[0.4940    0.1840    0.5560]);
xlabel('Position ID');
ylabel('RSSI (dBm)');
legend('Grass field','location', 'Southeast');
%title('OUTSIDE CHAMBER: wifi\_no\_tube\_flat\_25Hz');
ylim([-90 -60]);
set(gca,'XTick',1:9);
%ylim([-50 -20]);
set(gca, 'box', 'on')
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/Biowireless/new_corridor/deep_fading_2530_plot_grass.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

% cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test/grass/high/2530;
% mean_rssi_5 = [];
% for i=0:1:8
%     input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
%     input = input(1:500,:);
%     mean_rssi_5 = [mean_rssi_5 mean(input)];
% end



