%% Clean
close all
clear all
clc
%% Load results and agregate them
load('cond_lp.mat')
cond_lp = cond;
load('cond_qp.mat')
cond_qp = cond;

results =[cond_lp' ;cond_qp'];
%%
fontsize = 25;
logplot = true;
r = perf(results, logplot);
fig = figure(1)
set(fig, "WindowState", "maximized")
orient(fig, "landscape")
legend("K2.5", "K3.5", "K2", "K3", "location", "best", 'FontSize', fontsize)
title("Conditioning profile", 'FontSize', fontsize)
ax = fig.CurrentAxes;
set(ax, "FontSize", fontsize)

path = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Profil de performance - conditionnement\";

save_figure(fig, path+"Performance profile - conditionning")
save_figure_pdf(fig, path+"Performance profile - conditionning.pdf")








