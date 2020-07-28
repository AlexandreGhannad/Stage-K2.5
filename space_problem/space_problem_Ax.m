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
% d1 = 10^-4;
% d2 = 10^-4;

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
N = 2*m*n/rho1;
epsilon = 1e-5;
MB = Inf;

% [Xis,Etas] = ndgrid(-m:m,-m:m);
% Xis = Xis*rho1/m;
% Etas = Etas*rho1/m;
% DarkHole = Xis.^2 + Etas.^2;
% DarkHole = double(DarkHole >= rho0^2) .* double(DarkHole <= rho1^2);

j2 = transpose(-m:m);
Xis = j2*rho1/m;
Etas = Xis;
DarkHole = zeros(2*m+1);
map = zeros(2*m+1);
for i=-m:m
    for j=-m:m
        xi = Xis(i+m+1);
        eta = Etas(j+m+1);
        tmp2 = xi^2 + eta^2;
        if rho0^2 <= tmp2 && tmp2 <= rho1^2 && abs(eta) <= abs(xi)
            DarkHole(i+m+1,j+m+1) = 1;
            map(i+m+1,j+m+1) = tmp2;
        end
    end
end



[I,J] = ndgrid(-n:n,-n:n);
I = I/(2*n);
J = J/(2*n);
F = double(I.^2+J.^2<=(1/2)^2);
vecF = F(:);

F(n+1,:) = 2*F(n+1,:);
F(:,n+1) = 2*F(:,n+1);
Fhat = real(fft_one_step(fft_one_step(F,m,N)', m, N)');
F(n+1,:) = 0.5*F(n+1,:);
F(:,n+1) = 0.5*F(:,n+1);
vecFhat = Fhat(:);
x0 = [vecF ; vecFhat];

c = zeros(size(x0));
c(1:(2*n+1)^2) = -1;

bL = zeros(size(x0));
bU = zeros(size(x0));
bL(1:length(vecF)) = 0;
bU(1:length(vecF)) = 1;
e = 0;
bL(vecF==0) = -e;
bU(vecF==0) = e;
bL(1+length(vecF):end) = -MB;
bU(1+length(vecF):end) = +MB;

% bL(length(vecF)+1 : end) = -real(Fhat(1)) * 10^-5;
% bU(length(vecF)+1 : end) = real(Fhat(1)) * 10^-5;
% mask2 = zeros(size(x0));
% mask2(1:(2*n+1)^2) = vecF*3;
% mask2( 1+(2*n+1)^2 : end) = DarkHole(:); 
% bL(mask2==1) = Fhat(m+1,m+1)*-1e-5;
% bU(mask2==1) = Fhat(m+1,m+1)*1e-5;
% bL(mask2==2) = -inf;
% bU(mask2==2) = inf;
% bL(vecF==0) = 0;
% bU(vecF==0) = 0;



cL1 = zeros(size(vecFhat));
cU1 = zeros(size(vecFhat));
cL2 = -MB*ones(size(vecFhat));
cU2 = MB*ones(size(vecFhat));
cL3 = -MB*ones(size(vecFhat));
cU3 = MB*ones(size(vecFhat));
tmp = DarkHole(:);

cU2(tmp == 1) = 0;
cL3(tmp == 1) = 0;

cL = [cL1 ; cL2; cL3];
cU = [cU1 ; cU2; cU3];

name = "test";
funhandle = @(x, mode) Ax(x, n, m, N, epsilon, mode);

M1 = 3*(2*m+1)^2;
N1 = (2*n+1)^2 + (2*m+1)^2; 
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
options_pdco.Maxiter = 60; % min(max(30, slack.n), 80);
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
x=o.xmem(:, 1);
nn=2*n+1;
mm=2*m+1;
vecF = x(1:nn^2);
vecFhat = x(1+nn^2 : nn^2 + mm^2);
F = reshape(vecF, [nn nn]);
Fhat = reshape(vecFhat, [mm mm]);

figure()
subplot(121)
surf(F)
colormap("pink")

subplot(122)
surf(Fhat)
colormap("pink")


%% Reconstruction with optimization toolbox
% rho0 = 4;
% rho1 = 20;
% epsilon = 10^-5;
% n = 20;
% m = 10;

dx = 1/(2*n);
dy = dx;
j1 = transpose(0.5:n-0.5);
Xs = j1/(2*n);
Ys = Xs;
mask = zeros(n);
for a = 1:n
    for b = 1:n
        tmp2 = Xs(a)^2 + Ys(b)^2;
        if tmp2 < 0.25
            mask(a,b) = 1;
        end
    end
end
[row,col] = ind2sub(size(mask),find(mask==1));
Pupil = [Xs(col) Ys(row)];

F = ones(n).*mask;


j2 = transpose(0:m);
Xis = j2*rho1/m;
Etas = Xis;

DarkHole = [];
mask2 = zeros(m+1);
map = zeros(m+1);
for i=1:m+1
    for j=1:m+1
        xi = Xis(i);
        eta = Etas(j);
        tmp2 = xi^2 + eta^2;
        if rho0^2 <= tmp2 && tmp2 <= rho1^2 && eta <=xi
            DarkHole = [DarkHole ; [xi eta]];
            mask2(i,j) = 1;
            map(i,j) = tmp2;
        end
    end
end
%% Creation optim prob
prob = optimproblem;
prob.ObjectiveSense = "maximize";
F = optimvar("F", n,n);
Fhat = optimvar("Fhat", m+1,m+1);

prob.Objective = ones(1,n*n) * reshape( mask.*F, [n*n,1]);

cons1 = F >= 0;
cons2 = F <= 1;
prob.Constraints.cons1 = cons1;
prob.Constraints.cons2 = cons2;

cons3 = Fhat.*mask2 >= -epsilon*Fhat(1,1);
cons4 = Fhat.*mask2 <= epsilon*Fhat(1,1);
prob.Constraints.cons3 = cons3;
prob.Constraints.cons4 = cons4;

cons5 = Fhat == fhat(F,m,n, Xs, Etas, mask);
prob.Constraints.cons5 = cons5;
%% Solve
[sol,fval,exitflag] = solve(prob);
f = sol.F;
fh = sol.Fhat;
tmp = fhat(f,m,n, Xs, Etas, mask);
disp("gap between theoritical fhat and real fh")
disp(norm(fh-tmp))

res = zeros(2*n, 2*n);
res(1:n, 1:n) = f(end:-1:1,end:-1:1);
res(1:n, n+1:end) = f(end:-1:1,:);
res(n+1:end, 1:n) = f(:,end:-1:1);
res(n+1:end, n+1:end) = f(:,:);

resh = zeros(2*m+1, 2*m+1);
resh(1:m, 1:m) = fh(end:-1:2,end:-1:2);
resh(1:m, m+1:end) = fh(end:-1:2,:);
resh(m+1:end, 1:m) = fh(:,end:-1:2);
resh(m+1:end, m+1:end) = fh(:,:);
%% Display graphics
figure()
subplot(121)
surf(res)
colormap("pink")
subplot(122)
surf(resh)
colormap("pink")

%%

Y = Ax(x0, n, m, N, epsilon, 1);






