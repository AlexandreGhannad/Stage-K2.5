function output = fft_one_step(x, m, N)
n = (size(x,1)-1)/2;
% wN = exp(2*pi*1j/N);
t = transpose(-m:m)*(-n:n);
t = exp(2*pi*1j*t/N)/(2*n);
t=real(t);
output = t*x;
end