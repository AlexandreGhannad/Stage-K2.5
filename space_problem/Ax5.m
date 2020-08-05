function Y = Ax5(x, n, m, N, epsilon, transpose)
if transpose == 1 
    Fhat = spot.utils.idct(full(reshape(x,n,n)), N);
    Fhat = spot.utils.idct(Fhat', N)';
    Fhat = Fhat(1:m+1, 1:m+1);
    
    Y2 = Fhat(:) - epsilon * Fhat(1,1);
    Y3 = Fhat(:) + epsilon * Fhat(1,1);
    Y = [Y2;Y3];
    
elseif transpose == 2
    F1 = reshape(x(1:(m+1)^2), [m+1 m+1]);
    F2 = reshape(x((m+1)^2+1:end), [m+1 m+1]);
    
    Fhat1 = spot.utils.idct(full(F1), N);
    Fhat1 = spot.utils.idct(Fhat1', N)';
    Fhat1 = Fhat1(1:n, 1:n);
    
    Fhat2 = spot.utils.idct(full(F1), N);
    Fhat2 = spot.utils.idct(Fhat2', N)';
    Fhat2 = Fhat2(1:n, 1:n);
    
    Fhat1 = Fhat1(:) - epsilon * Fhat1(1,1);
    Fhat2 = Fhat2(:) + epsilon * Fhat2(1,1);
    
    Y = Fhat1 + Fhat2;
end
end
