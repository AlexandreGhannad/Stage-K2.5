%% Clean
close all
clear all
clc
%% Creation matrice F
n = 1000;
m = 500;
[I,J] = ndgrid(-n:n,-n:n);
I = I/(2*n);
J = J/(2*n);
F = double(I.^2+J.^2<=0.5^2);
F1 = randn(n);
%% Mise en place des différentes variables du problème.
rho0 = 4;
rho1 = 20;
dx = 1/(2*n);
dy = dx;
deta = rho1/(2*m);
dxi = deta;
%% Creation K
K = zeros(2*m+1, 2*n+1);
N = 1/(dx*deta);
wN = exp(2*pi*1j/N);
for i = -m:m
    for j = -n:n
        K(i+m+1,j+n+1) = wN^(i*j);
    end
end
%% test construction fft
x = randn(2*n+1,1);

tic
% creation K
% K = zeros(2*m+1, 2*n+1);
% N = 1/(dx*deta);
% wN = exp(2*pi*1j/N);
% for i = -m:m
%     for j = -n:n
%         K(i+m+1,j+n+1) = wN^(i*j);
%     end
% end
tmp1 = K*x;
t1 = toc

tic;
xtilde = create_even_x(x);
tmp2 = fft_one_step(xtilde,m,N);
tmp2 = tmp2(:,25:end-24);
t2 = toc

tic;
xtilde = create_even_x(x);
tmp3 = fft_two_step(xtilde,m,N);
tmp3 = tmp3(:,25:end-24);
t3 = toc

tic;
xtilde = create_even_x(x);
[xpair, ximpair] =  fft_divide_x_into_two(xtilde);
output1 = fft_two_step(xpair,m,N/2);
output2 = fft_two_step(ximpair,m,N/2);
t = transpose(-m:m);
t = exp(2*pi*1j*t/N);
tmp4 = output1+t.*output2;
tmp4 = tmp4(:,25:end-24);
t4=toc

tic;
xtilde = create_even_x(x);
tmp5 = recursive_fft(xtilde,m,N);
t5 = toc

figure(2)
clf(2)
plot(abs(tmp1), "LineWidth", 3)
hold on
plot(abs(tmp2), "k.")
plot(abs(tmp4), "r+")
plot(abs(tmp5))
legend("1", "2", "3", "4")

%% Test en 2D
% x = randn(2*n+1);
x = F;

tic
K = zeros(2*m+1, 2*n+1);
N = 1/(dx*deta);
wN = exp(2*pi*1j/N);
for i = -m:m
    for j = -n:n
        K(i+m+1,j+n+1) = wN^(i*j);
    end
end
tmp1 = K*x*K';
t1 = toc

tic;
xtilde = create_even_x(x);
tmp2 = fft_one_step(fft_one_step(xtilde,m,N)', m, N)';
t2 = toc

tic;
xtilde = create_even_x(x);
tmp3 = fft_two_step(fft_two_step(xtilde,m,N)', m, N)';
t3 = toc

f = figure(1)
subplot(121)
surf(abs(tmp1))
subplot(122)
surf(abs(tmp2))
set(f, "WindowState", "maximized")


%% Calcul Fhat
%% Test execution time
t1 = 0; t2=0;t3=0;
for i = 1 : 100
x = randn(2*n+1,1);
tic
tmp1 = K*x;
t1 = t1+toc;

tic;
tmp2 = fft_two_step(x,m,N);
t2 = t2+toc;

tic;
xtilde = create_even_x(x);
tmp3 = recursive_fft(xtilde,m,N);
t3 = t3+toc;
end
t1
t2
t3





