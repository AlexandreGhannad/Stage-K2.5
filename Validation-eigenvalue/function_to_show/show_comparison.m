function show_comparison(results, formulation, method)
iter1 = results(:,1,1);
iter2 = results(:,1,2);
iter3 = results(:,1,3);
reason1 = results(:,2,1);
reason2 = results(:,2,2);
reason3 = results(:,2,3);
comp_res1 = results(:,3,1);
comp_res2 = results(:,3,2);
comp_res3 = results(:,3,3);
time1 = results(:,4,1);
time2 = results(:,4,2);
time3 = results(:,4,3);
%% Iteration
figure()
[iter1, perm] = sort(iter1);
iter2 = iter2(perm);
iter3 = iter3(perm);
plot(iter1, "k.", "MarkerSize", 30)
hold on
plot(iter2, ".", "MarkerSize", 20, "Color", [0 0.4470 0.7410])
plot(iter3, ".", "MarkerSize", 10, "Color", [0.8500 0.3250 0.0980])
legend(formulation)
ylabel("Iteration")
title("Comparison of iteration (" + method + ")");
%% Time
figure()
[time1, perm] = sort(time1);
time2 = time2(perm);
time3 = time3(perm);
plot(time1, "k.", "MarkerSize", 15, "Color", [0.4660 0.6740 0.1880])
hold on
plot(time2, ".", "MarkerSize", 15, "Color", [0 0.4470 0.7410])
plot(time3, ".", "MarkerSize", 15, "Color", [0.8500 0.3250 0.0980])
legend(formulation)
ylabel("Time")
title("Comparison of execution time (" + method + ")");
%% Residu
figure()
[comp_res1, perm] = sort(comp_res1);
comp_res2 = comp_res2(perm);
comp_res3 = comp_res3(perm);
plot(comp_res1, "k.", "MarkerSize", 30)
hold on
plot(comp_res2, ".", "MarkerSize", 20, "Color", [0 0.4470 0.7410])
plot(comp_res3, ".", "MarkerSize", 10, "Color", [0.8500 0.3250 0.0980])
legend(formulation)
ylabel("Complementary residu")
title("Comparison of execution time (" + method + ")");
%% Reason of arrest
figure()
[reason1, perm] = sort(reason1);
reason2 = reason2(perm);
reason3 = reason3(perm);
plot(reason1, "k.", "MarkerSize", 30)
hold on
plot(reason2, ".", "MarkerSize", 20, "Color", [0 0.4470 0.7410])
plot(reason3, ".", "MarkerSize", 10, "Color", [0.8500 0.3250 0.0980])
legend(formulation)
ylabel("Reason of arrest")
title("Comparison of execution time (" + method + ")");



end