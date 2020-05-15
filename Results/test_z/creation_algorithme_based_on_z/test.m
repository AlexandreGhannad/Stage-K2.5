%% Cleaning
close all
clear all
clc
%% Load one x and z
ij=1;
for ij= 1 : 11
load("xlist")
load("zlist")
x = xlist(ij,:);
z = zlist(ij,:);
x(isnan(x)) = [];
z(isnan(z)) = [];
%% Print x and z
% figure();
% semilogy(z)
% hold on
% semilogy(x)
%% Test on one part of a graphic
% close all
% n = 73;
% xt = 1:n;
% zt = z(1:n);
% lambda = 10^10;
% 
% f = @(a) sum(abs(log10(zt) - a(1)*(xt) - a(2)));
% 
% x0 = [1 1];
% xf = fminsearch(f, x0)
% 
% figure()
% subplot(211)
% plot(zt)
% hold on
% plot([1 73], xf(1)*[1 73] + xf(2))
% subplot(212)
% plot(log10(zt))
% hold on
% plot([1 73], xf(1)*[1 73] + xf(2))


% figure()
% subplot(211)
% plot(xt)
% hold on
% plot(zt)
% subplot(212)
% semilogy(xt)
% hold on
% semilogy(zt)
%% Global test of the idea
% close all
rapport = zeros([1, length(x)-1]);
err = zeros([1, length(x)-1]);
xf = zeros([3, length(x)-1]);
err(:,1) = NaN;
xf(:,1) = NaN;

for n = 1 : length(x)-1
    coef = find_abc(z, n);
    y = broken_lines(coef,n,length(z));
    err(n) = sum(abs(log10(z) - y));
    xf(:,n) = coef;
end

figure()
subplot(211)
plot(err)
subplot(212)
semilogy(err)

[e,n] = min(err)
coef = xf(:,n);
y = broken_lines(coef,n,length(z));
figure()
plot(log10(z))
hold on
plot(log10(x))
plot(y)

% n = 73
% e = err(n)
% coef = xf(:,n);
% y = broken_lines(coef,n,length(z));
% figure()
% plot(log10(x))
% hold on
% plot(log10(z))
% plot(y)

end



























