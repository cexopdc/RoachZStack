function [fits, thetas, loudness]=analyze3d()
close all;

[loudness, filenames]=textread('dataset.csv','%f,%s');

% get size
load(filenames{1}, 'angles');
num_angles = size(angles, 3);
num_channels = size(angles, 1);
thetas = linspace(0, 360-360/num_angles, num_angles);


data = zeros(num_channels, num_angles, 0);
for i = 1:length(filenames)
    filename = filenames{i};
    decibels = loudness(i);
    load(filename, 'angles');
    mag = analyze2(angles, [0,0,0], (decibels ./ 96));
    mag = shiftAngles(mag);
    hold on;
    data = cat(3, data, mag);
end
pretty_polar(data(:, :, 1));

[x, y] = meshgrid(thetas', loudness);
x = reshape(x, num_angles * length(loudness), 1);
y = reshape(y, num_angles * length(loudness), 1);

fits = {};
for channel = [1,2,3]
    channel_data = data(channel, :, :);
    z = reshape(squeeze(channel_data)', num_angles*length(loudness), 1);
    figure; hold on;
    i = 0;
    for decibel = loudness'
        i = i + 1;
        d = squeeze(channel_data(1, :, i));
        %plot(thetas, d);
        
        %if dist == 4
        cf=fit(thetas', d', 'poly5')%@(k,a,b,x)fit_func(k,a,b,x),'Upper', [Inf, 1, 1])
        plot(cf, thetas, d);
        %end
        
    end
    sf = fit([x,y], z, 'loess')
    fits{channel} = sf;
    figure; plot(sf, [x,y],z);
    xlabel('Angle');
    ylabel('Intensity (dB)');
    zlabel('Microphone Amplitude');
end

figure;
i = 0;

theta1 = [0:360/num_angles:126];
theta2 = [117:360/num_angles:243];
theta3 = [234:360/num_angles:360];
for decibel = loudness'
    i = i + 1;
    r12 = data(1,:,i) ./ data(2,:,i);
    r23 = data(2,:,i) ./ data(3,:,i);
    r31 = data(3,:,i) ./ data(1,:,i);
    polar(theta1 * pi / 180, r12(1:15));
    polar(theta2 * pi / 180, r23(14:28));
    polar(theta3 * pi / 180, [r31(27:40), r31(1)]);
    hold on;
end

err = eval_all(fits, data, thetas, loudness);
disp(err);

end