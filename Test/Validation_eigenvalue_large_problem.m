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

formulation1 = 'K25';
solver = 'LU';
classname1 = build_variant(pdcoo_home, formulation1, solver);

formulation2 = 'K35';
solver = 'LU';
classname2 = build_variant(pdcoo_home, formulation2, solver);

formulation3 = 'K2';
solver = 'LU';
classname3 = build_variant(pdcoo_home, formulation3, solver);

Problem which are too large currently: 
large_problem = {'bnl2.mps'; ;'cycle.mps' ; '80bau3b.mps';'d2q06c.mps';'d6cube.mps';...
'degen3.mps';'dfl001.mps';'fit2d.mps''fit2p.mps'; 'greenbeb.mps'; ...
'greenbea.mps';'maros.mps'; 'nesm.mps'; 'pilot.mps';'pilot87.mps';...
'scagr25.mps'; 'ship08l.mps';'ship12l.mps';'ship12s.mps';...
'wood1p.mps';'woodw.mpsz'}



n_problem = length(large_problem);
% n_problem = 20;

options_pdco.d1 = 1.0e-2;
options_pdco.d2 = 1.0e-2;
options_pdco.OptTol = 1.0e-9;
options_solv.atol1 = 1.0e-4;
options_solv.atol2 = 1.0e-10;
options_solv.itnlim = 10;
options_pdco.Print = 1;

fprintf(options_pdco.file_id, ...
        '\n    Name    Objectif   Presid   Dresid   Cresid   PDitns   Inner     Time      D2 * r\n\n');

result = zeros(9,3,n_problem);
%% Loop
clc
bug = [34:49 53:57];
for i = 1:n_problem
if not(ismember(i, bug))

  mps_name = large_problem{i};
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
  options_form = struct();

  Problem1 = eval([classname1, '(slack, options_pdco,options_form,options_solv)']);
  Problem1.solve;
  Problem2 = eval([classname2, '(slack, options_pdco,options_form,options_solv)']);
  Problem2.solve;
  Problem3 = eval([classname3, '(slack, options_pdco,options_form,options_solv)']);
  Problem3.solve;
  fprintf(Problem1.file_id, ...
          '\n%12s   %11.4e   %6.0f   %6.0f   %6.0f   %6d   %6d   %7.2f s   %11.4e\n', ...
          mps_name, slack.fobj(Problem1.x),                                            ...
          log10(Problem1.Pinf), log10(Problem1.Dinf), log10(Problem1.Cinf0),             ...
          Problem1.PDitns, Problem1.inner_total, Problem1.time, options_pdco.d2^2 * norm(Problem1.y));
    xf1 = Problem1.x;
    zf1 = Problem1.z;
    xf2 = Problem2.x;
    zf2 = Problem2.z;
    xf3 = Problem3.x;
    zf3 = Problem3.z;
    obj1 = Problem1.objtrue;
    obj2 = Problem2.objtrue;
    obj3 = Problem3.objtrue;
    res = evaluation(xf1, xf2, xf3, zf1, zf2 , zf3 , obj1 , obj2 , obj3, Problem1.rapport, Problem1.err);
    result(:,:,i) = res;
end
end

fclose('all');
%% Print result
clc
print_result(result, large_problem)