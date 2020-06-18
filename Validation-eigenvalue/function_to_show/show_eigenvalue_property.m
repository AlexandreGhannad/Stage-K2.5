% Show the eigenvalues (positive and negative) of a problem with
% the associated bounds of the property 1 on a bisemilogy graphic. If
% the options check_limits of pdcoO is true (or 1), two graphics will be 
% display, one with the eigenvalues and bounds and one with the different 
% components of the bounds.
% Inputs:
% o: problem to display
% name_problem: name of the problem in string form
% d1 and d2: value of d1 ad d2 given by otions_pdco. Those inputs are
% optionnal.
%
% Same functionning as show_eigenvalue but with the bound of property one
% rather than theorem 1


function fig = show_eigenvalue_property(o, name_problem, d1, d2)
fontsize = 30;
fig = figure();
set(fig, "WindowState", "maximized")

eigenvalue = o.eigenvalue;
limit = o.limit;
features_property = o.features_property;

if o.check_limits
    lambda_max = features_property(1,:);
    lambda_min = features_property(2,:);
    sigma_max = features_property(3,:);
    sigma_min = features_property(4,:);
    delta = features_property(5,:);
    
    % Plot negative eigenvalue
    windows = subplot(211)
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
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    elseif exist("d1")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + ")", 'FontSize', fontsize)
    elseif exist("d2")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    else
        title("Property 1:"+name_problem+", size="+num2str(n), 'FontSize', fontsize)
    end
    
    subplot(212)
    semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
    hold on
    semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
    semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
    semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
    semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
    
    xlabel("Iteration", 'FontSize', fontsize)
    ylabel("Intern values of the bounds", 'FontSize', fontsize)
    legend({"lambda max", "lambda min", "sigma max", "sigma min", "delta"}, 'Location', 'best')
    
else
    % Plot Eigenvalue
    bisemilogy(eigenvalue, limit)
    
    xlabel("Iteration", 'FontSize', fontsize)
    ylabel("Eigenvalues and bounds", 'FontSize', fontsize)
    
    n = length(eigenvalue);
    if exist("d1") & exist("d2")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    elseif exist("d1")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + ")", 'FontSize', fontsize)
    elseif exist("d2")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
    else
        title("Property 1:"+name_problem+", size="+num2str(n), 'FontSize', fontsize)
    end
end
end