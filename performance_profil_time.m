%% Clean
close all
clear all
clc
%% Load results and agregate them
load('D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_lp\results1.mat')
res_lp = results(:,:,3);
load('D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_qp\results1.mat')
res_qp = results(:,:,3);
n = 20;
for i = 2:n
    load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_lp\results"+num2str(i)+".mat")
    res_lp = res_lp + results(:,:,3);
    load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_qp\results"+num2str(i)+".mat")
    res_qp = res_qp+results(:,:,3);
end
res_lp = res_lp/n;
res_qp = res_qp/20;
results =[res_lp ;res_qp];
%%
fontsize = 18;
logplot = true;
r = perf(results, logplot);
fig = figure(1)
set(fig, "WindowState", "maximized")
orient(fig, "landscape")
legend("K2.5", "K3.5", "K2", "K3", "location", "best")
title("Performance profile", 'FontSize', fontsize)

save_figure(fig, "Performance profile - time")








