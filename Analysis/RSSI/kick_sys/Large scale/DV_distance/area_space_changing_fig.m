clear all;
load('STD_area_space_20_to_200_combination.mat')


%mat_obj = matfile('STD_area_space_20_to_200_30trials.mat','Writable',true);
%{
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
x = start_point:20:end_point;
[hAx,hLine1,hLine2] = plotyy(x,error_matrix,x,coverage_matrix);
hLine1(1).Marker = '*';
hLine1(2).Marker = '+';
hLine1(3).Marker = 'x';
hLine1(4).Marker = 'd';
hLine1(5).Marker = 'p';
hLine1(6).Marker = '^';
%hLine1(7).Marker = 's';
hLine2.Marker = 'o';
hLine2.LineStyle = ':';
xlabel('Area side Length (m)');
ylabel(hAx(1),'Relative error mean') % left y-axis
ylabel(hAx(2),'Coverage') % right y-axis
ylim(hAx(2),[0 1]); % set coverage ylim
hAx(2).YTick = 0:0.2:1; % set coverage ytick
ylim(hAx(1),[0 inf]); % set error mean ylim
hAx(1).YTick = 0:0.2:2; % set error mean ytick
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','Coverage','Location','best');

figure;
x = start_point:20:end_point;
hLine = plot(x,std_matrix);
hLine(1).Marker = '*';
hLine(2).Marker = '+';
hLine(3).Marker = 'x';
hLine(4).Marker = 'd';
hLine(5).Marker = 'p';
hLine(6).Marker = '^';
hLine(7).Marker = 's';
xlabel('Area side Length (m)');
ylabel('Relative error standard deviation') % left y-axis
legend('KI','KK','KK2','DV-distance','N-hop-lateration','IWLSE','CRLB','Location','best');
