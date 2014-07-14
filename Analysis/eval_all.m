function err = eval_all(fits, data, speaker_distances)

    num_channels = size(data, 1);
    num_angles = size(data, 2);
    num_dist = size(data, 3);

    angles = linspace(0, 360-360/num_angles, num_angles);
    pred_angles = zeros(num_angles, num_dist);
    errors = zeros(num_angles, num_dist);

    for distance_index = 1:num_dist
        for angle_index = 1:num_angles
            angle = angles(angle_index);
            distance = speaker_distances(distance_index);
            [pred_angle, dist] = fit_eval(fits, squeeze(data(:,angle_index, distance_index)));
            pred_angles(angle_index, distance_index) = pred_angle;
            error = abs(angle - pred_angle);
            error = min(error, 360 - error);
            errors(angle_index, distance_index) = error;

        end
    end

    figure; surf(angles,speaker_distances,errors');
    xlabel('Angle');
    ylabel('Distance (in)');
    zlabel('Amplitude');
    figure; surf(angles,speaker_distances,pred_angles');
    xlabel('Angle');
    ylabel('Distance (in)');
    zlabel('Amplitude');
    
    err = mean(mean(errors));
end