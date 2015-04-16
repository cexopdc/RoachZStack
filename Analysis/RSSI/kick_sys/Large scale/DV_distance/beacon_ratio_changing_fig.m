clear all;
load('beacon_ratio_0.03_to_0.3.mat');
figure;
x = start_point:0.03:end_point;
plot(x,error_matrix,'*-');
xlabel('Beacon ratio');
ylabel('Relative error');
legend('kick','kick\_kalman','kick\_kalman\_2nodes','DV-distance','N-hop-lateration','IWLSE','CRLB');

figure;
x = start_point:0.03:end_point;
coverage_matrix = [ones(3,length(coverage_matrix));coverage_matrix;coverage_matrix;coverage_matrix;ones(1,length(coverage_matrix))];
plot(x,coverage_matrix,'*-');
xlabel('Beacon ratio');
ylabel('Coverage');
legend('kick','kick\_kalman','kick\_kalman\_2nodes','DV-distance','N-hop-lateration','IWLSE','CRLB');
