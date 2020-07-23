function output = fft_two_step(x,m,N)
[xpair, ximpair] =  fft_divide_x_into_two(x);
fftpair = fft_one_step(xpair, m, N/2);
fftimpair = fft_one_step(ximpair, m, N/2);
wN = exp(2*pi*1j/N);
t = transpose(-m:m);
t = wN.^t;
output = fftpair + t.*fftimpair;
end