%aggregate rssi from 0.2 to 3.0m.
dis_mean_std = [];
for i=1:1:20
    input = load(strcat(num2str(i),'m','.txt'));
    input = input(1:500,:);

    mean_rssi = mean(input);
    std_rssi = std(input);
    dis_mean_std = [dis_mean_std;i mean_rssi std_rssi];
end