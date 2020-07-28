function Y = Ax4(x, n, m, rho1, epsilon, transpose)
if transpose == 1
    n2 = 2*n;
    F = reshape(x(1:n2^2), [n2 n2]);
    
    Xs = ((0.5-n):(n-0.5))'/(2*n);
    Etas = (-m:m)'*rho1/m;
    K = cos(2*pi*Etas*Xs')/(2*n);
    Fhat = K*F*K';
    
    Y2 = Fhat(:) - epsilon * Fhat(1,1);
    Y3 = Fhat(:) + epsilon * Fhat(1,1);
    Y = [Y2;Y3];
    
elseif transpose == 2
    m2 = 2*m+1;
    n2 = 2*n;
    
    F1 = reshape(x(1:m2^2), [m2 m2]);
    F2 = reshape(x(m2^2+1:end), [m2 m2]);
    
    Xs = ( -m:m)'/(2*m);
    Etas = (0.5-n:n-0.5)'*rho1/n;
    K = cos(2*pi*Etas*Xs')/(2*m);
    Fhat1 = K*F1*K';
    Fhat2 = K*F2*K';
    Fhat1 = Fhat1(:) - epsilon * Fhat1(1);
    Fhat2 = Fhat2(:) + epsilon * Fhat2(1);
    
    Y = Fhat1 + Fhat2;
end
end
