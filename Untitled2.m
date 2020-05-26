n1 = 32;

%% Negative eigenvalue
t = eig(full(o.M));
t2 = t(t<0);
t2 = sort(t2);

test = vpa(eig(vpa(full(o.M), n1)), n1);
g = test(test<0);
g = sort(g);

figure(1)
clf(1)
semilogy([0 350], [rho_max_negative rho_max_negative], "Color", [0.8500 0.3250 0.0980], "LineWidth", 2)
hold on
semilogy([0 350], [rho_min_negative rho_min_negative], "Color", [0 0.4470 0.7410], "LineWidth", 2)
semilogy(g, "*", "Color", [0.6350 0.0780 0.1840], "MarkerSize", 7)
semilogy(t2, ".", "Color", [0.4660 0.6740 0.1880], "MarkerSize", 10)

legend("Inner bound", "Outer bound", "Eigenvalues 32 digits", "Standard eigenvalues", "Location", 'northwest')

% r1 = rank(vpa(full(o.M), 16));
% r2 = rank(vpa(full(o.M), n1));
% fprintf("Rank of o.M with 16 digits: %g\n", r1);
% fprintf("Rank of o.M with 32 digits: %g\n", r2);
%% Positive eigenvalue
t = eig(full(o.M));
t2 = t(t>0);
t2 = sort(t2);

test = vpa(eig(vpa(full(o.M), n1)), n1);
g = test(test>0);
g = sort(g);

figure(2)
clf(2)
semilogy([0 350], [rho_max_positive rho_max_positive], "Color", [0.8500 0.3250 0.0980])
hold on
semilogy([0 350], [rho_min_positive rho_min_positive], "Color", [0 0.4470 0.7410])
semilogy(t2, "k.", "MarkerSize", 5)
semilogy(g, "*", "Color", [0.6350 0.0780 0.1840 0.1], "MarkerSize", 5)

legend("Inner bound", "Outer bound", "Eigenvalue 16 digits","Eigenvalue 32 digits", "Location", 'northwest')

% r1 = rank(vpa(full(o.M), 16));
% r2 = rank(vpa(full(o.M), n1));
% fprintf("Rank of o.M with 16 digits: %g\n", r1);
% fprintf("Rank of o.M with 32 digits: %g\n", r2);