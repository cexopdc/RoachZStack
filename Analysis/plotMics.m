function plotMics(portString, handles, numMics)
    global settings status data
    if (~isempty(instrfind))
        fclose(instrfind);
    end
    %close all; 
    settings = {};
    status = {};
    data = {};
    
    
    settings.predict = 0;
    if evalin('base', 'exist(''fits'', ''var'')')
        settings.fits = evalin('base', 'fits');
        settings.predict = 1;
    end
    
    status.close_flag = 0;
    status.calib_flag = 0;
    status.motor_flag = 0;
    cleanupObj = onCleanup(@cleanup);
    
    data.motorAngle = 0;
    
    %javaaddpath(pwd, '-end')
    settings.output_port = 1234; 
    %settings.output_socket = MatlabOutputSocket(output_port);
    %assignin('base', 'output_socket', settings.output_socket);
    
    settings.sampleSize = 2;
    settings.plotSamples = 100;
    settings.readSamples = 42;
    settings.channels = numMics;
    settings.sampleRate = 1.25; % kHz
    settings.scale = 8192;
    data.recording = zeros(settings.channels, 0);
    data.avgData = zeros(settings.channels, settings.plotSamples);
    data.dir = zeros(1, settings.plotSamples);
    settings.windowSize = 50;
    data.frames = zeros(3,settings.windowSize,0);
    data.currentFrame = [];
    
    settings.dc_calib = zeros(settings.channels, 1);
    settings.scale_calib = ones(settings.channels, 1);
    
    
    xRange = (0:settings.plotSamples);%/(sampleRate * 1000);

    fRange = (0:settings.windowSize-1)*settings.sampleRate*1000/settings.windowSize;%/(sampleRate * 1000);

    settings.port = serial(portString,'BaudRate',115200);%, 'FlowControl', 'hardware');
    settings.port.BytesAvailableFcnCount = settings.readSamples * settings.sampleSize;
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
    
    settings.INC = 1.8; % do not change
    settings.STEP_SIZE_FACTOR = 5; % number of skips
    settings.STEP_SIZE = settings.INC * settings.STEP_SIZE_FACTOR;
    settings.NUM_STEPS = 360 / settings.STEP_SIZE;
    settings.START_DELAY = 6;
    settings.MOTOR_TIME = 3.1;
    
 
    while (1)
        pause(0.01);
        if status.close_flag==1
            break;
        end
        if status.calib_flag==1
            settings.dc_calib = prctile(data.plotBuffer, 50, 2);
            plotBuffer_zero = data.plotBuffer;
            for channel = 1:settings.channels
               plotBuffer_zero(channel,:) =  plotBuffer_zero(channel,:) - settings.dc_calib(channel);
            end
            maxes = prctile(plotBuffer_zero, 95, 2);
            max_max = max(maxes);
            % settings.scale_calib = max_max ./ maxes;
            status.calib_flag = 0;
        end
        if status.motor_flag==1
            settings.s = daq.createSession('ni');
            % Initialization daq
            data.angles = [];
            addDigitalChannel(settings.s,'Dev3','Port1/Line2:3','OutputOnly')
            t = timer('StartDelay', settings.START_DELAY, 'Period', settings.MOTOR_TIME);
            t.TimerFcn = @turnMotor;
            t.ExecutionMode = 'fixedRate';
            start(t);
            status.motor_flag = 0;
        end
        
        for channel = 1:settings.channels
            set(hAxes(channel),'YLim', [0, settings.scale]);
            set(hPlots(channel),'ydata',(data.plotBuffer(channel,:) - settings.dc_calib(channel)) * settings.scale_calib(channel));
            set(hAxes(channel),'XLim', [xRange(1), xRange(length(xRange))]);
            
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
            med = median(currentFrame, 2);
            data.avgData = [data.avgData(:, 2:end), med];
            data.frames = data.frames(:,:,2:end);
            if (size(data.frames, 3) > 5)
                size(data.frames)
            end
            if (settings.predict)
                [angle, dist] = fit_eval(settings.fits, med);
                disp(angle)
                disp(dist)
                set(hAxes3(channel),'YLim', [0, 360]);
                set(hAxes3(channel),'XLim', [0, settings.sampleRate*1000/2]);
                %set(hPlots3(channel),'ydata',f(channel,:));
            end
            data.dir = [data.dir(:, 2:end), angle];
            %output_socket.write(unicode2native(mat2str(power)));
        end
    end
    % close socket connection 
    %output_socket.close();
    fclose(settings.port);
end

function turnMotor(t, ~)
    global data settings
    data.angles = cat(3, data.angles, data.plotBuffer);
    for j=1:settings.STEP_SIZE_FACTOR
        outputSingleScan (settings.s,[1,1]);
        outputSingleScan (settings.s,[1,0]);          
        pause(0.01);
    end
    data.motorAngle = data.motorAngle + settings.STEP_SIZE;
    disp(data.motorAngle);
    if (data.motorAngle >= 360)
        stop(t);
        delete(t);
       
        analyze2(data.angles, settings.dc_calib);
        assignin('base', 'angles', data.angles);
        assignin('base', 'dc_calib', settings.dc_calib);
    end
end

function fillFrame(newData)
    global settings data
    newData_calib = newData;
    for channel = 1:settings.channels
       newData_calib(channel,:) =  (newData_calib(channel,:) - settings.dc_calib(channel)) * settings.scale_calib(channel);
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
    global settings data
    newData = fread(settings.port, settings.readSamples, ['int',num2str(8*settings.sampleSize)])';
    length(newData);
    if (~isempty(newData))
        newData = reshape(newData, settings.channels, length(newData)/settings.channels);
        fillFrame(newData);
        % recording = [recording, newData];
        %maxes = max(newData')';
        %avgData = [avgData(:, 2:end), maxes];
        
        data.plotBuffer = [data.plotBuffer(:,settings.readSamples/settings.channels+1:end), newData];
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
