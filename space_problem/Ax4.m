function Y = Ax4(x, T, epsilon, transpose)
if transpose == 1
    Fhat = real(T*x);
    Y2 = Fhat(:) - epsilon * Fhat(1,1);
    Y3 = Fhat(:) + epsilon * Fhat(1,1);
    Y = [Y2;Y3];
    
elseif transpose == 2
    l = length(x);
    m2 = sqrt(l/2);
    m = (m2-1)/2;
    F1 = x(1:m2^2);
    F2 = x(m2^2+1:end); 
    
    Fhat1 = real(T'*F1);
    Fhat2 = real(T'*F2);
    Fhat1 = Fhat1(:) - epsilon * Fhat1(m+1);
    Fhat2 = Fhat2(:) + epsilon * Fhat2(m+1);
    
    Y = Fhat1 + Fhat2;
end
end
