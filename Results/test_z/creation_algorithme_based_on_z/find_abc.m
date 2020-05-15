function coef = find_abc(z, n)
Y = log10(z);
len = length(z);
% coef0 = [-1 1 1 1 1];
coef0 = [-1 1 1];
f = @(coef) sum(abs((log10(z) - broken_lines(coef,n,len))));
coef = fminsearch(f, coef0);
end