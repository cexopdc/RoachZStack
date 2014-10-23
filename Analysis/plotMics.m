function plotMics(portString, handles, numMics)
global settings status data savedDataBuffer
    if (~isempty(instrfind))
        fclose(instrfind);
    end
    %close all;
    settings = {};
    status = {};
    data = {};
    
    status.close_flag = 0;
    status.calib_flag = 0;
    status.motor_flag = 0;
    cleanupObj = onCleanup(@cleanup);
    
    data.motorAngle = 0;
    
    %javaaddpath(pwd, '-end')
    settings.output_port = 1234;
    %settings.output_socket = MatlabOutputSocket(output_port);
    %assignin('base', 'output_socket', settings.output_socket);
    
    settings.sampleSize = 1;
    settings.plotSamples = 10000;
    settings.readSamples = 48;
    settings.channels = numMics;
    settings.sampleRate = 1.25; % kHz
    settings.scale = 128;
    data.recording = zeros(settings.channels, 0);
    data.avgData = zeros(settings.channels, settings.plotSamples);
    data.dir = zeros(1, settings.plotSamples);
    settings.windowSize = .1 * settings.sampleRate * 1000; %s * Hz = samples
    data.frames = zeros(settings.channels,settings.windowSize,0);
    data.currentFrame = [];
    
    settings.dc_calib = zeros(settings.channels, 1);
    settings.scale_calib = ones(settings.channels, 1);
    
    
    xRange = (0:settings.plotSamples);%/(sampleRate * 1000);

    fRange = (0:settings.windowSize-1)*settings.sampleRate*1000/settings.windowSize;%/(sampleRate * 1000);

    settings.port = serial(portString,'BaudRate',115200);%, 'FlowControl', 'hardware');
    settings.port.BytesAvailableFcnCount = settings.readSamples;
    settings.port.BytesAvailableFcnMode = 'byte';
    settings.port.BytesAvailableFcn = @serial_callback;
    fopen(settings.port);

    hAxes = zeros(1, settings.channels);
    hPlots = zeros(1, settings.channels);
    hAxes2 = zeros(1, settings.channels);
    hPlots2 = zeros(1, settings.channels);
    hAxes3 = zeros(1, settings.channels);
    hPlots3 = zeros(1, settings.channels);
    data.plotBuffer = zeros(settings.channels, settings.plotSamples);
    for channel = 1:settings.channels
        hAxes(channel) = subplot(settings.channels,1,channel,'Parent',handles.tab1);
        hPlots(channel) = plot(hAxes(channel), xRange(1:length(data.plotBuffer)), data.plotBuffer(channel,:).*settings.scale ./ 2^(8*settings.sampleSize-1));
    end
    
    for channel = 1:settings.channels
        hAxes2(channel) = subplot(settings.channels,1,channel,'Parent',handles.tab2);
        hPlots2(channel) = plot(hAxes2(channel), xRange(1:length(data.avgData)), data.avgData(channel,:).*settings.scale ./ 2^(8*settings.sampleSize-1));
    end
    
    for channel = 1:settings.channels
        hAxes3(channel) = subplot(settings.channels,1,channel,'Parent',handles.tab3);
        hPlots3(channel) = plot(hAxes3(channel), fRange, zeros(1, settings.windowSize));
    end
    
    
    hAxisDir = subplot(1,1,1, 'Parent', handles.tab4);
    hPlotDir = plot(data.dir);

    data.recording = [];
