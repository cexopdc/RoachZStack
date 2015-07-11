clear all;close all;

cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test;

% for outside chamber
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