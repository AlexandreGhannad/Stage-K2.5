% Show the eigenvalues (positive and negative) of a problem with
% the associated bounds of the theorem 2 on a bisemilogy graphic. If
% the options check_limits of pdcoO is true (or 1), two graphics will be
% display, one with the eigenvalues and bounds and one with the different
% components of the bounds.
% Inputs:
% o: problem to display
% name_problem: name of the problem in string form
% d1 and d2: value of d1 ad d2 given by otions_pdco. Those inputs are
% optionnal.
%
% Same functionning as show_eigenvalue but with the bound of theorem 2 one
% rather than theorem 1

function fig = compare_method_theorem_2(o, name_problem)
fig = figure();
set(fig, "WindowState", "maximized")
% Allocation
eigenvalue = o.eigenvalue;
features_theorem2 = o.features_theorem2;
limit1 = features_theorem2(1:4,:);
limit2 = features_theorem2(5:8,:);
limit3 = features_theorem2(9:12,:);
limit4 = features_theorem2(13:16,:);


%% Subplot(221)
windows = subplot(221);
data = [limit1; eigenvalue];
transparency = 0.7;
specs_rm = {"LineWidth", 3, "Color", [0.9290 0.6940 0.1250 transparency]};
specs_rM = {"LineWidth", 3, "Color", [0 0.4470 0.7410 transparency]};
specs_eig = {"k.", "MarkerSize", 5};
specs = cell(5,4);
specs(1,:) = specs_rm;
specs(2,:) = specs_rM;
specs(3,:) = specs_rm;
specs(4,:) = specs_rM;
specs(5,1:3) = specs_eig;
ind = [1 2 3 4 5];
bisemilogy_general(data, specs, ind, windows);

xlabel("Iteration")
ylabel("Eigenvalues and bounds")
legend({"Inner bounds", "Outer bounds", "Eigenvalues"}, 'Location', 'best')

n = length(eigenvalue);
title("Theorem 2(MaxGap):"+name_problem+", size="+num2str(n))
%% Subplot(222)
windows = subplot(222);
data = [limit2; eigenvalue];
transparency = 0.7;
specs_rm = {"LineWidth", 3, "Color", [0.9290 0.6940 0.1250 transparency]};
specs_rM = {"LineWidth", 3, "Color", [0 0.4470 0.7410 transparency]};
specs_eig = {"k.", "MarkerSize", 5};
specs = cell(5,4);
specs(1,:) = specs_rm;
specs(2,:) = specs_rM;
specs(3,:) = specs_rm;
specs(4,:) = specs_rM;
specs(5,1:3) = specs_eig;
ind = [1 2 3 4 5];
bisemilogy_general(data, specs, ind, windows);

xlabel("Iteration")
ylabel("Eigenvalues and bounds")
legend({"Inner bounds", "Outer bounds", "Eigenvalues"}, 'Location', 'best')

n = length(eigenvalue);
title("Theorem 2 (FirstBigGap):"+name_problem+", size="+num2str(n))
%% Subplot(223)
windows = subplot(223);
data = [limit3; eigenvalue];
transparency = 0.7;
specs_rm = {"LineWidth", 3, "Color", [0.9290 0.6940 0.1250 transparency]};
specs_rM = {"LineWidth", 3, "Color", [0 0.4470 0.7410 transparency]};
specs_eig = {"k.", "MarkerSize", 5};
specs = cell(5,4);
specs(1,:) = specs_rm;
specs(2,:) = specs_rM;
specs(3,:) = specs_rm;
specs(4,:) = specs_rM;
specs(5,1:3) = specs_eig;
ind = [1 2 3 4 5];
bisemilogy_general(data, specs, ind, windows);

xlabel("Iteration")
ylabel("Eigenvalues and bounds")
legend({"Inner bounds", "Outer bounds", "Eigenvalues"}, 'Location', 'best')

n = length(eigenvalue);
title("Theorem 2 (broken lines):"+name_problem+", size="+num2str(n))
%% Subplot(224)
windows = subplot(224);
data = [limit4; eigenvalue];
transparency = 0.7;
specs_rm = {"LineWidth", 3, "Color", [0.9290 0.6940 0.1250 transparency]};
specs_rM = {"LineWidth", 3, "Color", [0 0.4470 0.7410 transparency]};
specs_eig = {"k.", "MarkerSize", 5};
specs = cell(5,4);
specs(1,:) = specs_rm;
specs(2,:) = specs_rM;
specs(3,:) = specs_rm;
specs(4,:) = specs_rM;
specs(5,1:3) = specs_eig;
ind = [1 2 3 4 5];
bisemilogy_general(data, specs, ind, windows);

xlabel("Iteration")
ylabel("Eigenvalues and bounds")
legend({"Inner bounds", "Outer bounds", "Eigenvalues"}, 'Location', 'best')

n = length(eigenvalue);
title("Theorem 2 (power lines):"+name_problem+", size="+num2str(n))

end