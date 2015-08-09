clear all;close all;

%
cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test/outdoor;

%for outside chamber
cd no_tube_flat/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
end


mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end

figure;
pos_id = 1:9;
subplot(3,1,1)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('OUTDOOR: CC2530');
set(gca, 'FontSize', 14, 'LineWidth', 2);
%ylim([-80 -60]);

cd ../telos/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
end
% subtract the offset
mean_rssi = mean_rssi - 45*ones(1,9);

mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end

% subtract the offset
mean_rssi_2 = mean_rssi_2 - 45*ones(1,9);



pos_id = 1:9;
subplot(3,1,2)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('OUTDOOR: CC2420');
ylim([-60 -30]);
set(gca, 'FontSize', 14, 'LineWidth', 2);


cd ../wifi/;
mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
end

mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end


pos_id = 1:9;
subplot(3,1,3)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('OUTDOOR: wifi');
ylim([-60 -20]);
set(gca, 'FontSize', 14, 'LineWidth', 2);

%{
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

%{
cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/angle/small_fading_test/outdoor/;

mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
end

cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/angle/small_fading_test/in_chamber/no_tube_flat;


mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end

% subtract the offset
%mean_rssi = mean_rssi - 45*ones(1,9);
%}

%{
figure; hold on;
pos_id = 1:9;
h = plot(pos_id,mean_rssi,pos_id,mean_rssi_2,'LineWidth',2,'MarkerSize',8);
h(1).Marker =  'o';
h(2).Marker =  '+';
xlabel('Position ID');
ylabel('RSSI (dBm)');
legend('Indoor','In chamber','FontSize',14,'location', 'Best');
%title('OUTSIDE CHAMBER: wifi\_no\_tube\_flat\_25Hz');
ylim([-80 -60]);
%ylim([-50 -20]);
%}
set(gca, 'box', 'on')
set(gca, 'FontSize', 14, 'LineWidth', 2);
exportfig(gcf,'deep_fading_outdoor_plot.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


