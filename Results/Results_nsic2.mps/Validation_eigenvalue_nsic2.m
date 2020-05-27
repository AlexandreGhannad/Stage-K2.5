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

mps_name = 'nsic2.mps';
mps_name = pwd + "\Problems\lp_prob\" + mps_name;

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
check_cond = 1;
compare_formulations = 0;
check_residu = 1;
check_all_residu = 0; % = 1  need check_residu = 1
check_limits = 1;
check_eigenvalueK35 = 1;
check_all_eigenvalueK35 = 1;
check_theorem2 = 1;
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

o = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
o.solve;
prob2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
prob2.solve;
% prob3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
% prob3.solve;

fclose('all');
%% Print result
% clc
% print_result(result, list_problem)
% t = o.eigenvalue;
% tmp = t;
% tmp(t<0) = 10^10;
% t1 = max(t);
% t2 = min(tmp);
% tmp = t;
% tmp(t>0) = -10^10;
% t3 = min(t);
% t4 = max(tmp);
% 
% eigen = [t1;t2;t3;t4];
d1 = options_pdco.d1;
d2 = options_pdco.d2;
fig1 = show_eigenvalue(o.eigenvalue, o.limit, d1, d2);
fig2 = show_eigenvalue_theorem2(o.eigenvalue, o.features_theorem2, d1, d2, 0);
fig3 = show_eigenvalueK35(prob2.eigenvalue, d1, d2);
fig4 = show_cond(o.cond, o.limit, d1, d2, prob2.cond, "K3.5");
fig5 = show_residu(o.opt_residu,o.evolution_mu);

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
%% Save graphics
orient(fig1, "landscape")
orient(fig2, "landscape")
orient(fig3, "landscape")
orient(fig4, "landscape")
orient(fig5, "landscape")


set(fig1,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\figure1.pdf';
print(fig1, filename,'-dpdf', "-r1200")

set(fig2,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\figure2.pdf';
print(fig2, filename,'-dpdf', "-r1200")

set(fig3,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\figure3.pdf';
print(fig3, filename,'-dpdf', "-r1200")

set(fig4,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\figure4.pdf';
print(fig4, filename,'-dpdf', "-r1200")

set(fig5,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\figure5.pdf';
print(fig5, filename,'-dpdf', "-r1200")

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
% d1 = 10^-4;
d1 = 10^-2;
% d2 = [0 1];
d2 = [10^-8 10^-6 10^-4 10^-2 1];
% d2 = 0;
% d2 = 10^-8
options_pdco.d1 = d1;
for j = 1:length(d2)
    options_pdco.d2 = d2(j);
    
    mps_name = 'nsic2.mps';
    mps_name = pwd + "\Problems\lp_prob\" + mps_name;

    
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

    
end

fclose('all');
%% Save graphics
orient(fig1, "landscape")
orient(fig2, "landscape")
orient(fig3, "landscape")
orient(fig4, "landscape")
orient(fig5, "landscape")


set(fig1,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\variation_d2_figure1.pdf';
print(fig1, filename,'-dpdf', "-r1200")

set(fig2,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\variation_d2_figure2.pdf';
print(fig2, filename,'-dpdf', "-r1200")

set(fig3,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\variation_d2_figure3.pdf';
print(fig3, filename,'-dpdf', "-r1200")

set(fig4,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\variation_d2_figure4.pdf';
print(fig4, filename,'-dpdf', "-r1200")

set(fig5,'PaperSize',[45 25]); %set the paper size to what you want
filename = 'D:\git_repository\Stage-K2.5\Results\Results_nsic2.mps\variation_d2_figure5.pdf';
print(fig5, filename,'-dpdf', "-r1200")