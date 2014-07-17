function err = eval_all(fits, data, angles, loudness)

    num_channels = size(data, 1);
    num_angles = size(data, 2);
    num_dist = size(data, 3);

    pred_angles = zeros(num_angles, num_dist);
    errors = zeros(num_angles, num_dist);

    [meshes, x, y] = predict_mesh(fits);

    for distance_index = 1:num_dist
        distance_index
        for angle_index = 1:num_angles
            actual_angle = angles(angle_index);
            [pred_angle, dist] = fit_eval(x, y, meshes, squeeze(data(:,angle_index, distance_index)));
            pred_angles(angle_index, distance_index) = pred_angle;
            error = abs(actual_angle - pred_angle);
            error = min(error, 360 - error);
            errors(angle_index, distance_index) = error;

        end
    end

    figure; surf(angles, loudness,errors');
    xlabel('Angle');
    ylabel('Distance (in)');
    zlabel('Amplitude');
    figure; surf(angles, loudness,pred_angles');
    xlabel('Angle');
    ylabel('Distance (in)');
    zlabel('Amplitude');
    
    % plot first entry
    pred = pred_angles(:,1)';
    for i = 1:length(pred)
       if i < length(pred) / 3
           if pred(i) > 180
               pred(i) = pred(i) - 360
           end
       elseif i > length(pred) * 2 / 3
           if pred(i) < 180
               pred(i) = pred(i) + 360
           end
       end
    end
    
    figure; hold on;
    plot(angles, pred);
    plot(angles, angles);
    legend('Estimation', 'Actual');
    xlabel('Actual Angle (deg)');
    ylabel('Estimated Angle (deg)');
    
    err = mean(mean(errors));
end