function [xtilde, p] = create_even_x(x)
n = ( size(x,1) - 1 ) / 2;
p = nextpow2(n);
n2 = 2^p;
if size(x,2) == 1
    xtilde = zeros(2*n2+1, 1);
    xtilde(n2-n+1:n2+n+1) = x;
else
    xtilde = zeros(2*n2+1);
    xtilde(n2-n+1:n2+n+1, n2-n+1:n2+n+1) = x;
end
p = p+1;
end