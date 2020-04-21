function show_eigenvalue(eigenvalue, limits)
% Plot negative eigenvalue
figure()
semilogy(limits(1:2,:)', "LineWidth", 3)
hold on
tmp = eigenvalue';
tmp(tmp>0) = NaN; % Positive eigenvalue are set at NaN in order to have gaps when we display them
semilogy(tmp, "k.")
title("Validation of the negative eigenvalue (semilog scale)")
xlabel("Iteration")
ylabel("Eigenvalue and Bounds")
legend("Inferior negative bound", "Superior negative bound", "Eigenvalue")

% Plot positive eigenvalue
figure()
semilogy(limits(3:4,:)', "LineWidth", 3)
hold on
tmp = eigenvalue';
tmp(tmp<0) = NaN; % Negative eigenvalue are set at NaN in order to have gaps when we display them
semilogy(tmp, "k.")
title("Validation of the positive eigenvalue (semilog scale)")
xlabel("Iteration")
ylabel("Eigenvalue and Bounds")
legend("Inferior positive bound", "Superior positive bound", "Eigenvalue")

end