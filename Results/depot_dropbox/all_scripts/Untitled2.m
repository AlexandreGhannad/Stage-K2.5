%% qbrandy regulation
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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
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
%% Setup 2
import model.lpmodel;
import model.slackmodel;
fontsize = 35;
options_pdco.file_id = 1;

formulation1 = 'K25';
solver = 'LDL';
classname1 = build_variant(pdcoo_home, formulation1, solver);

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'qbrandy.qps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

d1 = 10^-2;
% d2 = 10^-2;
d2 = [10^-8 10^-6 10^-4 10^-2 10^-0];
% d2 = [10^-6];

% d1 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8 10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 0;
check_theorem2 = 0;
method_theorem2 = "MaxGap";
check_property = 0;

check_cond = 0;
check_residu = 0;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème singulier - variation de la régularisation\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème singulier - variation de la régularisation\";
%% Loop
clc
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            qp = qpstoqp(mps_stru);
            slack = slackmodel(qp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 77);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
%             o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
%             o2.solve;
%             o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
%             o3.solve;
%             o4 = eval([classname4, '(slack, options_pdco,options_form,options_solv)']);
%             o4.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue(o1, name_problem, d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                
                mtf(fig1)
                
                if d2(k) == 10^-8
                    ax = fig1.CurrentAxes;
                    lbl = ax.YTickLabel;
                    y = lbl;
                    t = [1:4:19 21 22 25:4:41];
                    y(:) = {''}
                    y(t) = lbl(t);
                    ax.YTickLabel = y;
                end
                if save_all_graphics
                    save_figure(fig1, path_to_save+"eps\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k)))
                    save_figure_pdf(fig1, path_to_save+"pdf\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k))+".pdf")
                end
            end
        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end
%% Save figure eigenvalue double precision
load('Problem1.mat')
Problem1.eigenvalue = double(Problem1.eigenvalue);
fig10 = show_eigenvalue(Problem1, name_problem, 10^-2, 10^-8);
ax = fig10.CurrentAxes;
set(ax,'FontSize',fontsize-10)

d1 = 10^-2;
d2 = 10^-8;
j=1; k=1;

ax = fig10.CurrentAxes;
lbl = ax.YTickLabel;
y = lbl;
t1 = 1:2:13;
t2 = 17:2:29;
y(t1) = {''};
y(t2) = {''};
ax.YTickLabel = y;

pause(2)
ax = fig10.CurrentAxes;

outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

save_figure(fig10, path_to_save+"eps\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k))+"_avec_precision")
save_figure_pdf(fig10, path_to_save+"pdf\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k))+"_avec_precision.pdf")

%% qbrandy standard
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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;
%% Setup 2
import model.lpmodel;
import model.slackmodel;
fontsize = 35;
position= [0.2470    0.0607    0.7530    0.8079];
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

formulation4 = 'K3';
solver = 'LU';
classname4 = build_variant(pdcoo_home, formulation4, solver);

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'qbrandy.qps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

d1 = 10^-2;
d2 = 10^-2;
% d1 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8 10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 1;
check_theorem2 = 0;
method_theorem2 = "all";
check_property = 1;

check_cond = 1;
check_residu = 1;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème singulier -  autre graphique\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème singulier -  autre graphique\";
%% Loop
clc
results = zeros(n_problem, length(d1), length(d2), 4, 23);
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            qp = qpstoqp(mps_stru);
            slack = slackmodel(qp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 95);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
            o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
            o2.solve;
            o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
            o3.solve;
            o4 = eval([classname4, '(slack, options_pdco,options_form,options_solv)']);
            o4.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue(o1, name_problem, d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                
                mtf(fig1)
                
                if save_all_graphics
                    save_figure(fig1, path_to_save+"eps\Eigenvalues d1=1e-2, d2=1e-2")
                    save_figure_pdf(fig1, path_to_save+"pdf\Eigenvalues d1=1e-2, d2=1e-2")
                end
            end
            
            if check_eigenvalue_other_formulation
                fig21 = show_eigenvalue_other_formulation(o2.eigenvalue, name_problem, "K3.5", d1(j), d2(k));
                ax = fig21.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig21)
                
                fig22 = show_eigenvalue_other_formulation(o3.eigenvalue, name_problem, "K2", d1(j), d2(k));
                ax = fig22.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig22)
                
                fig23 = show_eigenvalue_other_formulation(real(o4.eigenvalue), name_problem, "K3", d1(j), d2(k));
                ax = fig23.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig23)
                
                if save_all_graphics
                    save_figure(fig21, path_to_save+"eps\Eigenvalues K3.5 d1=1e-2, d2=1e-2")
                    save_figure(fig22, path_to_save+"eps\Eigenvalues K2 d1=1e-2, d2=1e-2")
                    save_figure(fig23, path_to_save+"eps\Eigenvalues K3 d1=1e-2, d2=1e-2")
                    save_figure_pdf(fig21, path_to_save+"pdf\Eigenvalues K3.5 d1=1e-2, d2=1e-2.pdf")
                    save_figure_pdf(fig22, path_to_save+"pdf\Eigenvalues K2 d1=1e-2, d2=1e-2.pdf")
                    save_figure_pdf(fig23, path_to_save+"pdf\Eigenvalues K3 d1=1e-2, d2=1e-2.pdf")
                end
            end
            
            if check_property
                fig3 = show_eigenvalue_property(o1, name_problem, d1(j), d2(k));
                ax = fig3.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig3)
                if save_all_graphics
                    save_figure(fig3, path_to_save+"eps\Property 1")
                    save_figure_pdf(fig3, path_to_save+"pdf\Property 1.pdf")
                end
            end
            
            if check_theorem2
                if method_theorem2 == "all"
                    fig4 = compare_method_theorem_2(o1, name_problem);
                else
                    fig4 = show_eigenvalue_theorem2(o1, name_problem, d1(j), d2(k));
                end
                if save_all_graphics
                    save_figure(fig4, path_to_save+"eps\Theorem 2")
                    save_figure_pdf(fig4, path_to_save+"pdf\Theorem 2.pdf")
                end
            end
            
            if check_cond
                fig5 = figure();
                set(fig5, "WindowState", "maximized")
                lim = o1.limit;
                lim = max(abs(lim))./min(abs(lim));
                semilogy(o1.cond, ".", "MarkerSize", 10, "LineWidth", 1, "Color", [0 0.4470 0.7410]);
                hold on
                semilogy(o2.cond, "+", "MarkerSize", 7, "LineWidth", 1, "Color", [0.8500 0.3250 0.0980]);
                semilogy(o3.cond, "*", "MarkerSize", 7, "LineWidth", 1, "Color", [0.4660 0.6740 0.1880]);
                semilogy(o4.cond, "s", "MarkerSize", 7, "LineWidth", 1, "Color", [0.4940 0.1840 0.5560]);
                semilogy(lim, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
                legend("K2.5", "K3.5", "K2", "K3", "Bound on K2.5", "location", "best", "FontSize", fontsize-10)
                title("Evolution of the conditioning", "FontSize", fontsize)
                ax = fig5.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                
                mtf(fig5)
                
                if save_all_graphics
                    save_figure(fig5, path_to_save+"eps\Conditioning")
                    save_figure_pdf(fig5, path_to_save+"pdf\Conditioning.pdf")
                end
            end
            
            if check_residu
                fig6 = show_residu(o1.opt_residu, o1.evolution_mu, d1(j), d2(k));
                ax = fig6.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig6)
                if save_all_graphics
                    save_figure(fig6, path_to_save+"eps\residu")
                    save_figure_pdf(fig6, path_to_save+"pdf\residu.pdf")
                end
            end
            
            if check_results
                res = squeeze(results(i,j,k,:,:));
                results(i,j,k,:,:) = save_features(res, o1,o2,o3,o4);
            end
        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end

%% nsic2 regulation
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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;
%% Setup 2
import model.lpmodel;
import model.slackmodel;

fontsize = 35;
position= [0.0538    0.03    0.9462    0.91];

options_pdco.file_id = 1;

formulation1 = 'K25';
solver = 'LDL';
classname1 = build_variant(pdcoo_home, formulation1, solver);

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'nsic2.mps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

% d1 = 10^-2;
% d2 = 10^-2;
d1 = [10^-4 10^-2 10^-0];
d2 = [10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 0;
check_theorem2 = 0;
method_theorem2 = "MaxGap";
check_property = 0;

check_cond = 0;
check_residu = 0;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème standard - variation de la régularisation\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème standard - variation de la régularisation\";
%% Loop
clc
results = zeros(n_problem, length(d1), length(d2), 4, 23);
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            lp = mpstolp(mps_stru);
            slack = slackmodel(lp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 95);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
%             o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
%             o2.solve;
%             o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
%             o3.solve;
%             o4 = eval([classname4, '(slack, options_pdco,options_form,options_solv)']);
%             o4.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue(o1, name_problem, d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig1)
                if save_all_graphics
                    save_figure(fig1, path_to_save+"eps\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k)))
                    save_figure_pdf(fig1, path_to_save+"pdf\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k))+".pdf")
                end
            end
            
%             if check_eigenvalue_other_formulation
%                 fig21 = show_eigenvalue_other_formulation(o2.eigenvalue, name_problem, "K3.5", d1(j), d2(k));
%                 fig22 = show_eigenvalue_other_formulation(o3.eigenvalue, name_problem, "K2", d1(j), d2(k));
%                 fig23 = show_eigenvalue_other_formulation(o4.eigenvalue, name_problem, "K3", d1(j), d2(k));
%                 if save_all_graphics
%                     save_figure(fig21, path_to_save+"fig21"+num2str(i))
%                     save_figure(fig22, path_to_save+"fig22"+num2str(i))
%                     save_figure(fig23, path_to_save+"fig23"+num2str(i))
%                 end
%             end
%             
%             if check_property
%                 fig3 = show_eigenvalue_property(o1, name_problem, d1(j), d2(k));
%                 if save_all_graphics
%                     save_figure(fig3, path_to_save+"fig3"+num2str(i))
%                 end
%             end
%             
%             if check_theorem2
%                 fig4 = show_eigenvalue_theorem2(o1, name_problem, d1(j), d2(k));
%                 if save_all_graphics
%                     save_figure(fig4, path_to_save+"fig4"+num2str(i))
%                 end
%             end
%             
%             if check_cond
%                 fig51 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o2.cond, "K3.5");
%                 fig52 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o3.cond, "K2");
%                 fig53 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o4.cond, "K3");
%                 if save_all_graphics
%                     save_figure(fig51, path_to_save+"fig51"+num2str(i))
%                     save_figure(fig52, path_to_save+"fig52"+num2str(i))
%                     save_figure(fig53, path_to_save+"fig53"+num2str(i))
%                 end
%             end
%             
%             if check_residu
%                 fig6 = show_residu(o1.opt_residu, o1.evolution_mu, d1(j), d2(k));
%                 if save_all_graphics
%                     save_figure(fig6, path_to_save+"fig6"+num2str(i))
%                 end
%             end
%             
%             if check_results
%                 res = squeeze(results(i,j,k,:,:));
%                 results(i,j,k,:,:) = save_features(res, o1,o2,o3,o4);
%             end
            close all
        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end

%% nsic2 standard
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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;
%% Setup 2
import model.lpmodel;
import model.slackmodel;
fontsize = 35;
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

formulation4 = 'K3';
solver = 'LU';
classname4 = build_variant(pdcoo_home, formulation4, solver);

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'nsic2.mps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

d1 = 10^-2;
d2 = 10^-2;
% d1 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8 10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 1;
check_theorem2 = 0;
method_theorem2 = "all";
check_property = 1;

check_cond = 1;
check_residu = 1;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème standard - autre graphique\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème standard - autre graphique\";
%% Loop
clc
results = zeros(n_problem, length(d1), length(d2), 4, 23);
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            lp = mpstolp(mps_stru);
            slack = slackmodel(lp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 95);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
            o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
            o2.solve;
            o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
            o3.solve;
            o4 = eval([classname4, '(slack, options_pdco,options_form,options_solv)']);
            o4.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue(o1, name_problem, d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig1)
                
                if save_all_graphics
                    save_figure(fig1, path_to_save+"eps\Eigenvalues d1=1e-2, d2=1e-2")
                    save_figure_pdf(fig1, path_to_save+"pdf\Eigenvalues d1=1e-2, d2=1e-2")
                end
            end
            
            if check_eigenvalue_other_formulation
                fig21 = show_eigenvalue_other_formulation(o2.eigenvalue, name_problem, "K3.5", d1(j), d2(k));
                ax = fig21.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig21)
                
                fig22 = show_eigenvalue_other_formulation(o3.eigenvalue, name_problem, "K2", d1(j), d2(k));
                ax = fig22.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig22)
                
                fig23 = show_eigenvalue_other_formulation(real(o4.eigenvalue), name_problem, "K3", d1(j), d2(k));
                ax = fig23.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig23)
                
                if save_all_graphics
                    save_figure(fig21, path_to_save+"eps\Eigenvalues K3.5 d1=1e-2, d2=1e-2")
                    save_figure(fig22, path_to_save+"eps\Eigenvalues K2 d1=1e-2, d2=1e-2")
                    save_figure(fig23, path_to_save+"eps\Eigenvalues K3 d1=1e-2, d2=1e-2")
                    save_figure_pdf(fig21, path_to_save+"pdf\Eigenvalues K3.5 d1=1e-2, d2=1e-2.pdf")
                    save_figure_pdf(fig22, path_to_save+"pdf\Eigenvalues K2 d1=1e-2, d2=1e-2.pdf")
                    save_figure_pdf(fig23, path_to_save+"pdf\Eigenvalues K3 d1=1e-2, d2=1e-2.pdf")
                end
            end
            
            if check_property
                fig3 = show_eigenvalue_property(o1, name_problem, d1(j), d2(k));
                ax = fig3.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig3)
                if save_all_graphics
                    save_figure(fig3, path_to_save+"eps\Property 1")
                    save_figure_pdf(fig3, path_to_save+"pdf\Property 1.pdf")
                end
            end
            
            if check_theorem2
                if method_theorem2 == "all"
                    fig4 = compare_method_theorem_2(o1, name_problem);
                else
                    fig4 = show_eigenvalue_theorem2(o1, name_problem, d1(j), d2(k));
                end
                if save_all_graphics
                    save_figure(fig4, path_to_save+"eps\Theorem 2")
                    save_figure_pdf(fig4, path_to_save+"pdf\Theorem 2.pdf")
                end
            end
            
            if check_cond
                fig5 = figure();
                set(fig5, "WindowState", "maximized")
                lim = o1.limit;
                lim = max(abs(lim))./min(abs(lim));
                semilogy(o1.cond, ".", "MarkerSize", 10, "LineWidth", 1, "Color", [0 0.4470 0.7410]);
                hold on
                semilogy(o2.cond, "+", "MarkerSize", 7, "LineWidth", 1, "Color", [0.8500 0.3250 0.0980]);
                semilogy(o3.cond, "*", "MarkerSize", 7, "LineWidth", 1, "Color", [0.4660 0.6740 0.1880]);
                semilogy(o4.cond, "s", "MarkerSize", 7, "LineWidth", 1, "Color", [0.4940 0.1840 0.5560]);
                semilogy(lim, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
                legend("K2.5", "K3.5", "K2", "K3", "Bound on K2.5", "location", "best")
                title("Evolution of the conditioning")
                ax = fig5.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig5)
                if save_all_graphics
                    save_figure(fig5, path_to_save+"eps\Conditioning")
                    save_figure_pdf(fig5, path_to_save+"pdf\Conditioning.pdf")
                end
            end
            
            if check_residu
                fig6 = show_residu(o1.opt_residu, o1.evolution_mu, d1(j), d2(k));
                ax = fig6.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig6)
                if save_all_graphics
                    save_figure(fig6, path_to_save+"eps\residu")
                    save_figure_pdf(fig6, path_to_save+"pdf\residu.pdf")
                end
            end
            
            if check_results
                res = squeeze(results(i,j,k,:,:));
                results(i,j,k,:,:) = save_features(res, o1,o2,o3,o4);
            end
        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end

