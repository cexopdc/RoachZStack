function burst(portString)
    global settings status data
    if (~isempty(instrfind))
        fclose(instrfind);
    end
    %close all; 
    settings = {};
    status = {};
    data = {};
    
    cleanupObj = onCleanup(@cleanup);
    
    settings.sampleSize = 1;
    settings.plotSamples = 330;
    settings.readSamples = 1;
    settings.sampleRate = 1.25; % kHz
    settings.scale = 8192;
    data.recording = zeros(1, 0);    
    
    settings.port = serial(portString,'BaudRate',115200);%, 'FlowControl', 'hardware');
    settings.port.BytesAvailableFcnCount = settings.readSamples * settings.sampleSize;
    settings.port.BytesAvailableFcnMode = 'byte';
    settings.port.BytesAvailableFcn = @serial_callback;
    fopen(settings.port);
    disp(settings.port);

    data.recording = [];

 
    pause(10);
    assignin('base', 'recording', data.recording);

    
    fclose(settings.port);
end

function serial_callback(obj, ~)
    global settings data
    if (obj.BytesAvailable > 0)
        newData = fread(settings.port, obj.BytesAvailable, ['int',num2str(8*settings.sampleSize)])';
        length(newData)
        if (~isempty(newData))
            data.recording = [data.recording, newData];
        end
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
