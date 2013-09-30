port = serial('COM1','BaudRate',115200);
fopen(port);
size = 100;
c1 = zeros(1,size);
c2 = zeros(1,size);
c3 = zeros(1,size);
figure; hold on;
while (1)
    data = fread(port, 3, 'int16')'
    c1 = [data(1) c1(1:end-1)];
    plot(c1);
    pause(0.001);
end
fclose(port);