load('std_0.05_to_0.5_IWLSE.mat');
figure;
x = start_point:0.05:end_point;
plot(x,error_matrix,'*-');
xlabel('Measurement error Std');
ylabel('Relative error');
legend('kick','DV-distance','N-hop-lateration','IWLSE');