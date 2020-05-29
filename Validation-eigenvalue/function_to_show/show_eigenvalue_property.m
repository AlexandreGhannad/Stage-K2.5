function fig = show_eigenvalue_property(o, name_problem, d1, d2)
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
    
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    if exist("d1") & exist("d2")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Property 1:"+name_problem+", size="+num2str(n))
    end
    
    subplot(212)
    semilogy(lambda_max, "LineWidth", 2, "Color", [0 0 1])
    hold on
    semilogy(lambda_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
    semilogy(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
    semilogy(sigma_min, "LineWidth", 2, "Color", [0 1 0])
    semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
    
    xlabel("Iteration")
    ylabel("Intern values of the bounds")
    legend({"lambda max", "lambda min", "sigma max", "sigma min", "delta"}, 'Location', 'best')
    
else
    % Plot Eigenvalue
    bisemilogy(eigenvalue, limit)
    
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    
    if exist("d1") & exist("d2")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Property 1:"+name_problem+", size="+num2str(n)+", (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Property 1:"+name_problem+", size="+num2str(n))
    end
end
end