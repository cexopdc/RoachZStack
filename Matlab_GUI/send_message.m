function y = send_message(msg)
try
port = serial('COM5','BaudRate',115200);
fopen(port);

fwrite(port, msg);

fclose(port);

y = 1;
catch
    y = 0;
end


end