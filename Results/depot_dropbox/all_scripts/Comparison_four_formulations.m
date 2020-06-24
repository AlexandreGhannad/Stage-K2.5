%% Clean
close all
clear all
clc
%% Load results and agregate them
fontsize = 35;
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
%% Display, sort according to K2.5
time1 = results(:,1);
time2 = results(:,2);
time3 = results(:,3);
time4 = results(:,4);

[time1, perm] = sort(time1, "ascend");
time2 = time2(perm);
time3 = time3(perm);
time4 = time4(perm);
 
time = [time1 time2 time3 time4]';
%% First graph
fig1 = figure(1);
set(fig1, "WindowState", "maximized")
clf(1)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1.5)
hold on
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
title("Execution time of the different formulations", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])
ax = fig1.CurrentAxes;
set(ax, "FontSize", fontsize)
%% Second graph
fig2 = figure(2);
set(fig2, "WindowState", "maximized")
clf(2)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1.5)
hold on
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
semilogy(time1, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 0.5)
semilogy(time2, "Color", [0 0.4470 0.7410], 'LineWidth', 0.5)
semilogy(time3, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 0.5)
semilogy(time4, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 0.5)
title("Execution time of the different formulations", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])
ax = fig2.CurrentAxes;
set(ax, "FontSize", fontsize)
%% Third graph
[tmax,imax] = max(time);
[tmin,imin] = min(time);

tmax1 = tmax;
tmax1(imax~=1) = NaN;
tmax2 = tmax;
tmax2(imax~=2) = NaN;
tmax3 = tmax;
tmax3(imax~=3) = NaN;
tmax4 = tmax;
tmax4(imax~=4) = NaN;

tmin1 = tmin;
tmin1(imin~=1) = NaN;
tmin2 = tmin;
tmin2(imin~=2) = NaN;
tmin3 = tmin;
tmin3(imin~=3) = NaN;
tmin4 = tmin;
tmin4(imin~=4) = NaN;

