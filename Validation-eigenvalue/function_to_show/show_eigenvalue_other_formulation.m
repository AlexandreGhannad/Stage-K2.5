% Display the eigenvalues of a formulation on a bisemilogy graphics. No
% bounds required
% eigenvalues: double array with the eigenvalues of the formulation
% name_problem: string variable, name of the proble (ex: "afiro")
% formulation: string variable, name of the formulation (ex: "K3.5")
% d1, d2 (optional): values given to the regulation d1 and d2 in the
% formulation (usually the variables options_pdco.d1 and options_pdco.d2)


function fig = show_eigenvalue_other_formulation(eigenvalue, name_problem, formulation, d1, d2)
fig = figure();
set(fig, "WindowState", "maximized")
bisemilogy(eigenvalue)
xlabel("Iteration")
ylabel("Eigenvalues")
legend("Eigenvalues", 'Location', 'best')
if exist("d1") & exist("d2")
    title(name_problem + " ("+formulation+"), (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title(name_problem + " ("+formulation+"), (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title(name_problem + " ("+formulation+"), (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title(name_problem + " ("+formulation+")")
end
end