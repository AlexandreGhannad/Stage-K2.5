function FFT = test(F ,m, n, rho1)
N = 2*m*n/rho1;

wN = exp(2*pi*1i/N);
t = wN.^( (0:2*n)'+(0:2*n) );
Ftmp = F.*t;

FFT = ifftshift(ifft2(Ftmp,N,N));
FFT = FFT(N/2-m : N/2+m , N/2-m : N/2+m);
t = (wN).^( -n*( (-m:m)'+(-m:m) ) );
FFT = ((N/m)^2)*FFT.*t;


% N = length(F);
% n = (N-1) / 2;
% FFT = zeros(2*m+1);
% w = exp(2*pi*1i*rho1/(2*n*m));
% for p = -m:m
%     for q = -m:m
%         
%         tmp = 0;
%         for j = -n:n
%             for k=-n:n
%                 tmp = tmp + (w^(j*p))*(w^(k*q))*F(j+n+1,k+n+1)/(4*n^2);
%             end
%         end
%         
%         FFT(p+m+1, q+m+1) = tmp;
%     end
% end
end