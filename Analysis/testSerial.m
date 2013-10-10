clear all;
close all;

port = serial('COM7','BaudRate',115200, 'FlowControl', 'hardware');
fopen(port);

signal = [255, 255, 255, 255, 255, 255];
buffer = zeros(1, length(signal));
while (1)
    data = fread(port, 1, 'uint8')';
    buffer = [data(1), buffer(1:end-1)];
    if signal==buffer
        break;
    end
end

newData = fread(port, 1, 'uint8')';
buffer = zeros(1, length(signal));
count = 0;
while (1)
    data = fread(port, 1, 'uint8')';
    buffer = [data(1), buffer(1:end-1)];
    count = count + 1;
    if signal==buffer
        disp(count);
        count = 0;
    end
end
fclose(port)