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
p = genpath(fullfile(pdcoo_home, 'space_problem'));
addpath(p);
p = genpath(fullfile(pdcoo_home, 'spot'));
addpath(p);
if exist('Variants', 'dir') ~= 7
    mkdir('Variants');
end
addpath(fullfile(pdcoo_home, 'Variants'));
addpath(fullfile(pdcoo_home, 'Test'));%% Setup 2
import model.lpmodel;
import model.slackmodel;
import model.slackmodel_spot;

options_pdco.file_id = 1;
%% Setup 2
import model.lpmodel;
import model.slackmodel;

options_pdco.file_id = 1;

formulation1 = 'K25';
solver = 'MINRES';
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

choice_list_problem = 1;
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
    path_problem = pwd + "/space_problem/";
    list_problem ={'space_problem_n=25_m=15.mps'};
    warning("Precise your path of the problem if you use your personal list")
end

n_problem = length(list_problem);
%% Choose option for the test
n_problem = min(n_problem, 2000); % Change the number if you want to test only a few problems

d1=0;
d2=0;
% d1 = 10^-2;
% d2 = 10^-2;
% d1 = [10^-8 10^-4 10^-2 10^-0];
% d2 = [10^-8 10^-4 10^-2 10^-0];
d1 = 10^-8;
d2 = 10^-8;

options_pdco.OptTol = 1.0e-10;
options_solv.atol1 = 1.0e-10;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 100;
options_pdco.Print = 1;

check_eigenvalue = 0;
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

save_all_graphics = 0;
path_to_save = "D:\git_repository\Stage-K2.5\";

check_results = 0;
save_results = 0;
path_to_save = "D:\git_repository\Stage-K2.5\";
%% Set up for space problem
n = 20;
m = 10;
rho0 = 4;
rho1 = 20;
epsilon = 1e-5;

dx=1/(2*n);
dy=dx;
Xs = (0.5:(n-0.5))'/(2*n);
Ys=Xs;
Pupil=(Xs.^2)'+(Ys.^2);
F = Pupil;
F(Pupil<0.25) = 1;
F(Pupil>=0.25) = 0;
mask = F;

Xis = (0:m)'*rho1/m;
Etas = Xis;

ComplexMap = (Xis.^2)' + Etas.^2;
DarkHole = zeros(size(ComplexMap));
for i =1:m+1
    for j = 1:m+1
        tmp = ComplexMap(i,j);
        if tmp >=rho0^2 && tmp <= rho1^2 && Etas(j) <= Xis(i)
            DarkHole(i,j) = 1;
        end
    end
end

Fhat = fhat(F,m,n, Xs, Etas, mask);

vecF = F(:);
x0 = vecF;
vecFhat = Fhat(:);

c = -ones(size(x0));

bL = zeros(size(x0));
bU = zeros(size(x0));
bL(1:length(vecF)) = 0;
bU(1:length(vecF)) = 1;
e = 0;
bL(vecF==0) = -e;
bU(vecF==0) = e;

cL2 = -Inf*ones(size(vecFhat));
cU2 = Inf*ones(size(vecFhat));
cL3 = -Inf*ones(size(vecFhat));
cU3 = Inf*ones(size(vecFhat));
tmp = DarkHole(:);

cU2(tmp == 1) = 0;
cL3(tmp == 1) = 0;

cL = [cL2; cL3];
cU = [cU2; cU3];

name = "test";
funhandle = @(x, mode) Ax3(x, n, m, rho1, epsilon, mode);

M1 = 2*(m+1)^2;
N1 =  n^2;
op = opFunction(M1, N1 ,funhandle);
own_model = model.lpmodel_spot(name, x0, cL, cU, bL, bU, op, c);
%% Load problem
clc
i=1;j=1;k=1;

slack = model.slackmodel_spot(own_model);
Anorm = normest(slack.gcon(slack.x0), 1.0e-3);

% options_pdco.featol = 10^-32; 
% options_pdco.OptTol = 10^-32;

options_pdco.d1 = d1(j);
options_pdco.d2 = d2(k);
options_pdco.x0 = slack.x0;
options_pdco.xsize = max(norm(options_pdco.x0, inf), 1);
options_pdco.zsize = max(norm(slack.gobj(slack.x0), inf) + sqrt(slack.n) * Anorm, 1);
options_pdco.z0 = options_pdco.zsize * ones(slack.n, 1);
options_pdco.y0 = zeros(slack.m, 1);
options_pdco.mu0 = options_pdco.zsize;
options_pdco.Maxiter = 300; % min(max(30, slack.n), 80);
options_pdco.explicitA = 0;

options_pdco.check_eigenvalue = check_eigenvalue;
options_pdco.check_limits = check_limits;
options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
options_pdco.check_theorem2 = check_theorem2;
options_pdco.method = method_theorem2;
options_pdco.check_property = check_property;
options_pdco.check_cond = check_cond;
options_pdco.check_residu = check_residu;
options_pdco.mem = 1;

mask = vecF;
options_pdco.mask = mask;

options_form = struct();

o = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
%% Solve
o.solve;
fclose('all');
%% Display graphics
% x = o.x;
x=o.xmem(:, end-1);
vecF = x(1:n^2);
F = reshape(vecF, [n n]);

K = cos(2*pi*Etas*Xs')/(2*n);

Fhat = K*F*K';

figure()
subplot(121)
surf(F)
colormap("pink")

subplot(122)
surf(Fhat)
colormap("pink")
%% Display symmetrised graphics

res = zeros(2*n, 2*n);
res(1:n, 1:n) = F(end:-1:1 , end:-1:1);
res(1:n, n+1:end) = F(end:-1:1,:);
res(n+1:end, 1:n) = F(:,end:-1:1);
res(n+1:end, n+1:end) = F(:,:);

resh = zeros(2*m+2, 2*m+2);
resh(1:m+1, 1:m+1) = Fhat(end:-1:1,end:-1:1);
resh(1:m+1, m+2:end) = Fhat(end:-1:1,:);
resh(m+2:end, 1:m+1) = Fhat(:,end:-1:1);
resh(m+2:end, m+2:end) = Fhat(:,:);

figure()
subplot(121)
surf(res)
colormap("pink")

subplot(122)
surf(resh)
colormap("pink")