%% nsic2 d1=1e-4, d2=0
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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;
%% Setup 2
import model.lpmodel;
import model.slackmodel;
fontsize = 35;
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

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'nsic2.mps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

d1 = 10^-4;
d2 = 0;
% d1 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8 10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 1;
check_theorem2 = 0;
method_theorem2 = "all";
check_property = 0;

check_cond = 0;
check_residu = 0;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\K2 d1=1e-4, d2=0\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\K2 d1=1e-4, d2=0\";
%% Loop
clc
results = zeros(n_problem, length(d1), length(d2), 4, 23);
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            lp = mpstolp(mps_stru);
            slack = slackmodel(lp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 95);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
            o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
            o2.solve;
            o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
            o3.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue_other_formulation(o1.eigenvalue, name_problem, "K2.5", d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                lbl = ax.YTickLabel;
                y = lbl;
                t = [1:3:25 28 31:3:55];
                y(:) = {''};
                y(t) = lbl(t);
                ax.YTickLabel = y;
                
                mtf(fig1)
                
                if save_all_graphics
                    save_figure(fig1, path_to_save+"K2.5 d1=1e-4, d2=0")
                    save_figure_pdf(fig1, path_to_save+"K2.5 d1=1e-4, d2=0")
                end
            end
            
            if check_eigenvalue_other_formulation
                fig21 = show_eigenvalue_other_formulation(o2.eigenvalue, name_problem, "K3.5", d1(j), d2(k));
                ax = fig21.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                lbl = ax.YTickLabel;
                y = lbl;
                t = [1:2:16 17 19:2:33];
                y(:) = {''};
                y(t) = lbl(t);
                ax.YTickLabel = y;
                
                mtf(fig21)
                
                fig22 = show_eigenvalue_other_formulation(o3.eigenvalue, name_problem, "K2", d1(j), d2(k));
                ax = fig22.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                lbl = ax.YTickLabel;
                y = lbl;
                t = [1:5:48 53 60:5:105];
                y(:) = {''};
                y(t) = lbl(t);
                ax.YTickLabel = y;
                
                mtf(fig22)
                
                
                if save_all_graphics
                    save_figure(fig21, path_to_save+"Eigenvalues K3.5 d1=1e-4, d2=0")
                    save_figure(fig22, path_to_save+"Eigenvalues K2 d1=1e-4, d2=0")
                    save_figure_pdf(fig21, path_to_save+"Eigenvalues K3.5 d1=1e-4, d2=0.pdf")
                    save_figure_pdf(fig22, path_to_save+"Eigenvalues K2 d1=1e-4, d2=0.pdf")
                end
            end

        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end

%% small009 regulation
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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;
%% Setup 2
import model.lpmodel;
import model.slackmodel;

fontsize = 35;
position= [0.0538    0.03    0.9462    0.91];

options_pdco.file_id = 1;

formulation1 = 'K25';
solver = 'LDL';
classname1 = build_variant(pdcoo_home, formulation1, solver);

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'small009.mps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

% d1 = 10^-2;
% d2 = 10^-2;
d1 = [10^-4 10^-2 10^-0];
d2 = [10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 0;
check_theorem2 = 0;
method_theorem2 = "MaxGap";
check_property = 0;

check_cond = 0;
check_residu = 0;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\small009\Problème standard - variation de la régularisation\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\small009\Problème standard - variation de la régularisation\";
%% Loop
clc
results = zeros(n_problem, length(d1), length(d2), 4, 23);
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            lp = mpstolp(mps_stru);
            slack = slackmodel(lp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 95);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
%             o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
%             o2.solve;
%             o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
%             o3.solve;
%             o4 = eval([classname4, '(slack, options_pdco,options_form,options_solv)']);
%             o4.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue(o1, name_problem, d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig1)
                if save_all_graphics
                    save_figure(fig1, path_to_save+"eps\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k)))
                    save_figure_pdf(fig1, path_to_save+"pdf\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k))+".pdf")
                end
            end
            
%             if check_eigenvalue_other_formulation
%                 fig21 = show_eigenvalue_other_formulation(o2.eigenvalue, name_problem, "K3.5", d1(j), d2(k));
%                 fig22 = show_eigenvalue_other_formulation(o3.eigenvalue, name_problem, "K2", d1(j), d2(k));
%                 fig23 = show_eigenvalue_other_formulation(o4.eigenvalue, name_problem, "K3", d1(j), d2(k));
%                 if save_all_graphics
%                     save_figure(fig21, path_to_save+"fig21"+num2str(i))
%                     save_figure(fig22, path_to_save+"fig22"+num2str(i))
%                     save_figure(fig23, path_to_save+"fig23"+num2str(i))
%                 end
%             end
%             
%             if check_property
%                 fig3 = show_eigenvalue_property(o1, name_problem, d1(j), d2(k));
%                 if save_all_graphics
%                     save_figure(fig3, path_to_save+"fig3"+num2str(i))
%                 end
%             end
%             
%             if check_theorem2
%                 fig4 = show_eigenvalue_theorem2(o1, name_problem, d1(j), d2(k));
%                 if save_all_graphics
%                     save_figure(fig4, path_to_save+"fig4"+num2str(i))
%                 end
%             end
%             
%             if check_cond
%                 fig51 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o2.cond, "K3.5");
%                 fig52 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o3.cond, "K2");
%                 fig53 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o4.cond, "K3");
%                 if save_all_graphics
%                     save_figure(fig51, path_to_save+"fig51"+num2str(i))
%                     save_figure(fig52, path_to_save+"fig52"+num2str(i))
%                     save_figure(fig53, path_to_save+"fig53"+num2str(i))
%                 end
%             end
%             
%             if check_residu
%                 fig6 = show_residu(o1.opt_residu, o1.evolution_mu, d1(j), d2(k));
%                 if save_all_graphics
%                     save_figure(fig6, path_to_save+"fig6"+num2str(i))
%                 end
%             end
%             
%             if check_results
%                 res = squeeze(results(i,j,k,:,:));
%                 results(i,j,k,:,:) = save_features(res, o1,o2,o3,o4);
%             end
            close all
        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end

%% small009 standard
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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;
%% Setup 2
import model.lpmodel;
import model.slackmodel;
fontsize = 35;
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

formulation4 = 'K3';
solver = 'LU';
classname4 = build_variant(pdcoo_home, formulation4, solver);

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'small009.mps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

d1 = 10^-2;
d2 = 10^-2;
% d1 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8 10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 1;
check_theorem2 = 0;
method_theorem2 = "all";
check_property = 1;

check_cond = 1;
check_residu = 1;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\small009\Problème standard - autre graphique\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\small009\Problème standard - autre graphique\";
%% Loop
clc
results = zeros(n_problem, length(d1), length(d2), 4, 23);
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            lp = mpstolp(mps_stru);
            slack = slackmodel(lp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 95);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
            o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
            o2.solve;
            o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
            o3.solve;
            o4 = eval([classname4, '(slack, options_pdco,options_form,options_solv)']);
            o4.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue(o1, name_problem, d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig1)
                
                if save_all_graphics
                    save_figure(fig1, path_to_save+"eps\Eigenvalues d1=1e-2, d2=1e-2")
                    save_figure_pdf(fig1, path_to_save+"pdf\Eigenvalues d1=1e-2, d2=1e-2")
                end
            end
            
            if check_eigenvalue_other_formulation
                fig21 = show_eigenvalue_other_formulation(o2.eigenvalue, name_problem, "K3.5", d1(j), d2(k));
                ax = fig21.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig21)
                
                fig22 = show_eigenvalue_other_formulation(o3.eigenvalue, name_problem, "K2", d1(j), d2(k));
                ax = fig22.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig22)
                
                fig23 = show_eigenvalue_other_formulation(real(o4.eigenvalue), name_problem, "K3", d1(j), d2(k));
                ax = fig23.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig23)
                
                if save_all_graphics
                    save_figure(fig21, path_to_save+"eps\Eigenvalues K3.5 d1=1e-2, d2=1e-2")
                    save_figure(fig22, path_to_save+"eps\Eigenvalues K2 d1=1e-2, d2=1e-2")
                    save_figure(fig23, path_to_save+"eps\Eigenvalues K3 d1=1e-2, d2=1e-2")
                    save_figure_pdf(fig21, path_to_save+"pdf\Eigenvalues K3.5 d1=1e-2, d2=1e-2.pdf")
                    save_figure_pdf(fig22, path_to_save+"pdf\Eigenvalues K2 d1=1e-2, d2=1e-2.pdf")
                    save_figure_pdf(fig23, path_to_save+"pdf\Eigenvalues K3 d1=1e-2, d2=1e-2.pdf")
                end
            end
            
            if check_property
                fig3 = show_eigenvalue_property(o1, name_problem, d1(j), d2(k));
                ax = fig3.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig3)
                if save_all_graphics
                    save_figure(fig3, path_to_save+"eps\Property 1")
                    save_figure_pdf(fig3, path_to_save+"pdf\Property 1.pdf")
                end
            end
            
            if check_theorem2
                if method_theorem2 == "all"
                    fig4 = compare_method_theorem_2(o1, name_problem);
                else
                    fig4 = show_eigenvalue_theorem2(o1, name_problem, d1(j), d2(k));
                end
                if save_all_graphics
                    save_figure(fig4, path_to_save+"eps\Theorem 2")
                    save_figure_pdf(fig4, path_to_save+"pdf\Theorem 2.pdf")
                end
            end
            
            if check_cond
                fig5 = figure();
                set(fig5, "WindowState", "maximized")
                lim = o1.limit;
                lim = max(abs(lim))./min(abs(lim));
                semilogy(o1.cond, ".", "MarkerSize", 10, "LineWidth", 1, "Color", [0 0.4470 0.7410]);
                hold on
                semilogy(o2.cond, "+", "MarkerSize", 7, "LineWidth", 1, "Color", [0.8500 0.3250 0.0980]);
                semilogy(o3.cond, "*", "MarkerSize", 7, "LineWidth", 1, "Color", [0.4660 0.6740 0.1880]);
                semilogy(o4.cond, "s", "MarkerSize", 7, "LineWidth", 1, "Color", [0.4940 0.1840 0.5560]);
                semilogy(lim, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
                legend("K2.5", "K3.5", "K2", "K3", "Bound on K2.5", "location", "best")
                title("Evolution of the conditioning")
                ax = fig5.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig5)
                if save_all_graphics
                    save_figure(fig5, path_to_save+"eps\Conditioning")
                    save_figure_pdf(fig5, path_to_save+"pdf\Conditioning.pdf")
                end
            end
            
            if check_residu
                fig6 = show_residu(o1.opt_residu, o1.evolution_mu, d1(j), d2(k));
                ax = fig6.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                mtf(fig6)
                if save_all_graphics
                    save_figure(fig6, path_to_save+"eps\residu")
                    save_figure_pdf(fig6, path_to_save+"pdf\residu.pdf")
                end
            end
            
            if check_results
                res = squeeze(results(i,j,k,:,:));
                results(i,j,k,:,:) = save_features(res, o1,o2,o3,o4);
            end
        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end

