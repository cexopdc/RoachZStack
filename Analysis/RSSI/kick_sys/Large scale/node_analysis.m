function node_analysis(node_stat,algorithm)
global Node;
global NUM_NODE BEACON_RATIO;
x = node_stat(:,1);
y = node_stat(:,2);

%x_std = node_stat(:,3);
%y_std = node_stat(:,4);
std = node_stat(:,3);

stage = 0:length(y)-1;

x_Bline=Node(NUM_NODE*BEACON_RATIO+1).pos(1)*ones(length(y));
y_Bline=Node(NUM_NODE*BEACON_RATIO+1).pos(2)*ones(length(y));

%{
%plot per step loc result for a single node 
figure;
%plot(stage,x,'-*y',stage,y,'-*b',stage,x_std,'-.r',stage,y_std,'-.g');
plot(stage,x,'-*y',stage,y,'-*b',stage,std,'-*g');
hold on;
plot(stage,x_Bline,'r',stage,y_Bline,'r');
%ylim([0,max([max(x),max(y),Node(4).pos(1),Node(4).pos(2)])+5]);
ylim([0,max([max(x),max(y),Node(NUM_NODE*BEACON_RATIO+1).pos(1),Node(NUM_NODE*BEACON_RATIO+1).pos(2)])+5]);
%legend('x coordinates','y coordinates','x_std','y_std');
legend('x coordinates','y coordinates','std');
xlabel('Stage');
if strcmp(algorithm,'kalman')
    title('Kalman filter algorithm');
else
    title('intuitive algorithm');
end
%}

figure; hold on;
if strcmp(algorithm,'kalman')
    for i=NUM_NODE*BEACON_RATIO+1:NUM_NODE
        Node(i).std = sqrt(sum(sum(Node(i).cov))/2);
    end
end

std_all=[];
for i = NUM_NODE*BEACON_RATIO+1:NUM_NODE
    std_all=[std_all Node(i).std];
end
plot(NUM_NODE*BEACON_RATIO+1:NUM_NODE,std_all);

if strcmp(algorithm,'kalman')
    title('Kalman filter algorithm');
else
    title('intuitive algorithm');
end

%plot the final result for all the unknowns
%{
loc_error=[];
for i=NUM_NODE*BEACON_RATIO+1:NUM_NODE
    loc_error =[loc_error sqrt((Node(i).pos(1)-Node(i).est_pos(1))^2+(Node(i).pos(2)-Node(i).est_pos(2))^2)];
end
figure;
node_id = NUM_NODE*BEACON_RATIO+1:NUM_NODE;
plot(node_id,loc_error);
%}