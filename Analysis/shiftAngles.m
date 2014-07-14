function shifted = shiftAngles(angles)

    x = linspace(0, 360, size(angles, 2))';
    %figure; hold on;
    for channel = [1,2,3]
        data = angles(channel, :)';
        cf = fit(x, data, 'fourier7');
        %plot(cf, x, data);
    end
    hold off;
    
    offset = find(angles(1,:)==max(angles(1,:)))-1;
    offset
    shifted = circshift(angles, [0, -offset]);
    
end