%% small009 d1=1e-4, d2=0
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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;
%% Setup 2
import model.lpmodel;
import model.slackmodel;
fontsize = 35;
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

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'small009.mps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

d1 = 10^-4;
d2 = 0;
% d1 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8 10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 1;
check_theorem2 = 0;
method_theorem2 = "all";
check_property = 0;

check_cond = 0;
check_residu = 0;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\small009\K2 d1=1e-4, d2=0\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\small009\K2 d1=1e-4, d2=0\";
%% Loop
clc
results = zeros(n_problem, length(d1), length(d2), 4, 23);
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            lp = mpstolp(mps_stru);
            slack = slackmodel(lp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 95);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
            o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
            o2.solve;
            o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
            o3.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue(o1, name_problem, d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                lbl = ax.YTickLabel;
                y = lbl;
                t = [1:2:12 14 16:2:27];
                y(:) = {''};
                y(t) = lbl(t);
                ax.YTickLabel = y;
                
                mtf(fig1)
                
                if save_all_graphics
                    save_figure(fig1, path_to_save+"K2.5 d1=1e-4, d2=0")
                    save_figure_pdf(fig1, path_to_save+"K2.5 d1=1e-4, d2=0.pdf")
                end
            end
            
            if check_eigenvalue_other_formulation
                fig21 = show_eigenvalue_other_formulation(o2.eigenvalue, name_problem, "K3.5", d1(j), d2(k));
                ax = fig21.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
%                 lbl = ax.YTickLabel;
%                 y = lbl;
%                 t = [1:2:16 17 19:2:33];
%                 y(:) = {''};
%                 y(t) = lbl(t);
%                 ax.YTickLabel = y;
                
                mtf(fig21)
                
                fig22 = show_eigenvalue_other_formulation(o3.eigenvalue, name_problem, "K2", d1(j), d2(k));
                ax = fig22.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                lbl = ax.YTickLabel;
                y = lbl;
                t = [1:2:14 15 17:2:29];
                y(:) = {''};
                y(t) = lbl(t);
                ax.YTickLabel = y;
                
                mtf(fig22)
                
                if save_all_graphics
                    save_figure(fig21, path_to_save+"Eigenvalues K3.5 d1=1e-4, d2=0")
                    save_figure(fig22, path_to_save+"Eigenvalues K2 d1=1e-4, d2=0")
                    save_figure_pdf(fig21, path_to_save+"Eigenvalues K3.5 d1=1e-4, d2=0.pdf")
                    save_figure_pdf(fig22, path_to_save+"Eigenvalues K2 d1=1e-4, d2=0.pdf")
                end
            end

        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end

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
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
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
%% Setup 2
import model.lpmodel;
import model.slackmodel;
fontsize = 35;
options_pdco.file_id = 1;

formulation1 = 'K25';
solver = 'LDL';
classname1 = build_variant(pdcoo_home, formulation1, solver);

% formulation2 = 'K35';
% solver = 'LDL';
% classname2 = build_variant(pdcoo_home, formulation2, solver);
% 
% formulation3 = 'K2';
% solver = 'LDL';
% classname3 = build_variant(pdcoo_home, formulation3, solver);
% 
% formulation4 = 'K3';
% solver = 'LU';
% classname4 = build_variant(pdcoo_home, formulation4, solver);

choice_list_problem = 5;
if choice_list_problem == 1
    % Only linear afiro
    path_problem = pwd + "/Problems/lp_prob/";
    list_problem ={'afiro.mps'};
elseif choice_list_problem == 2
    % Only quadratic afiro
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'afiro.qps'};
elseif choice_list_problem == 3
    % All the linear problem available
    path_problem = pwd + "/Problems/lp_prob";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 4
    % All the quadratic problems available
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem = dir(path_problem);
    list_problem = {list_problem.name};
    list_problem = list_problem(3:end);
