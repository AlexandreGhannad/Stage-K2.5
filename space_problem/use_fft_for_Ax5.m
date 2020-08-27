function y = use_fft_for_Ax5(F, n, m, N)
y = fft2(F,N,N);
ind1 = 1:m+1;
ind2 = N-m+1:N;
y1 = y(ind1, ind1);
y2 = y(ind1, ind2);
y3 = y(ind2, ind1);
y4 = y(ind2, ind2);
y = [y4 y3 ; y2 y1];
% y = fftshift(fft2(F,N,N));
% y = y(1+N/2+(-m:+m) , 1+N/2+(-m:+m));

t = (-m:m)' + (-m:m);
t = exp(-2*pi*1i*n*t / N);
y = real(t.*y);
end