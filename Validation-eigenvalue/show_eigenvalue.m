function show_eigenvalue(eigenvalue, limit, d1, d2, features_limits)
if exist("features_limits")
    nu_max = features_limits(1,:);
    nu_min = features_limits(2,:);
    sigma_max = features_limits(3,:);
    sigma_min = features_limits(4,:);
    
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
    
    subplot(212)
    semilogy(nu_max)
    hold on
    semilogy(nu_min)
    semilogy(sigma_max)
    semilogy(sigma_min)
    
    xlabel("Iteration")
    ylabel("Intern values of the bounds")
    legend("nu max", "nu min", "sigma max²*x max", "sigma min²*x min")
    
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
    subplot(212)
    semilogy(nu_max, "LineWidth", 3, "Color", [0 0.4470 0.7410])
    hold on
    semilogy(nu_min, "LineWidth", 3, "Color", [0.3 0.7 0.9])
    semilogy(sigma_max, "LineWidth", 3, "Color", [0.8 0 0])
    semilogy(sigma_min, "LineWidth", 3, "Color", [0.8500 0.3250 0.0980])
    xlabel("Iteration")
    ylabel("Intern values of the bounds")
    legend("nu max", "nu min", "sigma max²*x max", "sigma min²*x min")
    
    if exist("d1") & exist("d2")
        title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Positive eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Positive eigenvalues)")
    end
    
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