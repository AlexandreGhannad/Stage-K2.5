%% Clean
close all
clear all
clc
%%
rho0 = 4;
rho1 = 20;
epsilon = 10^-5;

n = 100;
m = 35;


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
%%
[I,J] = ndgrid(1:n,1:n);
I = I/n;
J = J/n;
F = double( (I-1/2).^2 + (J-1/2).^2 <= (1/2)^2);

n2 = 2^nextpow2(n);
m2 = 2^nextpow2(m);
Ftmp = zeros(n2);
Ftmp(1:n, 1:n) = F;
Fhat = fastpartialfouriertransform(fastpartialfouriertransform(Ftmp,n2,m2).',n2,m2).' ;
Fhat = Fhat(1:m,1:m);


%% Execution time comparison
tic
for i = 1 : 100
    clear res1
    res1 = fhat(F,m,n, Xs, Etas, mask);
end
t1=toc

tic
for i = 1 : 100
    clear res2
    res2 = test(Ft ,m, n, rho1);
end
t2=toc

n2 = 2^nextpow2(n);
m2 = 2^nextpow2(m);
Ftmp = zeros(n2);
Ftmp(1:n, 1:n) = F;

tic
for i = 1 : 100
    clear res3
res3 = fastpartialfouriertransform(fastpartialfouriertransform(Ftmp,n2,m2).',n2,m2).' ;
end
t3=toc






















































































