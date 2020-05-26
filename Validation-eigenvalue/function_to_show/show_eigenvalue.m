function fig = show_eigenvalue(eigenvalue, limit, d1, d2, features_limits)

if exist("features_limits")
    lambda_max = features_limits(1,:);
    lambda_min = features_limits(2,:);
    sigma_max = features_limits(3,:);
    sigma_min = features_limits(4,:);
    xmax = features_limits(5,:);
    xmin = features_limits(6,:);
    zmax = features_limits(7,:);
    zmin = features_limits(8,:);
    
    % Plot negative eigenvalue
    fig = figure();
    ax = subplot(211)
    % same script as bisemilogy but with one change to adapt tothe
    % situation (ax = subplot(211) instead of ax = axes)
    pos = eigenvalue';
    pos(pos<=0) = NaN;
    pos = log10(pos);
    neg = eigenvalue';
    neg(neg>=0) = NaN;
    neg = -log10(-neg);
    rmm = -log10(abs(limit(1,:)));
    rMm = -log10(abs(limit(2,:)));
    rmp = log10(abs(limit(3,:)));
    rMp = log10(abs(limit(4,:)));
    
    
    l1 = max(max(log10(abs(eigenvalue(eigenvalue~=0))), [], "all"), max(log10(abs(limit(limit~=0))), [], "all"));
    l2 = min(min(log10(abs(eigenvalue(eigenvalue~=0))), [], "all"), min(log10(abs(limit(limit~=0))), [], "all"));
    l1 = 2*ceil(l1/2);
    l2 = 2*floor(l2/2);
    L = l1 + abs(l2)+2;
    pos = pos + abs(l2)+2;
    neg = neg - abs(l2)-2;
    rmp = rmp + abs(l2)+2;
    rMp = rMp + abs(l2)+2;
    rmm = rmm - abs(l2)-2;
    rMm = rMm - abs(l2)-2;
    
    if ismember(0, limit)
        for i=1:length(rmm)
            if rmm(i) == Inf
                rmm(i) = 0;
            end
            if rMm(i) == Inf
                rMm(i) = 0;
            end
            if rmp(i) == -Inf
                rmp(i) = 0;
            end
            if rMp(i) == -Inf
                rMp(i) = 0;
            end
        end
    end
    
    hold on
    plot(rmp, "LineWidth", 3, "Color", [0.9290 0.6940 0.1250])
    plot(rMp, "LineWidth", 3, "Color", [0 0.4470 0.7410])
    plot(pos, "k.", "MarkerSize", 5)
    plot(neg, "k.", "MarkerSize", 5)
    % rmm and rMm are plot after eigenvalues in order to have the legend associated with the right data
    plot(rmm, "LineWidth", 3, "Color", [0 0.4470 0.7410])
    plot(rMm, "LineWidth", 3, "Color", [0.9290 0.6940 0.1250])
    ax.XAxisLocation = 'origin';
    ylim([-L L]);
    ax.YTick=-L:2:L;
    
    t = l2:2:l1;
    
    lbl = cell(size(t));
    tmp = -1;
    cpt = 0;
    for i = -length(t):length(t)
        if i < 0
            lbl{i+length(t)+1} = ['-10^{',num2str(t(length(t)-cpt)),'}'];
            cpt = cpt+1;
        elseif i == 0
            lbl{i+length(t)+1} = ['0'];
            cpt = 1;
        elseif i > 0
            lbl{i+length(t)+1} = ['10^{',num2str(t(i)),'}'];
            cpt = cpt+1;
        end
        
    end
    
    ax.YTickLabel = lbl;
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend({"Inner bounds", "Outer bounds", "Eigenvalues"}, 'Location', 'bestoutside')
    if exist("d1") & exist("d2")
        title("Eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Eigenvalues")
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
    legend({"lambda max", "lambda min", "sigma max", "sigma min", "xmax", "xmin", "zmax", "zmin"}, 'Location', 'best')
    
else
    % Plot Eigenvalue
    fig = figure();
    bisemilogy(eigenvalue, limit)
    
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend({"Inner bounds", "Outer bounds", "Eigenvalues"}, 'Location', 'best')
    
    if exist("d1") & exist("d2")
        title("Eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Eigenvalues")
    end
end


