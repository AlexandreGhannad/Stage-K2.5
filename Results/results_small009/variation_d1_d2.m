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

options_pdco.file_id = 1;

formulation1 = 'K25';
solver = 'LDL';
classname1 = build_variant(pdcoo_home, formulation1, solver);

% formulation2 = 'K35';
% solver = 'LDL';
% classname2 = build_variant(pdcoo_home, formulation2, solver);
% 
% formulation3 = 'K2';
% solver = 'LU';
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
path_to_save = "D:\git_repository\Stage-K2.5\Results\results_small009\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\Results\results_small009\";
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
            options_pdco.Maxiter = min(max(30, slack.n), 100);
            
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
                if save_all_graphics
                    save_figure(fig1, path_to_save+"fig"+num2str(j)+num2str(k))
                end
            end
            
            if check_eigenvalue_other_formulation
                fig21 = show_eigenvalue_other_formulation(o2.eigenvalue, name_problem, "K3.5", d1(j), d2(k));
                fig22 = show_eigenvalue_other_formulation(o3.eigenvalue, name_problem, "K2", d1(j), d2(k));
                fig23 = show_eigenvalue_other_formulation(o4.eigenvalue, name_problem, "K3", d1(j), d2(k));
                if save_all_graphics
                    save_figure(fig21, path_to_save+"fig21"+num2str(i))
                    save_figure(fig22, path_to_save+"fig22"+num2str(i))
                    save_figure(fig23, path_to_save+"fig23"+num2str(i))
                end
            end
            
            if check_property
                fig3 = show_eigenvalue_property(o1, name_problem, d1(j), d2(k));
                if save_all_graphics
                    save_figure(fig3, path_to_save+"fig3"+num2str(i))
                end
            end
            
            if check_theorem2
                fig4 = show_eigenvalue_theorem2(o1, name_problem, d1(j), d2(k));
                if save_all_graphics
                    save_figure(fig4, path_to_save+"fig4"+num2str(i))
                end
            end
            
            if check_cond
                fig51 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o2.cond, "K3.5");
                fig52 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o3.cond, "K2");
                fig53 = show_cond(o1.cond, o1.limit, d1(j), d2(k), o4.cond, "K3");
                if save_all_graphics
                    save_figure(fig51, path_to_save+"fig51"+num2str(i))
                    save_figure(fig52, path_to_save+"fig52"+num2str(i))
                    save_figure(fig53, path_to_save+"fig53"+num2str(i))
                end
            end
            
            if check_residu
                fig6 = show_residu(o1.opt_residu, o1.evolution_mu, d1(j), d2(k));
                if save_all_graphics
                    save_figure(fig6, path_to_save+"fig6"+num2str(i))
                end
            end
            
            if check_results
                res = squeeze(results(i,j,k,:,:));
                results(i,j,k,:,:) = save_features(res, o1,o2,o3,o4);
            end
            close all
        end
    end
end
fclose('all');
if save_results
    results = squeeze(results);
    save(path_to_save+"results.mat", "results")
end