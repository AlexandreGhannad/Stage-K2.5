%% Clean
clear all
close all
clc
%% Setup 1
pdcoo_home = pwd;

addpath(pdcoo_home);
addpath(fullfile(pdcoo_home, 'Formulations'));
addpath(fullfile(pdcoo_home, 'Solvers'));
addpath(fullfile(pdcoo_home, 'readmps'));
addpath(fullfile(pdcoo_home, 'Tools'));
addpath(fullfile(pdcoo_home, 'Problems\MPS'));
addpath(fullfile(pdcoo_home, 'Validation-eigenvalue'));
p = genpath(fullfile(pdcoo_home, 'addons'));
addpath(p);
p = genpath(fullfile(pdcoo_home, 'Results'));
addpath(p);
if exist('Variants', 'dir') ~= 7
    mkdir('Variants');
end
addpath(fullfile(pdcoo_home, 'Variants'));
addpath(fullfile(pdcoo_home, 'Test'));
%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;

formulation1 = 'K25';
solver = 'LU';
classname1 = build_variant(pdcoo_home, formulation1, solver);

formulation2 = 'K35';
solver = 'LU';
classname2 = build_variant(pdcoo_home, formulation2, solver);

formulation3 = 'K2';
solver = 'LU';
classname3 = build_variant(pdcoo_home, formulation3, solver);

list_problem = {'25fv47.mps';'adlittle.mps';'afiro.mps';...
    'agg.mps';'agg2.mps';'agg3.mps';'bandm.mps';'beaconfd.mps';...
    'blend.mps';'bnl1.mps';'boeing1.mps';'boeing2.mps';'bore3d.mps';'brandy.mps';...
    'capri.mps';'czprob.mps';...
    'degen2.mps';'e226.mps';'etamacro.mps';...
    'fffff800.mps';'finnis.mps';'fit1d.mps';'fit1p.mps';...
    'ganges.mps';'gfrd-pnc.mps';...
    'grow7.mps';'grow15.mps';'grow22.mps';'israel.mps';...
    'kb2.mps';'lotfi.mps';'maros-r7.mps';'modszk1.mps';...
    'scsd1.mps';'scsd6.mps';'scsd8.mps';...
    'share2b.mps';'shell.mps';'ship04l.mps';'ship04s.mps';...
    'ship08s.mps';...
    'sierra.mps';'stair.mps';'standata.mps';'standgub.mps';...
    'standmps.mps';'stocfor1.mps';'stocfor2.mps';'tuff.mps';...
    'vtp_base.mps';...
    'bnl2.mps';'cycle.mps' ; '80bau3b.mps';'d2q06c.mps';'d6cube.mps';...
    'degen3.mps';'dfl001.mps';'fit2d.mps';'fit2p.mps'; 'greenbeb.mps'; ...
    'greenbea.mps';'maros.mps'; 'nesm.mps'; 'pilot.mps';'pilot87.mps';...
    'scagr25.mps'; 'ship08l.mps';'ship12l.mps';'ship12s.mps';...
    'wood1p.mps'}

n_problem = length(list_problem);

options_pdco.d1 = 1.0e-2;
options_pdco.d2 = 1.0e-2;
options_pdco.OptTol = 1.0e-9;
options_solv.atol1 = 1.0e-4;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 10;
options_pdco.Print = 1;

fprintf(options_pdco.file_id, ...
    '\n    Name    Objectif   Presid   Dresid   Cresid   PDitns   Inner     Time      D2 * r\n\n');
%% Loop
clc
n_problem = min(n_problem, 30000);
results = string(zeros(4,3,n_problem));

for i = 1:n_problem
    
    mps_name = list_problem{i};
    fprintf('%s\n', mps_name);
    
    % Read .mps file
    mps_name = pwd + "\Problems\MPS\" + mps_name;
    mps_stru = readmps(mps_name);
    lp = mpstolp(mps_stru);
    slack = slackmodel(lp);
    Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
    
    options_pdco.x0 = slack.x0;
    options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
    options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
    options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
    options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
    options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
    options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
    options_pdco.y0 = zeros(slack.m, 1);
    options_pdco.mu0 = options_pdco.zsize;
    options_pdco.Maxiter = min(max(30, slack.n), 100);
    options_form = struct();
    
    Problem1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
    Problem1.solve;
    Problem2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
    Problem2.solve;
    Problem3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
    Problem3.solve;
    result = save_comparison(Problem1, Problem2, Problem3, 1);
    results(:,:,i) = result;
end

fclose('all');
%% Print and save results
clc
for i = 1 : n_problem;
    print_comparison(Problem1, Problem2, Problem3, squeeze(results(:,:,i)))
end
cpt = length(dir("D:\git_repository\Stage-K2.5\Results\comparison_efficiency"));
save("D:\git_repository\Stage-K2.5\Results\comparison_efficiency\results"+num2str(cpt+1)+".mat", "results")
%% Show results with graphics (little problem and mean)
close all
clear all
clc
load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency\results_mean_50_tests.mat")

