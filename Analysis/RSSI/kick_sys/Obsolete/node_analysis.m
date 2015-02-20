function node_analysis(node_stat)
x = node_stat(:,1);
y = node_stat(:,2);
std = node_stat(:,3);
stage = 0:length(y)-1;

x_Bline=23.3*ones(length(y));
y_Bline=26.4*ones(length(y));

figure
plot(stage,x,'-*y',stage,y,'-*b',stage,std,'-*g');
hold on;
plot(stage,x_Bline,'r',stage,y_Bline,'r');
ylim([0,max(max(x),max(y))+5]);
legend('x coordinates','y coordinates','std');
xlabel('Stage');
