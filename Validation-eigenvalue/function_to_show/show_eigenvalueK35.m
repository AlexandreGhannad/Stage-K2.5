function show_eigenvalueK35(eigenvalue, d1, d2)
figure()
bisemilogy(eigenvalue)
xlabel("Iteration")
ylabel("Eigenvalues")
legend({"Eigenvalues"}, 'Location', 'best')
if exist("d1") & exist("d2")
    title("Eigenvalues (K3.5), (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title("Eigenvalues (K3.5), (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title("Eigenvalues (K3.5), (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title("Eigenvalues (K3.5))")
end
end