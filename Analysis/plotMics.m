function plotMics()
    global port plotBuffer readSamples channels drawCounter sampleSize recording avgData dir
    try
        fclose(port)
    catch
    end
    close all;


    sampleSize = 1;
    plotSamples = 5000;
    readSamples = 42;
    channels = 3;
    sampleRate = 1.25; % kHz
    scale = 1.15;
    recording = zeros(channels, 0);
    avgData = zeros(channels, plotSamples);
    dir = zeros(1, plotSamples);
    
    xRange = (0:plotSamples);%/(sampleRate * 1000);

    port = serial('COM14','BaudRate',115200)%, 'FlowControl', 'hardware');
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
    hAxes = zeros(1, channels);
    hPlots = zeros(1, channels);
    hAxes2 = zeros(1, channels);
    hPlots2 = zeros(1, channels);
    plotBuffer = zeros(channels,plotSamples);
    for channel = 1:channels
        hAxes(channel) = subplot(channels,1,channel);
        axes(hAxes(channel));
        hPlots(channel) = plot(xRange(1:length(plotBuffer)), plotBuffer(channel,:).*scale ./ 2^(8*sampleSize-1));
    end
    figure; hold on;
    
    for channel = 1:channels    
        hAxes2(channel) = subplot(channels,1,channel);
        axes(hAxes2(channel));
        hPlots2(channel) = plot(xRange(1:length(avgData)), avgData(channel,:).*scale ./ 2^(8*sampleSize-1));
    end
    
    
    figure; hold on;
    hAxisDir = gca;
    hPlotDir = plot(dir);

    index = 1;
    drawCounter = 0;
    recording = [];
    lastPlay = 1;
    playCount = 1;
    
    fwrite(port, '*')

    while (1)
        pause(0.1);
        %if drawCounter >= plotSamples/20
            for channel = 1:channels
                set(hAxes(channel),'YLim', [0, scale]);
                set(hPlots(channel),'ydata',plotBuffer(channel,:).*scale ./ 2^(8*sampleSize-1));
                
                set(hAxes2(channel),'YLim', [0, scale]);
                set(hPlots2(channel),'ydata',avgData(channel,:).*scale ./ 2^(8*sampleSize-1));
                
            end
            
            set(hAxisDir,'YLim', [0, 4]);
            set(hPlotDir,'ydata',dir(:));
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
        %recording;
        assignin('caller', 'record', recording);
    end

    fclose(port);
end
function serial_callback(obj,event)
    global port plotBuffer channels drawCounter readSamples sampleSize recording avgData dir
    newData = fread(port, readSamples/sampleSize, ['int',num2str(8*sampleSize)])';
    length(newData);
    if (length(newData) > 0)
        newData = reshape(newData, channels, length(newData)/channels);
        drawCounter = drawCounter + readSamples;
        %recording = [recording, newData];
        maxes = max(newData')';
        avgData = [avgData(:, 2:end), maxes];
        newDir = 0;
        if (maxes(1) > maxes(2) && maxes(1) > maxes(3))
            newDir = 1;
        elseif (maxes(2) > maxes(3))
            newDir = 2;
        else
            newDir = 3;
        end
        dir = [dir(:, 2:end), newDir];
        plotBuffer = [plotBuffer(:,readSamples/channels/sampleSize+1:end), newData];
    end
        
end
