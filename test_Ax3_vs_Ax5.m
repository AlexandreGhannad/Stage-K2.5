%% Clean
clear all
close all
clc
%% Setup
n_iter = 100;
nn = 100:500;
mm = 10:50;
rho1 = 20;
epsilon = 1e-5;
transpose = 1;
l1 = length(nn);
l2 = length(mm);
T = zeros(l1,l2,2);
cpt = 1;
LN = zeros(l1*l2,1);
%% Loop
for i = 1:l1
    for j = 1:l2
        n = nn(i)
        m = mm(j)
        N = round(2*m*n/rho1);
        LN(cpt) = N;
        cpt = cpt + 1;
        t1 = 0;
        t2 = 0;
        for k = 1 : n_iter
            x = randn((2*n+1)^2,1);
            tic
            Y = Ax3(x, n, m, rho1, epsilon, transpose);
            t1 = t1 + toc;
            tic
            Y = Ax5(x, n, m, N, epsilon, transpose);
            t2 = t2 + toc;
        end
        T(i,j,1) = t1;
        T(i,j,2) = t2;
    end
end
%% Display Results
t1 = T(:,:,1);
t1 = t1(:);
t2 = T(:,:,2);
t2 = t2(:);
% figure();
% plot(t1)
% hold on
% plot(t2)
% plot(4*t1)
% plot(LN/(max(LN)))

% figure()
% plot(t2./t1)
% 
% figure()
% plot(t2./t1/4)

%% test speed operation
n = 100:20:1500;
l = length(n);
t1 = zeros(size(n));
t2 = zeros(size(n));
for i = 1:l
    nn = n(i)
    for k = 1 : 10
        x1 = randn(nn);
        tic
        x2 = randn(nn);
        y = x1*x2*x1;
        t1(i) = t1(i) + toc;
        
        nnn = round(nn);
        x2 = randn(nnn);
        tic
        y = fft2(x2);
        t2(i) = t2(i) + toc;  
    end
end
clear y x1 x2
%% Display
x1 = n.*n.*n;
X1 = [x1' ones(size(x1'))];
x2 = n.*n.*log(n);
X2 = [x2' ones(size(x2'))];
y1 = t1';
y2 = t2';
theta1 = X1 \ y1;
theta2 = X2 \ y2;
y1fit = X1 * theta1;
y2fit = X2 * theta2;

figure(1)
clf(1)
subplot(121)
plot(x1, y1, '*'); hold on; 
plot(x1, y1fit, '-');
subplot(122)
plot(x2, y2, '*'); hold on; 
plot(x2, y2fit, '-');

figure(2)
clf(2)
plot(n,y1)
hold on
plot(n,y2)

%% Combinaison : n=160,m=33

























