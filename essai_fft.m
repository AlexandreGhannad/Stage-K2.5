%% Clean
close all
clear all
clc
%% Set up for space problem
n = 30;
m = 30;
rho0 = 4;
rho1 = 20;
epsilon = 1e-5;
N = 2*m*n/rho1;

F = rand(2*n+1);
F=F*F';

dx=1/(2*n);
dy=dx;
Xs = (-n:n)'/(2*n);
Ys=Xs;
Pupil=(Xs.^2)'+(Ys.^2);
% F = Pupil;
% F(Pupil<0.25) = 1;
% F(Pupil>=0.25) = 0;

Xis = (-m:m)'*rho1/m;
Etas = Xis;

ComplexMap = (Xis.^2)' + Etas.^2;
DarkHole = zeros(size(ComplexMap));
for i =1:m+1
    for j = 1:m+1
        tmp = ComplexMap(i,j);
        if tmp >=rho0^2 && tmp <= rho1^2 && Etas(j) <= Xis(i)
            DarkHole(i,j) = 1;
        end
    end
end

% K = cos(2*pi*Etas*Xs')/(2*n);
K = exp(2*pi*1i*Etas*Xs')/(2*n);
Fhat = 4*K*F*K';
Fhat = real(Fhat);

vecF = F(:);
x0 = vecF;
vecFhat = Fhat(:);
figure(1)
% subplot(121)
% surf(F)
% subplot(122)
surf(Fhat)
%% Test
X = zeros(N);
X(1:2*n+1 , 1:2*n+1) = F;

y = ifft2(X);
ind1 = 1:m+1;
ind2 = N-m+1:N;
y1 = y(ind1, ind1);
y2 = y(ind1, ind2);
y3 = y(ind2, ind1);
y4 = y(ind2, ind2);
y = [y4 y3 ; y2 y1];

for k = -m:m
    for l = -m:m
        y(k+m+1, l+m+1) = y(k+m+1, l+m+1) * exp(-2*pi*1i* n*(k+l) / N);
    end
end
% y = real(fftshift(y));
% y = y(m+1:end,m+1:end); 
y = real(y);

figure(2)
surf(real(y))

figure(3)
surf(y/norm(y) - Fhat/norm(Fhat))

