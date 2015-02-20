clear all;
Pkt_sec = fliplr([50 40 30 20 10 8 7 5 3 2 1]);
PDR_2440M = fliplr([0.255 0.33 0.325 0.495 0.765 0.94 1 1 1 1 1]);
PDR_2494M = fliplr([0.26 0.3 0.405 0.49 0.925 0.95 1 1 1 1 1]);
Pkt_sec_high_power = fliplr([50 40 30 25 20 15 10 9 8 7 5 3 2 1]);
PDR_2494M_high_power = fliplr([0.5 0.5 0.5 0.65 0.8 0.75 0.95 1 1 1 1 1 1 1 ]);

%{
plot(Pkt_sec,PDR_2440M,'-o',Pkt_sec,PDR_2494M,'-o');
xlabel('Packet rate (Pkts/sec)');
ylabel('PDR');
legend('2440MHz','2494MHz');
%}

plot(Pkt_sec,PDR_2440M,'-o',Pkt_sec,PDR_2494M,'-o',Pkt_sec_high_power,PDR_2494M_high_power,'-o');
xlabel('Packet rate (Pkts/sec)');
ylabel('PDR');
legend('2440MHz','2494MHz','2494MHz\_high\_power');
