% Respect of the LICQ is based on A and the active and inactive constraint
% of A. Created the matrice [A I] with I the matrix identity of the active
% constraint, and check if the LICQ is verified.
% The result depends on the chosen method to decide if a constraint is
% active or not.

function res = check_LICQ(A, xf, method)
ind = detect_active_inactive_constraint(xf, method);
I = eye(length(xf));
M = [A' I(:,ind)];
r = sprank(M);
s = min(size(M));
res = (r==s);
end