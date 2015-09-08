clear all;close all;

%
cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/Angle/Small_fading_test/IN_CHAMBER/;

%for outside chamber
cd no_tube_flat_25hz;

mean_rssi = zeros(1,9);
std_rssi = zeros(1,9);
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi(i+1) = mean(input);
    std_rssi(i+1) = std(input);
end

mean_rssi_2 = zeros(1,9);
std_rssi_2 = zeros(1,9);
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2(i+1) = mean(input);
    std_rssi_2(i+1) = std(input);
end

pos_id = 1:9;
subplot(2,1,1)
hold on;
plot(pos_id,mean_rssi,'r',pos_id,mean_rssi_2,'b','linewidth',2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree','location','best');
title('INSIDE CHAMBER: no\_tube\_flat\_25Hz');
h_error=errorbar(pos_id,mean_rssi,std_rssi,'r.','markersize', 5); set(h_error,'linewidth',2);
h_error2=errorbar(pos_id,mean_rssi_2,std_rssi_2,'b.','markersize', 5); set(h_error2,'linewidth',2);
set(findall(gcf,'-property','FontSize'),'FontSize',16);

%ylim([-85 -50]);

%
mean_rssi = zeros(1,9);
std_rssi = zeros(1,9);
for i=0:1:8
    input = load(strcat('1m_0degree_pos_0_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi(i+1) = mean(input);
    std_rssi(i+1) = std(input);
end

mean_rssi_2 = zeros(1,9);
std_rssi_2 = zeros(1,9);
for i=0:1:8
    input = load(strcat('1m_90degree_pos_0_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2(i+1) = mean(input);
    std_rssi_2(i+1) = std(input);
end
%

%{
mean_rssi = [-62.30 -62.60 -62.43 -62.54 -62.77 -62.22 -62.65  -62.39 -62.58];
std_rssi = [0.202 0.235 0.313 0.291 0.274 0.322 0.341 0.234 0.277];
mean_rssi_2 = [-68.40 -68.70 -68.53 -68.64 -68.77 -68.29 -68.55  -68.74 -68.85];
std_rssi_2 = [0.252 0.335 0.363 0.201 0.174 0.122 0.241 0.224 0.217];
%}

pos_id = 1:9;
subplot(2,1,2)
hold on;
plot(pos_id,mean_rssi,'r',pos_id,mean_rssi_2,'b','linewidth',2);
xlabel('Time sequence');
ylabel('RSSI');
legend('0 degree','90 degree','location','best');
title('INSIDE CHAMBER: no\_tube\_flat\_25Hz');
h_error=errorbar(pos_id,mean_rssi,std_rssi,'r.','markersize', 5); set(h_error,'linewidth',2);
h_error2=errorbar(pos_id,mean_rssi_2,std_rssi_2,'b.','markersize', 5); set(h_error2,'linewidth',2);
ylim([-75 -60]);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
exportfig(gcf,'fixed_vs_nine_pos_outside.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


print





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

%{
%cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/angle/small_fading_test/wifi_no_tube_flat_25hz;

mean_rssi = [];
for i=0:1:8
    input = load(strcat('1m_0degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi = [mean_rssi mean(input)];
end


% subtract the offset
%mean_rssi = mean_rssi - 45*ones(1,9);


mean_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
end

% subtract the offset
%mean_rssi_2 = mean_rssi_2 - 45*ones(1,9);

figure; hold on;
pos_id = 1:9;
subplot(2,1,1)
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('OUTSIDE CHAMBER: wifi\_no\_tube\_flat\_25Hz');
%ylim([-85 -50]);
ylim([-50 -20]);
%}

%cd /Users/hongxiong/Documents/RoachZStack/Analysis/RSSI/strong_anntena_range_test/2531calibration/angle/small_fading_test/in_chamber/wifi_no_tube_flat_25hz;
mean_rssi = zeros(1,9);
std_rssi = zeros(1,9);
for i=0:1:8
    input = load(strcat('1m_0degree_pos_0_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi(i+1) = mean(input);
    std_rssi(i+1) = std(input);
end

% subtract the offset
%mean_rssi = mean_rssi - 45*ones(1,9);


mean_rssi_2 = [];
std_rssi_2 = [];
for i=0:1:8
    input = load(strcat('1m_90degree_pos_0_',num2str(i),'.txt'));
    input = input(1:500,:);
    mean_rssi_2 = [mean_rssi_2 mean(input)];
    std_rssi_2 = [std_rssi_2 std(input)];
end

% subtract the offset
%mean_rssi_2 = mean_rssi_2 - 45*ones(1,9);

pos_id = 1:9;
subplot(2,1,2)
hold on;
plot(pos_id,mean_rssi,pos_id,mean_rssi_2);
xlabel('Position ID');
ylabel('RSSI');
legend('0 degree','90 degree');
title('INSIDE CHAMBER: wifi\_no\_tube\_flat\_25Hz');
h_error=errorbar(pos_id,mean_rssi,std_rssi,'bo','markersize', 5); %set(h,'linestyle','none');
h_error=errorbar(pos_id,mean_rssi_2,std_rssi_2,'bo','markersize', 5); %set(h,'linestyle','none');
%ylim([-85 -50]);
ylim([-50 -20]);
%}
