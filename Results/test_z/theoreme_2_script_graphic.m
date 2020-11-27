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

list_problem = {"bore3d.mps"};
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
compare_formulations = 0;
check_residu = 0;
check_all_residu = 0; % = 1  need check_residu = 1
check_limits = 0;
check_eigenvalueK35 = 0;
check_all_eigenvalueK35 = 0;
check_theorem2 = 1;
check_all_theorem2 = 0;
method_theorem2 = "power_lines";
results = zeros(n_problem, 4,3);

check_other_method = 0;
%% Loop
clc
zlist = zeros(n_problem, 10000);
xlist = zeros(n_problem, 10000);

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
    
    if check_theorem2
        fig4 = show_eigenvalue_theorem2(Problem1, list_problem{i}, options_pdco.d1, options_pdco.d2);
    end
    
    zlist(i,1:length(Problem1.z)) = Problem1.z;
    xlist(i,1:length(Problem1.x)) = Problem1.x;
    
end
%% Représentation des méthodes
save_fig = 0;
name_save = list_problem{1};
x = Problem1.x;
z = Problem1.z;
x = abs(x) / norm(x);
z = abs(z) / norm(z);
[x , perm] = sort(x, "descend");
z = z(perm);

fontsize = 30;
fig = figure(1);
clf(1)
semilogy(z, "LineWidth", 3)
hold on
semilogy(x, "LineWidth", 3)

% method 1
n = norm(x) * 10^-8;
semilogy([0 length(z)],[n n], "k--", "LineWidth", 3)

% method 2
[t, perm] = sort(abs(x));
gap = t(2:end)./t(1:end-1);
[~,l] = max(gap);
ind = perm(l);
semilogy([ind ind],[min(x) max(x)], ":", "LineWidth", 3, "Color", [0.6350 0.0780 0.1840])

% method 3
[t, perm] = sort(abs(x));
gap = t(2:end)./t(1:end-1);
l = find(gap >= 100);
if not(isempty(l))
    l = l(1);
else
    l = 0;
end
if l ~= 0
    ind = perm(l);
    semilogy([ind ind],[min(x) max(x)], "k--", "LineWidth", 3)
end

% method 4
method = "broken_lines";
coef0 = [-1 1 1];
obj = @(y) norm(y-log10(z));
tmp = Inf;
cpt = 0;
err = Inf;
% for n = 10:length(z)-10
%     Cf = find_abc(z', n, method, coef0);
%     y = broken_lines(Cf(1:3),n,length(z));
%     err = obj(y);
%     if err < tmp
%         tmp = err;
%         cpt = n;
%     end
% end
% Cf = find_abc(z', cpt, method, coef0);
% y = broken_lines(Cf(1:3),cpt,length(z));
[Cf,~] = g_broken_lines(z, round(length(z)/2));
y = f_broken_lines(length(z), Cf);
semilogy(exp(y*log(10)), "LineWidth", 3)

% method 5
method = "normal_power_lines";
coef0 = [1 1 1 1 1];
obj = @(y) norm(y-log10(z));
tmp = Inf;
cpt = 0;
L = zeros(size(10:length(z)-10));
% for n = 270:310
%     Cf = find_abc(z', n, method, coef0);
%     y = power_lines(Cf,n,length(z));
%     err = obj(y);
%     L(n-9) = err;
%     if err < tmp
%         tmp = err;
%         cpt = n;
%     end
% end
% cpt = 74
% Cf = find_abc(z', cpt, method, coef0);
% y = normal_power_lines(Cf,cpt,length(z));

[Cf,~] = g_power_lines(z, round(length(z)/2));
y = f_power_lines(length(z), Cf);
semilogy(exp(y*log(10)), "LineWidth", 3, "Color", [0.4940 0.1840 0.5560])


title("Valeur absolue des vecteurs x et z de "+name_save, "FontSize", fontsize)
if l~=0
legend("Valeur absolue de z", "Valeur absolue de z",...
    "Méthode 1", "Méthode 2", "Méthode 3", "Méthode 4", "Méthode 5",...
    "Location", "best", "FontSize", fontsize-15)
else
    legend("Valeur absolue de z", "Valeur absolue de z",...
    "Méthode 1", "Méthode 2", "Méthode 4", "Méthode 5",...
    "Location", "best", "FontSize", fontsize-15)
end
set(fig, "WindowState", "maximized"); %set the paper size to what you want

if save_fig
    save_figure_png(fig, name_save);
end
