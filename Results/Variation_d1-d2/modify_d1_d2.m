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

formulation = 'K25';
solver = 'LU';
classname = build_variant(pdcoo_home, formulation, solver);

options_pdco.OptTol = 1.0e-9;
options_solv.atol1 = 1.0e-4;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 10;
options_pdco.Print = 1;

fprintf(options_pdco.file_id, ...
        '\n    Name    Objectif   Presid   Dresid   Cresid   PDitns   Inner     Time      D2 * r\n\n');
%% Check eigenvalues and compare method
check_eigenvalue = 1
show_one_graphic = 1; % = 1  need check_eigenvalue = 1
show_all_graphic = 0; % = 1  need check_eigenvalue = 1
check_cond = 1;
check_residu = 1;
check_all_residu = 0; % = 1  need check_residu = 1
check_limits = 1;
%% Loop
clc

d1 = [10^-4];
d2 = [10^-4];
% d1 = [10^-4 1];
% d2 = [10^-4 1];
% d1 = logspace(-4,0,3);
% d2 = logspace(-4,0,3);

for i = 1 : length(d1)
    for j = 1 : length(d2)
        
        options_pdco.d1 = d1(i);
        options_pdco.d2 = d2(j);
        
        mps_name = 'afiro.mps';
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
        options_form = struct();

        Problem = eval([classname, '(slack, options_pdco,options_form,options_solv)']);
        Problem.solve;
        
        show_eigenvalue(Problem.eigenvalue, Problem.limit, d1(i), d2(j), Problem.features_limits)
        show_cond(Problem.cond, Problem.limit, d1(i), d2(j))
        show_residu(Problem.opt_residu, Problem.evolution_mu, d1(i), d2(i))
    end
end

fclose('all');