load('num_node_20_to_200_ideal.mat')
figure;
x = start_point:10:end_point;
[hAx,hLine1,hLine2] = plotyy(x,error_matrix,x,connectivity_array);
hLine1(1).LineStyle = '-';
hLine1(2).LineStyle = '-';
hLine1(3).LineStyle = '-';
hLine2.LineStyle = '-';
hLine1(1).Marker = '*';
hLine1(2).Marker = '*';
hLine1(3).Marker = '*';
hLine2.Marker = 'o';
xlabel('Number of nodes');
ylabel(hAx(1),'Relative error') % left y-axis
ylabel(hAx(2),'connectivity') % right y-axis
legend('kick','DV-distance','N-hop-lateration','connectivity');

figure;
x = start_point:10:end_point;
coverage_matrix = [ones(1,length(coverage_matrix));coverage_matrix;coverage_matrix];
h = plot(x,coverage_matrix);
h(1).Marker = 'o';
h(2).Marker = '*';
h(3).Marker = 's';
xlabel('Number of nodes');
ylabel('Coverage');
legend('kick','DV-distance','N-hop-lateration');