clear all;
load('flop_results/FLOP_area_space_20_to_200_50trials_no_stage.mat')
%sets the default color order to the colors used in 2014b.
co = [0    0.4470    0.7410;
    0.8500    0.3250    0.0980;
    0.9290    0.6940    0.1250;
    0.4940    0.1840    0.5560;
    0.4660    0.6740    0.1880;
    0.3010    0.7450    0.9330;
    0.6350    0.0780    0.1840];
set(groot,'defaultAxesColorOrder',co)

%{
mat_obj = matfile('flop_results/FLOP_area_space_20_to_200_50trials_no_stage.mat','Writable',true);
%
[m,n] = size(aggregate_error_matrix);
for i=1:m
    for j=1:n
        % deal with errors larger than 3
        if aggregate_error_matrix(i,j)>2.5
            aggregate_error_matrix(i,j) = 0;    %%%%%%%%%%%
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
        if aggregate_std_matrix(i,j)>2.5
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

%mat_obj1 = matfile('STD_area_space_20_to_200_combination.mat','Writable',true);
%save('STD_area_space_20_to_200_combination.mat','error_matrix','std_matrix','coverage_matrix','start_point','end_point');
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
legend('kick','DV-distance','N-hop Multilateration-bound','connectivity');
%}

figure;
x = start_point:20:end_point;
[hAx,hLine1,hLine2] = plotyy(x,corrected_error_matrix,x,coverage_matrix);
set(hLine1,{'Marker'},{'*','+','x','d','p','^'}');
%{
set(hLine1(1),'Marker','*');
set(hLine1(2),'Marker','+');
set(hLine1(3),'Marker','x');
set(hLine1(4),'Marker','d');
set(hLine1(5),'Marker','p');
set(hLine1(6),'Marker','^');
%}
%set(hLine1(7),'Marker','s');
set(hLine1,'LineWidth',2,'MarkerSize',8);
set(hLine2,'Marker','o','LineStyle',':','LineWidth',2,'MarkerSize',8);
xlabel('Area side Length (m)');
ylabel(hAx(1),'Relative error mean') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
ylim(hAx(2),[0 1]); % set coverage ylim
set(hAx(2),'YTick',0:0.2:1);
ylim(hAx(1),[0 inf]); % set error mean ylim
set(hAx(1),'YTick',0:0.2:2);
legend({'KI','KK','KK2','DV-distance','N-hop Multilateration','IWLSE','Coverage'},'Location','best','FontSize', 16);
set(hAx, 'FontSize', 16, 'LineWidth', 2);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(hAx,'XTick',20:20:200);
set(hAx, 'box', 'on')
exportfig(gcf,'flop_results/area_space_20_to_200_mean_comparison_no_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');


figure;
x = start_point:20:end_point;
hLine = plot(x,corrected_std_matrix,'LineWidth',2,'MarkerSize',8);
set(hLine,{'Marker'},{'*','+','x','d','p','^','s'}');
xlabel('Area side Length (m)');
ylabel('Relative error standard deviation') % left y-axis
legend({'KI','KK','KK2','DV-distance','N-hop Multilateration','IWLSE','CRLB'},'Location','best','FontSize', 16);
set(gca,'XTick',20:20:200,'xlim',[20 200]);
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca, 'box', 'on')
exportfig(gcf,'flop_results/area_space_20_to_200_std_comparison_no_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

figure;
x = start_point:20:end_point;
hLine = semilogy(x,flop_matrix,'LineWidth',2,'MarkerSize',8);
set(hLine,{'Marker'},{'*','+','x','d','p','^'}');
xlabel('Area side Length (m)');
ylabel('Flops') % left y-axis
legend({'KI','KK','KK2','DV-distance','N-hop Multilateration','IWLSE'},'Location','best','FontSize', 16);
set(gca,'XTick',20:20:200,'xlim',[20 200]);
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
grid on;
%{
magnifyOnFigure(gcf,...
        'units', 'pixels',...
        'magnifierShape', 'rectangle',...
        'initialPositionSecondaryAxes', [326.933 259.189 164.941 102.65],...
        'initialPositionMagnifier',     [73.8 47.2 94.1164 20.627],...    
        'mode', 'interactive',...    
        'displayLinkStyle', 'straight',...        
        'edgeWidth', 2,...
        'edgeColor', 'black',...
        'secondaryAxesFaceColor', [0.91 0.91 0.91],... 
        'secondaryAxesXLim',[20 60],...
        'secondaryAxesYLim',[0 5*10^5]...
            );
%}
exportfig(gcf,'flop_results/area_space_20_to_200_flop_comparison_no_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb','LockAxes',0);

figure;
x = start_point:20:end_point;
hLine = plot(x,stage_matrix,'LineWidth',2,'MarkerSize',8);
set(hLine,{'Marker'},{'*','+','x','d','p'}');
xlabel('Area side Length (m)');
ylabel('Iteration steps') % left y-axis
legend({'KI','KK','KK2','N-hop Multilateration','IWLSE'},'Location','best','FontSize', 16);
set(gca,'XTick',20:20:200,'xlim',[20 200]);
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'flop_results/area_space_20_to_200_stage_comparison_no_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

figure;
x = start_point:20:end_point;
hLine = plot(x,msg_matrix,'LineWidth',2,'MarkerSize',8);
set(hLine,{'Marker'},{'*','+','x','d','p','^'}');
xlabel('Area side Length (m)');
ylabel('Messages sent') % left y-axis
legend({'KI','KK','KK2','DV-distance','N-hop Multilateration','IWLSE'},'Location','best','FontSize', 16);
set(gca,'XTick',20:20:200,'xlim',[20 200]);
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'flop_results/area_space_20_to_200_msg_comparison_no_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');

figure;
x = start_point:20:end_point;
hLine = plot(x,bytes_matrix,'LineWidth',2,'MarkerSize',8);
set(hLine,{'Marker'},{'*','+','x','d','p','^'}');
xlabel('Area side Length (m)');
ylabel('Bytes sent') % left y-axis
legend({'KI','KK','KK2','DV-distance','N-hop Multilateration','IWLSE'},'Location','best','FontSize', 16);
set(gca,'XTick',20:20:200,'xlim',[20 200]);
set(gca, 'FontSize', 16, 'LineWidth', 2);
set(gca, 'box', 'on')
exportfig(gcf,'flop_results/area_space_20_to_200_bytes_comparison_no_stage.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');




