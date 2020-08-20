function Y = Ax7(x, n, m, epsilon, transpose)
if transpose == 1
    F = reshape(x(1:n^2), [n n]);
%     F(2:2:2*n, 2:2:2*n) = reshape(x(1:n^2), [n n]);
    
    Fhat = real(ifft(real(ifft(F,m+1))',m+1)');
    
    Y2 = Fhat(:) - epsilon * Fhat(1, 1);
    Y3 = Fhat(:) + epsilon * Fhat(1, 1);
    Y = [Y2;Y3];
    
elseif transpose == 2
%     F1(1:m+1, 1:m+1) = reshape(x(1:(m+1)^2), [m+1 m+1]);
%     F2(1:m+1, 1:m+1) = reshape(x((m+1)^2+1:end), [m+1 m+1]);
    
    F1 = reshape(x(1:(m+1)^2), [(m+1) (m+1)]);
    F2 = reshape(x(1:(m+1)^2), [(m+1) (m+1)]);
    
    Fhat1 = real(ifft(real(ifft(F1,n))',n)');
    Fhat1 = 4*Fhat1(1:n, 1:n);
    Fhat2 = real(ifft(real(ifft(F2,n))',n)');
    Fhat2 = 4*Fhat2(1:n, 1:n);
    
    Fhat1 = Fhat1(:) - epsilon * Fhat1(1,1);
    Fhat2 = Fhat2(:) + epsilon * Fhat2(1,1);
    
    Y = Fhat1 + Fhat2;
end
end
