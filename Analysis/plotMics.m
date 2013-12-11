try
    fclose(port)
catch
end
close all;

port = serial('COM7','BaudRate',115200, 'FlowControl', 'hardware');
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
channels = 2;
data = zeros(channels,size);
ah = zeros(1, channels);
for channel = 1:channels
    ah(channel) = subplot(channels,1,channel);
end
%figure; hold on;

plotSamples = 10000;
plotBuffer = zeros(channels,plotSamples);
index = 1;
drawCounter = 0;
signal = [255, 255, 255, 255, 255, 255];
sampleSize = 1;
recording = [];
lastPlay = 1;
playCount = 1;


while (1)
    
    buffer = zeros(1, length(signal));
    while (1)
        data = fread(port, 1, 'uint8')';
        buffer = [data(1), buffer(1:end-1)];
        if signal==buffer
            break;
        end
    end
    
    len = fread(port, 1, 'uint16');
    if (len ~= 90)
        x = 0
    end
while(len > 1000 || len <=0 )
    len = fread(port, 1, 'uint16')
end
    newData = fread(port, len/sampleSize, ['int',num2str(8*sampleSize)])';
    if (min(newData) == -1)
        x = 0
        len
        newData
    end
    newData = reshape(newData, channels, length(newData)/channels);
    recording = [recording, newData];
    if sum(newData(1,:) > 100)
        t = 3;
    end

    plotBuffer = [plotBuffer(:,len/channels/sampleSize+1:end), newData];
    

    if drawCounter == plotSamples/20
        for channel = 1:channels
            axes(ah(channel));
            cla;
            plot(plotBuffer(channel,:));
            ylim([0, 2^(8*sampleSize-1)])
        end
        drawnow;
        refresh;
        drawCounter = 0;
    end
    %drawCounter = drawCounter + 1;
    playCount = playCount + len/channels/sampleSize;
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