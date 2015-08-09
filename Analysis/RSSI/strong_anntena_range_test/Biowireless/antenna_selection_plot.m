clear all;
barvalues = [-76.2 -78.8; -52.4 -53.6; -53.7 -54.4]; %3 groups of 2 bars: Chip, IFA, Dipole; indoor and in chamber
errors = [3.4 3.5; 2.8 2.7; 2.7 2.9]; % standard deviation for each 

width = 1; 
groupnames = {'Chip antenna'; 'Inverted-F Antenna'; 'Dipole Antenna'};
bw_title = [];
bw_xlabel = [];
bw_ylabel = 'RSSI (dBm)';
bw_colormap = 'Gray';
gridstatus = [];
bw_legend = {'Indoor'; 'Anechoic chamber'};
error_sides = 2;
legend_type = 'plot';

numgroups = size(barvalues, 1); % number of groups
numbars = size(barvalues, 2); % number of bars in a group

% Plot bars
handles.bars = bar(barvalues, width,'edgecolor','k', 'linewidth', 2);
hold on
colormap(bw_colormap);
handles.legend = legend(bw_legend, 'location', 'SouthEast', 'fontsize',12);
legend boxoff;

change_axis = 0;
ymin = 0;
if size(barvalues,2) == 1
    barvalues = barvalues';
    errors = errors';
end
if size(barvalues,1) == 1
    barvalues = [barvalues; zeros(1,length(barvalues))];
    errors = [errors; zeros(1,size(barvalues,2))];
    change_axis = 1;
end
numgroups = size(barvalues, 1); % number of groups
numbars = size(barvalues, 2); % number of bars in a group
if isempty(width)
    width = 1;
end
% Plot erros
for i = 1:numbars
    x = get(get(handles.bars(i),'children'), 'xdata');
    x = mean(x([1 3],:));
    handles.errors(i) = errorbar(x, barvalues(:,i), errors(:,i), 'k', 'linestyle', 'none', 'linewidth', 2);
    ymin = min([ymin; barvalues(:,i)+errors(:,i)]);
end

if error_sides == 1
    set(gca,'children', flipud(get(gca,'children')));
end

ylim([ymin*1.1 0]);
xlim([0.5 numgroups-change_axis+0.5]);

if strcmp(legend_type, 'axis')
    for i = 1:numbars
        xdata = get(handles.errors(i),'xdata');
        for j = 1:length(xdata)
            text(xdata(j),  -0.03*ymax*1.1, bw_legend(i), 'Rotation', 60, 'fontsize', 12, 'HorizontalAlignment', 'right');
        end
    end
    set(gca,'xaxislocation','top');
end

if ~isempty(bw_title)
    title(bw_title, 'fontsize',14);
end
if ~isempty(bw_xlabel)
    xlabel(bw_xlabel, 'fontsize',14);
end
if ~isempty(bw_ylabel)
    ylabel(bw_ylabel, 'fontsize',14);
end

set(gca, 'xticklabel', groupnames, 'box', 'off', 'ticklength', [0 0], 'fontsize', 12, 'xtick',1:numgroups, 'linewidth', 2,'xgrid','off','ygrid','off');
if ~isempty(gridstatus) && any(gridstatus == 'x')
    set(gca,'xgrid','on');
end
if ~isempty(gridstatus) && any(gridstatus ==  'y')
    set(gca,'ygrid','on');
end

handles.ax = gca;
hold off

set(gca, 'box', 'on')
exportfig(gcf,'antenna_selection.eps','height',6,'Width',8,'fontmode','Scaled', 'color', 'rgb');