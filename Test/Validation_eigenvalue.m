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

% Problem which are too large currently: 
% large_problem = ['bnl2.mps'; ;'cycle.mps' ; '80bau3b.mps';'d2q06c.mps';'d6cube.mps';...
% 'degen3.mps';'dfl001.mps';'fit2d.mps''fit2p.mps'; 'greenbeb.mps'; ...
% 'greenbea.mps';'maros.mps'; 'nesm.mps'; 'pilot.mps';'pilot87.mps';...
% 'scagr25.mps'; 'ship08l.mps';'ship12l.mps';'ship12s.mps';...
% 'wood1p.mps';'woodw.mpsz']

%     {'perold.mps';'pilot.ja.mps';'pilot.we.mps';'pilot4.mps';...
%     'pilotnov.mps';'recipe.mps';'sc50a.mps';...
%     'sc50b.mps';'sc105.mps';'sc205.mps';'scagr7.mps';...
%     'scfxm1.mps';'scfxm2.mps';'scfxm3.mps';...
%     'scorpion.mps';'scrs8.mps';'sctap1.mps';...
%     'sctap2.mps';'sctap3.mps';'seba.mps' ; 'share1b.mps'}

list_problem ={'25fv47.mps';'adlittle.mps';'afiro.mps';...
  'agg.mps';'agg2.mps';'agg3.mps';'bandm.mps';'beaconfd.mps';...
  'blend.mps';'bnl1.mps';'boeing1.mps';'boeing2.mps';'bore3d.mps';'brandy.mps';...
  'capri.mps';'czprob.mps';...
  'degen2.mps';'e226.mps';'etamacro.mps';...
  'fffff800.mps';'finnis.mps';'fit1d.mps';'fit1p.mps';...
  'ganges.mps';'gfrd-pnc.mps';...
  'grow7.mps';'grow15.mps';'grow22.mps';'israel.mps';...
  'kb2.mps';'lotfi.mps';'maros-r7.mps';'modszk1.mps';...
  'scsd1.mps';'scsd6.mps';'scsd8.mps';...
  'share2b.mps';'shell.mps';'ship04l.mps';'ship04s.mps';...
  'ship08s.mps';...
  'sierra.mps';'stair.mps';'standata.mps';'standgub.mps';...
  'standmps.mps';'stocfor1.mps';'stocfor2.mps';'tuff.mps';...
  'vtp_base.mps'};

% list_problem = {"afiro.mps"};
n_problem = length(list_problem);
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
%% Check eigenvalues and compare method
n_problem = min(n_problem, 2000);
check_eigenvalue = 1
show_one_graphic = 0; % = 1  need check_eigenvalue = 1
show_all_graphic = 1; % = 1  need check_eigenvalue = 1
check_cond = 1;
compare_formulations = 0;
check_residu = 1;
check_all_residu = 1; % = 1  need check_residu = 1
%% Loop
clc
for i = 1:n_problem

  mps_name = list_problem{i};
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
  options_pdco.check_eigenvalue = check_eigenvalue;
  options_pdco.check_residu = check_residu;
  options_pdco.check_cond = check_cond;
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
    if check_eigenvalue
        if i == 1
            name = list_problem{i};
            prob1 = Problem1;
            prob2 = Problem2;
            prob3 = Problem3;
            l = length(Problem1.M);
            if check_residu
                residu = Problem1.opt_residu;
            end
        else
            if length(Problem1.M) > l
                name = list_problem{i};
                prob1 = Problem1;
                prob2 = Problem2;
                prob3 = Problem3;
                l = length(Problem1.M);
                if check_residu
                    residu = Problem1.opt_residu;
                end
            end
        end
    end
    if show_all_graphic
        show_eigenvalue(Problem1.eigenvalue, Problem1.limit);
    end
    if check_all_residu
        residu = Problem1.opt_residu
        show_residu(residu)
    end
    
    if compare_formulations
        if i == 1
            name = list_problem{i};
            prob1 = Problem1;
            prob2 = Problem2;
            prob3 = Problem3;
            l = length(Problem1.M);
        else
            if length(Problem1.M) > l
                name = list_problem{i};
                prob1 = Problem1;
                prob2 = Problem2;
                prob3 = Problem3;
                l = length(Problem1.M);
            end
        end
    end
    if check_cond & check_eigenvalue
        show_cond(Problem1.cond, Problem1.limit);
    else
        show_cond(Problem1.cond);
    end
end

fclose('all');
%% Print result
% clc
% print_result(result, list_problem)
if show_one_graphic
    show_eigenvalue(prob1.eigenvalue, prob1.limit);
end
if compare_formulations
    print_comparison(prob1, prob2, prob3);
end