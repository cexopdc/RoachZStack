function node_analysis(node_stat)
global Node;
x = node_stat(:,1);
y = node_stat(:,2);

%x_std = node_stat(:,3);
%y_std = node_stat(:,4);
std = node_stat(:,3);

stage = 0:length(y)-1;

x_Bline=Node(4).pos(1)*ones(length(y));
y_Bline=Node(4).pos(2)*ones(length(y));

figure
%plot(stage,x,'-*y',stage,y,'-*b',stage,x_std,'-.r',stage,y_std,'-.g');
plot(stage,x,'-*y',stage,y,'-*b',stage,std,'-*g');
hold on;
plot(stage,x_Bline,'r',stage,y_Bline,'r');
%ylim([0,max([max(x),max(y),Node(4).pos(1),Node(4).pos(2)])+5]);
ylim([0,max([max(x),max(y),Node(4).pos(1),Node(4).pos(2)])+5]);
%legend('x coordinates','y coordinates','x_std','y_std');
legend('x coordinates','y coordinates','std');
xlabel('Stage');
