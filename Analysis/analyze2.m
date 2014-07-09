function mic_data=analyze(dataset, dc_calib)
    mic_data = [];
    
    num_angles = size(dataset, 3);
    mic_data = zeros(3, num_angles);
    
    for i=1:num_angles
        trial_data = dataset(:,:,i);
        trial_results = [];
        for channel=1:3
            data = trial_data(channel,:);
            rms_value = rms(data);
            k = max(data) * rms_value; 
            trial_results = cat(1, trial_results, k);
        end
        mic_data(:,i) = trial_results;
    end
    figure;
    mic_data = [mic_data, mic_data(:,1)]; % repeat first entry
   % mic_data = mic_data ./ (max(mic_data,[],2) * ones(1,41)); % normalize
    offset = 36 * pi / 180;
    
    t = 0 : .01 : 2 * pi;
    P = polar(t, max(max(mic_data)) * ones(size(t)));
    set(P, 'Visible', 'off')
    hold on;
    
    h1 = polar([0:num_angles]*360/num_angles*pi/180 - offset, mic_data(1,:),'b');
    h2 = polar([0:num_angles]*360/num_angles*pi/180 - offset, mic_data(2,:),'r');
    h3 = polar([0:num_angles]*360/num_angles*pi/180 - offset, mic_data(3,:),'g');
    
    set(h1, 'Color', [2, 105, 214] ./ 255);
    set(h2, 'Color', [14, 138, 3] ./ 255);
    set(h3, 'Color', [196, 22, 22] ./ 255);
    
    set([h1, h2, h3], 'LineWidth', 2);
    hTitle = title('Polar Microphone Response');
    hLegend = legend([h1, h2, h3], 'Mic A', 'Mic B', 'Mic C');
    set( gca                       , ...
    'FontName'   , 'Helvetica' );
    set([hTitle], ...
        'FontName'   , 'AvantGarde');
    set([hLegend, gca]             , ...
        'FontSize'   , 8           );
    set( hTitle                    , ...
        'FontSize'   , 12          , ...
        'FontWeight' , 'bold'      );

    set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.02 .02] , ...
      'XMinorTick'  , 'on'      , ...
      'YMinorTick'  , 'on'      , ...
      'YGrid'       , 'on'      , ...
      'XColor'      , [.3 .3 .3], ...
      'YColor'      , [.3 .3 .3], ...
      'YTick'       , 0:500:2500, ...
      'LineWidth'   , 1         );
end
