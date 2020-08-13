function output = recursive_fft2d_start(x,m,N)
xtilde = create_even_x(x);
output = recursive_fft_start(recursive_fft_start(xtilde,m,N)', m, N)';
end