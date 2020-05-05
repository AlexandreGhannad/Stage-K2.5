function [result, eigenvalue, limit, rapport, err, lambda_max, lambda_min, sigma_max, sigma_min] = validation_eigenvalue_theorem2(o)
% Calculate the bounds with the theorem 1
%% Save different values
A = o.A;
hess_eigen = eigs(o.hess);
xmax = max(abs(o.x));
zmax = max(o.z1-o.z2);

xmin = min(abs(o.x));


% Maximal and minimal eigenvalue of H
lambda_max = max(hess_eigen);
lambda_min = min(hess_eigen);
% Maximal and minimal singular value of H
sigma_max = svds(A,1, "largest");
sigma_min = svds(A,1, "smallest");

%% Insure that variables aren't NaN
cpt = 1;
while(isnan(sigma_min))
    sigma_min = min(svds(A, cpt * 20, "smallest"), [], "all");
    cpt = cpt+1;
end

cpt = 1;
while(isnan(sigma_max))
    sigma_max = max(svds(A, cpt * 20, "largest"), [], "all");
    cpt = cpt+1;
end

cpt = 1;
while(isnan(lambda_min))
    lambda_min = min(eigs(H, cpt * 20, "smallestab"), [], "all");
    cpt = cpt+1;
end

cpt = 1;
while(isnan(lambda_max))
    lambda_max = max(eigs(H, cpt * 20, "largestab"), [], "all");
    cpt = cpt+1;
end

%% Calcul of the bounds

eta_max = (lambda_max + o.d1^2) * xmax;
eta_min = (lambda_min + o.d1^2) * xmin;

rho_min_negative = 0.5 * ( o.d2^2 - eta_max - ( (eta_max+o.d2^2)^2 + 4*xmax * sigma_max^2 )^0.5 );
rho_max_negative = -eta_min;
rho_min_positive = 0.5 * ( o.d2^2 - eta_max + ( (eta_max+o.d2^2)^2 + 4*xmin * sigma_min^2 )^0.5 );
rho_max_positive = 0.5 * ( o.d2^2 - eta_min + ( (eta_min+o.d2^2)^2 + 4*xmax * sigma_max^2 )^0.5 );
limit = [rho_min_negative;rho_max_negative;rho_min_positive;rho_max_positive];

eigenvalue = eigs(o.M, size(o.M,1));

test_inf = eigenvalue > rho_min_negative & eigenvalue < rho_max_negative;
test_sup = eigenvalue > rho_min_positive & eigenvalue < rho_max_positive;
result = test_inf | test_sup;

indice  =  find(result == 0);
err = zeros(size(o.M,1),1);
err(indice) = min([(eigenvalue(indice) - rho_min_negative).^2 ...
        (eigenvalue(indice) - rho_max_negative).^2 ...
        (eigenvalue(indice) - rho_min_positive).^2 ...
        (eigenvalue(indice) - rho_max_positive).^2 ], [] , 2);
err = sparse(err);

indice = abs(err) < 10^-14;
result(indice) = 1;
rapport = sum(result) / length(result);
end