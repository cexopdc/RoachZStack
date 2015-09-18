function readADC(portString, numMics,time)
global settings status data fullData
    if (~isempty(instrfind))
        fclose(instrfind);
    end
    %close all;
    settings = {};
    status = {};
    data = {};
    
    transmitADC(time)
    
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
    
    settings.port = serial(portString,'BaudRate',115200);
    settings.port.BytesAvailableFcnCount = settings.readSamples;
    settings.port.BytesAvailableFcnMode = 'byte';
    settings.port.BytesAvailableFcn = @serial_callback;
    fopen(settings.port);

    % Set initial graphs and fill with 0
    data.plotBuffer = zeros(settings.channels, settings.plotSamples);
    count = 0;
    while (1)
        pause(0.01);  
%         count = count + 1
        if status.close_flag == 1
            break;
        end
    end
    fclose(settings.port);
end

function serial_callback(~, ~)
global settings data fullData status
    newData = fread(settings.port, settings.readSamples/settings.sampleSize, ['int',num2str(8*settings.sampleSize)])';
    length(newData);
    if (~isempty(newData))
        newData = reshape(newData, settings.channels, length(newData)/settings.channels);
        % appends new data to plot buffer
        data.plotBuffer = [data.plotBuffer(:,settings.readSamples/settings.channels/settings.sampleSize+1:end), newData]
        fullData = [fullData, newData];     
        status.close_flag = 1;
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