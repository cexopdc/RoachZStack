%
%%% RSSI VS distance %%%
clear all;
input = load('dist_mean_std_diff_rssi.txt');
rssi_list = input(:,1);
distance_mean_list = input(:,2);
distance_std_list = input(:,3);

b0=[-57/20,1/20]; %initial est
fun=inline('10.^(b(1)-b(2)*x)','b','x');
x1=rssi_list;
y1=distance_mean_list;
[b,r,j]=nlinfit(x1,y1,fun,b0);
b=real(b);
y2 = 10.^(b(1)-b(2)*x1);

figure;
plot(x1,y1,'b*',x1,y2,'-r','LineWidth',2,'MarkerSize',6);
ylabel('distance (m)');
xlabel('RSSI (dBm)');
legend('original mapping','After fitting');
hold on;
errorbar(x1,distance_mean_list,distance_std_list,'bo','markersize', 5);
%title('RSSI vs Distance fitting');

set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'result_fig/1111_rssi_dis_fit.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

%store the rssi vs distance fitting
input = load('interp_dist_mean_std_diff_rssi.txt');
x3 = input(:,1);
y3 = 10.^(b(1)-b(2)*x3);
std3 = input(:,3);
rssi_dis_fitting = [x3 y3 std3];
dlmwrite('rssi_dis_fitting.txt', rssi_dis_fitting);



%weighted fit: abs(1/rssi)^5 as weight
weights = (-1./rssi_list).^5;
[b,r,j]=nlinfit(x1,y1,fun,b0,'Weights',weights);
b=real(b);
y2 = 10.^(b(1)-b(2)*x1);
figure;
plot(x1,y1,'b*',x1,y2,'-r','LineWidth',2,'MarkerSize',6);
ylabel('distance (m)');
xlabel('RSSI');
legend('original data','Nonlinear Regression');
hold on;
errorbar(x1,distance_mean_list,distance_std_list,'bo','markersize', 5);
title('RSSI vs Distance weighted fitting');
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'result_fig/rssi_dis_fit_weighted.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

%store the rssi vs distance fitting
input = load('interp_dist_mean_std_diff_rssi.txt');
x3 = input(:,1);
y3 = 10.^(b(1)-b(2)*x3);
std3 = input(:,3);
rssi_dis_fitting = [x3 y3 std3];
dlmwrite('rssi_dis_weighted_fitting.txt', rssi_dis_fitting);
%}


%{
%%%distance vs RSSI%%%

%aggregate rssi from 0.2 to 3.0m.
aggr_mean_rssi=[];
aggr_std_rssi=[];

for i=1.0:1:10.0
    aggr_input = []; % aggregate input for 5 random spots.
    for j=1:1:5
        input = load(strcat(char(vpa(i,2)),'m_',num2str(j),'.txt'));
        input = input(1:500,:);
        aggr_input = [aggr_input;input];
    end
    %get the mean and std for aggr_input
    aggr_mean_rssi = [aggr_mean_rssi mean(aggr_input)];
    aggr_std_rssi = [aggr_std_rssi std(aggr_input)];   
end

figure;
b0=[-57,20];
fun=inline('b(1)-b(2).*log10(x)','b','x');
x1=1.0:1:10.0;
y1=aggr_mean_rssi;
[b,r,j]=nlinfit(x1,y1,fun,b0);
b=real(b);
y2=b(1)-b(2).*log10(x1);
plot(x1,y1,'b*',x1,y2,'-r','LineWidth',2,'MarkerSize',6);
xlabel('distance (m)');
ylabel('RSSI');
legend('original data','Nonlinear Regression');
hold on;
errorbar(x1,aggr_mean_rssi,aggr_std_rssi,'bo','markersize', 5);
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'dis_rssi_fit.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
%}


syms x
f(x) = b(1)-b(2).*log10(x);
g = finverse(f,'x');
figure;
h = ezplot(g,[-90,-40]);
title([]);
ylabel('distance (m)');
xlabel('RSSI');
set(gca, 'FontSize', 18, 'LineWidth', 2);
exportfig(gcf,'rssi_dis_reverse_fit.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
ylim([0 3]);
exportfig(gcf,'rssi_dis_reverse_fit_cut_3m.eps'...
    ,'height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
%}