%% Separate graph between positive and Eigenvalue
% if exist("features_limits")
%     nu_max = features_limits(1,:);
%     nu_min = features_limits(2,:);
%     sigma_max = features_limits(3,:);
%     sigma_min = features_limits(4,:);
%     xmax = features_limits(5,:);
%     xmin = features_limits(6,:);
%     zmax =features_limits(7,:);
%     zmin = features_limits(8,:);
%
%     % Plot Eigenvalue
%     figure()
%     subplot(211)
%     semilogy(limit(1:2,:)', "LineWidth", 3)
%     hold on
%     tmp = eigenvalue';
%     tmp(tmp>0) = NaN; % Positive eigenvalue are set at NaN in order to have gaps when we display them
%     semilogy(tmp, "k.")
%     xlabel("Iteration")
%     ylabel("Eigenvalues and bounds")
%     legend("Inferior negative bound", "Superior negative bound", "Eigenvalues")
%
%     if exist("d1") & exist("d2")
%         title("Eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
%     elseif exist("d1")
%         title("Eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
%     elseif exist("d2")
%         title("Eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
%     else
%         title("Eigenvalues)")
%     end
%
%     subplot(212)
%     plot(nu_max, "LineWidth", 2, "Color", [0 0 1])
%     hold on
%     plot(nu_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
%     plot(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
%     plot(sigma_min, "LineWidth", 2, "Color", [0 1 0])
%     plot(xmax, "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
%     plot(xmin, "LineWidth", 2, "Color", [1 0 0])
%     plot(zmax, "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
%     plot(zmin, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
%
%     xlabel("Iteration")
%     ylabel("Intern values of the bounds")
%     legend("nu max", "nu min", "sigma max", "sigma min", "xmax", "xmin", "zmax", "zmin")
%
%     % Plot positive eigenvalue
%     figure()
%     subplot(211)
%     semilogy(limit(4,:)', "LineWidth", 3)
%     hold on
%     semilogy(limit(3,:)', "LineWidth", 3)
%     tmp = eigenvalue';
%     tmp(tmp<0) = NaN; % Eigenvalue are set at NaN in order to have gaps when we display them
%     semilogy(tmp, "k.")
%     xlabel("Iteration")
%     ylabel("Eigenvalues and bounds")
%     legend("Inferior positive bound", "Superior positive bound", "Eigenvalues")
%
%     if exist("d1") & exist("d2")
%         title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
%     elseif exist("d1")
%         title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
%     elseif exist("d2")
%         title("Positive eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
%     else
%         title("Positive eigenvalues)")
%     end
%
%     subplot(212)
%     plot(nu_max, "LineWidth", 2, "Color", [0 0 1])
%     hold on
%     plot(nu_min, "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
%     plot(sigma_max, "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
%     plot(sigma_min, "LineWidth", 2, "Color", [0 1 0])
%     plot(xmax, "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
%     plot(xmin, "LineWidth", 2, "Color", [1 0 0])
%     plot(zmax, "LineWidth", 2, "Color", [0.8500 0.3250 0.0980])
%     plot(zmin, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
%
%     xlabel("Iteration")
%     ylabel("Intern values of the bounds")
%     legend("nu max", "nu min", "sigma max", "sigma min", "xmax", "xmin", "zmax", "zmin")
%
% else
%     % Plot Eigenvalue
%     figure()
%     semilogy(limit(1:2,:)', "LineWidth", 3)
%     hold on
%     tmp = eigenvalue';
%     tmp(tmp>0) = NaN; % Positive eigenvalue are set at NaN in order to have gaps when we display them
%     semilogy(tmp, "k.")
%     xlabel("Iteration")
%     ylabel("Eigenvalues and bounds")
%     legend("Inferior negative bound", "Superior negative bound", "Eigenvalues")
%
%
%     if exist("d1") & exist("d2")
%         title("Eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
%     elseif exist("d1")
%         title("Eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
%     elseif exist("d2")
%         title("Eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
%     else
%         title("Eigenvalues)")
%     end
%
%     % Plot positive eigenvalue
%     figure()
%     semilogy(limit(4,:)', "LineWidth", 3)
%     hold on
%     semilogy(limit(3,:)', "LineWidth", 3)
%     tmp = eigenvalue';
%     tmp(tmp<0) = NaN; % Eigenvalue are set at NaN in order to have gaps when we display them
%     semilogy(tmp, "k.")
%     xlabel("Iteration")
%     ylabel("Eigenvalues and bounds")
%     legend("Inferior positive bound", "Superior positive bound", "Eigenvalues")
%     if exist("d1") & exist("d2")
%         title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
%     elseif exist("d1")
%         title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
%     elseif exist("d2")
%         title("Positive eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
%     else
%         title("Positive eigenvalues)")
%     end
% end
end