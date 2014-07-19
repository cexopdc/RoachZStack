function plotMics(portString, handles, numMics)
    global settings status data
    if (~isempty(instrfind))
        fclose(instrfind);
    end
    %close all; 
    settings = {};
    status = {};
    data = {};
    
    settings.nodes = [31087];%hex2dec('3751')];%, hex2dec('5110')];
    settings.num_nodes = length(settings.nodes);
    
    % 0 expecting addr
    % 1 expecting data
    % 2 expected terminator
    settings.state = 2;
    settings.node = 0;
    
    
    settings.predict = 1;
    
    if settings.predict
        for node = 1:settings.num_nodes
            fit_data = {};
            load(num2str(settings.nodes(node)), 'fits');
            settings.fits{node} = fits;
            [fit_data.meshes, fit_data.x, fit_data.y] = predict_mesh(settings.fits{node});
            settings.fit_data{node} = fit_data;
        end
    end
    
    status.close_flag = 0;
    status.calib_flag = 0;
    status.motor_flag = 0;
    status.open_socket = 0;
    cleanupObj = onCleanup(@cleanup);
    
    data.motorAngle = 0;

    settings.sampleSize = 2;
    settings.plotSamples = 100;
    settings.readSamples = 42;
    settings.channels = numMics;
    settings.sampleRate = 1.25; % kHz
    settings.scale = 8192;
    
    data.leftover = [];
    data.recording = zeros(settings.channels, settings.num_nodes, 0);
    data.avgData = zeros(settings.channels, settings.num_nodes, settings.plotSamples);
    data.dir = zeros(settings.num_nodes, settings.plotSamples);
    settings.windowSize = 10;
    data.frames = cell(settings.num_nodes,1); %zeros(settings.channels, settings.num_nodes, settings.windowSize, 0);
    data.frame_index = zeros(settings.num_nodes, 1);
    data.currentFrame = zeros(settings.channels,settings.num_nodes, settings.windowSize);
    
    settings.dc_calib = zeros(settings.channels, settings.num_nodes, 1);
    settings.scale_calib = ones(settings.channels, settings.num_nodes, 1);
    
    
    xRange = (0:settings.plotSamples);%/(sampleRate * 1000);

    fRange = (0:settings.windowSize-1)*settings.sampleRate*1000/settings.windowSize;%/(sampleRate * 1000);

    settings.port = serial(portString,'BaudRate',115200);%, 'FlowControl', 'hardware');
    settings.port.BytesAvailableFcnCount = settings.readSamples * settings.sampleSize;
    settings.port.BytesAvailableFcnMode = 'byte';
    %settings.port.Terminator = {char(13) char(10)};
    settings.port.BytesAvailableFcn = @serial_callback;
    fopen(settings.port);

    hAxes = zeros(settings.channels,settings.num_nodes);
    hPlots = zeros(settings.channels,settings.num_nodes);
    hAxes2 = zeros(settings.channels,settings.num_nodes);
    hPlots2 = zeros(settings.channels,settings.num_nodes);
    hAxes3 = zeros(settings.channels,settings.num_nodes);
    hPlots3 = zeros(settings.channels,settings.num_nodes);
    hAxesDir = zeros(settings.num_nodes, 1);
    hPlotsDir = zeros(settings.num_nodes, 1);
    data.plotBuffer = zeros(settings.channels, settings.num_nodes, settings.plotSamples);
    for channel = 1:settings.channels
        for node = 1:settings.num_nodes
            hAxes(channel, node) = subplot(settings.channels,settings.num_nodes,settings.num_nodes*(channel-1)+node,'Parent',handles.tab1);
            hPlots(channel, node) = plot(hAxes(channel, node), xRange(1:size(data.plotBuffer, 3)), squeeze(data.plotBuffer(channel,node,:)).*settings.scale ./ 2^(8*settings.sampleSize-1));
        end
    end
    
    for channel = 1:settings.channels
        for node = 1:settings.num_nodes
            hAxes2(channel, node) = subplot(settings.channels,settings.num_nodes,settings.num_nodes*(channel-1)+node,'Parent',handles.tab2);
            hPlots2(channel, node) = plot(hAxes2(channel, node), xRange(1:size(data.avgData, 3)),squeeze(data.avgData(channel,node,:)).*settings.scale ./ 2^(8*settings.sampleSize-1));
        end
    end
    
    for channel = 1:settings.channels
        for node = 1:settings.num_nodes
            hAxes3(channel, node) = subplot(settings.channels,settings.num_nodes,settings.num_nodes*(channel-1)+node,'Parent',handles.tab3);
            hPlots3(channel, node) = plot(hAxes3(channel, node), fRange, zeros(1, settings.windowSize));
        end
    end
    
    for node = 1:settings.num_nodes
        hAxesDir(node) = subplot(settings.num_nodes,1,node,'Parent',handles.tab4);
        hPlotsDir(node) = plot(hAxesDir(node), data.dir(node,:));
    end

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
            settings.dc_calib = prctile(data.plotBuffer, 50, 3);
            plotBuffer_zero = data.plotBuffer;
            for channel = 1:settings.channels
                for node = 1:settings.num_nodes
                    plotBuffer_zero(channel,node,:) =  plotBuffer_zero(channel,node,:) - settings.dc_calib(channel, node);
                end
            end
            maxes = prctile(plotBuffer_zero, 95, 3);
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
        
        if status.open_socket==1
            try
                fclose(settings.output_socket);
            catch
            end
            settings.output_socket = tcpip('localhost', 12345, 'NetworkRole', 'server');
            settings.output_socket.BytesAvailableFcnCount = 1;
            settings.output_socket.BytesAvailableFcnMode = 'byte';
            settings.output_socket.BytesAvailableFcn = @socket_callback;
            fopen(settings.output_socket)
            status.open_socket = 0;
        end
        
        for channel = 1:settings.channels
            for node = 1:settings.num_nodes
                set(hAxes(channel, node),'YLim', [0, settings.scale]);
                set(hPlots(channel, node),'ydata',(data.plotBuffer(channel, node,:) - settings.dc_calib(channel, node)) * settings.scale_calib(channel, node));
                set(hAxes(channel, node),'XLim', [xRange(1), xRange(length(xRange))]);

                set(hAxes2(channel, node),'YLim', [-settings.scale, settings.scale]);
                set(hPlots2(channel, node),'ydata',data.avgData(channel,node,:).*settings.scale ./ 2^(8*settings.sampleSize-1) * 2);
            end
        end

        for node = 1:settings.num_nodes
            set(hAxesDir(node),'YLim', [0, 360]);
            set(hPlotsDir(node),'ydata',data.dir(node,:));
        end
        
        drawnow;
        refresh;
        
        assignin('base', 'record', data.recording);
        
        if (settings.predict)
            pred_angles = zeros(0, settings.num_nodes);
            for node = 1:settings.num_nodes
                frames = data.frames{node};
                if ~isempty(frames)
                    currentFrame = squeeze(frames(:,:,1));
                    med = median(currentFrame, 2);
                    %data.avgData = cat(3, data.avgData(:, :, 2:end), med);
                    data.frames{node} = frames(:,:,2:end);
                    if (size(data.frames{node}, 3) > 5)
                        size(data.frames{node}, 3)
                    end
                
                    fit_data = settings.fit_data{node};
                    node_data = med;
                    [pred_angle, dist] = fit_eval(fit_data.x, fit_data.y, fit_data.meshes, node_data);
                    disp(pred_angle)
                    %disp(dist)
                    pred_angles(node) = pred_angle;
                    %set(hAxes3(channel),'YLim', [0, 360]);
                    %set(hAxes3(channel),'XLim', [0, settings.sampleRate*1000/2]);
                    %set(hPlots3(channel),'ydata',f(channel,:));
                    data.dir(node,:) = [data.dir(node, 2:end), pred_angle];
                    toSend = [settings.nodes(settings.node), pred_angle];
                    if isfield(settings, 'output_socket')
                        fwrite(settings.output_socket,unicode2native(mat2str(toSend)));
                    end
                end
            end
        end
    end
    
    if isfield(settings, 'output_socket')
        % close socket connection 
        fclose(settings.output_socket);
    end
    
    if isfield(settings, 'port')
        fclose(settings.port);
    end
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
        figure;
        analyze2(data.angles, settings.dc_calib);
        assignin('base', 'angles', data.angles);
        assignin('base', 'dc_calib', settings.dc_calib);
    end
