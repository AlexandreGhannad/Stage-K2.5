function Y = test_dct(X, N, m)
    Y = spot.utils.idct(full(X), N);
    Y = spot.utils.idct(Y', N)';
    Y = Y(1:m+1, 1:m+1);    
end