function show_eigenvalue_theorem2(eigenvalue, features_theorem2, d1, d2, all_features)
if not(exist("all_features"))
    all_features = 0;
end
if all_features
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
    limit = features_theorem2(1:4,:);
    
    figure()
    subplot(221)
    %% bisemilogy copy in order to function inside the subplot
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
    
    ax = subplot(221);
    
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
    %%
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend({"Lower bounds", "Upper bounds", "Eigenvalues"}, 'Location', 'best')
    
    if exist("d1") & exist("d2")
        title("Eigenvalues and bounds (theorem2), (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Eigenvalues and bounds (theorem2), (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Eigenvalues and bounds (theorem2), (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Eigenvalues and bounds (theorem2)")
    end
    
    subplot(222)
    semilogy(abs(lambda_max), "LineWidth", 2, "Color", [0 0 1])
    hold on
    semilogy(abs(lambda_min), "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
    xlabel("Iteration")
    ylabel("Eigenvalue of the hessien matrix")
    legend({"lambda max", "lambda min"}, 'Location', 'best')
    
    if lambda_max == 0 & lambda_min == 0
        title("Eigenvalues are 0")
    end
    
    subplot(223)
    semilogy(abs(sigma_max), "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
    hold on
    semilogy(abs(sigma_min), "LineWidth", 2, "Color", [0 1 0])
    xlabel("Iteration")
    ylabel("Singular value of A")
    legend({"sigma max", "sigma min"}, 'Location', 'best')
    
    subplot(224)
    semilogy(abs(xmax), "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
    hold on
    semilogy(abs(xmin), "LineWidth", 2, "Color", [1 0 0])
    semilogy(abs(x'), "k.")
    xlabel("Iteration")
    ylabel("x and its optimum for inactive bounds")
    legend({"xmax", "xmin", "x"}, 'Location', 'best')
    
else
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
    limit = features_theorem2(1:4,:);
    
    figure()
    %% bisemilogy copy in order to function inside the subplot
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
    
    ax = axes;
    
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
    %%
    xlabel("Iteration")
    ylabel("Eigenvalues and bounds")
    legend({"Lower bounds", "Upper bounds", "Eigenvalues"}, 'Location', 'best')
    
    if exist("d1") & exist("d2")
        title("Eigenvalues and bounds (theorem2), (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
    elseif exist("d1")
        title("Eigenvalues and bounds (theorem2), (d1 = " + sprintf("%7.1e", d1) + ")")
    elseif exist("d2")
        title("Eigenvalues and bounds (theorem2), (d2 = " + sprintf("%7.1e", d2) + ")")
    else
        title("Eigenvalues and bounds (theorem2)")
    end
end
end