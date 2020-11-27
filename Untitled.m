i=1;j=1;k=1;
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
options_pdco.Maxiter = 100;

options_pdco.check_eigenvalue = check_eigenvalue;
options_pdco.check_limits = check_limits;
options_pdco.check_eigenvalue_other_formulation = check_eigenvalue_other_formulation;
options_pdco.check_theorem2 = check_theorem2;
options_pdco.method = method_theorem2;
options_pdco.check_property = check_property;
options_pdco.check_cond = check_cond;
options_pdco.check_residu = check_residu;

options_form = struct();


