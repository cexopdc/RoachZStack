function plotMics(portString, handles, numMics)
global settings status data fullData
    if (~isempty(instrfind))
        fclose(instrfind);
    end
    %close all;
    settings = {};
    status = {};
    data = {};
    
    status.close_flag = 0;
    cleanupObj = onCleanup(@cleanup);
        
    settings.sampleSize = 1;
    settings.plotSamples = 10000;
    settings.readSamples = 48;
    settings.channels = numMics;
    settings.sampleRate = 1.25; % kHz
    settings.scale = 128;
    settings.windowSize = .1 * settings.sampleRate * 1000; %s * Hz = samples
    
    data.dir = zeros(1, settings.plotSamples);   
    
    xRange = (0:settings.plotSamples);%/(sampleRate * 1000);
    fRange = (0:settings.windowSize-1)*settings.sampleRate*1000/settings.windowSize;%/(sampleRate * 1000);

    settings.port = serial(portString,'BaudRate',115200);%, 'FlowControl', 'hardware');
    settings.port.BytesAvailableFcnCount = settings.readSamples;
    settings.port.BytesAvailableFcnMode = 'byte';
    settings.port.BytesAvailableFcn = @serial_callback;
    fopen(settings.port);

    % Set initial graphs and fill with 0
    hAxes = zeros(1, settings.channels);
    hPlots = zeros(1, settings.channels);
    data.plotBuffer = zeros(settings.channels, settings.plotSamples);
    for channel = 1:settings.channels
        hAxes(channel) = subplot(settings.channels,1,channel,'Parent',handles.tab1);
        hPlots(channel) = plot(hAxes(channel), xRange(1:length(data.plotBuffer)), data.plotBuffer(channel,:).*settings.scale ./ 2^(8*settings.sampleSize-1));
    end
       
    hAxisDir = subplot(1,1,1, 'Parent', handles.tab4);

    while (1)
        pause(0.01);
        if status.close_flag==1
            break;
        end
        
        % plot data received from serial port
        for channel = 1:settings.channels
            set(hAxes(channel),'YLim', [0, settings.scale]);
            set(hPlots(channel),'ydata',(data.plotBuffer(channel,:)));
        end
        drawnow;
        refresh;
    end
    fclose(settings.port);
end

function serial_callback(~, ~)
global settings data fullData
    newData = fread(settings.port, settings.readSamples/settings.sampleSize, ['int',num2str(8*settings.sampleSize)])';
    length(newData);
    if (~isempty(newData))
        newData = reshape(newData, settings.channels, length(newData)/settings.channels);
        % appends new data to plot buffer
        data.plotBuffer = [data.plotBuffer(:,settings.readSamples/settings.channels/settings.sampleSize+1:end), newData];
        fullData = [fullData, newData];        
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