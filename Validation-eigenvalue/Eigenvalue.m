function eigenvalue = Eigenvalue(H, A,d2)
if isscalar(d2)
    D2 = d2 * eye(size(A,1));
else
    D2 = diag(d2);
end
% K = [-X*(H+D1.^2)*X-Z X*A' ; A*X D2.^2];
K = [-H A' ; A D2.^2];
eigenvalue = eig(K);
end