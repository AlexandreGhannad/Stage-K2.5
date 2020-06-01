% Display the residu and the evolution of mu, a variabe linked to the limit
% of the residu inside the formulation.
% d1 and d2 are optionnal and given in the title of the graphic if they are
% given.

function fig = show_residu(residu, evolution_mu, d1, d2)
fig = figure();
semilogy(residu, "k.")
hold on
semilogy(evolution_mu, "b")
xlabel("Iteration")
ylabel("Complementary residu")

if exist("d1") & exist("d2")
    title("Evolution of the complementary residu, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title("Evolution of the complementary residu, (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title("Evolution of the complementary residu, (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title("Evolution of the complementary residu)")
end
end