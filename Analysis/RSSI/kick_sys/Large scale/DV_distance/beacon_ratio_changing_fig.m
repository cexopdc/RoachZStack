load('beacon_ratio_0.03_to_0.3_IWLSE.mat');
figure;
x = start_point:0.03:end_point;
plot(x,error_matrix,'*-');
xlabel('Beacon ratio');
ylabel('Relative error');
legend('kick','DV-distance','N-hop-lateration');

figure;
x = start_point:0.03:end_point;
coverage_matrix = [ones(1,length(coverage_matrix));coverage_matrix;coverage_matrix];
plot(x,coverage_matrix,'*-');
xlabel('Beacon ratio');
ylabel('Coverage');
legend('kick','DV-distance','N-hop-lateration');