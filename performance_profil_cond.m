%% Clean
close all
clear all
clc
%% Load results and agregate them
load('cond_lp.mat')
load('cond_qp.mat')

results =[cond_lp' ;cond_qp'];
%%

logplot = true;
r = perf(results, logplot);
fig = figure(1)
set(fig, "WindowState", "maximized")
orient(fig, "landscape")
legend("K2.5", "K3.5", "K2", "K3", "location", "best")
title("Performance profile for conditionning", 'FontSize', 18)

save_figure(fig, "Performance profile - conditionning")








