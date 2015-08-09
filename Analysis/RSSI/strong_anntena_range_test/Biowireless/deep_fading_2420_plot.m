clear all;close all;

%{
cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test;

%for outside chamber
cd no_tube_flat/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi = [mean_rssi mean(input)];
end


mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end

figure;
pos_id = 1:9;
subplot(3,2,1)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('OUTSIDE CHAMBER: no\_tube\_flat');
ylim([-85 -50]);

cd ../with_tube_flat/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi = [mean_rssi mean(input)];
end

mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end


pos_id = 1:9;
subplot(3,2,3)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('OUTSIDE CHAMBER: with\_tube\_flat');
ylim([-85 -50]);

cd ../with_tube_tilt/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi = [mean_rssi mean(input)];
end

mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end


pos_id = 1:9;
subplot(3,2,5)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('OUTSIDE CHAMBER: with\_tube\_tilt');
ylim([-85 -50]);

% for in chamber
cd ../IN_CHAMBER/;
cd no_tube_flat/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi = [mean_rssi mean(input)];
end

mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end


pos_id = 1:9;
subplot(3,2,2)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('IN CHAMBER: no\_tube\_flat');
ylim([-85 -50]);

cd ../with_tube_flat/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi = [mean_rssi mean(input)];
end

mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end


pos_id = 1:9;
subplot(3,2,4)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('IN CHAMBER: with\_tube\_flat');
ylim([-85 -50]);

cd ../with_tube_tilt/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi = [mean_rssi mean(input)];
end

mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:1000,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end


pos_id = 1:9;
subplot(3,2,6)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('IN CHAMBER: with\_tube\_tilt');
ylim([-85 -50]);
%}

cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/angle/small_fading_test/telosb_no_tube_flat;

mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
end


cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/angle/small_fading_test/in_chamber/telosb_no_tube_flat;


mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end

cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test/outdoor/telos/;
mean_rssi_3 = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_3 = [mean_rssi_3 mean(input)];
end

cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test/grass/low/2420;
mean_rssi_4 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_4 = [mean_rssi_4 mean(input)];
end

% cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test/grass/high/2420;
% mean_rssi_5 = [];
% for i=0:1:8
%     input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
%     input = input(1:500,:);
%     mean_rssi_5 = [mean_rssi_5 mean(input)];
% end

% subtract the offset
mean_rssi = mean_rssi - 45*ones(1,9);
mean_rssi_2 = mean_rssi_2 - 45*ones(1,9);
mean_rssi_3 = mean_rssi_3 - 45*ones(1,9);
mean_rssi_4 = mean_rssi_4 - 45*ones(1,9);
%mean_rssi_5 = mean_rssi_5 - 45*ones(1,9);

figure; hold on;
pos_id = 1:9;
h = plot(pos_id,mean_rssi,pos_id,mean_rssi_2,pos_id,mean_rssi_3,pos_id,mean_rssi_4,'LineWidth',2,'MarkerSize',9);
h(1).Marker =  'o';
h(2).Marker =  '+';
h(3).Marker =  'v';
h(4).Marker =  's';
%h(5).Marker =  'h';
xlabel('Position ID');
ylabel('RSSI (dBm)');
legend({'Indoor','Anechoic chamber','Concrete field','Grass field'},'FontSize',18,'location', 'Southeast');
%title('OUTSIDE CHAMBER: wifi\_no\_tube\_flat\_25Hz');
ylim([-70 -40]);
set(gca,'XTick',1:9);
%ylim([-50 -20]);
set(gca, 'box', 'on')
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'/Users/hongxiong/Documents/roachzstack/analysis/rssi/strong_anntena_range_test/Biowireless/deep_fading_2420_plot_with_grass.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