iter = double(squeeze(results(1,:,:)));
reason = results(2,:,:);
complementarity_resid = double(squeeze(results(3,:,:)));
time = double(squeeze(results(4,:,:)));

figure(1)
clf(1)
time = sort(time, 2);
t1 = time(1,:);
t2 = time(2,:);
t3 = time(3,:);
semilogy(t1, "b+", "LineWidth", 2)
hold on
semilogy(t2, "k+", "LineWidth", 2)
semilogy(t3, "r+", "LineWidth", 2)
title("Execution time of the different formulations")
legend("K2.5", "K3.5", "K2")
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

figure(2)
clf(2)
semilogy(tmax1, "b+", "LineWidth", 2)
hold on
semilogy(tmin1, "b+", "LineWidth", 2)
semilogy(tmax2, "k+", "LineWidth", 2)
semilogy(tmin2, "k+", "LineWidth", 2)
semilogy(tmax3, "r+", "LineWidth", 2)
semilogy(tmin3, "r+", "LineWidth", 2)
title("Best and worst execution time")
ylabel("Time (s)")




% Compare efficiency in duel
figure(3)
clf(3)

% K2.5 vs K3.5
subplot(221)
semilogy(t1, "b+", "LineWidth", 2)
hold on
semilogy(t2, "k+", "LineWidth", 2)
title("K2.5 vs K3.5")
legend("K2.5", "K3.5")
ylabel("Time (s)")

% K2.5 vs K2
subplot(222)
semilogy(t1, "b+", "LineWidth", 2)
hold on
semilogy(t3, "r+", "LineWidth", 2)
title("K2.5 vs K2")
legend("K2.5", "K2")
ylabel("Time (s)")

% K3.5 vs K2
subplot(223)
semilogy(t2, "k+", "LineWidth", 2)
hold on
semilogy(t3, "r+", "LineWidth", 2)
title("K3.5 vs K2")
legend("K3.5", "K2")
ylabel("Time (s)")

n1 = sum(imin == 1);
n2 = sum(imin == 2);
n3 = sum(imin == 3);
fprintf("\nNombre de fois que K2.5 est meilleur : %g\n", n1)
fprintf("Nombre de fois que K3.5 est meilleur : %g\n", n2)
fprintf("Nombre de fois que K2 est meilleur : %g\n\n", n3)
%% Show results with graphics (large problem)
% close all
clear all
% clc
load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency\results_ten_test_all_problems.mat")

iter = double(squeeze(results(1,:,:)));
reason = results(2,:,:);
complementarity_resid = double(squeeze(results(3,:,:)));
time = double(squeeze(results(4,:,:)));

n_largest_problems = 25;

figure(4)
clf(4)
time = sort(time, 2);
time = time(:, end - n_largest_problems+1:end);
t1 = time(1,:);
t2 = time(2,:);
t3 = time(3,:);
semilogy(t1, "b+", "LineWidth", 2)
hold on
semilogy(t2, "k+", "LineWidth", 2)
semilogy(t3, "r+", "LineWidth", 2)
title("Execution time of the different formulations")
legend("K2.5", "K3.5", "K2")
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

figure(5)
clf(5)
semilogy(tmax1, "b+", "LineWidth", 2)
hold on
semilogy(tmin1, "b+", "LineWidth", 2)
semilogy(tmax2, "k+", "LineWidth", 2)
semilogy(tmin2, "k+", "LineWidth", 2)
semilogy(tmax3, "r+", "LineWidth", 2)
semilogy(tmin3, "r+", "LineWidth", 2)
title("Best and worst execution time")
ylabel("Time (s)")




% Compare efficiency in duel
figure(6)
clf(6)

% K2.5 vs K3.5
subplot(221)
semilogy(t1, "b+", "LineWidth", 2)
hold on
semilogy(t2, "k+", "LineWidth", 2)
title("K2.5 vs K3.5")
legend("K2.5", "K3.5")
ylabel("Time (s)")

% K2.5 vs K2
subplot(222)
semilogy(t1, "b+", "LineWidth", 2)
hold on
semilogy(t3, "r+", "LineWidth", 2)
title("K2.5 vs K2")
legend("K2.5", "K2")
ylabel("Time (s)")

% K3.5 vs K2
subplot(223)
semilogy(t2, "k+", "LineWidth", 2)
hold on
semilogy(t3, "r+", "LineWidth", 2)
title("K3.5 vs K2")
legend("K3.5", "K2")
ylabel("Time (s)")

n1 = sum(imin == 1);
n2 = sum(imin == 2);
n3 = sum(imin == 3);
fprintf("\nNombre de fois que K2.5 est meilleur : %g\n", n1)
fprintf("Nombre de fois que K3.5 est meilleur : %g\n", n2)
fprintf("Nombre de fois que K2 est meilleur : %g\n\n", n3)