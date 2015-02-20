function node_analysis_random(node_stat)
global Node;
x = node_stat(:,1);
y = node_stat(:,2);
std = node_stat(:,3);
stage = 0:length(y)-1;

x_Bline=Node(4).x*ones(length(y));
y_Bline=Node(4).y*ones(length(y));

figure
plot(stage,x,'-*y',stage,y,'-*b',stage,std,'-*g');
hold on;
plot(stage,x_Bline,'r',stage,y_Bline,'r');
ylim([0,max([max(x),max(y),Node(4).x,Node(4).y])+5]);
legend('x coordinates','y coordinates','std');
xlabel('Stage');
