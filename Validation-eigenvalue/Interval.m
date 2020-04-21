function limit = Interval(H, A,d2)
% tmp = eig(H); % eigenvalue of H
% lambda_min = min(tmp);
% lambda_max = max(tmp);
% tmp = svds(A); % singular value fo A
% sigma_min = min(tmp);
% sigma_max = max(tmp);
% xmin = min(x);
% xmax = max(x);
% zmin = min(z);
% zmax = max(z);
% nu_max = (lambda_min + d1^2)*xmin + zmin;
% nu_min = (lambda_max + d1^2)*xmax + zmax;
% 
% rho_min_negative = 0.5*( d2^2 - nu_max - ( (nu_max+d2^2)^2 + 4 * sigma_max^2*xmax)^0.5);
% rho_max_negative = min( (lambda_min + d1^2)*xmin , min( d1^2*x + z,[], "all"));
% rho_min_positive = 0.5*( d2^2 - nu_max + ( (nu_max+d2^2)^2 + 4 * sigma_min^2*xmin)^0.5);
% rho_max_positive = 0.5*( d2^2 - nu_min + ( (nu_min+d2^2)^2 + 4 * sigma_max^2*xmax)^0.5);


tmp = eig(H); % eigenvalue of H
lambda_min = min(tmp);
lambda_max = max(tmp);
tmp = svds(A); % singular value fo A
sigma_min = min(tmp);
sigma_max = max(tmp);

rho_min_negative = 0.5 * ( d2^2 - lambda_max - ( (lambda_max+d2^2)^2 + 4*sigma_max )^0.5 );
rho_max_negative = -lambda_min
rho_min_positive = 0.5 * ( d2^2 - lambda_max + ( (lambda_max+d2^2)^2 + 4*sigma_min )^0.5 );
rho_max_positive = 0.5 * ( d2^2 - lambda_min + ( (lambda_min+d2^2)^2 + 4*sigma_max )^0.5 );

limit = [rho_min_negative rho_max_negative ; rho_min_positive rho_max_positive];



end