function Fhat = fhat(F,m,n, Xs, Etas, mask)
K = zeros(m+1,n);
for i = 1 : n
    for j = 1 : m+1
        K(j,i) = cos(2 * pi * Xs(i) * Etas(j)) / (2*n);
    end
end
Fhat = K*(F.*mask)*K';
end