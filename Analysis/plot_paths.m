hold on;

file2 = 'C:\Users\Eric\Desktop\RoachTrack_19_Jul_2014__19_46_23';
file = 'C:\Users\Eric\SkyDrive\iBionicS\IEEE Sensors 2014\data\RoachTrack_20_Jul_2014__11_05_07';


%ids = [56, 57];
ids = [1,0];
addrs = [31087,31088];
data = cell(length(ids));
angle_time = 0;
angle_id = 0;
angle = zeros(1, length(addrs));
last_pos = zeros(3, length(ids));
angle_cor = cell(length(ids));

roach_file = fopen(fullfile(file, 'roach.log'));
angle_file = fopen(fullfile(file, 'angles.log'));
video = VideoReader(fullfile(file, 'roach_view.avi'));
pos_set = 0;

speaker = [482.1373-(640-480)/2, 274.0250];%[145.77-(640-480)/2, 358.31];

while 1
    C = textscan(roach_file, '%d64,%s\n');
    time = C{1};
    if isempty(time)
        break
    end
    
    while time >= angle_time
        if pos_set==1 && ~isempty(angle_id) && angle_id > 0
            angle_cor{angle_id} = cat(2, angle_cor{angle_id}, cat(1,angle,squeeze(last_pos(:,angle_id))));
        end
        angle_data = textscan(angle_file, '%d64, %d, %f\n');
        angle_addr = angle_data{2};
        if ~isempty(angle_addr)
            angle_id = find(addrs==angle_addr, 1);
            angle_time = angle_data{1};
            angle = angle_data{3};
        else
            break
        end
    end

    [line, count] = sscanf(C{2}{1}, '%d,%f,%f,%f%[,]');
    count = (count+1) / 5;
    for i = 0:(count-1)
        id = line(i*5+1);
        r_angle = line(i*5+2);
        x = line(i*5+3);
        y = line(i*5+4);
        index = find(ids==id, 1);
        if ~isempty(index)
            data{index} = cat(2, data{index}, [x;y]);
            last_pos(1, index) = x;
            last_pos(2, index) = y;
            last_pos(3, index) = r_angle;
            pos_set = 1;
        end
    end
end

errors = [];

for i=1:length(ids)
    xy = data{i};
    plot(xy(1,:), -xy(2,:), 'LineWidth', 2);
    
    for j=1:size(angle_cor{i}, 2)
        axya = angle_cor{i}(:,j);
        l = 25;
        ang = double(axya(1));
        dir = double(axya(4));
        x1 = axya(2);
        y1 = axya(3);
        
        audio_angle = -ang + dir;
        actual_angle = atan2(-(speaker(2) - y1), speaker(1)-x1);
        err = abs(audio_angle - actual_angle*180/pi);
        err = min(err, abs(360-err));
        errors = [errors, err];
        
        x2 = cos(audio_angle*pi/180.0)*l + x1;
        y2 = -sin(audio_angle*pi/180.0)*l + y1;
        
        x2d = cos(dir*pi/180.0)*l + x1;
        y2d = -sin(dir*pi/180.0)*l + y1;
        
        x2a = cos(actual_angle)*l + x1;
        y2a = -sin(actual_angle)*l + y1;
        if (mod(j, 12)==0)
            plot([x1, x2]', [-y1, -y2]', 'Color',  [0.92941,0.14118,0.14902]);

            plot([x1, x2d]', [-y1, -y2d]', 'black');
            plot([x1, x2a]', [-y1, -y2a]', 'green');
        end
    end
end
scatter(speaker(1), -speaker(2));
xlim([0,480]);    
ylim([-480, 0]);
mean(errors)
