function plot_record(msg)
global port plotBuffer readSamples channels drawCounter sampleSize recording
global initial_flag xold
initial_flag = 0;
try
   fclose(port)
catch
end

totalBufferData = [];
sampleSize = 1;
plotSamples = 5000;
readSamples = 42;
channels = 2;
scale = 5;

% set up filter
wp = 0.5; ws = 0.6; rp = 1; rs = 80;
s = window(@hanning, 9);
b = fir1(8,wp,s);
% [N1, wn1] = buttord(wp, ws, rp, rs);
% [N2, wn2] = cheb1ord(wp, ws, rp, rs);
% [N3, wn3] = cheb2ord(wp, ws, rp, rs);
% [N4, wn4] = ellipord(wp, ws, rp, rs);
% [b1, a1] = butter(N1, wn1);
% [b2, a2] = cheby1(N2, rp, wn2);
% [b3, a3] = cheby2(N3, rs, wn3);
% [N4, wn4] = ellipord(wp, ws, rp, rs);
% [b4, a4] = ellip(N4, rp, rs, wn4);
% Nt = N4;
% bt = b4;
% at = a4;

N = 8192;
%L = N - Nt;% + 1; %L = 2^k - filtord + 1
%M = N - plotSamples + 1;

% coeff = Nt+1;
% filter = [bt./at, zeros(1,8183)]%N-Nt+1)]; 
b = [b, zeros(1, 8183)];
B1 = fft(b); %filter);

% y = zeros(1,length(norm_data));
% numBlocks = floor(length(norm_data)/L);
% j = 1;
% while(j < numBlocks)
%     test = norm_data(1+(j-1)*L:j*L);
%     filt = overlap_save(test, L, B1, coeff);
%     y(1+(j-1)*L: j*L) = filt;
%     j = j+1;
% end



xRange = (0:plotSamples);%/(sampleRate * 1000);

port = serial('COM5','BaudRate',115200);%, 'FlowControl', 'hardware');
port.BytesAvailableFcnCount = readSamples;
port.BytesAvailableFcnMode = 'byte';
port.BytesAvailableFcn = @serial_callback;
fopen(port);
try
    %figure('Moth Muscle Stimulation','My First Named Figure','numbertitle','off')
    figure(1); 
    hold on;
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

    fwrite(port, msg)
    index = 1;
    while (1)%i < 50)
        pause(0.1);
            for channel = 1:channels
              % set(hAxes(channel),'YLim', [-0.5 0.5]);
                seq = plotBuffer(channel, :).*scale ./ 2^(8*sampleSize -1);
                %seq = overlap_save(seq, plotSamples, B1, 3193);
                totalBufferData = [totalBufferData, seq];
                set(hPlots(channel),'ydata', seq);
            end
            drawnow;
            refresh;
        %i = i + 1;
    end
catch
fclose(port);
save test_data.mat;
end
end

function serial_callback(obj,event)
    global port plotBuffer channels drawCounter readSamples sampleSize recording
    newData = fread(port, readSamples/sampleSize, ['int',num2str(8*sampleSize)])';
    if (length(newData) > 0)
        newData = reshape(newData, channels, length(newData)/channels);
        plotBuffer = [plotBuffer(:,readSamples/channels/sampleSize+1:end), newData];
    end  
end