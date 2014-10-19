clear all;
close all;

fclose(instrfind)
port = serial('COM4','BaudRate',115200, 'FlowControl', 'hardware');
fopen(port);

inputs = 42;
size = 4;
length_b = inputs;
buffer = zeros(1, length_b);

count = 0;
while (count < length_b)
    data = fread(port, 1, 'uint8')';
    buffer = [data(1), buffer(1:end-1)];
    count = count + 1;
end
buffer
%reshape(buffer, inputs, length(buffer)/size)
fclose(port)