function Y = Ax(x, n, m, N, epsilon, transpose)
if transpose == 1
    n2 = 2*n+1;
    F(1:n2, 1:n2) = reshape(x(1:n2^2), [n2 n2]);
    vecFhat = x(1+(n2)^2 : end);
    Y1 = own_fft2(F, m, N, 1);
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
    
    Y1 = own_fft2(x1, n, N, 1);
    
    ind = sub2ind([2*m+1 2*m+1],m+1,m+1);
    x2(ind) = x2(ind) - sum(x2*epsilon);
    x3(ind) = x3(ind) + sum(x3*epsilon);
    Y2 = -x1(:) + x2 + x3;
%     Y2(ind) = Y2(ind) - epsilon*Y2(ind)*m2^2;
%     Y2(ind) = Y2(ind) + epsilon*Y2(ind)*m2^2;
    
    Y = [Y1(:);Y2];
end
end



% n2 = 2^nextpow2(n);
% m2 = 2^nextpow2(m);
% F = zeros(n2);
%
% if not(tranpose)
%
%     F(1:n, 1:n) = reshape(x(1:n^2), [n n]);
%     vecFhat = x(1+n^2 : end);
%
%     [I,J] = ndgrid(1:n,1:n);
%     I = I/n;
%     J = J/n;
%     mask = 1-double((I-1/2).^2+(J-1/2).^2<=(1/2)^2);
%
%     Y1 = fastpartialfouriertransform(fastpartialfouriertransform(F,n2,m2).',n2,m2).' ;
%     Y1 = Y1(1:m,1:m);
%     Y1 = Y1(:)-vecFhat;
%     Y2 = x(mask==1);
%
%     Y = [Y1;Y2];
%
% else
%
%     F(1:m, 1:m) = reshape(x(1:m^2), [m m]);
%     vecFhat = x(1+m^2 : end);
%
%     [I,J] = ndgrid(1:m,1:m);
%     I = I/m;
%     J = J/m;
%     mask = 1-double((I-1/2).^2+(J-1/2).^2<=(1/2)^2);
%
%     Y1 = fastpartialfouriertransform(fastpartialfouriertransform(F,m2,n2).',m2,n2).' ;
%     Y1 = Y1(1:n,1:n);
%     Y1 = Y1(:)-vecFhat;
%     Y2 = x(mask==1);
%
%     Y = [Y1;Y2];
% end