fig3 = figure(3);
set(fig3, "WindowState", "maximized")
clf(3)
semilogy(tmax1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
hold on
semilogy(tmax2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(tmax3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(tmax4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
semilogy(tmin1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
semilogy(tmin2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(tmin3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(tmin4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1.5)

title("Best and worst execution time", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])
ax = fig3.CurrentAxes;
set(ax, "FontSize", fontsize)
%% Fourth graph
% Compare efficiency in duel
fig4 = figure(4);
clf(4)
set(fig4, "WindowState", "maximized")

% K2.5 vs K3.5
subplot(321)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
title("K2.5 vs K3.5", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K2.5 vs K2
subplot(322)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
title("K2.5 vs K2", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K2 (LDL solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K2.5 vs K3
subplot(323)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K2.5 vs K2", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K3.5 vs K2
subplot(324)
[t2, perm] = sort(time2, "ascend");
semilogy(t2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
hold on
semilogy(time3(perm), "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
title("K3.5 vs K2", 'FontSize', fontsize)
legend("K3.5 (LDL solver)", "K2 (LDL solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K3.5 vs K3
subplot(325)
semilogy(t2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
hold on
semilogy(time4(perm), "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K3.5 vs K2", 'FontSize', fontsize)
legend("K3.5 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K2 vs K3
subplot(326)
[t3, perm] = sort(time3, "ascend");
semilogy(t3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
hold on
semilogy(time4(perm), "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K2 vs K3", 'FontSize', fontsize)
legend("K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

n1 = sum(imin == 1);
n2 = sum(imin == 2);
n3 = sum(imin == 3);
n4 = sum(imin == 4);

fprintf("\nNombre de fois que K2.5 est meilleur : %g\n", n1)
fprintf("Nombre de fois que K3.5 est meilleur : %g\n", n2)
fprintf("Nombre de fois que K3 est meilleur : %g\n", n3)
fprintf("Nombre de fois que K2 est meilleur : %g\n\n", n4)

%% Display, sort according to 
time1 = results(:,1);
time2 = results(:,2);
time3 = results(:,3);
time4 = results(:,4);
load('sizeA_lp.mat')
load('sizeA_qp.mat')
sizeA = [sizeA;size_A];
[x, perm] = sort(sizeA);
time1 = time1(perm);
time2 = time2(perm);
time3 = time3(perm);
time4 = time4(perm);
 
time = [time1 time2 time3 time4]';
%% First graph
fig5 = figure(5);
set(fig5, "WindowState", "maximized")
clf(5)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1.5)
hold on
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
title("Execution time of the different formulations", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])
ax = fig5.CurrentAxes;
set(ax, "FontSize", fontsize)
%% Second graph
fig6 = figure(6);
set(fig6, "WindowState", "maximized")
clf(6)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1.5)
hold on
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
semilogy(time1, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 0.5)
semilogy(time2, "Color", [0 0.4470 0.7410], 'LineWidth', 0.5)
semilogy(time3, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 0.5)
semilogy(time4, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 0.5)
title("Execution time of the different formulations", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])
ax = fig6.CurrentAxes;
set(ax, "FontSize", fontsize)
%% Third graph
[tmax,imax] = max(time);
[tmin,imin] = min(time);

tmax1 = tmax;
tmax1(imax~=1) = NaN;
tmax2 = tmax;
tmax2(imax~=2) = NaN;
tmax3 = tmax;
tmax3(imax~=3) = NaN;
tmax4 = tmax;
tmax4(imax~=4) = NaN;

tmin1 = tmin;
tmin1(imin~=1) = NaN;
tmin2 = tmin;
tmin2(imin~=2) = NaN;
tmin3 = tmin;
tmin3(imin~=3) = NaN;
tmin4 = tmin;
tmin4(imin~=4) = NaN;

fig7 = figure(7);
set(fig7, "WindowState", "maximized")
clf(7)
semilogy(tmax1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
hold on
semilogy(tmax2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(tmax3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(tmax4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1.5)
semilogy(tmin1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
semilogy(tmin2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(tmin3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(tmin4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1.5)

title("Best and worst execution time", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])
ax = fig7.CurrentAxes;
set(ax, "FontSize", fontsize)
%% Fourth graph
% Compare efficiency in duel
fig8 = figure(8);
clf(8)
set(fig8, "WindowState", "maximized")

% K2.5 vs K3.5
subplot(321)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
title("K2.5 vs K3.5", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K2.5 vs K2
subplot(322)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
title("K2.5 vs K2", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K2 (LDL solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K2.5 vs K3
subplot(323)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K2.5 vs K3", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K3.5 vs K2
subplot(324)
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
hold on
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
title("K3.5 vs K2", 'FontSize', fontsize)
legend("K3.5 (LDL solver)", "K2 (LDL solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K3.5 vs K3
subplot(325)
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
hold on
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K3.5 vs K3", 'FontSize', fontsize)
legend("K3.5 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])

% K2 vs K3
subplot(326)
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
hold on
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K3 vs K2", 'FontSize', fontsize)
legend("K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize)
xlim([0, 220])


n1 = sum(imin == 1);
n2 = sum(imin == 2);
n3 = sum(imin == 3);
n4 = sum(imin == 4);

fprintf("\nNombre de fois que K2.5 est meilleur : %g\n", n1)
fprintf("Nombre de fois que K3.5 est meilleur : %g\n", n2)
fprintf("Nombre de fois que K2 est meilleur : %g\n", n3)
fprintf("Nombre de fois que K3 est meilleur : %g\n\n", n4)
%% Save graphics
path = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Temps d'exécution\pdf\";

save_figure_pdf(fig1, path + "fig1");
save_figure_pdf(fig2, path + "fig2");
save_figure_pdf(fig3, path + "fig3");
save_figure_pdf(fig4, path + "fig4");
save_figure_pdf(fig5, path + "fig5");
save_figure_pdf(fig6, path + "fig6");
save_figure_pdf(fig7, path + "fig7");
save_figure_pdf(fig8, path + "fig8");

path = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Temps d'exécution\eps\";

save_figure(fig1, path + "fig1");
save_figure(fig2, path + "fig2");
save_figure(fig3, path + "fig3");
save_figure(fig4, path + "fig4");
save_figure(fig5, path + "fig5");
save_figure(fig6, path + "fig6");
save_figure(fig7, path + "fig7");
save_figure(fig8, path + "fig8");

% save_figure(fig1, path + "fig1.pdf");
% save_figure(fig2, path + "fig2.pdf");
% save_figure(fig3, path + "fig3.pdf");
% save_figure(fig4, path + "fig4.pdf");
% save_figure(fig5, path + "fig5.pdf");
% save_figure(fig6, path + "fig6.pdf");
% save_figure(fig7, path + "fig7.pdf");
% save_figure(fig8, path + "fig8.pdf");














