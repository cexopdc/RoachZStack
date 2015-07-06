clear all;
load('trans_range_10_to_50_50trials.mat')

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
x = start_point:10:end_point;
hLine = plot(x,error_matrix);
hLine(1).Marker = '*';
hLine(2).Marker = '+';
hLine(3).Marker = 'x';
hLine(4).Marker = 'd';
hLine(5).Marker = 'p';
hLine(6).Marker = '^';
hLine(7).Marker = 'o';
xlabel('Transmission range (m)');
ylabel('Relative error') % left y-axis
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','CRLB');

figure
x = start_point:10:end_point;
h = plot(x,coverage_matrix);
xlabel('Transmission range (m)');
ylabel('Coverage');