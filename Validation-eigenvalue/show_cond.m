function show_cond(cond, limits, d1, d2, cond2, formulation)

figure()
semilogy(cond, "k.")
xlabel("Iteration")
ylabel("conditionning")
title("Evolution of the conditionning")

if not(isempty(limits))
    hold on
    tmp = max(abs(limits)) ./ min(abs(limits));
    semilogy(tmp)
end

if(exist("cond2"))
    hold on
    semilogy(cond2, "b+")
end

if not(isempty(limits)) & exist("cond2")
    legend("Conditionning", "Bound on the conditionning",formulation)
elseif not(isempty(limits)) & not(exist("cond2"))
    legend("Conditionning", "Bound on the conditionning")
elseif isempty(limits) & exist("cond2")
    legend("Conditionning", formulation)
else
    legend("Conditionning")
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