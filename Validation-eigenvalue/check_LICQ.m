function res = check_LICQ(A, xf, method)
ind = detect_active_inactive_constraint(xf, method);
I = eye(length(xf));
M = [A' I(:,ind)];
r = sprank(M);
s = min(size(M));
res = (r==s);
end