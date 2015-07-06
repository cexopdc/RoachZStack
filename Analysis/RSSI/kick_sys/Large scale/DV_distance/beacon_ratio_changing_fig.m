clear all;
load('beacon_ratio_0.03_to_0.30_100nodes_100trials.mat');
figure;
x = start_point:0.03:end_point;
hLine = plot(x,error_matrix);
hLine(1).Marker = '*';
hLine(2).Marker = '+';
hLine(3).Marker = 'x';
hLine(4).Marker = 'd';
hLine(5).Marker = 'p';
hLine(6).Marker = '^';
hLine(7).Marker = 'o';
xlabel('Beacon ratio');
ylabel('Relative error');
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','CRLB');
ax = gca;
ax.XTick = 0:0.03:0.30;

figure
x = start_point:0.03:end_point;
h = plot(x,coverage_matrix);
xlabel('Beacon ratio');
ylabel('Coverage');
