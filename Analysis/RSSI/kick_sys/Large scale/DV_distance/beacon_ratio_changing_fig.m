clear all;
load('STD_beacon_ratio_0.03_to_0.30_100nodes_100trials.mat');

%mat_obj = matfile('STD_beacon_ratio_0.03_to_0.30_100nodes_100trials.mat','Writable',true);

%{
[m,n] = size(aggregate_error_matrix);
for i=1:m
    for j=1:n
        % deal with errors larger than 3
        if aggregate_error_matrix(i,j)> 3 
            aggregate_error_matrix(i,j) = 3;    %%%%%%%%%%%
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
        if aggregate_std_matrix(i,j) > 3
            aggregate_std_matrix(i,j) = 3;     %%%%%%%%%
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
%mat_obj.corrected_error_matrix = error_matrix;
%mat_obj.corrected_std_matrix = std_matrix;
%}

figure;
x = start_point:0.03:end_point;
[hAx,hLine1,hLine2] = plotyy(x,corrected_error_matrix,x,coverage_matrix);
hLine1(1).Marker = '*';
hLine1(2).Marker = '+';
hLine1(3).Marker = 'x';
hLine1(4).Marker = 'd';
hLine1(5).Marker = 'p';
hLine1(6).Marker = '^';
%hLine1(7).Marker = 's';
hLine2.Marker = 'o';
hLine2.LineStyle = ':';
xlabel('Beacon ratio');
ylabel(hAx(1),'Relative error mean') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
ylim(hAx(2),[0 1]); % set coverage ylim
hAx(2).YTick = 0:0.2:1; % set coverage ytick
ylim(hAx(1),[0 inf]); % set error mean ylim
hAx(1).YTick = 0:0.2:2; % set error mean ytick
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','Coverage','Location','best');
ax = gca;
ax.XTick = 0:0.03:0.30;

figure;
x = start_point:0.03:end_point;
hLine = plot(x,corrected_std_matrix);
hLine(1).Marker = '*';
hLine(2).Marker = '+';
hLine(3).Marker = 'x';
hLine(4).Marker = 'd';
hLine(5).Marker = 'p';
hLine(6).Marker = '^';
hLine(7).Marker = 's';
xlabel('Beacon ratio');
ylabel('Relative error standard deviation') % left y-axis
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','CRLB','Location','best');
