b1=[-40,15,1];
x1=0:0.2:6;
y1=b1(1)-b1(2).*log(x1./b1(3));

b2=[-40,15,1];
x2=0:0.2:6;
y2=b2(1)-b2(2).*log((x2+3)./b2(3));

plot(x1,y1,x2,y2);
xlabel('distance (m)');
ylabel('RSSI');
h_legend = legend('Higher Tx Power','Lower Tx Power');
set(h_legend,'FontSize',14);