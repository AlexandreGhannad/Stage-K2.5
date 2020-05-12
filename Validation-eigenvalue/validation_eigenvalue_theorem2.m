function [eigenvalue, features_theorem2] = validation_eigenvalue_theorem2(o)
% Calculate the bounds with the theorem 1
%% Save different values
xmax = max(abs(o.x));
ind = detect_active_inactive_constraint(o.x, o.method);
A = o.A(:,ind);
hess_eigen = eigs(o.hess(ind, ind), size(o.hess(ind, ind), 1));
xmin = min(abs([o.x1(ind) ;  o.x2(ind)] ));


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
features_theorem2 = [ rho_min_negative;rho_max_negative;rho_min_positive;rho_max_positive;...
    lambda_max; lambda_min; sigma_max; sigma_min; xmax; xmin;o.x; o.z1-o.z2];
    
%     [lambda_max lambda_min sigma_max sigma_min xmax xmin]

eigenvalue = eigs(o.M, size(o.M,1));
end