%     savedDataBuffer = [savedDataBuffer, data.plotBuffer]
%     assignin('base', 'saved', savedDataBuffer)
 
    while (1)
        pause(0.01);
        if status.close_flag==1
            break;
        end
        if status.calib_flag==1
            settings.dc_calib = prctile(data.plotBuffer, 5, 2);
            plotBuffer_zero = data.plotBuffer;
            for channel = 1:settings.channels
               plotBuffer_zero(channel,:) = plotBuffer_zero(channel,:) - settings.dc_calib(channel);
            end
            maxes = prctile(plotBuffer_zero, 95, 2);
            max_max = max(maxes);
            settings.scale_calib = max_max ./ maxes;
            status.calib_flag = 0;
        end
        
        
        for channel = 1:settings.channels
            set(hAxes(channel),'YLim', [0, settings.scale]);
            %data.plotBuffer(channel,:)
            %assignin('base','plotbuffer',data.plotBuffer(channel,:))
            set(hPlots(channel),'ydata',(data.plotBuffer(channel,:) - settings.dc_calib(channel)) * settings.scale_calib(channel));

            set(hAxes2(channel),'YLim', [-settings.scale, settings.scale]);
            set(hPlots2(channel),'ydata',data.avgData(channel,:).*settings.scale ./ 2^(8*settings.sampleSize-1) * 2);

        end

        set(hAxisDir,'YLim', [0, 4]);
        set(hPlotDir,'ydata',data.dir(:));
        drawnow;
        refresh;
        
        assignin('base', 'record', data.recording);
        
        
        if (size(data.frames, 3)>0)
            currentFrame = data.frames(:,:,1);
            f = abs(fft(currentFrame, [], 2)).*settings.scale ./ 2^(8*settings.sampleSize-1)/settings.windowSize*2;
            power = sqrt(mean(f(:,10:end) .^ 2, 2));
            data.avgData = [data.avgData(:, 2:end), power];
            data.frames = data.frames(:,:,2:end);
            if (size(data.frames, 3) > 5)
                size(data.frames)
            end
            for channel = 1:settings.channels
                set(hAxes3(channel),'YLim', [0, 1.2]);
                set(hAxes3(channel),'XLim', [0, settings.sampleRate*1000/2]);
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
            data.dir = [data.dir(:, 2:end), newDir];
            %output_socket.write(unicode2native(mat2str(power)));
        end
    end
    % close socket connection
    %output_socket.close();
    fclose(settings.port);
end

% used on the other plots - power, etc. 
function fillFrame(newData)
global settings data
    newData_calib = newData;
    for channel = 1:settings.channels
       newData_calib(channel,:) = (newData_calib(channel,:) - settings.dc_calib(channel)) * settings.scale_calib(channel);
    end
    if (size(data.currentFrame, 2)<settings.windowSize)
        if (settings.windowSize-size(data.currentFrame, 2) > size(newData_calib, 2))
            data.currentFrame = [data.currentFrame newData_calib];
        else
            data.currentFrame = [data.currentFrame newData_calib(:, 1:settings.windowSize-size(data.currentFrame, 2))];
            data.frames = cat(3, data.frames, [data.currentFrame]);
            data.currentFrame = [];
        end
    else
        data.currentFrame = [];
    end
end

function serial_callback(~, ~)
global settings data savedDataBuffer
    newData = fread(settings.port, settings.readSamples/settings.sampleSize, ['int',num2str(8*settings.sampleSize)])';
    length(newData);
    if (~isempty(newData))
        newData = reshape(newData, settings.channels, length(newData)/settings.channels)
        %fillFrame(newData);
        % appends new data to plot buffer
        data.plotBuffer = [data.plotBuffer(:,settings.readSamples/settings.channels/settings.sampleSize+1:end), newData]
        %savedDataBuffer = [savedDataBuffer, data.plotBuffer]
        %assignin('base', 'saved', savedDataBuffer)
       
%         fid = fopen('output_data.txt', 'at'); % opens file for appending
%         dlmwrite('output_data.txt',newData','-append') %fprintf(fid, ' %3d ', dataBuffer);
%         fclose('all');
%         
    end
        
end

function cleanup()
global settings
    %settings.output_socket.close();
    try
        fclose(settings.port);
        settings = rmfield(settings, 'port');
    catch
    end
    delete(timerfind)
end