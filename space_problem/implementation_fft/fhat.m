function Fhat = fhat(F,m,n, Xs, Etas, mask)
K = cos(2*pi*Etas*Xs')/(2*n);
Fhat = 4*K*(F.*mask)*K';
end