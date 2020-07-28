function Y = Ax2(x, n, m, N, epsilon, transpose)
if transpose == 1
    n2 = sqrt(length(x));
    F(1:n2, 1:n2) = reshape(x, [n2 n2]);
    
    F(n+1,:) = 2*F(n+1,:);
    F(:,n+1) = 2*F(:,n+1);
    Y1 = real(fft_one_step(fft_one_step(F,m,N)', m, N)');
    F(n+1,:) = 0.5*F(n+1,:);
    F(:,n+1) = 0.5*F(:,n+1);
    
    Y1= Y1(:);
    
    ind = sub2ind([2*m+1 2*m+1],m+1,m+1);
    Y2 = Y1 - Y1(ind)*epsilon;
    Y3 = Y1 + Y1(ind)*epsilon;
    Y = [Y2;Y3];
    
elseif transpose == 2
    m2 = 2*m+1;
    x1 = reshape(x(1:m2^2), [m2 m2]);
    x2 = reshape(x(m2^2+1:end), [m2 m2]);
    
    x1(m+1,:) = 2*x1(m+1,:);
    x1(:,m+1) = 2*x1(:,m+1);
    Y1 = real(fft_one_step(fft_one_step(x1,n,N)', n, N)');
    
    x2(m+1,:) = 2*x2(m+1,:);
    x2(:,m+1) = 2*x2(:,m+1);
    Y2 = real(fft_one_step(fft_one_step(x2,n,N)', n, N)');
    
    Y1 = Y1(:);
    Y2 = Y2(:);
    
    ind = sub2ind([2*m+1 2*m+1],m+1,m+1);
    Y1(ind) = Y1(ind) - sum(Y1)*epsilon;
    Y2(ind) = Y2(ind) + sum(Y2)*epsilon;
%     Y2(ind) = Y2(ind) - epsilon*Y2(ind)*m2^2;
%     Y2(ind) = Y2(ind) + epsilon*Y2(ind)*m2^2;
    
    Y = Y1 + Y2;
end
end
