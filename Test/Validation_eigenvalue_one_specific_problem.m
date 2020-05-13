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
% {'farm.mps'}    {'finnis.mps'}    {'gams10a.mps'}    {'gams30a.mps'}    {'grow7.mps'}    {'iiasa.mps'}
mps_name = 'grow7.mps';
mps_name = pwd + "\Problems\lp_prob\" + mps_name;

options_pdco.file_id = 1;
formulation1 = 'K25';
solver = 'LDL';
classname1 = build_variant(pdcoo_home, formulation1, solver);
% formulation2 = 'K35';
% solver = 'LDL';
% classname2 = build_variant(pdcoo_home, formulation2, solver);
% formulation3 = 'K2';
% solver = 'LDL';
% classname3 = build_variant(pdcoo_home, formulation3, solver);

options_pdco.d1 = 1.0e-2;
options_pdco.d2 = 1.0e-2;
options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

fprintf(options_pdco.file_id, ...
    '\n    Name    Objectif   Presid   Dresid   Cresid   PDitns   Inner     Time      D2 * r\n\n');
%% Check eigenvalues and compare method
check_eigenvalue = 1
show_one_graphic = 1; % = 1  need check_eigenvalue = 1
show_all_graphic = 0; % = 1  need check_eigenvalue = 1
check_cond = 0;
compare_formulations = 0;
check_residu = 0;
check_all_residu = 0; % = 1  need check_residu = 1
check_limits = 0;
check_eigenvalueK35 = 0;
check_all_eigenvalueK35 = 0;
check_theorem2 = 0;
check_all_theorem2 = 0;
method_theorem2 = "MaxGap";
check_licq = 0;
check_property = 1;
%% Loop
clc

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
options_pdco.check_property = check_property;
options_form = struct();

prob1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
prob1.solve;
% prob2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
% prob2.solve;
% prob3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
% prob3.solve;

fclose('all');
%% Print result
% clc
% print_result(result, list_problem)
t = prob1.eigenvalue;
tmp = t;
tmp(t<0) = 10^10;
t1 = max(t);
t2 = min(tmp);
tmp = t;
tmp(t>0) = -10^10;
t3 = min(t);
t4 = max(tmp);

eigen = [t1;t2;t3;t4];

show_eigenvalue(eigen, prob1.limit);
limit = prob1.features_property(1:4,:);
show_eigenvalue(eigen, limit);
    
% if check_eigenvalue
%     if check_limits
%         show_eigenvalue(prob1.eigenvalue, prob1.limit, options_pdco.d1, options_pdco.d2, prob1.features_limits)
%     else
%         show_eigenvalue(prob1.eigenvalue, prob1.limit);
%     end
% end
% if check_residu
%     show_residu(residu,evolution_mu);
% end
% if compare_formulations
%     print_comparison(prob1, prob2, prob3);
% end
% 
% if check_theorem2
%     show_eigenvalue_theorem2(prob1.eigenvalue, prob1.features_theorem2);
% end
% 
% if check_eigenvalueK35
%     show_eigenvalueK35(prob2.eigenvalue, options_pdco.d1, options_pdco.d2)
% end
% 
% if check_licq
%    check_LICQ(prob1.A, prob1.x, options_pdco.method)
% end
% 
% if check_property
%     limit = prob1.features_property(1:4,:);
%     show_eigenvalue(prob1.eigenvalue, limit);
% end