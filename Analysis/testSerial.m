clear all;
close all;
delete(instrfindall);

transmitADC('0100')
settings = {}

% fclose(instrfind)
port = serial('COM13','BaudRate',115200, 'FlowControl', 'hardware');
fopen(port);

inputs = 4;
size = 160;
length_b = inputs*size;
buffer = zeros(1, length_b);

count = 0;
while (count < length_b)
    try 
        data = fread(port, 1, 'uint8')';
    catch
        data = [0,0];
    end
    buffer = [data(1), buffer(1:end-1)];
    count = count + 1;
end
buffer;
M = reshape(buffer, inputs, length_b/inputs)
%assignin('base','test',M)
%fid = fopen('output_data.txt', 'at'); % opens file for appending
%dlmwrite('output_data.txt',M','-append') %fprintf(fid, ' %3d ', dataBuffer);
%fclose('all');
fclose(port);
delete(port);
%delete(instrfindall)
