close all; clear all;
speaker_distances = [4, 8, 12, 16, 20, 24];
speaker_distances_scaled = speaker_distances;%(speaker_distances - mean(speaker_distances)) ./ std(speaker_distances);

% get size
load(['t2_', num2str(speaker_distances(1)), 'in']);
num_angles = size(angles, 3);
num_channels = size(angles, 1);
thetas = linspace(0, 360-360/num_angles, num_angles);
thetas_scaled = thetas;%(thetas - mean(thetas)) ./ std(thetas);

data = zeros(num_channels, num_angles, 0);
for dist = speaker_distances
    load(['t1_', num2str(dist), 'in']);
    mag = analyze2(angles, [0,0,0], 1-(dist ./ 48));
    mag = shiftAngles(mag);
    hold on;
    data = cat(3, data, mag);
end
pretty_polar(data(:, :, 1));

[x, y] = meshgrid(thetas_scaled', speaker_distances_scaled);
x = reshape(x, num_angles * length(speaker_distances), 1);
y = reshape(y, num_angles * length(speaker_distances), 1);

fits = {};
for channel = [1,2,3]
    channel_data = data(channel, :, :);
    z = reshape(squeeze(channel_data)', num_angles*length(speaker_distances), 1);
    figure; hold on;
    i = 0;
    for dist = speaker_distances
        i = i + 1;
        d = squeeze(channel_data(1, :, i));
        %plot(thetas, d);
        
        %if dist == 4
        cf=fit(thetas_scaled', d', 'poly5')%@(k,a,b,x)fit_func(k,a,b,x),'Upper', [Inf, 1, 1])
        plot(cf, thetas_scaled, d);
        %end
        
    end
    sf = fit([x,y], z, 'poly55')
    fits{channel} = sf;
    figure; plot(sf, [x,y],z);
    xlabel('Angle');
    ylabel('Distance (in)');
    zlabel('Amplitude');
end

figure;
i = 0;

theta1 = [0:360/num_angles:126];
theta2 = [117:360/num_angles:243];
theta3 = [234:360/num_angles:360];
for dist = speaker_distances
    i = i + 1;
    r12 = data(1,:,i) ./ data(2,:,i);
    r23 = data(2,:,i) ./ data(3,:,i);
    r31 = data(3,:,i) ./ data(1,:,i);
    polar(theta1 * pi / 180, r12(1:15));
    polar(theta2 * pi / 180, r23(14:28));
    polar(theta3 * pi / 180, [r31(27:40), r31(1)]);
    hold on;
end

err = eval_all(fits, data, speaker_distances);
disp(err);