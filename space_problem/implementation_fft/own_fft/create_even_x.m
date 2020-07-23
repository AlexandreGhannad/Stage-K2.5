function xtilde = create_even_x(x)
if size(x,2) == 1
    n = ( length(x) - 1 ) / 2;
    n2 = 2^nextpow2(n);
    xtilde = zeros(2*n2+1, 1);
    xtilde(n2-n+1:n2+n+1) = x;
else
    n = ( length(x) - 1 ) / 2;
    n2 = 2^nextpow2(n);
    xtilde = zeros(2*n2+1);
    xtilde(n2-n+1:n2+n+1, n2-n+1:n2+n+1) = x;
end
end