function plotMics(portString, handles)
     
    global port output_socket plotBuffer readSamples channels drawCounter sampleSize recording avgData dir windowSize frames close_flag calib_flag dc_calib scale_calib
    %close all; 
    close_flag = 0;
    calib_flag = 0;
    %cleanupObj = onCleanup(@cleanup);
    
    
    %javaaddpath(pwd, '-end')
    output_port = 1234; 
    %output_socket = MatlabOutputSocket(output_port);
    assignin('caller', 'output_socket', output_socket);
    
    sampleSize = 1;
    plotSamples = 5000;
    readSamples = 42;
    channels = 3;
    sampleRate = 1.25; % kHz
    scale = 128;
    recording = zeros(channels, 0);
    avgData = zeros(channels, plotSamples);
    dir = zeros(1, plotSamples);
    windowSize = .1 * sampleRate * 1000; %s * Hz = samples
    frames = zeros(3,windowSize,0);
    
    xRange = (0:plotSamples);%/(sampleRate * 1000);

    fRange = (0:windowSize-1)*sampleRate*1000/windowSize;%/(sampleRate * 1000);

    port = serial(portString,'BaudRate',115200)%, 'FlowControl', 'hardware');
    port.BytesAvailableFcnCount = readSamples;
    port.BytesAvailableFcnMode = 'byte';
    port.BytesAvailableFcn = @serial_callback;
    fopen(port);
    closeFID = onCleanup(@() fclose(port));


    dataSize = 93;
    data = zeros(channels,dataSize);
    hAxes = zeros(1, channels);
    hPlots = zeros(1, channels);
    hAxes2 = zeros(1, channels);
    hPlots2 = zeros(1, channels);
    hAxes3 = zeros(1, channels);
    hPlots3 = zeros(1, channels);
    plotBuffer = zeros(channels,plotSamples);
    for channel = 1:channels
        hAxes(channel) = subplot(channels,1,channel,'Parent',handles.tab1);
        axes(hAxes(channel));
        hPlots(channel) = plot(xRange(1:length(plotBuffer)), plotBuffer(channel,:).*scale ./ 2^(8*sampleSize-1));
    end
    
    for channel = 1:channels    
        hAxes2(channel) = subplot(channels,1,channel,'Parent',handles.tab2);
        axes(hAxes2(channel));
        hPlots2(channel) = plot(xRange(1:length(avgData)), avgData(channel,:).*scale ./ 2^(8*sampleSize-1));
    end
    
    for channel = 1:channels    
        hAxes3(channel) = subplot(channels,1,channel,'Parent',handles.tab3);
        axes(hAxes3(channel));
        hPlots3(channel) = plot(fRange, zeros(1, windowSize));
    end
    
    
    hAxisDir = subplot(1,1,1, 'Parent', handles.tab4);
    hPlotDir = plot(dir);

    index = 1;
    drawCounter = 0;
    recording = [];
    lastPlay = 1;
    playCount = 1;
    
    fwrite(port, '*')
    
 
    dc_calib = zeros(channels, 1);
    scale_calib = ones(channels, 1);
    
    while (1)
        pause(0.01);
        if close_flag==1
            break;
        end
        if calib_flag==1
            dc_calib = min(plotBuffer, [], 2);
            plotBuffer_zero = plotBuffer;
            for channel = 1:channels
               plotBuffer_zero(channel,:) =  plotBuffer_zero(channel,:) - dc_calib(channel);
            end
            maxes = max(plotBuffer_zero, [], 2);
            max_max = max(maxes);
            scale_calib = max_max ./ maxes;
            calib_flag = 0;
        end
        %if drawCounter >= plotSamples/20
            for channel = 1:channels
                set(hAxes(channel),'YLim', [0, scale]);
                set(hPlots(channel),'ydata',(plotBuffer(channel,:) - dc_calib(channel)) * scale_calib(channel));
                
                set(hAxes2(channel),'YLim', [-scale, scale]);
                set(hPlots2(channel),'ydata',avgData(channel,:).*scale ./ 2^(8*sampleSize-1) * 2);
                
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
        
        if (size(frames, 3)>0)
            currentFrame = frames(:,:,1);
            f = abs(fft(currentFrame, [], 2)).*scale ./ 2^(8*sampleSize-1)/windowSize*2;
            power = sqrt(mean(f(:,10:end) .^ 2, 2))
            avgData = [avgData(:, 2:end), power];
            frames = frames(:,:,2:end);
            if (size(frames, 3) > 5)
                size(frames)
            end
            for channel = 1:channels
                set(hAxes3(channel),'YLim', [0, 1.2]);
                set(hAxes3(channel),'XLim', [0, sampleRate*1000/2]);
                set(hPlots3(channel),'ydata',f(channel,:));
            end
            newDir = 0;
            if (power(1) > power(2) && power(1) > power(3))
                newDir = 1;
            elseif (power(2) > power(3))
                newDir = 2;
            else
                newDir = 3;
            end
            dir = [dir(:, 2:end), newDir];
            %output_socket.write(unicode2native(mat2str(power)));
        end
    end
    % close socket connection 
    %output_socket.close();
    fclose(port);
end

function fillFrame(newData)
    global frames currentFrame windowSize channels dc_calib scale_calib
    newData_calib = newData;
    for channel = 1:channels
       newData_calib(channel,:) =  (newData_calib(channel,:) - dc_calib(channel)) * scale_calib(channel);
    end
    if (size(currentFrame, 2)<windowSize)
        if (windowSize-size(currentFrame, 2) > size(newData_calib, 2))
            currentFrame = [currentFrame newData_calib];
        else
            currentFrame = [currentFrame newData_calib(:, 1:windowSize-size(currentFrame, 2))];
            frames = cat(3, frames, [currentFrame]);
            currentFrame = [];
        end
    else
        currentFrame = [];
    end
end

function serial_callback(obj,event)
    global port plotBuffer channels drawCounter readSamples sampleSize recording avgData dir
    newData = fread(port, readSamples/sampleSize, ['int',num2str(8*sampleSize)])';
    length(newData);
    if (length(newData) > 0)
        newData = reshape(newData, channels, length(newData)/channels);
        fillFrame(newData)
        drawCounter = drawCounter + readSamples;
        % recording = [recording, newData];
        maxes = max(newData')';
        %avgData = [avgData(:, 2:end), maxes];
        
        plotBuffer = [plotBuffer(:,readSamples/channels/sampleSize+1:end), newData];
    end
        
end

function cleanup()
    disp 'CLOSING DOWN!';
    global port output_socket
    %output_socket.close();
    try
        fclose(port)
    catch
    end
end
