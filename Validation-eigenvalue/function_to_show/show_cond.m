function fig = show_cond(cond, limits, d1, d2, cond2, formulation)
% cond is the conditionning of K2.5
% limits are the bounds on the eigenvalue of K2.5
% cond2 is the conditionning of another formulation (ex: K3.5)
% formulation is the name of the other formulation in string (ex: "K3.5")

fig = figure();
semilogy(cond, "k.")
hold on
xlabel("Iteration")
ylabel("conditionning")
title("Evolution of the conditionning")

if exist("limits")
    limit = limits;
    tmp = max(abs(limit)) ./ min(abs(limit));
    tmp(min(abs(limit)) == 0) = NaN;
    semilogy(tmp)
    if ismember(0,limits)
        tmp = 1;
    end
end

if(exist("cond2"))
    semilogy(cond2, "b+")
end

if exist("limits") & exist("cond2")
    if tmp == 1
        legend({"Conditionning", "Bound on the conditionning (Warning: 0 in bounds)",formulation}, 'Location', 'best')
    else
        legend({"Conditionning", "Bound on the conditionning",formulation}, 'Location', 'best')
    end 
elseif exist("limits") & not(exist("cond2"))
    if tmp == 1
        legend({"Conditionning (Warning: 0 in bounds)", "Bound on the conditionning"}, 'Location', 'best')
    else
        legend({"Conditionning", "Bound on the conditionning"}, 'Location', 'best')
    end
elseif not(exist("limits")) & exist("cond2")
    legend({"Conditionning", formulation}, 'Location', 'best')
else
    legend({"Conditionning"}, 'Location', 'best')
end

if exist("d1") & exist("d2")
    title("Evolution of the conditionning, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title("Evolution of the conditionning, (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title("Evolution of the conditionning, (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title("Evolution of the conditionning)")
end
end