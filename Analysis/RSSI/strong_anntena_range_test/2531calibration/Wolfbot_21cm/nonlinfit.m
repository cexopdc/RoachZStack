%{
%%% RSSI VS distance %%%
clear all;
input = load('dist_mean_std_diff_rssi.txt');
rssi_list = input(:,1);
distance_mean_list = input(:,2);
distance_std_list = input(:,3);

b0=[1.24,9.32,-60.75]; %initial est
fun=inline('b(2).*10.^((b(3)-x)/b(1))','b','x');
x1=rssi_list;
y1=distance_mean_list;
[b,r,j]=nlinfit(x1,y1,fun,b0);
b=real(b);
y2 = b(2).*10.^((b(3)-x1)/b(1));

plot(x1,y1,'b*',x1,y2,'-or');
ylabel('distance (m)');
xlabel('RSSI');
legend('original data','Nonlinear Regression');
hold on;
errorbar(x1,distance_mean_list,distance_std_list,'bo','markersize', 5);
%}


%
%%%distance vs RSSI%%%

%aggregate rssi from 0.2 to 3.0m.
aggr_mean_rssi=[];
aggr_std_rssi=[];

for i=0.2:0.2:3.0
    aggr_input = []; % aggregate input for 5 random spots.
    for j=1:1:5
        input = load(strcat(char(vpa(i,2)),'m_',num2str(j),'.txt'));
        input = input(1:1000,:);
        aggr_input = [aggr_input;input];
    end
    %get the mean and std for aggr_input
    aggr_mean_rssi = [aggr_mean_rssi mean(aggr_input)];
    aggr_std_rssi = [aggr_std_rssi std(aggr_input)];   
end

b0=[-57,1,1];
fun=inline('b(1)+b(2).*log(x./b(3))','b','x');
x1=0.2:0.2:3.0;
y1=aggr_mean_rssi;
[b,r,j]=nlinfit(x1,y1,fun,b0);
b=real(b);
y2=b(1)+b(2).*log(x1./b(3));
plot(x1,y1,'b*',x1,y2,'-or');
xlabel('distance (m)');
ylabel('RSSI');
legend('original data','Nonlinear Regression');
hold on;
errorbar(x1,aggr_mean_rssi,aggr_std_rssi,'bo','markersize', 5);
%

syms x
f(x) = b(1)+b(2).*log(x./b(3));
g = finverse(f,'x');
figure;
h = ezplot(g,[-90,-40]);
title([]);
ylabel('distance (m)');
xlabel('RSSI');
ylim([0 3]);



