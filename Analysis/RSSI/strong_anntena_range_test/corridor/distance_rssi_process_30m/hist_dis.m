dist_rssi = load('dist_rssi_-70.0.txt');
dist = dist_rssi(:,1);
min_dist = min(dist);
max_dist = max(dist);

xcenters = min_dist:3:max_dist;
[nelements,xcenters] = hist(dist,xcenters);
figure
bar(xcenters,nelements/sum(nelements))
set(gca,'xtick',xcenters)
%hist(dist,1);