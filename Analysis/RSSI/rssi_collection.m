function rssi_collection(output_filename)
if nargin < 1
    disp('Please give one output filename');
    return;
end

global port counter Data
try
    fclose(port)
catch
end
close all;
%USBport = '/dev/ttyUSB0';%'/dev/ttyUSB0' or 'COM1';
USBport = '/dev/tty.usbserial-A5006u7j';
port=serial(USBport);
%Set serial properties according to the Contiki-doc.
port.BaudRate=115200;
port.StopBits = 1;
port.Parity = 'none';
port.DataBits = 8;
port.FlowControl = 'none';
%end of setting

counter = 0;
Data = [];

% The input buffer must be large enough to accomodate the amount of data
%  that will be received while your program is busy processing previously
%  received chunks of data. Having a buffer that is too large is not a
%  problem for most modern computers.
port.InputBufferSize=2^18; % in bytes
% The "BytesAvailableFcn" function will be called whenever
%  BytesAvailableFcnCount number of bytes have been received from the USB
%  device.
port.BytesAvailableFcnMode='terminator';
port.BytesAvailableFcnCount=1; %  120 samples of char
% The serial port object must be opened for communication
fopen(port);
% The name of the BytesAvailableFcn function in this example is
%  "getNewData", and it has one additional input argument ("arg1").
port.BytesAvailableFcn = @serial_callback;



while (counter<(500+7))
  pause(0.0001);
end
dlmwrite(strcat('original_',output_filename), Data, 'delimiter','');%, '-append');
%remove the device info, just leave RSSI
fid = fopen(strcat('original_',output_filename));
tmp_cell = textscan(fid,'%s');
tmp_cell = tmp_cell{1,1};
tmp_vector = char(tmp_cell);
final_vector = tmp_vector(8:end,:);
fclose(fid);
delete(strcat('original_',output_filename));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dlmwrite(output_filename, final_vector, 'delimiter','');
fclose(port);
delete(port);
end




function serial_callback(obj,event)
    global port counter Data
    newData = fscanf(port);
    %newData = strcat(newData);
    Data = [Data,newData];
    counter = counter + 1;
        
end