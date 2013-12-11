function plotMics()
    global port plotBuffer readSamples channels drawCounter sampleSize
    try
        fclose(port)
    catch
    end
    close all;

    sampleSize = 1;
    plotSamples = 5000;
    readSamples = 42;
    channels = 3;
    scale = 1.15;

    port = serial('COM7','BaudRate',115200, 'FlowControl', 'hardware');
    port.BytesAvailableFcnCount = readSamples;
    port.BytesAvailableFcnMode = 'byte';
    port.BytesAvailableFcn = @serial_callback;
    fopen(port);

    % signal = [255, 255, 255, 255, 255, 255];
    % buffer = zeros(1, length(signal));
    % while (1)
    %     data = fread(port, 1, 'uint8')';
    %     buffer = [data(1), buffer(1:end-1)]
    %     if signal==buffer
    %         break;
    %     end
    % end
    figure; hold on;
    size = 93;
    data = zeros(channels,size);
    ah = zeros(1, channels);
    for channel = 1:channels
        ah(channel) = subplot(channels,1,channel);
    end
    %figure; hold on;

    plotBuffer = zeros(channels,plotSamples);
    index = 1;
    drawCounter = 0;
    recording = [];
    lastPlay = 1;
    playCount = 1;

    len = 12
    
    fwrite(port, '*')

    while (1)
        pause(0.005);
        %if drawCounter >= plotSamples/20
            for channel = 1:channels
                axes(ah(channel));
                cla;
                plot(plotBuffer(channel,:).*scale ./ 2^(8*sampleSize-1));
                ylim([0, scale])
            end
            drawnow;
            refresh;
            drawCounter = 0;
        %end
        %playCount = playCount + len/channels/sampleSize;
        if playCount-lastPlay > 25000
            sample = recording(1,lastPlay:end);
            isNonZero = sample > 2;
            sample = sample .* isNonZero;
            %p = audioplayer(sample,5000);
            %p.play();
            lastPlay = length(recording)+1;
        end
    end

    fclose(port);
end
function serial_callback(obj,event)
    global port plotBuffer channels drawCounter readSamples sampleSize
    newData = fread(port, readSamples/sampleSize, ['int',num2str(8*sampleSize)])';
    newData = reshape(newData, channels, length(newData)/channels);
    
    
    drawCounter = drawCounter + readSamples;
    plotBuffer = [plotBuffer(:,readSamples/channels/sampleSize+1:end), newData];
        
end