elseif choice_list_problem == 5
    % Personal list to change
    path_problem = pwd + "/Problems/qp_prob/";
    list_problem ={'qbrandy.qps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

d1 = 10^-2;
% d2 = 10^-2;
d2 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8];

% d1 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8 10^-4 10^-2 10^-0];

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 1;
check_limits = 0;
check_eigenvalue_other_formulation = 0;
check_theorem2 = 0;
method_theorem2 = "MaxGap";
check_property = 0;

check_cond = 0;
check_residu = 0;

% digit_number = 64; % Increase precision to calculate eigenvalue, but
% increase highly the execution time

% n_theorem2 % Only helpful with brokenl_lines and power_lines method.
% Moreover, require knowledge on the method and on the problem.

save_all_graphics = 1;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème singulier - variation de la régularisation\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Problème singulier - variation de la régularisation\";
%% Loop
clc
for i = 1:n_problem
    for j = 1 : length(d1)
        for k = 1 : length(d2)
            
            name_problem = list_problem{i};
            fprintf('%s\n', name_problem);
            % Read .mps file
            mps_name = path_problem + name_problem;
            mps_stru = readmps(mps_name);
            qp = qpstoqp(mps_stru);
            slack = slackmodel(qp);
            Anorm = normest(slack.gcon(slack.x0), 1.0e-3);
            
            options_pdco.d1 = d1(j);
            options_pdco.d2 = d2(k);
            options_pdco.x0 = slack.x0;
            options_pdco.x0(slack.jLow) = slack.bL(slack.jLow) + 1;
            options_pdco.x0(slack.jUpp) = slack.bU(slack.jUpp) - 1;
            options_pdco.x0(slack.jTwo) = (slack.bL(slack.jTwo) + slack.bU(slack.jTwo)) / 2;
            options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
            options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
            options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
            options_pdco.y0 = zeros(slack.m, 1);
            options_pdco.mu0 = options_pdco.zsize;
            options_pdco.Maxiter = min(max(30, slack.n), 77);
            
            options_pdco.check_eigenvalue = check_eigenvalue;
            options_pdco.check_limits = check_limits;
            options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
            options_pdco.check_theorem2 = check_theorem2;
            options_pdco.method = method_theorem2;
            options_pdco.check_property = check_property;
            options_pdco.check_cond = check_cond;
            options_pdco.check_residu = check_residu;
            
            %             options_pdco.digit_number = digit_number;
            %             options_pdco.n_theorem2 = n_theorem2;
            
            options_form = struct();
            
            o1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
            o1.solve;
