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

function fig = show_eigenvalue_theorem2(o, name_problem, d1, d2)
fontsize=30;
fig = figure();
set(fig, "WindowState", "maximized")
% Allocation
eigenvalue = o.eigenvalue;
features_theorem2 = o.features_theorem2;
limit = features_theorem2(1:4,:);

if o.check_limits
    % Allocation
    rho_min_negative = features_theorem2(1,:);
    rho_max_negative = features_theorem2(2,:);
    rho_min_positive = features_theorem2(3,:);
    rho_max_positive = features_theorem2(4,:);
    lambda_max = features_theorem2(5,:);
    lambda_min = features_theorem2(6,:);
    sigma_max = features_theorem2(7,:);
    sigma_min = features_theorem2(8,:);
    xmax = features_theorem2(9,:);
    xmin = features_theorem2(10,:);
    n = (size(features_theorem2,1) - 10) /2;
    x = features_theorem2(11:11+n-1,:);
    z = features_theorem2(11+n:end,:);
    
    windows = subplot(221);
    data = [limit; eigenvalue];
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
    
    xlabel("Iteration", 'FontSize', fontsize)
    ylabel("Eigenvalues and bounds", 'FontSize', fontsize)
    
    n = length(eigenvalue);    
    if exist("d1") & exist("d2")
        title("Theorem 2:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    elseif exist("d1")
        title("Theorem 2:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + ")", 'FontSize', fontsize)
    elseif exist("d2")
        title("Theorem 2:"+name_problem+", size="+num2str(n)+", (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    else
        title("Theorem 2:"+name_problem+", size="+num2str(n), 'FontSize', fontsize)
    end
    
    subplot(222)
    semilogy(abs(lambda_max), "LineWidth", 2, "Color", [0 0 1])
    hold on
    semilogy(abs(lambda_min), "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
    xlabel("Iteration", 'FontSize', fontsize)
    ylabel("Eigenvalue of the hessien matrix", 'FontSize', fontsize)
    legend({"lambda max", "lambda min"}, 'Location', 'best')
    
    if lambda_max == 0 & lambda_min == 0
        title("Eigenvalues are 0", 'FontSize', fontsize)
    end
    
    subplot(223)
    semilogy(abs(sigma_max), "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
    hold on
    semilogy(abs(sigma_min), "LineWidth", 2, "Color", [0 1 0])
    xlabel("Iteration", 'FontSize', fontsize)
    ylabel("Singular value of A", 'FontSize', fontsize)
    legend({"sigma max", "sigma min"}, 'Location', 'best')
    
    subplot(224)
    semilogy(abs(xmax), "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
    hold on
    semilogy(abs(xmin), "LineWidth", 2, "Color", [1 0 0])
    semilogy(abs(x'), "k.")
    xlabel("Iteration", 'FontSize', fontsize)
    ylabel("x and its optimum for inactive bounds", 'FontSize', fontsize)
    legend({"xmax,I", "xmin,I", "x"}, 'Location', 'best')
    
else

    windows = fig;
    data = [limit; eigenvalue];
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
        
    xlabel("Iteration", 'FontSize', fontsize)
    ylabel("Eigenvalues and bounds", 'FontSize', fontsize)
    legend({"Inner bounds", "Outer bounds", "Eigenvalues"}, 'Location', 'best')
    
    n = length(eigenvalue);    
    if exist("d1") & exist("d2")
        title("Theorem 2:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    elseif exist("d1")
        title("Theorem 2:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + ")", 'FontSize', fontsize)
    elseif exist("d2")
        title("Theorem 2:"+name_problem+", size="+num2str(n)+", (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    else
        title("Theorem 2:"+name_problem+", size="+num2str(n), 'FontSize', fontsize)
    end
end
end