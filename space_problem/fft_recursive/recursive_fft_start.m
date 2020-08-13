function output = recursive_fft_start(x,m,N)
% xtilde = create_even_x(x);
% len = size(x,1);
t = transpose(-m:m);
t = exp(2*pi*1j*t/N);
output = recursive_fft(x, m, N, t);
end