function output = recursive_fft(x,m,N)
len = length(x);

if len <= 9
    output = fft_one_step(x, m, N); 
else
    [xpair, ximpair] =  fft_divide_x_into_two(x);
    fftpair = recursive_fft(xpair, m, N/2);
    fftimpair = recursive_fft(ximpair, m, N/2);
    t = transpose(-m:m);
    t = exp(2*pi*1j*t/N);
    output = fftpair + t.*fftimpair;
end


end