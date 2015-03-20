function readADC2(portString,time)

transmitADC(time)
settings = {};
fullData = {};

settings.sampleSize = 1;
settings.readSamples = 48;

settings.channel = 4;
settings.port = serial(portString,'BaudRate',115200);
settings.port.BytesAvailableFcnCount = 48;
settings.port.BytesAvailableFcnMode = 'byte';
settings.port.BytesAvailableFcn = @serial_callback;
fopen(settings.port);

count = 0;
while(count < 10)
    pause(0.1);
end
end

function serial_callback(~, ~)
global settings fullData
    newData = fread(settings.port, settings.readSamples/settings.sampleSize, ['int',num2str(8*settings.sampleSize)])';
    length(newData);
    if (~isempty(newData))
        newData = reshape(newData, settings.channels, length(newData)/settings.channels)
        fullData = [fullData, newData];        
    end
end