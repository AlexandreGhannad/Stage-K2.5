function Y = Ax(x, n, m, N, epsilon, transpose)
if transpose == 1
    n2 = 2*n+1;
    F(1:n2, 1:n2) = reshape(x(1:n2^2), [n2 n2]);
    vecFhat = x(1+(n2)^2 : end);
    
    F(n+1,:) = 2*F(n+1,:);
    F(:,n+1) = 2*F(:,n+1);
%     Y1 = own_fft2(F, m, N, 1);
    Y1 = real(fft_one_step(fft_one_step(F,m,N)', m, N)');
    F(n+1,:) = 0.5*F(n+1,:);
    F(:,n+1) = 0.5*F(:,n+1);
    
    Y1 = Y1(:)- vecFhat;
    
    ind = sub2ind([2*m+1 2*m+1],m+1,m+1);
    Y2 = vecFhat - vecFhat(ind)*epsilon;
    Y3 = vecFhat + vecFhat(ind)*epsilon;
    Y = [Y1;Y2;Y3];
    
elseif transpose == 2
    m2 = 2*m+1;
    x1(1:m2, 1:m2) = reshape(x(1:m2^2), [m2 m2]);
    x2 = x(1+m2^2 : 2*m2^2);
    x3 = x(1+2*m2^2 : end);
    
    x1(m+1,:) = 2*x1(m+1,:);
    x1(:,m+1) = 2*x1(:,m+1);
    Y1 = real(fft_one_step(fft_one_step(x1,n,N)', n, N)');
    x1(m+1,:) = 0.5*x1(m+1,:);
    x1(:,m+1) = 0.5*x1(:,m+1);
    
    ind = sub2ind([2*m+1 2*m+1],m+1,m+1);
    x2(ind) = x2(ind) - sum(x2)*epsilon;
    x3(ind) = x3(ind) + sum(x3)*epsilon;
    Y2 = -x1(:) + x2 + x3;
%     Y2(ind) = Y2(ind) - epsilon*Y2(ind)*m2^2;
%     Y2(ind) = Y2(ind) + epsilon*Y2(ind)*m2^2;
    
    Y = [Y1(:);Y2];
end
end
