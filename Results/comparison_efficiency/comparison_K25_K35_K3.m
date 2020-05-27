%% Clean
close all
clear all
clc
%% Load results and agregate them
load('D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_lp\results1.mat')
res_lp = results;
load('D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_qp\results1.mat')
res_qp = results;
for i = 2:20
    load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_lp\results"+num2str(i)+".mat")
    res_lp = res_lp + results;
    load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL_qp\results"+num2str(i)+".mat")
    res_qp = res_qp+results;
end
res_lp = res_lp/20;
res_qp = res_qp/20;
results =[res_lp ;res_qp];
%% Show
iter = double(squeeze(results(:,1,:)))';
reason = double(squeeze(results(:,2,:)))';
complementarity_resid = double(squeeze(results(:,3,:)))';
time = double(squeeze(results(:,4,:)))';

fig1 = figure(1)
clf(1)
time = sort(time, 2);
t1 = time(1,:);
t2 = time(2,:);
t3 = time(3,:);
semilogy(t1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
hold on
semilogy(t2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(t3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
title("Execution time of the different formulations")
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K3 (QR solver)", "Location", "northwest")
ylabel("Time (s)")


[tmax,imax] = max(time);
[tmin,imin] = min(time);

tmax1 = tmax;
tmax1(imax~=1) = NaN;
tmax2 = tmax;
tmax2(imax~=2) = NaN;
tmax3 = tmax;
tmax3(imax~=3) = NaN;

tmin1 = tmin;
tmin1(imin~=1) = NaN;
tmin2 = tmin;
tmin2(imin~=2) = NaN;
tmin3 = tmin;
tmin3(imin~=3) = NaN;

fig2 = figure(2)
clf(2)
semilogy(tmax1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
hold on
semilogy(tmax2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(tmax3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
semilogy(tmin1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
semilogy(tmin2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
semilogy(tmin3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
title("Best and worst execution time")
ylabel("Time (s)")
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K3 (QR solver)", "Location", "northwest")





% Compare efficiency in duel
fig3 = figure(3)
clf(3)

% K2.5 vs K3.5
subplot(221)
semilogy(t1, "x", "MarkerSize", 1.5, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
hold on
semilogy(t2, "d", "MarkerSize", 1, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
title("K2.5 vs K3.5")
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "Location", "northwest")
ylabel("Time (s)")

% K2.5 vs K3
subplot(222)
semilogy(t1, "x", "MarkerSize", 1.5, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 2)
hold on
semilogy(t3, "o", "MarkerSize", 1, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
title("K2.5 vs K3")
legend("K2.5 (LDL solver)", "K3 (QR solver)", "Location", "northwest")
ylabel("Time (s)")

% K3.5 vs K3
subplot(223)
semilogy(t2, "d", "MarkerSize", 1, "Color", [0 0.4470 0.7410], 'LineWidth', 1.5)
hold on
semilogy(t3, "o", "MarkerSize", 1, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1.5)
title("K3.5 vs K3")
legend("K3.5 (LDL solver)", "K3 (QR solver)", "Location", "northwest")
ylabel("Time (s)")

n1 = sum(imin == 1);
n2 = sum(imin == 2);
n3 = sum(imin == 3);
fprintf("\nNombre de fois que K2.5 est meilleur : %g\n", n1)
fprintf("Nombre de fois que K3.5 est meilleur : %g\n", n2)
fprintf("Nombre de fois que K3 est meilleur : %g\n\n", n3)
%% Save graphics
orient(fig1, "landscape")
orient(fig2, "landscape")
orient(fig3, "landscape")

set(fig1,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\comparison_efficiency\Execution_time.pdf';
print(fig1, filename,'-dpdf', "-r1200")

set(fig2,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\comparison_efficiency\Best_wost_execution_time.pdf';
print(fig2, filename,'-dpdf', "-r1200") 

set(fig3,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\comparison_efficiency\Comparison_side_by_side.pdf';
print(fig3, filename,'-dpdf', "-r1200")