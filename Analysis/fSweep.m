function fSweep()
    global port plotBuffer readSamples channels drawCounter sampleSize recording
    try
        fclose(port)
    catch
    end
    close all;
    pause(10);
    sampleSize = 1;
    plotSamples = 2500;
    readSamples = 42;
    channels = 3;
    sampleRate = 1.25; % kHz
    scale = 1.15;
    recording = zeros(channels, 0);
    
    xRange = (0:plotSamples);%/(sampleRate * 1000);

    port = serial('COM15','BaudRate',115200)%, 'FlowControl', 'hardware');
    port.BytesAvailableFcnCount = readSamples;
    port.BytesAvailableFcnMode = 'byte';
    port.BytesAvailableFcn = @serial_callback;
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
    data = zeros(channels,size);
    hAxes = zeros(1, channels);
    hPlots = zeros(1, channels);
    plotBuffer = zeros(channels,plotSamples);
    for channel = 1:channels
        hAxes(channel) = subplot(channels,1,channel);
        axes(hAxes(channel));
        hPlots(channel) = plot(xRange(1:length(plotBuffer)), plotBuffer(channel,:).*scale ./ 2^(8*sampleSize-1));
    end
    %figure; hold on;

    drawCounter = 0;
    recording = [];
    
    fwrite(port, '*')

    % %% start the initialization of the DAQ for the motor
    d = daqfind;
    delete(d);
    % Initialization daq
    % global dio;
    dio = digitalio('nidaq', 'Dev2'); %make sure your dac name is same to the one used here
    addline (dio, 2:3,1,'Out')
    
    angles = [];
    
    INC = 1.8;
    STEP_SIZE_FACTOR = 2;
    STEP_SIZE = INC * STEP_SIZE_FACTOR;
    NUM_STEPS = 360 / STEP_SIZE;
    for i=1:NUM_STEPS
        for j=1:STEP_SIZE_FACTOR
            putvalue(dio,[1,1]); %[x,y] x is direction y is the step
            putvalue(dio,[1,0]);
            
            pause(0.01);
        end
        pause(1.5);
        disp('step');
        disp(i*STEP_SIZE);
        pause(plotSamples / sampleRate / 1000);
        angles = cat(3, angles, plotBuffer);
    end
    assignin('caller', 'angles', angles);
    
    fclose(port);
    analyze(angles);
end
function serial_callback(obj,event)
    global port plotBuffer channels drawCounter readSamples sampleSize recording
    newData = fread(port, readSamples/sampleSize, ['int',num2str(8*sampleSize)])';
    if (length(newData) > 0)
        newData = reshape(newData, channels, length(newData)/channels);
        drawCounter = drawCounter + readSamples;
        %recording = [recording, newData];
        plotBuffer = [plotBuffer(:,readSamples/channels/sampleSize+1:end), newData];
    end
        
end
