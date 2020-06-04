%% Cleaning
clear all
close all
clc
%% test
load('D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_lp\results1.mat')
res_lp = results;
n = 30;
for i = 2:n
    load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_lp\results"+num2str(i)+".mat")
    res_lp = res_lp + results;
end
res_lp = res_lp/n;
results = res_lp;
%% test
figure(1)

for i = 1 : 9
    subplot(3,3,i)
    semilogy(abs(results(:,:,13+i)))
    legend("k25","k35","k2","k3")
end

