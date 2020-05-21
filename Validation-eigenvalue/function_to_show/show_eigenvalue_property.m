function fig = show_eigenvalue_property(eigenvalue, limit, d1, d2, features_property)

if exist("features_property")
    lambda_max = features_property(1,:);
    lambda_min = features_property(2,:);
    sigma_max = features_property(3,:);
    sigma_min = features_property(4,:);
    delta = features_property(5,:);
    
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
    plot(pos, "k.", "MarkerSize", 15)
    plot(neg, "k.", "MarkerSize", 15)
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
    legend({"Lower bounds", "Upper bounds", "Eigenvalues"}, 'Location', 'bestoutside')
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
    semilogy(delta, "LineWidth", 2, "Color", [0.9290 0.6940 0.1250])
    
    xlabel("Iteration")
    ylabel("Intern values of the bounds")
    legend({"lambda max", "lambda min", "sigma max", "sigma min", "delta"}, 'Location', 'best')
    
else
    % Plot Eigenvalue
    fig = figure();
    bisemilogy(eigenvalue, limit)
    
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend({"Lower bounds", "Upper bounds", "Eigenvalues"}, 'Location', 'best')
    
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




end