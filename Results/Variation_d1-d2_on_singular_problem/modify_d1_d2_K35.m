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

% formulation2 = 'K35';
% solver = 'LDL';
% classname2 = build_variant(pdcoo_home, formulation2, solver);

% formulation3 = 'K2';
% solver = 'LDL';
% classname3 = build_variant(pdcoo_home, formulation3, solver);


n_problem = 1;

options_pdco.d1 = 1.0e-2;
options_pdco.d2 = 1.0e-2;
options_pdco.OptTol = 1.0e-16;
options_solv.atol1 = 1.0e-12;
options_solv.atol2 = 1.0e-12;
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
check_cond = 0;
compare_formulations = 0;
check_residu = 0;
check_all_residu = 0; % = 1  need check_residu = 1
check_limits = 0;
check_eigenvalueK35 = 0;
check_theorem2 = 0;
check_all_theorem2 = 0;
method_theorem2 = "MaxGap";
check_property = 0;
% digit_number = 64;

options_pdco.d1 = 0;
options_pdco.d2 = 0;
%% Loop
clc
list_problem ={pwd + "/Problems/qp_prob/"+'qbrandy.qps'};
% d1 = 10^-4;
% d1 = 10^-2;
% d2 = [0 1];
d1 = 10^-2;
d2 = [10^-8 10^-6 10^-4 10^-2 10^0];
% d2 = 0;
% d2 = 10^-8

for j = 1:length(d2)
    options_pdco.d1 = d1;
    options_pdco.d2 = d2(j);
    
    mps_name = list_problem{1};
    
    % Read .mps file
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
    %     options_pdco.Maxiter = min(max(30, slack.n), 100);
    options_pdco.Maxiter = 108;
    options_pdco.check_eigenvalue = check_eigenvalue;
    options_pdco.check_residu = check_residu;
    options_pdco.check_cond = check_cond;
    options_pdco.check_limits = check_limits;
    options_pdco.check_theorem2 = check_theorem2;
    options_pdco.check_eigenvalueK35 = check_eigenvalueK35;
    options_pdco.method = method_theorem2;
    options_pdco.check_property = check_property;
    %     options_pdco.digit_number = digit_number;
    options_form = struct();
    
    Problem1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
    Problem1.solve;
    
    show_eigenvalue(Problem1.eigenvalue, Problem1.limit, d1, d2(j))
    %     limits = Problem1.features_property(1:4,:);
    %     show_eigenvalue_property(Problem1.eigenvalue, limits, d1, d2(j), Problem1.features_property(5:end,:))
    %     show_eigenvalueK35(Problem2.eigenvalue, d1, d2(j))
    %     show_eigenvalue_theorem2(Problem1.eigenvalue, Problem1.features_theorem2, d1, d2(j))
    %     show_cond(Problem1.cond, Problem1.limit, d1, d2(j), Problem2.cond, "K3.5" )
    
end

fclose('all');
%% Save graphics
fig1 = figure(1);
fig2 = figure(2);
fig3 = figure(3);
fig4 = figure(4);
fig5 = figure(5);
% fig6 = figure(6);

path = 'D:\git_repository\Stage-K2.5\Results\Variation_d1-d2_on_singular_problem\';
name1 = "figure1 qbrandy variation d1 d2";
name2 = "figure2 qbrandy variation d1 d2";
name3 = "figure3 qbrandy variation d1 d2";
name4 = "figure4 qbrandy variation d1 d2";
name5 = "figure5 qbrandy variation d1 d2";
name6 = "figure6 qbrandy variation d1 d2";

filename1 = path+name1;
filename2 = path+name2;
filename3 = path+name3;
filename4 = path+name4;
filename5 = path+name5;
% filename6 = path+name6;

save_figure(fig1, filename1)
save_figure(fig2, filename2)
save_figure(fig3, filename3)
save_figure(fig4, filename4)
save_figure(fig5, filename5)
% save_figure(fig6, filename6)