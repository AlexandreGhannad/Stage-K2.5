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
solver = 'LDL';
classname1 = build_variant(pdcoo_home, formulation1, solver);

formulation2 = 'K35';
solver = 'LDL';
classname2 = build_variant(pdcoo_home, formulation2, solver);

formulation3 = 'K2';
solver = 'LDL';
classname3 = build_variant(pdcoo_home, formulation3, solver);

path_problem = pwd + "/Problems/lp_prob";
list_problem = dir(path_problem);
list_problem = {list_problem.name};
list_problem = list_problem(3:end);
n_problem = length(list_problem);

options_pdco.d1 = 1.0e-2;
options_pdco.d2 = 1.0e-2;
options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

fprintf(options_pdco.file_id, ...
    '\n    Name    Objectif   Presid   Dresid   Cresid   PDitns   Inner     Time      D2 * r\n\n');

result = zeros(9,3,n_problem);
%% Check eigenvalues and compare method
n_problem = min(n_problem, 2000);
check_eigenvalue = 0;
show_one_graphic = 0; % = 1  need check_eigenvalue = 1
show_all_graphic = 0; % = 1  need check_eigenvalue = 1
check_cond = 0;
compare_formulations = 1;
check_residu = 0;
check_all_residu = 0; % = 1  need check_residu = 1
check_limits = 0;
check_eigenvalueK35 = 0;
check_all_eigenvalueK35 = 0;
check_theorem2 = 0;
check_all_theorem2 = 0;
method_theorem2 = "MaxGap";
results = zeros(n_problem, 4,3);
%% Loop
clc
for i = 1:n_problem
    
    mps_name = list_problem{i};
    fprintf('%s\n', mps_name);
    
    % Read .mps file
    mps_name = pwd + "\Problems\lp_prob\" + mps_name;
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
    options_pdco.check_eigenvalue = check_eigenvalue;
    options_pdco.check_residu = check_residu;
    options_pdco.check_cond = check_cond;
    options_pdco.check_limits = check_limits;
    options_pdco.check_theorem2 = check_theorem2;
    options_pdco.check_eigenvalueK35 = check_eigenvalueK35;
    options_pdco.method = method_theorem2;
    options_form = struct();
    
    Problem1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
    Problem1.solve;
    Problem2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
    Problem2.solve;
    Problem3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
    Problem3.solve;
    fprintf(Problem1.file_id, ...
        '\n%12s   %11.4e   %6.0f   %6.0f   %6.0f   %6d   %6d   %7.2f s   %11.4e\n', ...
        mps_name, slack.fobj(Problem1.x),                                            ...
        log10(Problem1.Pinf), log10(Problem1.Dinf), log10(Problem1.Cinf0),             ...
        Problem1.PDitns, Problem1.inner_total, Problem1.time, options_pdco.d2^2 * norm(Problem1.y));
    if check_eigenvalue
        if i == 1
            name = list_problem{i};
            prob1 = Problem1;
            prob2 = Problem2;
            prob3 = Problem3;
            l = length(Problem1.M);
            if check_residu
                residu = Problem1.opt_residu;
                evolution_mu = Problem1.evolution_mu;
            end
        else
            if length(Problem1.M) > l
                name = list_problem{i};
                prob1 = Problem1;
                prob2 = Problem2;
                prob3 = Problem3;
                l = length(Problem1.M);
                if check_residu
                    residu = Problem1.opt_residu;
                    evolution_mu = Problem1.evolution_mu;
                end
            end
        end
    end
    if show_all_graphic
        if check_limits
            show_eigenvalue(Problem1.eigenvalue, Problem1.limit, options_pdco.d1, options_pdco.d2, Problem1.features_limits)
        else
            show_eigenvalue(Problem1.eigenvalue, Problem1.limit);
        end
    end
    if check_all_theorem2
        show_eigenvalue_theorem2(Problem1.eigenvalue, Problem1.features_theorem2);
    end
    if check_all_residu
        residu = Problem1.opt_residu
        evolution_mu = Problem1.evolution_mu;
        show_residu(residu, evolution_mu)
    end
    
    if compare_formulations
        result = save_comparison(Problem1, Problem2, Problem3);
        results(i,:,:) = result;
        
    end
    if check_cond & check_eigenvalue
        show_cond(Problem1.cond, Problem1.limit);
    elseif check_cond & not(check_eigenvalue)
        show_cond(Problem1.cond);
    end
    
    if check_all_eigenvalueK35
        show_eigenvalueK35(Problem2.eigenvalue, options_pdco.d1, options_pdco.d2)
    end
end

fclose('all');
%% save
cpt = length(dir("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL\")) - 3 + 1;
save("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL\results"+num2str(cpt)+".mat", "results")
%% Show results with graphics
close all
clear all
clc
load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL\results"+num2str(1)+".mat")
res = zeros(size(results));
cpt = length(dir("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL\")) - 3;
for i = 1 : cpt
    load("D:\git_repository\Stage-K2.5\Results\comparison_efficiency_LDL\results"+num2str(i)+".mat")
    res = res + results;
end
results = res/10;

iter = double(squeeze(results(:,1,:)))';
reason = double(squeeze(results(:,2,:)))';
complementarity_resid = double(squeeze(results(:,3,:)))';
time = double(squeeze(results(:,4,:)))';

figure(1)
clf(1)
time = sort(time, 2);
t1 = time(1,:);
t2 = time(2,:);
t3 = time(3,:);
semilogy(t1, "+", "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
hold on
semilogy(t2, "+", "LineWidth", 2, "Color", [0 0.4470 0.7410])
semilogy(t3, "+", "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
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
semilogy(tmax1, "+", "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
hold on
semilogy(tmin1, "+", "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
semilogy(tmax2, "+", "LineWidth", 2, "Color", [0 0.4470 0.7410])
semilogy(tmin2, "+", "LineWidth", 2, "Color", [0 0.4470 0.7410])
semilogy(tmax3, "+", "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
semilogy(tmin3, "+", "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
title("Best and worst execution time")
ylabel("Time (s)")




% Compare efficiency in duel
figure(3)
clf(3)

% K2.5 vs K3.5
subplot(221)
semilogy(t1, "+", "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
hold on
semilogy(t2, "+", "LineWidth", 2, "Color", [0 0.4470 0.7410])
title("K2.5 vs K3.5")
legend("K2.5", "K3.5")
ylabel("Time (s)")

% K2.5 vs K2
subplot(222)
semilogy(t1, "+", "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
hold on
semilogy(t3, "+", "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
title("K2.5 vs K2")
legend("K2.5", "K2")
ylabel("Time (s)")

% K3.5 vs K2
subplot(223)
semilogy(t2, "+", "LineWidth", 2, "Color", [0 0.4470 0.7410])
hold on
semilogy(t3, "+", "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
title("K3.5 vs K2")
legend("K3.5", "K2")
ylabel("Time (s)")

n1 = sum(imin == 1);
n2 = sum(imin == 2);
n3 = sum(imin == 3);
fprintf("\nNombre de fois que K2.5 est meilleur : %g\n", n1)
fprintf("Nombre de fois que K3.5 est meilleur : %g\n", n2)
fprintf("Nombre de fois que K2 est meilleur : %g\n\n", n3)
