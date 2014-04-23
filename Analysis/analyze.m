function mic_data=analyze(dataset)
    mic_data = [];
    windowSize = 1000;
    sampleRate = 1250;
    
    points = size(dataset, 3);
    
    fAxis = (0:windowSize-1)*sampleRate/windowSize;
    for i=1:points
        trial_data = dataset(:,:,i);
        trial_results = [];
        for channel=1:3
            data = trial_data(channel,:);
            f = abs(fft(data))/length(data);
            sum(data)
            %figure; plot(fAxis, f);
            power = mean(f(10:end));
            trial_results = cat(1, trial_results, power);
        end
        mic_data = [mic_data, trial_results];
    end
    figure;
    
    polar([0:points-1]*360/points*pi/180, mic_data(3,:));
    hold on;
    
    polar([0:points-1]*360/points*pi/180, mic_data(2,:),'r');
    
    polar([0:points-1]*360/points*pi/180, mic_data(1,:),'g');
end
