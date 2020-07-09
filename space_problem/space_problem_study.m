%% Clean
close all
clear all
clc
%%
rho0 = 0;
rho1 = 1;
epsilon = 10^-5;

n = 100;
dx = 1/(2*n);
dy = dx;
j1 = transpose(0.5:n-0.5);
Xs = j1/(2*n);
Ys = Xs;
mask = zeros(n);
for a = 1:n
    for b = 1:n
        tmp2 = Xs(a)^2 + Ys(b)^2;
        if tmp2 < 0.25
            mask(a,b) = 1;
        end
    end
end
[row,col] = ind2sub(size(mask),find(mask==1));
Pupil = [Xs(col) Ys(row)];

F = ones(n).*mask;

m = 35;

j2 = transpose(0:m);
Xis = j2*rho1/m;
Etas = Xis;

DarkHole = [];
mask2 = zeros(m+1);
for i=1:m+1
    for j=1:m+1
        xi = Xis(i);
        eta = Etas(j);
        tmp2 = xi^2 + eta^2;
        if rho0^2 <= tmp2 && tmp2 <= rho1^2 && eta <=xi
            DarkHole = [DarkHole ; [xi eta]];
            mask2(i,j) = 1;
        end
    end
end

K = zeros(m+1,n);
for i = 1 : n
    for j = 1 : m+1
        K(j,i) = cos(2 * pi * Xs(i) * Etas(j)) / (2*n);
    end
end

Y = zeros(2*n, 2*n);
Y(1:n, 1:n) = F(end:-1:1,end:-1:1);
Y(1:n, n+1:end) = F(end:-1:1,:);
Y(n+1:end, 1:n) = F(:,end:-1:1);
Y(n+1:end, n+1:end) = F(:,:);
%%

tmp1 = K*F*K';
res1 = zeros(2*m+1, 2*m+1);
res1(1:m, 1:m) = tmp1(end:-1:2,end:-1:2);
res1(1:m, m+1:end) = tmp1(end:-1:2,:);
res1(m+1:end, 1:m) = tmp1(:,end:-1:2);
res1(m+1:end, m+1:end) = tmp1(:,:);
M = 2*(m+1);

% N = 2*n+1;
% Ft = ones(N);

x = linspace(-1/2,1/2,2*n+1);
y = x;
[xx, yy] = meshgrid(x,y);
Ft = zeros(size(xx));
Ft((xx.^2+yy.^2)<(1/2)^2)=1;

res2 = test(Ft ,m, n, rho1);
%%

figure(1)
subplot(121)
surf(res1)
colormap("gray")
colorbar
subplot(122)
surf(real(res2))
colormap("gray")
colorbar
%% Execution time comparison
tic
for i = 1 : 10
    clear res1
    res1 = fhat(F,m,n, Xs, Etas, mask);
end
t1=toc

tic
for i = 1 : 10
    clear res2
    res2 = test(Ft ,m, n, rho1);
end
t2=toc


%% Test
% %%
% F = Ft;
% N2 = 2*m*n/rho1;
% X1 = zeros(N2,N2);
% X2 = zeros(N2,N2);
% X3 = zeros(N2,N2);
% X4 = zeros(N2,N2);
% 
% X1(1:n,1:n+1) = F(n+2:end,1:n+1);
% X2(1:n,1:n)  = F(n+2:end,n+2:end);
% X3(1:n+1,1:n+1)  = F(1:n+1, 1:n+1);
% X4(1:n+1,1:n)  = F(1:n+1 , n+2:end);
% % X1= sparse(X1);
% % X2= sparse(X2);
% % X3= sparse(X3);
% % X4= sparse(X4);
% 
% 
% % figure()
% % subplot(221)
% % surf(X1)
% % subplot(222)
% % surf(X2)
% % subplot(223)
% % surf(X3)
% % subplot(224)
% % surf(X4)
% wN= exp(2*pi*1i/N2);
% % M = 2*m+1;
% % Y1 = (1/N2^2)*ifft( (wN*fft(X1 , M)).', M).';
% % Y2 = ifft2(X2, M, M);
% % Y3 = (1/N2^2)*fft2(X3, M, M);
% % Y4 = (1/N2^2)*fft( (wN*ifft(X1 , M)).', M).';
% %%
% N2 = 2*m*n/rho1;
% Ftmp = zeros(N2);
% wN = exp(2*pi*1i/N2);
% t = F;
% W = zeros(2*n+1);
% P = zeros(2*n+1);
% for j = 1:2*n+1
%     for k = 1:2*n+1
%         t(j,k) = t(j,k) * wN^( (j-1)+(k-1));
%         W(j,k) = wN^( (j-1)+(k-1));
%         P(j,k) = (j-1)+(k-1);
%     end
% end
% 
% Ftmp(1:2*n+1, 1:2*n+1) = t;
% tmp = ifft2(Ftmp);
% tmp = ifftshift(tmp);
% tmp = tmp(N2/2-m:N2/2+m, N2/2-m:N2/2+m);
% 
% W = zeros(2*m+1);
% for p=-m:m
%     for q=-m:m
%         W(p+m+1, q+m+1) = wN^(-n*(p+q));
%     end
% end
% 
% tmp = tmp.*W;






















































































