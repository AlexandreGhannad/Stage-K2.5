function show_cond(cond, limits)
if nargin == 1
    figure()
    semilogy(cond, "k.")
    xlabel("Iteration")
    ylabel("Conditionnement")
    title("Evolution of the conditionnement")
else
    figure()
    tmp = max(abs(limits)) ./ min(abs(limits));
    semilogy(tmp, "LineWidth" , 3)
    hold on
    semilogy(cond, "k.")
    xlabel("Iteration")
    ylabel("Conditionnement")
    title("Evolution of the conditionnement")
    legend("Bounds on the conditionnement", "Conditionnement")
end


end