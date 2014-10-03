% Implements the overlap-save method for filtering in real time
function yn = overlap_save(sequence, L, filter, M) % L = length of sequence, M = length of filter
global initial_flag xold ;

if initial_flag==0
    block = zeros(1, M-1);
    initial_flag = 1;
else
    block = xold;
end

x_n = [block sequence]; % should be (M-1) + L = N samples long
Xn  = fft(x_n);
yn  = ifft(Xn .* filter);
xold = yn(L+1:end); %size should be (M-1) samples long
yn  = yn(1:L);

return;
end
