function show_residu(residu)
figure()
semilogy(residu, "k.")
xlabel("Iteration")
ylabel("Complementary residu")
title("Evolution of the complementary residu")
% text(length(residu)-10, 10, num2str(residu(end)))
end