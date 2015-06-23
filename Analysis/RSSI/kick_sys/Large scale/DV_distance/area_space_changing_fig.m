clear all;
load('area_space_20_to_200_combination.mat')

%{
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
legend('kick','DV-distance','N-hop-lateration-bound','connectivity');
%}

figure;
x = start_point:20:end_point;
plot(x,error_matrix,'-*');
xlabel('Area space Length');
ylabel('Relative error') % left y-axis
legend('kick','kick\_kalman','kick\_kalman\_2nodes','DV-distance','N-hop-lateration','IWLSE','CRLB');

figure
x = start_point:20:end_point;
h = plot(x,coverage_matrix);
xlabel('Area space Length');
ylabel('Coverage');