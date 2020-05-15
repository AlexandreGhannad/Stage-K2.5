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
mps_name = 'iiasa.mps';
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
check_limits = 1;
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

o = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
o.solve;
% prob2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
% prob2.solve;
% prob3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
% prob3.solve;

fclose('all');

%% Print result
% clc
% print_result(result, list_problem)
clc
close all

t = o.eigenvalue;
tmp = t;
tmp(t<0) = 10^10;
t1 = max(t);
t2 = min(tmp);
tmp = t;
tmp(t>0) = -10^10;
t3 = min(t);
t4 = max(tmp);

eigen = [t1;t2;t3;t4];

show_eigenvalue(eigen, o.limit, options_pdco.d1, options_pdco.d2, o.features_limits)
limit = o.features_property(1:4,:);
show_eigenvalue_property(eigen, limit, options_pdco.d1, options_pdco.d2,o.features_property(5:end,:));
%%
% %% Features and limits calcul for theorem
% d1 = options_pdco.d1;
% d2 = options_pdco.d2;
% 
% features_limits = o.features_limits;
% lambda_max = features_limits(1,:);
% lambda_min = features_limits(2,:);
% sigma_max = features_limits(3,:);
% sigma_min = features_limits(4,:);
% xmax = features_limits(5,:);
% xmin = features_limits(6,:);
% zmax = features_limits(7,:);
% zmin = features_limits(8,:);
% 
% rmm = o.limit(1,:);
% rMm = o.limit(2,:);
% rmp = o.limit(3,:);
% rMp = o.limit(4,:);
% figure()
% %% rmm, rMm, rmp, rMp theorem
% subplot(521)
% semilogy(rmp, "LineWidth", 3)
% hold on
% semilogy(rMp, "LineWidth",3)
% legend("rmp", "rMp")
% title("Study of the positive eigenvalues") 
% 
% subplot(522)
% semilogy(rmm, "LineWidth", 3)
% hold on
% semilogy(rMm, "LineWidth",3)
% legend("rmm","rMm")
% title("Study of the negative eigenvalues")
% %% features theorem
% subplot(523)
% semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
% hold on
% semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
% semilogy(xmax, "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
% semilogy(xmin, "LineWidth", 2, "Color", [1 0 0])
% semilogy(zmax, "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
% semilogy(zmin, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% 
% subplot(524)
% semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
% hold on
% semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
% semilogy(xmax, "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
% semilogy(xmin, "LineWidth", 2, "Color", [1 0 0])
% semilogy(zmax, "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
% semilogy(zmin, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% legend({"lambda max", "lambda min", "sigma max", "sigma min", "xmax", "xmin", "zmax", "zmin"}, 'Location', 'best')
% %% rmm, rMm, rmp, rMp property
% features_property = o.features_property(5:end,:);
% lambda_max = features_property(1,:);
% lambda_min = features_property(2,:);
% sigma_max = features_property(3,:);
% sigma_min = features_property(4,:);
% delta = features_property(5,:);
% 
% rmm = limit(1,:);
% rMm = limit(2,:);
% rmp = limit(3,:);
% rMp = limit(4,:);
% 
% subplot(525)
% semilogy(rmp, "LineWidth", 3)
% hold on
% semilogy(rMp, "LineWidth",3)
% legend("rmp", "rMp")
% title("Positive limit property")
% 
% subplot(526)
% semilogy(rmm, "LineWidth", 3)
% hold on
% semilogy(rMm, "LineWidth",3)
% legend("rmm","rMm")
% title("Negative limit property")
% %% features property
% subplot(527)
% semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
% hold on
% semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
% semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% 
% subplot(528)
% semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
% hold on
% semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
% semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% legend({"lambda max", "lambda min", "sigma max", "sigma min", "delta"}, 'Location', 'best')
% %% features theorem
% features_limits = o.features_limits;
% lambda_max = features_limits(1,:);
% lambda_min = features_limits(2,:);
% sigma_max = features_limits(3,:);
% sigma_min = features_limits(4,:);
% xmax = features_limits(5,:);
% xmin = features_limits(6,:);
% zmax = features_limits(7,:);
% zmin = features_limits(8,:);
% 
% etamin = (lambda_min + d1^2).*xmin + zmin;
% etamax = (lambda_max + d1^2).*xmax + zmax;
% 
% delta = d2*ones(size(delta));
% 
% subplot(529)
% semilogy(etamax, "LineWidth", 3, "Color", [0 0 1])
% hold on
% semilogy(etamin, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max.*xmax.^0.5, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min.*xmin.^0.5, "LineWidth", 2, "Color", [0 1 0])
% semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% 
% subplot(5,2,10)
% semilogy(etamax, "LineWidth", 3, "Color", [0 0 1])
% hold on
% semilogy(etamin, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max.*xmax.^0.5, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min.*xmin.^0.5, "LineWidth", 2, "Color", [0 1 0])
% semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% %% figure 4
% figure()
% %% features property
% features_property = o.features_property(5:end,:);
% lambda_max = features_property(1,:);
% lambda_min = features_property(2,:);
% sigma_max = features_property(3,:);
% sigma_min = features_property(4,:);
% delta = features_property(5,:);
% 
% subplot(221)
% semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
% hold on
% semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
% semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% 
% subplot(222)
% semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
% hold on
% semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
% semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% legend({"lambda max", "lambda min", "sigma max", "sigma min", "delta"}, 'Location', 'best')
% %% features theorem
% features_limits = o.features_limits;
% lambda_max = features_limits(1,:);
% lambda_min = features_limits(2,:);
% sigma_max = features_limits(3,:);
% sigma_min = features_limits(4,:);
% xmax = features_limits(5,:);
% xmin = features_limits(6,:);
% zmax = features_limits(7,:);
% zmin = features_limits(8,:);
% 
% etamin = (lambda_min + d1^2).*xmin + zmin;
% etamax = (lambda_max + d1^2).*xmax + zmax;
% 
% delta = (o.d2*ones(size(delta))).^2;
% 
% subplot(223)
% semilogy(etamax, "LineWidth", 3, "Color", [0 0 1])
% hold on
% semilogy(etamin, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max.*xmax.^0.5, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min.*xmin.^0.5, "LineWidth", 2, "Color", [0 1 0])
% semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% 
% subplot(224)
% semilogy(etamax, "LineWidth", 3, "Color", [0 0 1])
% hold on
% semilogy(etamin, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
% semilogy(sigma_max.*xmax.^0.5, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
% semilogy(sigma_min.*xmin.^0.5, "LineWidth", 2, "Color", [0 1 0])
% semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
% xlabel("Iteration")
% ylabel("Intern values of the bounds")
% legend("eta max", "eta min", "sigma max", "sigma min", "delta")


