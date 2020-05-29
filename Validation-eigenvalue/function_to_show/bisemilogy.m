% Create a graphic biesmilogy specific for a figure without subplot.
% For more general use, see bisemilogy_general
% A bisemilogy graphic is a graphic in logarythmic scale on ordinate but
% linear on abscissa. An axe with zero value is fixed on the center of the
% graphic. It allows to separate and display at the same time positive and
% negative eigenvalue.
%
% Warning: values on this axes correspond to real
% zeros. But there is a blank space between the zero axe and the lowest
% values. Because of some manipulation, these blank space doesn't have any
% mathematical sense, but is mandatory to have at the same time positive,
% negative and zero values.
% For example, with values going from 10^-7 to 10^2 in absolute value, and
% some zeros values, you will have zeros value on the center and a blank
% values between those zeros values and the values at 10^-7

function bisemilogy(eigenvalue, limit)
transparency = 0.7; % allow to set the transparency of the bounds

if exist("limit")
    % Allocation: distinction of the positive and negative values and 
    pos = eigenvalue';
    pos(pos<=0) = NaN;
    neg = eigenvalue';
    neg(neg>=0) = NaN;
    
    % Logarythmic scale on values
    pos = log10(pos);
    neg = -log10(-neg);
    rmm = -log10(abs(limit(1,:)));
    rMm = -log10(abs(limit(2,:)));
    rmp = log10(abs(limit(3,:)));
    rMp = log10(abs(limit(4,:)));
    
    % Now, values are between l2 and l1 in magnitude, with l2 and l1 minimal
    % and maximum exponents of the values. l1 and l2 are after round to the 
    % nearer mutliple of 2. Later, it will allow to graduate by 100 the ordinate  
    l1 = max(max(log10(abs(eigenvalue(eigenvalue~=0))), [], "all"), max(log10(abs(limit(limit~=0))), [], "all"));
    l2 = min(min(log10(abs(eigenvalue(eigenvalue~=0))), [], "all"), min(log10(abs(limit(limit~=0))), [], "all"));
    l1 = 2*ceil(l1/2);
    l2 = 2*floor(l2/2);
    % For example, if values goes from 10^-7 to 10^2, we currently have:
    % l2 = -8, l1 = +2
    
    % We have to separate positive and negative values.
    % Problem, lowest positive values are currently negative (+l2) and, on
    % the contrary, lowest (in magnitude) negative values are positive
    % (-l2)
    % To separate them, we increase all the positive values by |l2|, and
    % decrease the nagative values by -|l2|
    % However, lowest positive and negative value could still be at the
    % same value 0. To insure the separation, we increase the positive
    % values (and decrease the negative values) by 2.
    L = l1 + abs(l2)+2; % Variable useful to set the limit of the ordinate
    pos = pos + abs(l2)+2;
    neg = neg - abs(l2)-2;
    rmp = rmp + abs(l2)+2;
    rMp = rMp + abs(l2)+2;
    rmm = rmm - abs(l2)-2;
    rMm = rMm - abs(l2)-2;
    % l2 = -8, l1 = +2, L = 12
    
    % In the case of the utilisation of semilogy, only bounds could be
    % zeros. In this case, their value become Inf (because log(0) = Inf in
    % matlab). Those zeros bounds are reset at 0: on the graphics, they
    % will be on the center axe.    
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
    
    % Currently, zero values are 0 (even after the logarythmic scaling) and
    % l2 (the rounded limit to the lowest values in magnitude) is
    % equivalent to 2.
    
    ax = axes;
    
    hold on
    plot(rmp, "LineWidth", 3, "Color", [0.9290 0.6940 0.1250 transparency])
    plot(rMp, "LineWidth", 3, "Color", [0 0.4470 0.7410 transparency])
    plot(rmm, "LineWidth", 3, "Color", [0 0.4470 0.7410 transparency])
    plot(rMm, "LineWidth", 3, "Color", [0.9290 0.6940 0.1250 transparency])
    plot(pos, "k.", "MarkerSize", 5)
    plot(neg, "k.", "MarkerSize", 5)
    ax.XAxisLocation = 'origin';
    
    % Treatment of the ordinate:
    % All values are 0 (if they are trully 0), between 2 and L (if they are
    % positive), or between -L and -2 if they are negative.
    % So ordinate are set.
    ylim([-L L]);
    ax.YTick=-L:2:L;
    % Currently, the function doesn't do anything: values display
    % correspond to the current ordinate. But the function will change the
    % ordinate. Actually, the value 2 is equivalent to l2, the rounded
    % limit of the loggarythmic scaled values. So, the 2in ordinate is
    % equivalent to 10^l2 in the original data. With the same idea, L is
    % equivalent to 10^(l1+2).
    % Ordinate are changed to be those new values, from 10^l2 to 10^(l1+2)
    % for positive values (10^(l1+2) to 10^l2 for negative)
    
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
    % Same metodoly than before, but without the treatment of bounds.
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
    plot(pos, "k.", "MarkerSize", 5)
    plot(neg, "k.", "MarkerSize", 5)
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