function y = use_fft_for_Ax5(F, n, m, N)
X = zeros(N);
X(1:2*n+1 , 1:2*n+1) = F;

y = ifft2(X);
ind1 = 1:m+1;
ind2 = N-m+1:N;
y1 = y(ind1, ind1);
y2 = y(ind1, ind2);
y3 = y(ind2, ind1);
y4 = y(ind2, ind2);
y = [y4 y3 ; y2 y1];

for k = -m:m
    for l = -m:m
        y(k+m+1, l+m+1) = y(k+m+1, l+m+1) * exp(-2*pi*1i* n*(k+l) / N);
    end
end
y = 4*real(y);
end