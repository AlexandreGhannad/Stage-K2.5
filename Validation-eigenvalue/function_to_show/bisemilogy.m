function bisemilogy(eigenvalue, limit)
if exist("limit")
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
    
else
    pos = eigenvalue';
    pos(pos<=0) = NaN;
    pos = log10(pos);
    neg = eigenvalue';
    neg(neg>=0) = NaN;
    neg = -log10(-neg);    
    
    l1 = max(max(log10(abs(eigenvalue(eigenvalue~=0))), [], "all"));
    l2 = min(min(log10(abs(eigenvalue(eigenvalue~=0))), [], "all"));
    l1 = 2*ceil(l1/2);
    l2 = 2*floor(l2/2);
    L = l1 + abs(l2)+2;
    pos = pos + abs(l2)+2;
    neg = neg - abs(l2)-2;
   
    ax = axes;
    
    hold on
    plot(pos, "k.", "MarkerSize", 15)
    plot(neg, "k.", "MarkerSize", 15)
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
    
end

end