end

function fillFrame(newData)
    global settings data
    newData_calib = newData;
    for channel = 1:settings.channels
        newData_calib(channel,1,:) =  (newData_calib(channel,1,:) - settings.dc_calib(channel,settings.node)) * settings.scale_calib(channel,settings.node);
    end
    if (data.frame_index(settings.node)<settings.windowSize)
        if (settings.windowSize-data.frame_index(settings.node) > size(newData_calib, 3))
            data.currentFrame(:,settings.node,data.frame_index(settings.node)+1:data.frame_index(settings.node)+size(newData_calib,3)) = newData_calib;
            data.frame_index(settings.node) = data.frame_index(settings.node) + size(newData_calib,3);
        else
            data.currentFrame(:,settings.node,data.frame_index(settings.node)+1:end) = newData_calib(:, 1, 1:settings.windowSize-data.frame_index(settings.node));
            data.frame_index(settings.node) = 0;
            data.frames{settings.node} = cat(3, data.frames{settings.node}, squeeze(data.currentFrame(:,settings.node,:)));
            data.currentFrame(:,settings.node,:) = zeros(settings.channels, 1, settings.windowSize);
        end
    else
        data.currentFrame(:,settings.node,:) = zeros(settings.channels, 1, settings.windowSize);
    end
end

