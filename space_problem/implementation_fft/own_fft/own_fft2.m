function Y = own_fft2(x,m,N, only_real_part)
% Create an even x
if size(x,2) == 1
    n = ( length(x) - 1 ) / 2;
    n2 = 2^nextpow2(n);
    xtilde = zeros(2*n2+1, 1);
    xtilde(n2-n+1:n2+n+1) = x;
else
    n = ( length(x) - 1 ) / 2;
    n2 = 2^nextpow2(n);
    xtilde = zeros(2*n2+1);
    xtilde(n2-n+1:n2+n+1, n2-n+1:n2+n+1) = x;
end
% T*x
Y = fft_one_step(fft_one_step(xtilde,m,N)', m, N)';
if only_real_part
    Y = real(Y);
end
end