%             o2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
%             o2.solve;
%             o3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
%             o3.solve;
%             o4 = eval([classname4, '(slack, options_pdco,options_form,options_solv)']);
%             o4.solve;
            
            if check_eigenvalue
                fig1 = show_eigenvalue(o1, name_problem, d1(j), d2(k));
                ax = fig1.CurrentAxes;
                set(ax,'FontSize',fontsize-10)
                
                mtf(fig1)
                
                if d2(k) == 10^-8
                    ax = fig1.CurrentAxes;
                    lbl = ax.YTickLabel;
                    y = lbl;
                    t = [1:4:19 21 22 25:4:41];
                    y(:) = {''}
                    y(t) = lbl(t);
                    ax.YTickLabel = y;
                end
                if save_all_graphics
                    save_figure(fig1, path_to_save+"eps\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k)))
                    save_figure_pdf(fig1, path_to_save+"pdf\Eigenvalue_d1="+num2str(d1(j))+"_d2="+num2str(d2(k))+".pdf")
                end
            end
        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end

%% Clean
close all
clear all
clc
%% Load results and agregate them
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
%%
fontsize = 35;
logplot = true;
fig = figure()
r = perf(results, logplot);
set(fig, "WindowState", "maximized")
orient(fig, "landscape")
legend("K2.5", "K3.5", "K2", "K3", "location", "best", 'FontSize', fontsize-10)
title("Execution time profile", 'FontSize', fontsize)
ax = fig.CurrentAxes;
set(ax, "FontSize", fontsize-10)

mtf(fig)

path = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Profil de performance - temps d'exécution\";

save_figure(fig, path+"Profil de performance - temps d'exécution")
save_figure_pdf(fig, path+"Profil de performance - temps d'exécution.pdf")


%% Clean
close all
clear all
clc
%% Load results and agregate them
load('cond_lp.mat')
load('cond_qp.mat')

results =[cond_lp' ;cond_qp'];
%%

fontsize = 35;
logplot = true;
fig = figure()
r = perf(results, logplot);
set(fig, "WindowState", "maximized")
orient(fig, "landscape")
legend("K2.5", "K3.5", "K2", "K3", "location", "best", 'FontSize', fontsize-10)
title("Conditioning profile", 'FontSize', fontsize)
ax = fig.CurrentAxes;
set(ax, "FontSize", fontsize-10)
path = "D:\git_repository\Stage-K2.5\Results\depot_dropbox\Profil de performance - conditionnement\";

mtf(fig)

save_figure(fig, path+"Performance profile - conditionning")
save_figure_pdf(fig, path+"Performance profile - conditionning.pdf")


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
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])
ax = fig1.CurrentAxes;
set(ax, "FontSize", fontsize-10)
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
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])
ax = fig2.CurrentAxes;
set(ax, "FontSize", fontsize-10)
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
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])
ax = fig3.CurrentAxes;
set(ax, "FontSize", fontsize-10)
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
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K2.5 vs K2
subplot(322)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
title("K2.5 vs K2", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K2 (LDL solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K2.5 vs K3
subplot(323)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K2.5 vs K2", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K3.5 vs K2
subplot(324)
[t2, perm] = sort(time2, "ascend");
semilogy(t2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
hold on
semilogy(time3(perm), "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
title("K3.5 vs K2", 'FontSize', fontsize)
legend("K3.5 (LDL solver)", "K2 (LDL solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K3.5 vs K3
subplot(325)
semilogy(t2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
hold on
semilogy(time4(perm), "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K3.5 vs K2", 'FontSize', fontsize)
legend("K3.5 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K2 vs K3
subplot(326)
[t3, perm] = sort(time3, "ascend");
semilogy(t3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
hold on
semilogy(time4(perm), "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K2 vs K3", 'FontSize', fontsize)
legend("K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
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
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])
ax = fig5.CurrentAxes;
set(ax, "FontSize", fontsize-10)
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
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])
ax = fig6.CurrentAxes;
set(ax, "FontSize", fontsize-10)
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
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])
ax = fig7.CurrentAxes;
set(ax, "FontSize", fontsize-10)
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
legend("K2.5 (LDL solver)", "K3.5 (LDL solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K2.5 vs K2
subplot(322)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
title("K2.5 vs K2", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K2 (LDL solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K2.5 vs K3
subplot(323)
semilogy(time1, "x", "MarkerSize", 9, "Color", [0.4660 0.6740 0.1880], 'LineWidth', 1)
hold on
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K2.5 vs K3", 'FontSize', fontsize)
legend("K2.5 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K3.5 vs K2
subplot(324)
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
hold on
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
title("K3.5 vs K2", 'FontSize', fontsize)
legend("K3.5 (LDL solver)", "K2 (LDL solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K3.5 vs K3
subplot(325)
semilogy(time2, "d", "MarkerSize", 6, "Color", [0 0.4470 0.7410], 'LineWidth', 1)
hold on
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K3.5 vs K3", 'FontSize', fontsize)
legend("K3.5 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
xlim([0, 220])

% K2 vs K3
subplot(326)
semilogy(time3, "o", "MarkerSize", 6, "Color", [0.8500 0.3250 0.0980], 'LineWidth', 1)
hold on
semilogy(time4, "+", "MarkerSize", 6, "Color", [0.4940 0.1840 0.5560], 'LineWidth', 1)
title("K3 vs K2", 'FontSize', fontsize)
legend("K2 (LDL solver)", "K3 (LU solver)", "Location", "northwest", 'FontSize', fontsize-10)
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