function process(newData)
    global settings data
    newData = [data.leftover, newData];
    newAudio = [];
    data.leftover = [];
    if settings.state == 0
        % expecting addr
        addr = newData(1);
        settings.node = find(settings.nodes == addr);
        if isempty(settings.node)
           settings.node = find(settings.nodes==0,1);
           settings.nodes(settings.node) = addr
        end
        newData = newData(2:end);
        settings.state = 1;
    end
    if settings.state == 1
        index = find(newData == -4370, 1);
        if length(index) == 1
            newAudio = newData(1:index-1);
            newData = newData(index:end);
            settings.state = 2;
        else
            newAudio = newData(1:length(newData) - mod(length(newData), settings.channels));
            newData = newData(length(newData) - mod(length(newData), settings.channels)+1:end);
        end
    end
    if settings.state == 2
        index = find(newData == -4370, 1);
        if length(index) == 1
            newData = newData(index+1:end);
            settings.state = 0;
        else
            newData = [];
        end
    end
    data.leftover = newData;
    if (~isempty(newAudio) && ~isempty(settings.node))
        newAudio = reshape(newAudio, settings.channels, 1, length(newAudio)/settings.channels);
        fillFrame(newAudio);
        % recording = [recording, newData];
        %maxes = max(newData')';
        %avgData = [avgData(:, 2:end), maxes];
        data.plotBuffer(:,settings.node,:) = cat(3, data.plotBuffer(:,settings.node,size(newAudio,3)+1:end), newAudio);
    end
    if length(data.leftover) > settings.channels
        process([]);
    end
end

function serial_callback(~, ~)
    global settings
    newData = fread(settings.port, settings.readSamples, ['int',num2str(8*settings.sampleSize)])';
    process(newData);        
end

function socket_callback(~, ~)
    global settings
    if (settings.output_socket.BytesAvailable > 0)
        newData = fread(settings.output_socket, settings.output_socket.BytesAvailable, 'int8')';
        disp(newData);
        toSend = typecast(org.apache.commons.codec.binary.Base64.decodeBase64(newData), 'uint8')';
        fwrite(settings.port, toSend);
    end
end

function cleanup()
    global settings
    try
        fclose(settings.output_socket)
        settings = rmfield(settings, 'output_socket');
    catch
    end
    
    try
        fclose(settings.port);
        settings = rmfield(settings, 'port');
    catch
    end
    delete(timerfind)
end
