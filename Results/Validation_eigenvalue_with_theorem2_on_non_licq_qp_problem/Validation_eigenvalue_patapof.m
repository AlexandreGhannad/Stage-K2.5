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
p = genpath(fullfile(pdcoo_home, 'eigenvalue'));
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

% formulation3 = 'K3';
% solver = 'LDL';
% classname3 = build_variant(pdcoo_home, formulation3, solver);

list_problem = {'qbore3d.qps' 'qbrandy.qps' 'qship04l.qps' 'qship04s.qps' 'qship08l.qps' 'qship08s.qps' 'qship12l.qps' 'qship12s.qps' 'stcqp1.qps'};
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
n_problem = min(n_problem, 10000);
check_eigenvalue = 1
show_one_graphic = 0; % = 1  need check_eigenvalue = 1
show_all_graphic = 1; % = 1  need check_eigenvalue = 1
check_cond = 1;
compare_formulations = 1;
check_residu = 1;
check_all_residu = 0; % = 1  need check_residu = 1
check_limits = 0;
check_eigenvalueK35 = 1;
check_all_eigenvalueK35 = 1;
check_theorem2 = 1;
check_all_theorem2 = 1;
method_theorem2 = "MaxGap";

options_pdco.d1 = 0.01;
options_pdco.d2 = 0.01;
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
    
    %% Path to the directory to save figures
    pathway = "D:\git_repository\Stage-K2.5\Results\Validation_eigenvalue_with_theorem2\figure";
    cpt = length(dir("D:\git_repository\Stage-K2.5\Results\Validation_eigenvalue_with_theorem2\")) - 5+1;
    name_figure = pathway + num2str(cpt)+ ".pdf";
    %% Save the first figure: validation eigenvalue (theorem 1)
    fig1 = show_eigenvalue(Problem1.eigenvalue, Problem1.limit);
    orient(fig1, "landscape");
    print(fig1, "-r1200", "-dpdf","-fillpage", name_figure);
    cpt = cpt+1;
    name_figure = pathway + num2str(cpt)+ ".pdf";
    %% Save the second figure: validation eigenvalue (theorem 2)
    fig2 = show_eigenvalue_theorem2(Problem1.eigenvalue, Problem1.features_theorem2);
    orient(fig2, "landscape");
    print(fig2, "-r1200", "-dpdf","-fillpage", name_figure);
    cpt = cpt+1;
    name_figure = pathway + num2str(cpt)+ ".pdf";
    %% Save the third figure: other formulation
    fig3 = show_eigenvalueK35(Problem2.eigenvalue, options_pdco.d1, options_pdco.d2);
    orient(fig3, "landscape");
    print(fig3, "-r1200", "-dpdf","-fillpage", name_figure);
    cpt = cpt+1;
    name_figure = pathway + num2str(cpt)+ ".pdf";
    %% Save the fourth figure: residu
    residu = Problem1.opt_residu;
    evolution_mu = Problem1.evolution_mu;
    fig4 = show_residu(residu, evolution_mu)
    orient(fig4, "landscape");
    print(fig4, "-r1200", "-dpdf","-fillpage", name_figure);
    cpt = cpt+1;
    name_figure = pathway + num2str(cpt)+ ".pdf";
    %% Save the fifth figure: conditioning
    cond2 = max(abs(Problem2.eigenvalue)) ./ min(abs(Problem2.eigenvalue));
    fig5 = show_cond(Problem1.cond, Problem1.limit, options_pdco.d1, options_pdco.d2, cond2 , "K3.5");
    orient(fig5, "landscape");
    print(fig5, "-r1200", "-dpdf","-fillpage", name_figure);
    cpt = cpt+1;
    name_figure = pathway + num2str(cpt)+ ".pdf";
    %%
    close all
    clc
    
end

fclose('all');