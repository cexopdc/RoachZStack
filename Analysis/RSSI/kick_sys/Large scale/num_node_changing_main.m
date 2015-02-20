close all; clear all; clc;
rng default;

global TRANS_RANGE;
global NUM_NODE;
start_point = 20;
end_point = 200;
loc_error_array=[];
connectivity_array=[];
for i=start_point:10:end_point % number of nodes
    aggregate_error=[];
    aggregate_connectivity_counter=0;
    for j=1:10 % number of trials
        [loc_error,connectivity_counter] = main(i,0.2,0.2);
        aggregate_error=[aggregate_error loc_error];
        aggregate_connectivity_counter = aggregate_connectivity_counter + connectivity_counter;
    end
    mean_loc_error = mean(aggregate_error)/TRANS_RANGE;
    avg_connectivity = aggregate_connectivity_counter/(NUM_NODE*10);
    loc_error_array = [loc_error_array mean_loc_error];
    connectivity_array = [connectivity_array avg_connectivity];
end

figure;
x = start_point:10:end_point;
[hAx,hLine1,hLine2] = plotyy(x,loc_error_array,x,connectivity_array);
hLine1.LineStyle = '-';
hLine2.LineStyle = '-';
hLine1.Marker = '*';
hLine2.Marker = 'o';
xlabel('Number of nodes');
ylabel(hAx(1),'Relative error') % left y-axis
ylabel(hAx(2),'connectivity') % right y-axis
legend('Relative error','connectivity');