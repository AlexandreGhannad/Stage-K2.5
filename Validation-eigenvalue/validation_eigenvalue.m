% Calculate eigenvalues and bounds of the theorem 1.
% More variables to evaluate the resultats can be asked.
% The input is the all pdcoO object (o)
% Depending on the different options of pdcoO, some results are calulated
% or not
% Output:
% result: list of booleans, says if the corresponding eigenvalues is inside
%         the bounds or not
% eigenvalue: eigenvalues of o.M
% limit: theoritical bounds on the eigenvalues from the theorem 1
% rapport: rapport of the number of eigenvalue inside the bounds on the 
%          total number of eigenvalues (rapport should be equal to one)
% err: vector of the error one the bounds. The value is 0 if the eigenvalue
%      is inside the bounds, and eigenvalue - the nearer bounds in the
%      other case
% lambda_max, lambda_min, sigma_max, sigma_min, xmax, xmin, zmax, zmin: 
%     components of the calculation of the bounds
% 
% Note: there is a scaling of x, z, the hessien and some other variables.
% So, some inside values (like d1 and d2), are different from the inputs.

function [result, eigenvalue, limit, rapport, err, lambda_max, lambda_min, sigma_max, sigma_min, xmax, xmin, zmax, zmin] = validation_eigenvalue(o)
%% Save different values to calculate the bounds
d1 = o.d1;
d2 = o.d2;

A = o.A;
hess = eigs(o.hess, size(o.hess, 1));

x1s = o.x1;
x2s = o.x2;
x = ones(size(x1s));
x(o.low) = x(o.low) .* x1s(o.low);
x(o.upp) = x(o.upp) .* x2s(o.upp);

x1z2 = zeros(o.n,1);
x1z2(o.upp) = o.z2(o.upp);
x1z2(o.low) = x1z2(o.low) .* o.x1(o.low);

x2z1 = zeros(o.n,1);
x2z1(o.low) = o.z1(o.low);
x2z1(o.upp) = x2z1(o.upp) .* o.x2(o.upp);

z = x2z1+x1z2;

xmin = min(x);
xmax = max(x);
zmin = min(z);
zmax = max(z);

% Maximal and minimal eigenvalues of H
lambda_max = max(hess);
lambda_min = min(hess);
% Maximal and minimal singular values of A
sigma_max = max(svds(A,10, "largest"));
sigma_min = min(svds(A,10, "smallest"));
%% Insure that variables aren't NaN
% Use the method smallest and largest with svd could lead to NaN value.
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
%% Calcul of the bounds
% Follow theorem 1
eta_max = (lambda_max + d1^2) * xmax + zmax;
eta_min = (lambda_min + d1^2) * xmin + zmin;

rho_min_negative = 0.5 * ( d2^2 - eta_max - sqrt( (eta_max+d2^2)^2 + 4*xmax * sigma_max^2 ) );
rho_max_negative = -max( eta_min - zmin , min((d1^2)*x+z));
if rank(full(o.A)) < size(o.A, 1)  % A does not have full row rank
    rho_min_positive = o.d2^2;
else
    rho_min_positive = 0.5 * ( d2^2 - eta_max + ( (eta_max+d2^2)^2 + 4*xmin * sigma_min^2 )^0.5 );
end
rho_max_positive = 0.5 * ( d2^2 - eta_min + ( (eta_min+d2^2)^2 + 4*xmax * sigma_max^2 )^0.5 );
% Register bounds inside the variable lmits in croissant order.
limit = [rho_min_negative;rho_max_negative;rho_min_positive;rho_max_positive];

% Possibility to increase the precision on the calculation of the
% eigenvalue of o.M. High cost in term of execution time
if isempty(o.digit_number)
    eigenvalue = eigs(o.M, size(o.M,1));
else
    eigenvalue = vpa(eig(vpa(full(o.M), o.digit_number)), o.digit_number);
end
if norm(imag(eigenvalue)) < norm(eigenvalue) * 10^-8
    eigenvalue = real(eigenvalue);
end
%% Creation of some results to evaluate the theorem
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

if o.check_limits
    o.xmem = [o.xmem o.x];
    o.zmem = [o.zmem z];
end
end