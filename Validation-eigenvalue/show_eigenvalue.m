function show_eigenvalue(eigenvalue, limit, d1, d2, features_limits)
if exist("features_limits")
    nu_max = features_limits(1,:);
    nu_min = features_limits(2,:);
    sigma_max = features_limits(3,:);
    sigma_min = features_limits(4,:);
    xmax = features_limits(5,:);
    xmin = features_limits(6,:);
    zmax =features_limits(7,:);
    zmin = features_limits(8,:);
    
    % Plot negative eigenvalue
    figure()
    subplot(211)
    semilogy(limit(1:2,:)', "LineWidth", 3)
    hold on
    tmp = eigenvalue';
    tmp(tmp>0) = NaN; % Positive eigenvalue are set at NaN in order to have gaps when we display them
    semilogy(tmp, "k.")
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend("Inferior negative bound", "Superior negative bound", "Eigenvalues")
    
    if exist("d1") & exist("d2")
        title("Negative eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Negative eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Negative eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Negative eigenvalues)")
    end
    
    subplot(212)
    plot(nu_max, "LineWidth", 2, "Color", [0 0 1])
    hold on
    plot(nu_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
    plot(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
    plot(sigma_min, "LineWidth", 2, "Color", [0 1 0])
    plot(xmax, "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
    plot(xmin, "LineWidth", 2, "Color", [1 0 0])
    plot(zmax, "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
    plot(zmin, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
    
    xlabel("Iteration")
    ylabel("Intern values of the bounds")
    legend("nu max", "nu min", "sigma max", "sigma min", "xmax", "xmin", "zmax", "zmin")
    
    % Plot positive eigenvalue
    figure()
    subplot(211)
    semilogy(limit(4,:)', "LineWidth", 3)
    hold on
    semilogy(limit(3,:)', "LineWidth", 3)
    tmp = eigenvalue';
    tmp(tmp<0) = NaN; % Negative eigenvalue are set at NaN in order to have gaps when we display them
    semilogy(tmp, "k.")
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend("Inferior positive bound", "Superior positive bound", "Eigenvalues")
    
    if exist("d1") & exist("d2")
        title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Positive eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Positive eigenvalues)")
    end
    
    subplot(212)
    plot(nu_max, "LineWidth", 2, "Color", [0 0 1])
    hold on
    plot(nu_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
    plot(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
    plot(sigma_min, "LineWidth", 2, "Color", [0 1 0])
    plot(xmax, "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
    plot(xmin, "LineWidth", 2, "Color", [1 0 0])
    plot(zmax, "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
    plot(zmin, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
    
    xlabel("Iteration")
    ylabel("Intern values of the bounds")
    legend("nu max", "nu min", "sigma max", "sigma min", "xmax", "xmin", "zmax", "zmin")
    
else
    % Plot negative eigenvalue
    figure()
    semilogy(limit(1:2,:)', "LineWidth", 3)
    hold on
    tmp = eigenvalue';
    tmp(tmp>0) = NaN; % Positive eigenvalue are set at NaN in order to have gaps when we display them
    semilogy(tmp, "k.")
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend("Inferior negative bound", "Superior negative bound", "Eigenvalues")
    
    
    if exist("d1") & exist("d2")
        title("Negative eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Negative eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Negative eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Negative eigenvalues)")
    end
    
    % Plot positive eigenvalue
    figure()
    semilogy(limit(4,:)', "LineWidth", 3)
    hold on
    semilogy(limit(3,:)', "LineWidth", 3)
    tmp = eigenvalue';
    tmp(tmp<0) = NaN; % Negative eigenvalue are set at NaN in order to have gaps when we display them
    semilogy(tmp, "k.")
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend("Inferior positive bound", "Superior positive bound", "Eigenvalues")
    if exist("d1") & exist("d2")
        title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Positive eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Positive eigenvalues)")
    end
end
end