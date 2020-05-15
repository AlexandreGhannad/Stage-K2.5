function [result, eigenvalue, limit, rapport, err, lambda_max, lambda_min, sigma_max, sigma_min, xmax, xmin, zmax, zmin] = validation_eigenvalue(o, options)
% Calculate the bounds with the theorem 1
%% Save different values
d1 = o.d1;
d2 = o.d2;

A = o.A;
hess_eigen = eigs(o.hess, size(o.hess, 1));

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

%% Calcul of the bounds

eta_max = (lambda_max + d1^2) * xmax + zmax;
eta_min = (lambda_min + d1^2) * xmin + zmin;

rho_min_negative = 0.5 * ( o.d2^2 - eta_max - ( (eta_max+o.d2^2)^2 + 4*xmax * sigma_max^2 )^0.5 );
rho_max_negative = -max( eta_min - zmin , min((d1^2)*x+z));
rho_min_positive = 0.5 * ( d2^2 - eta_max + ( (eta_max+d2^2)^2 + 4*xmin * sigma_min^2 )^0.5 );
rho_max_positive = 0.5 * ( d2^2 - eta_min + ( (eta_min+d2^2)^2 + 4*xmax * sigma_max^2 )^0.5 );
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


if o.check_limits
    o.xmem = [o.xmem o.x];
    o.zmem = [o.zmem z];
end

end