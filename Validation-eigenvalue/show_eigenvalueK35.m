function show_eigenvalueK35(eigenvalueK35, d1, d2)
figure()
limit = max(eigenvalue, [], "all");
bisemilogy(eigenvalue, limit)
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
end