%% Cleaning
close all
clear all
clc
%% Load one x and z
for ij=1:11;
load("xlist")
load("zlist")
x = xlist(ij,:);
z = zlist(ij,:);
x(isnan(x)) = [];
z(isnan(z)) = [];
%% Global test of the idea
rapport = zeros([1, length(x)-1]);
err = zeros([1, length(x)-1]);
% xf = zeros([3, length(x)-1]);
xf = zeros([5, length(x)-1])
err(:,1) = NaN;
xf(:,1) = NaN;
xf1 = zeros([3, length(x)-1]);
xf1(:,1) = NaN;
err1 = zeros([1, length(x)-1]);
err1(:,1) = NaN;
method = "power_lines"


for n = 10 : length(x)-10
    coef1 = find_abc(z, n, "broken_lines");
    coef = find_abc(z, n, method);
    switch method
        case "broken_lines"
            y = broken_lines(coef,n,length(z));
        case "broken_lines_and_laplace"
            y = broken_lines_and_laplace(coef,n,length(z));
        case "broken_lines_with_weight"
            y = broken_lines(coef,n,length(z));
        case "broken_lines_and_laplace_with_weight"
            y = broken_lines_and_laplace(coef,n,length(z));
        case "power_lines"
            y = power_lines(coef,n,length(z));
        case "power_lines_with_hole"
            y = power_lines(coef,n,length(z));
        case "power_lines_L2"
            y = power_lines(coef,n,length(z));
        case "normal_power_lines"
            y = normal_power_lines(coef,n,length(z));
    end
    y1 = broken_lines(coef1,n,length(z));
    err(n) = sum(abs(log10(z) - y));
    err1(n) = sum(abs(log10(z) - y1));
    xf(:,n) = coef;
    xf1(:,n) = coef1;
end


%% Show
err(err==0) = NaN;
err1(err1==0) = NaN;

figure()
subplot(211)
semilogy(err,"." , "MarkerSize", 12, "Color", [0 0.4470 0.7410])
hold on
semilogy(err, "LineWidth", 0.5, "Color", [0 0.4470 0.7410])
title("Error on the power lines")
subplot(212)
semilogy(err1,"." , "MarkerSize", 12, "Color", [0 0.4470 0.7410])
hold on
semilogy(err1, "LineWidth", 0.5, "Color", [0 0.4470 0.7410])
title("Error on the broken lines")

[e,n] = min(err,[],'omitnan')
coef = xf(:,n);
y = power_lines(coef,n,length(z));
[e1,n1] = min(err1)
coef1 = xf1(:,n1);
y1 = broken_lines(coef1,n1,length(z));
figure()
plot(log10(z),"." , "MarkerSize", 12, "Color", [0 0.4470 0.7410])
hold on
plot(log10(z), "LineWidth", 0.5, "Color", [0 0.4470 0.7410])
plot(log10(x),"." , "MarkerSize", 12, "Color", [0.8500 0.3250 0.0980])
plot(log10(x), "LineWidth", 0.5, "Color", [0.8500 0.3250 0.0980])
plot(y1, "Color", [0.4660 0.6740 0.1880 0.7], "Linewidth", 3)
plot(y, "Color", [0.6350 0.0780 0.1840  0.7], "Linewidth", 2)
legend("z","z", "x","x", "Broken lines", "Power lines")


end