function plotMics(portString, handles, numMics)
    global settings status data
    if (~isempty(instrfind))
        fclose(instrfind);
    end
    %close all; 
    settings = {};
    status = {};
    data = {};
    
    %status.close_flag = 0;
    %status.calib_flag = 0;
    cleanupObj = onCleanup(@cleanup);
    

    settings.sampleSize = 1;
    settings.plotSamples = 5000;
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
    fopen(settings.port)

    hAxes = zeros(1, settings.channels);
    hPlots = zeros(1, settings.channels);

    data.plotBuffer = zeros(settings.channels, settings.plotSamples);
    
    for channel = 1:settings.channels
        hAxes(channel) = subplot(settings.channels,1,channel,'Parent',handles.tab1);
        hPlots(channel) = plot(hAxes(channel), xRange(1:length(data.plotBuffer)), data.plotBuffer(channel,:).*settings.scale ./ 2^(8*settings.sampleSize-1));
    end

    %hAxisDir = subplot(1,1,1, 'Parent', handles.tab4);
    hPlotDir = plot(data.dir);

    data.recording = [];
    
    while (1)
        pause(0.01);
    
        for channel = 1:settings.channels
            set(hAxes(channel),'YLim', [0, settings.scale]);
            set(hPlots(channel),'ydata',(data.plotBuffer(channel,:)))% - settings.dc_calib(channel)) * settings.scale_calib(channel));
        end

        %set(hAxisDir,'YLim', [0, 4]);
        %set(hPlotDir,'ydata',data.dir(:));
        drawnow;
        refresh;
        
        assignin('base', 'record', data.recording);
        
    fclose(settings.port);
    end
end

function fillFrame(newData)
    global settings data
    newData_calib = newData;
    %for channel = 1:settings.channels
    %   newData_calib(channel,:) =  (newData_calib(channel,:) - settings.dc_calib(channel)) * settings.scale_calib(channel);
    %end
    if (size(data.currentFrame, 2)<settings.windowSize)
        if (settings.windowSize-size(data.currentFrame, 2) > size(newData_calib, 2))
            data.currentFrame = [data.currentFrame newData_calib];
        else
            data.currentFrame = [data.currentFrame newData_calib(:, 1:settings.windowSize-size(data.currentFrame, 2))];
            data.frames = cat(3, data.frames, [data.currentFrame]);
            data.currentFrame = []
        end
    else
        data.currentFrame = [];
    end
end

function serial_callback(~, ~)
    global settings data
    newData = fread(settings.port, settings.readSamples/settings.sampleSize, ['int',num2str(8*settings.sampleSize)])';
    length(newData);
    if (~isempty(newData))
        newData = reshape(newData, settings.channels, length(newData)/settings.channels);
        fillFrame(newData);
  
        data.plotBuffer = [data.plotBuffer(:,settings.readSamples/settings.channels/settings.sampleSize+1:end), newData];
    end
        
end

function cleanup()
    global settings
    try
        fclose(settings.port);
        settings = rmfield(settings, 'port');
    catch
    end
    delete(timerfind)
end