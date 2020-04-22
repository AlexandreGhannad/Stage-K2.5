function show_residu(residu, evolution_mu, d1, d2)
figure()
semilogy(residu, "k.")
hold on
semilogy(evolution_mu, "b")
xlabel("Iteration")
ylabel("Complementary residu")

if exist("d1") & exist("d2")
    title("Evolution of the complementary residu, (d1 = " + num2str(d1) + "), (d2 = " + num2str(d2) + ")")
elseif exist("d1")
    title("Evolution of the complementary residu, (d1 = " + num2str(d1) + ")")
elseif exist("d2")
    title("Evolution of the complementary residu, (d2 = " + num2str(d2) + ")")
else
    title("Evolution of the complementary residu)")
end
% text(length(residu)-10, 10, num2str(residu(end)))
end