
% This script is to take raw data from the 'name'_data.mat files and format
% them in order to perform various filter functions to provide clean data
clear;
%load Frank_data.mat
global initial_flag xold;
initial_flag = 0;
xold = [];
k = 8;
N = 2^k;  %256

% norm_data = totalBufferData./N;
% norm_data = norm_data(30000:end);  %gets rid of zeros at beginning

wp = 0.5; ws = 0.6; rp = 1; rs = 80;
[N1, wn1] = buttord(wp, ws, rp, rs);
[N2, wn2] = cheb1ord(wp, ws, rp, rs);
[N3, wn3] = cheb2ord(wp, ws, rp, rs);
[N4, wn4] = ellipord(wp, ws, rp, rs);
[b1, a1] = butter(N1, wn1);
[b2, a2] = cheby1(N2, rp, wn2);
[b3, a3] = cheby2(N3, rs, wn3);
[b4, a4] = ellip(N4, rp, rs, wn4);

Nt = N4;
bt = b4;
at = a4;

L = N - Nt;% + 1; %L = 2^k - filtord + 1

coeff = Nt+1;
filter = [bt./at, zeros(1,L-1)]; 
B1 = fft(filter);

y = zeros(1,length(norm_data));
numBlocks = floor(length(norm_data)/L);
j = 1;
while(j < numBlocks)
    test = norm_data(1+(j-1)*L:j*L);
    filt = overlap_save(test, L, B1, coeff);
    y(1+(j-1)*L: j*L) = filt;
    j = j+1;
end

figure(1), 

grid on, 
subplot(211), plot(y)
title('1 - Filtered Data using filter, 2 - normalized data');
subplot(212), plot(norm_data);

