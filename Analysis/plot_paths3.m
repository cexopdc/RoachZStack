close all;
cx = [70,540];
cy = [20, 480];
I = imread('C:\Users\Eric\SkyDrive\iBionicS\IEEE Sensors 2014\data\scene2a.jpg');
i2 = imcrop(I, [cx(1), cy(1), cx(2)-cx(1), cy(2)-cy(1)]);
imshow(i2,'XData', cx, 'YData', cy, 'Border', 'tight');
hold on;

files = {'C:\Users\Eric\SkyDrive\iBionicS\IEEE Sensors 2014\data\RoachTrack_20_Jul_2014__16_51_14'};
ids_files = {[1]}
offsets = [635414862085331700+3.2*1e7];

for file_index = 1:length(files)
    file = files{file_index};

    %ids = [56, 57];
    offset_timestamp = offsets(file_index)+1;
    ids = ids_files{file_index};
    addrs = [31087];
    data = cell(length(ids));
    angle_frame = 0;
    angle_id = 0;
    angle = zeros(1, length(addrs));
    last_pos = zeros(3, length(ids));
    angle_cor = cell(length(ids));

    roach_file = fopen(fullfile(file, 'fixed_roach_view_trimmed.csv'));
    angle_file = fopen(fullfile(file, 'angles.log'));

    speaker = [419.3456, 480-385.2738];
    frame = 0;
    pos_set = 0;

    find_speaker = 0;
    if (find_speaker)
        video = VideoReader(fullfile(file, 'roach_view_trimmed.avi'));
        f = read(video, 1);
        imshow(f);
        [x, y] = ginput(1)
    end

    while 1

        while frame >= angle_frame
            if pos_set && ~isempty(angle_id) && angle_id > 0
                angle_cor{angle_id} = cat(2, angle_cor{angle_id}, cat(1,angle,squeeze(last_pos(:,angle_id))));
            end
            angle_data = textscan(angle_file, '%d64, %d, %f\n');
            angle_addr = angle_data{2};
            if ~isempty(angle_addr)
                angle_id = find(addrs==angle_addr, 1);
                angle_time = double(angle_data{1} - offset_timestamp);
                angle_frame = angle_time / 1e7 * 15.0;
                angle = angle_data{3};
            else
                break
            end
        end

        line = textscan(roach_file, '%s', 1, 'Delimiter', '\n');
        if isempty(line{1})
            break
        end
        [line, count] = sscanf(line{1}{1}, '%f   %f   %f   %f   %f   %f   ');

        count = (count) / 6;
        for i = 0:(count-1)
            id = line(i*6+1);
            r_angle = line(i*6+6)*180/pi;
            x = line(i*6+2) * .3155;
            y = line(i*6+3) * .3155;
            index = find(ids==id, 1);
            if ~isempty(index)
                data{index} = cat(2, data{index}, [x;480-y]);
                last_pos(1, index) = x;
                last_pos(2, index) = y;
                last_pos(3, index) = r_angle;
                pos_set = 1;
            end
        end

        frame = frame + 1;
    end

    errors = [];

    for i=1:length(ids)
        xy = data{i};
        plot(xy(1,:), xy(2,:), 'LineWidth', 2, 'LineSmoothing','on');

        for j=1:size(angle_cor{i}, 2)
            axya = angle_cor{i}(:,j);
            l = 25;
            ang = double(axya(1));
            dir = double(axya(4));
            x1 = axya(2);
            y1 = axya(3);

            audio_angle = -ang + dir;
            actual_angle = atan2((speaker(2) - y1), speaker(1)-x1);
            err = abs(audio_angle - actual_angle*180/pi);
            err = min(err, abs(360-err));
            errors = [errors, err];

            x2 = cos(audio_angle*pi/180.0)*l + x1;
            y2 = sin(audio_angle*pi/180.0)*l + y1;

            x2d = cos(dir*pi/180.0)*l + x1;
            y2d = sin(dir*pi/180.0)*l + y1;

            x2a = cos(actual_angle)*l + x1;
            y2a = sin(actual_angle)*l + y1;
            if (mod(j, 30)==0)
                %plot([x1, x2]', [480-y1, 480-y2]', 'Color',  [0.92941,0.14118,0.14902], 'LineWidth', 2, 'LineSmoothing','on');

                plot([x1, x2a]', [480-y1, 480-y2a]', 'black', 'LineWidth', 2);
                arrow([x1,480-y1], [x2,480-y2], 'Length', 10, 'EdgeColor', [0.92941,0.14118,0.14902], 'FaceColor', [0.92941,0.14118,0.14902], 'LineSmoothing','on');
                arrow([x1,480-y1], [x2d,480-y2d], 'Length', 10, 'EdgeColor', [ 0.4940    0.1840    0.5560], 'FaceColor', [ 0.4940    0.1840    0.5560], 'LineSmoothing','on');
            end
        end
    end
    %scatter(speaker(1), speaker(2));
    %xlim([70,540]);    
    %ylim([20 480]);
    mean(errors)
    fclose(roach_file);
    fclose(angle_file);
end