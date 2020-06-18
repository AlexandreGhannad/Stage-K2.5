% Display graphics on the evolution of the conditionning for K2.5.
% Input:
% cond: conditionning of the formultion (for a pdcoO object o, 
% cond = o.cond)
% limit (optional): bounds of the eigenvalue (limits = o.limit)
% d1, d2 (optional): value of d1 and d2 use inside the resolution
% (usually, should be options_pdco.d1 and options_pdco.d2)
% cond2 (optional): conditionning of another formulation, to compare with
% the first conditionning.
% formulation (optional, must be put with cond2): string, name of the
% second formulation in oprder to indicate it inside the legend and the
% title (example: formulation = "K3.5").


function fig = show_cond(cond, limit, d1, d2, cond2, formulation2, cond3, formulation3, cond4, formulation4)
fontsize = 18;
% Display the conditionning of K2.5
fig = figure();
set(fig, "WindowState", "maximized")
semilogy(cond, "k.")
hold on
xlabel("Iteration", 'FontSize', fontsize)
ylabel("conditionning", 'FontSize', fontsize)
title("Evolution of the conditionning", 'FontSize', fontsize)

% Display the theoritical limit if it is given
if exist("limits") & not(isempty(limits))
    limit = limit;
    tmp = max(abs(limit)) ./ min(abs(limit));
    % If they are 0 for the lowest bounds, it could lead to infinite value
    % for the bouds of the conditionning. in this case, the bound isn't
    % displayed    
    tmp(min(abs(limit)) == 0) = NaN;
    semilogy(tmp)
    if ismember(0,limit)
        tmp = 1;    % The variable tmp now registers if a bound was 0
    else
        tmp = 0;
    end
end

% Display the second conditionning if it exists
if(exist("cond2"))
    semilogy(cond2, "b+")
end

% Display the legend
if exist("limits") & exist("cond2")
    if tmp == 1
        % If bounds have a zero, add a warning to the legend
        legend({"Conditionning", "Bound on the conditionning (Warning: 0 in bounds)",formulation2}, 'Location', 'best')
    else
        legend({"Conditionning", "Bound on the conditionning",formulation2}, 'Location', 'best')
    end 
elseif exist("limits") & not(exist("cond2"))
    if tmp == 1
        % If bounds have a zero, add a warning to the legend
        legend({"Conditionning (Warning: 0 in bounds)", "Bound on the conditionning"}, 'Location', 'best')
    else
        legend({"Conditionning", "Bound on the conditionning"}, 'Location', 'best')
    end
elseif not(exist("limits")) & exist("cond2")
    legend({"Conditionning", formulation2}, 'Location', 'best')
else
    legend({"Conditionning"}, 'Location', 'best')
end

% Display the title
if exist("d1") & exist("d2")
    title("Evolution of the conditionning, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
elseif exist("d1")
    title("Evolution of the conditionning, (d1 = " + sprintf("%7.1e", d1) + ")", 'FontSize', fontsize)
elseif exist("d2")
    title("Evolution of the conditionning, (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
else
    title("Evolution of the conditionning)", 'FontSize', fontsize)
end
end