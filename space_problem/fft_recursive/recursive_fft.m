function output = recursive_fft(x, m, N, H)
len = size(x,1);

if len <= 5
%     if size(x, 2) == 1
        output = fft_one_step(x, m, N);
%     else
%         output =  fft_one_step(fft_one_step(x,m,N)', m, N)';
%     end
else
    [xpair, ximpair] =  fft_divide_x_into_two(x);
    t = transpose(-m:m);
    t = exp(2*pi*1j*t/(N/2));
    fftpair = recursive_fft(xpair, m, N/2, t);
    fftimpair = recursive_fft(ximpair, m, N/2, t);
    output = fftpair + H.*fftimpair;
end
end