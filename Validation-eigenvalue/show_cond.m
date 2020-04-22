function show_cond(cond, limits, d1, d2)

figure()
semilogy(cond, "k.")
xlabel("Iteration")
ylabel("conditionning")
title("Evolution of the conditionning")

if exist("limits")
    hold on
    tmp = max(abs(limits)) ./ min(abs(limits));
    semilogy(tmp)
    legend("Bounds on the conditionning", "conditionning")
end

if exist("d1") & exist("d2")
    title("Evolution of the conditionning, (d1 = " + num2str(d1) + "), (d2 = " + num2str(d2) + ")")
elseif exist("d1")
    title("Evolution of the conditionning, (d1 = " + num2str(d1) + ")")
elseif exist("d2")
    title("Evolution of the conditionning, (d2 = " + num2str(d2) + ")")
else
    title("Evolution of the conditionning)")
end



end