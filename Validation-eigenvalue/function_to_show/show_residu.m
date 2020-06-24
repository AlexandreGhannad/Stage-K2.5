% Display the residu and the evolution of mu, a variabe linked to the limit
% of the residu inside the formulation.
% d1 and d2 are optionnal and given in the title of the graphic if they are
% given.

function fig = show_residu(residu, evolution_mu, d1, d2)
fontsize = 35;
fig = figure();
set(fig, "WindowState", "maximized")
semilogy(residu, "k.")
hold on
semilogy(evolution_mu, "b")
xlabel("Iteration", 'FontSize', fontsize)
ylabel("Complementary residu", 'FontSize', fontsize)

if exist("d1") & exist("d2")
    title("Evolution of the complementary residu, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
elseif exist("d1")
    title("Evolution of the complementary residu, (d1 = " + sprintf("%7.1e", d1) + ")", 'FontSize', fontsize)
elseif exist("d2")
    title("Evolution of the complementary residu, (d2 = " + sprintf("%7.1e", d2) + ")", 'FontSize', fontsize)
else
    title("Evolution of the complementary residu)")
end
end