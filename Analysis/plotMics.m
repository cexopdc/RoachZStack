clear all;
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
channels = 3;
data = zeros(channels,size);
ah = zeros(1, channels);
for channel = 1:channels
    ah(channel) = subplot(3,1,channel);
end
%figure; hold on;

plotSamples = 1000;
plotBuffer = zeros(channels,plotSamples);
index = 1;
drawCounter = 0;
signal = [255, 255, 255, 255, 255, 255];
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

    newData = fread(port, len, 'int8')';
    newData=reshape(newData, 3, length(newData)/3);
    
%     if newData(1,11) ~= -1
%         break;
%     end

    plotBuffer = [plotBuffer(:,len/3+1:end), newData];
    

    if drawCounter == plotSamples/20
        for channel = 1:channels
            axes(ah(channel));
            cla;
            plot(plotBuffer(channel,:));
            ylim([0, 256])
        end
        drawnow;
        refresh;
        drawCounter = 0;
    end
    drawCounter = drawCounter + 1;
end

fclose(port);