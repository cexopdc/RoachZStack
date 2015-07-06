clear all;close all;

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
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('with\_tube\_tilt');
