% Show the eigenvalues (positive and negative) of a problem with
% the associated bounds on a bisemilogy graphic. If the options
% check_limits of pdcoO is true (or 1), two graphics will be display, one
% with the eigenvalues and bounds and one with the different components of
% the bounds.
% Inputs:
% o: problem to display
% name_problem: name of the problem in string form
% d1 and d2: value of d1 ad d2 given by otions_pdco. Those inputs are
% optionnal.

function fig = show_eigenvalue(o, name_problem, d1, d2)
% Create the figure in fullscreen size
fontsize = 30;
fig = figure();
set(fig, "WindowState", "maximized")

if o.check_limits
    % Two figures, on with the positive and negative eigenvalues, with the
    % associated bounds, and one with the different values inside the
    % calculation of the bounds.
    
    % Allocation of the different values to display.
    eigenvalue = o.eigenvalue;
    limit = o.limit;
    features_limits = o.features_limits;
    
    lambda_max = features_limits(1,:);
    lambda_min = features_limits(2,:);
    sigma_max = features_limits(3,:);
    sigma_min = features_limits(4,:);
    xmax = features_limits(5,:);
    xmin = features_limits(6,:);
    zmax = features_limits(7,:);
    zmin = features_limits(8,:);
    
    % Plot  eigenvalue on the first subplot    
    windows = subplot(211);
    transparency = 0.7; % Value to choose the transparency of the bounds
    % Formatting data and specification to display thank bisemilogy_general
    data = [limit; eigenvalue];
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
        title("Problem:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    elseif exist("d1")
        title("Problem:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + ")", 'FontSize', fontsize)
    elseif exist("d2")
        title("Problem:"+name_problem+", size="+num2str(n)+", (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    else
        title("Problem:"+name_problem+", size="+num2str(n), 'FontSize', fontsize)
    end
    
    subplot(212)
    semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
    hold on
    semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
    semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
    semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
    semilogy(xmax, "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
    semilogy(xmin, "LineWidth", 2, "Color", [1 0 0])
    semilogy(zmax, "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
    semilogy(zmin, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
    
    xlabel("Iteration")
    ylabel("Intern values of the bounds")
    legend(["lambda max", "lambda min", "sigma max", "sigma min", "xmax", "xmin", "zmax", "zmin"], 'Location', 'best')
    
else
    % Allocation
    eigenvalue = o.eigenvalue;
    limit = o.limit;
    % Display
    bisemilogy(eigenvalue, limit)
    
    xlabel("Iteration", 'FontSize', fontsize)
    ylabel("Eigenvalues and bounds", 'FontSize', fontsize)
    
    n = length(eigenvalue);
    if exist("d1") & exist("d2")
        title("Problem:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    elseif exist("d1")
        title("Problem:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + ")", 'FontSize', fontsize)
    elseif exist("d2")
        title("Problem:"+name_problem+", size="+num2str(n)+", (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    else
        title("Problem:"+name_problem+", size="+num2str(n), 'FontSize', fontsize)
    end
end
end