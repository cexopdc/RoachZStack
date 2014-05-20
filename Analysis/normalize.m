function normalized=normalize(dataset)
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
            %figure; plot(fAxis, f);
            power = max(f(10:end));
            %power = mean(f(900:1000));
            trial_results = cat(1, trial_results, power);
        end
        mic_data = [mic_data, trial_results];
    end
    factors = max(mic_data, [], 2)
    normalized = dataset;
    normalized(1,:,:) = dataset(1,:,:) ./ factors(1);
    normalized(2,:,:) = dataset(2,:,:) ./ factors(2);
    normalized(3,:,:) = dataset(3,:,:) ./ factors(3);
end
