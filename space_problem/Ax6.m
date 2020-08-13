function Y = Ax6(x, n, m, N, epsilon, transpose)
if transpose == 1
    F = reshape(x(1:(2*n+1)^2), [2*n+1 2*n+1]);
    Fhat = recursive_fft2d_start(F,m,N);
    
    Y2 = Fhat(:) - epsilon * Fhat(m+1, m+1);
    Y3 = Fhat(:) + epsilon * Fhat(m+1, m+1);
    Y = [Y2;Y3];
    
elseif transpose == 2
    F1 = reshape(x(1:(2*m+1)^2), [2*m+1 2*m+1]);
    F2 = reshape(x((2*m+1)^2+1:end), [2*m+1 2*m+1]);
    
    Fhat1 = recursive_fft2d_start(F1,n,N);
    Fhat2 = recursive_fft2d_start(F2,n,N);
    
    Fhat1 = Fhat1(:) - epsilon * Fhat1(n+1,n+1);
    Fhat2 = Fhat2(:) + epsilon * Fhat2(n+1,n+1);
    
    Y = Fhat1 + Fhat2;
end
end
