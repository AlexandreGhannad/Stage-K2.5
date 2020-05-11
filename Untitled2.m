load("results"+num2str(1)+".mat")
res = zeros(size(results));
for i = 1 : 10
    load("results"+num2str(i)+".mat");
    res = res + results;
end
res= res/10;
formulation = {formulation1 formulation2 formulation3};
method = solver;
show_comparison(res, formulation, method)
