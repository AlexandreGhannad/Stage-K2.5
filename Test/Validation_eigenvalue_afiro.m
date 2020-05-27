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
p = genpath(fullfile(pdcoo_home, 'addons'));
addpath(p);
p = genpath(fullfile(pdcoo_home, 'Results'));
addpath(p);
p = genpath(fullfile(pdcoo_home, 'Problems'));
addpath(p);
p = genpath(fullfile(pdcoo_home, 'Validation-eigenvalue'));
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

list_problem ={'afiro.mps'};
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
check_eigenvalue = 1
show_one_graphic = 1; % = 1  need check_eigenvalue = 1
show_all_graphic = 0; % = 1  need check_eigenvalue = 1
check_cond = 1;
compare_formulations = 1;
check_residu = 1;
check_all_residu = 0; % = 1  need check_residu = 1
check_limits = 1;
check_eigenvalueK35 = 1;
check_all_eigenvalueK35 = 1;
check_theorem2 = 1;
check_all_theorem2 = 0;
method_theorem2 = "MaxGap";
check_property = 1;


options_pdco.d1 = 0.01;
options_pdco.d2 = 0.01;
%% Loop
clc
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
        show_eigenvalue_theorem2(o.eigenvalue, o.features_theorem2);
    end
    if check_all_residu
        residu = Problem1.opt_residu
        evolution_mu = Problem1.evolution_mu;
        show_residu(residu, evolution_mu)
    end
    
    if compare_formulations
        if i == 1
            name = list_problem{i};
            prob1 = Problem1;
            prob2 = Problem2;
            prob3 = Problem3;
            l = length(Problem1.M);
        else
            if length(Problem1.M) > l
                name = list_problem{i};
                prob1 = Problem1;
                prob2 = Problem2;
                prob3 = Problem3;
                l = length(Problem1.M);
            end
        end
    end
    if check_cond & check_eigenvalue
        show_cond(Problem1.cond, Problem1.limit);
    elseif check_cond & not(check_eigenvalue)
        show_cond(Problem1.cond);
    end
    
    if check_all_eigenvalueK35
        show_eigenvalueK35(Problem2.eigenvalue, options_pdco.d1, options_pdco.d2)
    end
    show_eigenvalue_property(eigenvalue, limit, d1, d2, features_property)
end

fclose('all');
%% Print result
% clc
% print_result(result, list_problem)
if show_one_graphic
    if check_limits
        show_eigenvalue(prob1.eigenvalue, prob1.limit, options_pdco.d1, options_pdco.d2, prob1.features_limits)
    else
        show_eigenvalue(prob1.eigenvalue, prob1.limit);
    end
end
if check_residu
    show_residu(residu,evolution_mu);
end
if compare_formulations
    print_comparison(prob1, prob2, prob3);
end

if check_theorem2 & not(check_all_theorem2)
    show_eigenvalue_theorem2(prob1.eigenvalue, prob1.features_theorem2, options_pdco.d1, options_pdco.d2, 1);
end

if check_eigenvalueK35 & not(check_eigenvalueK35)
    show_eigenvalueK35(prob2.eigenvalue, options_pdco.d1, options_pdco.d2)
end