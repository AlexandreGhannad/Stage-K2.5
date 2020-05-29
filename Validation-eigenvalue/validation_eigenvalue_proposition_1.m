% Calculate eigenvalues and bounds of the property 1.
% The input is the all pdcoO object (o)
% Output:
% features_property: value of the property 1 bounds and of the components
% of the bounds.
% eigenvalue: eigenvalues of o.M (optional)


function [features_property, eigenvalue] = validation_eigenvalue_proposition_1(o)
%% Allocation of variables
H = - o.M(1:o.n,1:o.n);
A = o.M(o.n+1:end, 1:o.n);
Delta = diag(o.M(o.n+1:end, o.n+1:end));
% Maximal and minimal eigenvalue of H
lambda_max = eigs(H,1, "largestab");
lambda_min = eigs(H,1, "smallestabs");
% Maximal and minimal singular value of H
sigma_max = svds(A,1, "largest");
sigma_min = svds(A,1, "smallest");
%% Insure that variables aren't NaN
% Use the method smallest and largest with svd or eigs could lead to NaN values.
% Use loop to insure non NaN values on sigma_max and sigma_min.

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
%% Calcul of bounds for eigenvalue
delta = max(Delta);
rho_min_negative = 0.5 * ( delta - lambda_max - ( (lambda_max+delta)^2 + 4*sigma_max^2 )^0.5 );
rho_max_negative = -lambda_min;
rho_min_positive = 0.5 * ( delta - lambda_max + ( (lambda_max+delta)^2 + 4*sigma_min^2 )^0.5 );
rho_max_positive = 0.5 * ( delta - lambda_min + ( (lambda_min+delta)^2 + 4*sigma_max^2 )^0.5 );
limit = [rho_min_negative;rho_max_negative;rho_min_positive;rho_max_positive];

% calculation of the eigenvalues in the case that the property 1 is used
% without comparison with theorem 1
if not(o.check_eigenvalue)
    eigenvalue = eigs(o.M, size(o.M,1));
end
% Register results
features_property = [limit; lambda_max; lambda_min; sigma_max; sigma_min; delta];
end