function show_residu(residu, evolution_mu)
figure()
semilogy(residu, "k.")
hold on
semilogy(evolution_mu, "b")
xlabel("Iteration")
ylabel("Complementary residu")
title("Evolution of the complementary residu")
% text(length(residu)-10, 10, num2str(residu(end)))
end