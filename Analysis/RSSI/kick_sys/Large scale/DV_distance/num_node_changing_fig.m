clear all;
load('flop_results/FLOP_num_node_20_to_200_100trials_no_break_stage.mat')

%{
mat_obj1 = matfile('STD_num_node_20_to_100_100trials.mat','Writable',true);
mat_obj2 = matfile('STD_num_node_120_to_200_30trials.mat','Writable',true);

error_matrix = [mat_obj1.corrected_error_matrix mat_obj2.corrected_error_matrix];
std_matrix = [mat_obj1.corrected_std_matrix mat_obj2.corrected_std_matrix];
coverage_matrix = [mat_obj1.coverage_matrix mat_obj2.coverage_matrix];
start_point = 20;
end_point = 200;

save('STD_num_node_20_to_200_combination.mat','error_matrix','std_matrix','coverage_matrix','start_point','end_point');
%}

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

%{
[m,n] = size(aggregate_error_matrix);
for i=1:m
    for j=1:n
        % deal with errors larger than 3
        if aggregate_error_matrix(i,j)>2
            aggregate_error_matrix(i,j) = 2;    %%%%%%%%%%%
        end
    end
end

error_matrix = [];
for i=1:m/num_trials
    tmp_error_matrix = [];
    for j=1:n
        tmp_error_matrix = [tmp_error_matrix mean(nonzeros(aggregate_error_matrix((num_trials*(i-1)+1):num_trials*i,j)))];
    end
    error_matrix = [error_matrix; tmp_error_matrix];
end
error_matrix = error_matrix';

[m,n] = size(aggregate_std_matrix);
for i=1:m
    for j=1:n
        if aggregate_std_matrix(i,j)>2
            aggregate_std_matrix(i,j) = 0;     %%%%%%%%%
        end
    end
end

std_matrix = [];
for i=1:m/num_trials
    tmp_std_matrix = [];
    for j=1:n
        tmp_std_matrix = [tmp_std_matrix mean(nonzeros(aggregate_std_matrix((num_trials*(i-1)+1):num_trials*i,j)))];
    end
    std_matrix = [std_matrix; tmp_std_matrix];
end
std_matrix = std_matrix';

% store corrected stats to original mat.
mat_obj.corrected_error_matrix = error_matrix;
mat_obj.corrected_std_matrix = std_matrix;
%}

figure;
x = start_point:20:end_point;
[hAx,hLine1,hLine2] = plotyy(x,error_matrix,x,coverage_matrix);
hLine1(1).Marker = '*';
hLine1(2).Marker = '+';
hLine1(3).Marker = 'x';
hLine1(4).Marker = 'd';
hLine1(5).Marker = 'p';
hLine1(6).Marker = '^';
for i=1:6
    hLine1(i).LineWidth = 2;
    hLine1(i).MarkerSize = 8;
end
%hLine1(7).Marker = 's';
hLine2.Marker = 'o';
hLine2.LineStyle = ':';
hLine2.LineWidth = 2;
hLine2.MarkerSize = 8;
xlabel('Number of nodes');
ylabel(hAx(1),'Relative error mean') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
ylim(hAx(2),[0 1]); % set coverage ylim
hAx(2).YTick = 0:0.2:1; % set coverage ytick
ylim(hAx(1),[0 inf]); % set error mean ylim
hAx(1).YTick = 0:0.2:2; % set error mean ytick
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','Coverage','Location','best','FontSize', 16);
hAx(1).XTick = 20:20:200;
set(hAx, 'FontSize', 16, 'LineWidth', 2);
set(hAx, 'box', 'on')
exportfig(gcf,'flop_results/num_node_20_to_200_mean_comparison_no_break_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


figure;
x = start_point:20:end_point;
hLine = plot(x,std_matrix,'LineWidth',2,'MarkerSize',8);
hLine(1).Marker = '*';
hLine(2).Marker = '+';
hLine(3).Marker = 'x';
hLine(4).Marker = 'd';
hLine(5).Marker = 'p';
hLine(6).Marker = '^';
hLine(7).Marker = 's';
xlabel('Number of nodes');
ylabel('Relative error standard deviation') % left y-axis
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','CRLB','Location','best','FontSize', 16);
set(gca,'XTick',20:20:200,'xlim',[20 200]);
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'flop_results/num_node_20_to_200_std_comparison_no_break_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

figure;
x = start_point:20:end_point;
hLine = plot(x,flop_matrix,'LineWidth',2,'MarkerSize',8);
hLine(1).Marker = '*';
hLine(2).Marker = '+';
hLine(3).Marker = 'x';
hLine(4).Marker = 'd';
hLine(5).Marker = 'p';
hLine(6).Marker = '^';
xlabel('Number of nodes');
ylabel('Flops') % left y-axis
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','Location','best','FontSize', 16);
set(gca,'XTick',20:20:200,'xlim',[20 200]);
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'flop_results/num_node_20_to_200_flop_comparison_no_break_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb','LockAxes',0);

figure;
x = start_point:20:end_point;
hLine = plot(x,stage_matrix,'LineWidth',2,'MarkerSize',8);
hLine(1).Marker = '*';
hLine(2).Marker = '+';
hLine(3).Marker = 'x';
hLine(4).Marker = 'd';
hLine(5).Marker = 'p';
xlabel('Number of nodes');
ylabel('Iteration steps') % left y-axis
legend('KI','KK','KK2','N-hop-lateration','IWLSE','Location','best','FontSize', 16);
set(gca,'XTick',20:20:200,'xlim',[20 200]);
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'flop_results/num_node_20_to_200_stage_comparison_no_break_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');
