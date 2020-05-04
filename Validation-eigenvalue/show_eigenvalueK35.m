function show_eigenvalueK35(eigenvalueK35, d1, d2)
% Plot negative eigenvalue
figure()
tmp = eigenvalueK35';
tmp(tmp>0) = NaN; % Positive eigenvalue are set at NaN in order to have gaps when we display them
semilogy(tmp, "k.")
xlabel("Iteration")
ylabel("Eigenvalues")
legend("Eigenvalues")
if exist("d1") & exist("d2")
    title("Negative eigenvalues (K3.5), (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title("Negative eigenvalues (K3.5), (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title("Negative eigenvalues (K3.5), (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title("Negative eigenvalues (K3.5))")
end

% Plot positive eigenvalue
figure()
tmp = eigenvalueK35';
tmp(tmp<0) = NaN; % Negative eigenvalue are set at NaN in order to have gaps when we display them
semilogy(tmp, "k.")
xlabel("Iteration")
ylabel("Eigenvalues")
legend("Eigenvalues")
if exist("d1") & exist("d2")
    title("Positive eigenvalues (K3.5), (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title("Positive eigenvalues (K3.5), (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title("Positive eigenvalues (K3.5), (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title("Positive eigenvalues (K3.5))")
end

end