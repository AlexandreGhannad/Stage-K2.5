function coef = find_abc(z, n, method)
Y = log10(z);
len = length(z);
if not(exist("method"))
    method = "broken_lines"
end
switch method
    case "broken_lines"
        coef0 = [-1 1 1];
        f = @(coef) sum(abs((log10(z) - broken_lines(coef,n,len))));
        coef = fminsearch(f, coef0);
        
    case "broken_lines_and_laplace"
        coef0 = [-1 1 1 1 1];
        f = @(coef) sum(abs((log10(z) - broken_lines_and_laplace(coef,n,len))));
        coef = fminsearch(f, coef0);
        
    case "broken_lines_with_weight"
        if n-30 > 1 & n+30 < len
            d = ones(size(z));
            d(n-30:n-10) = 10^-10;
            d(n+10:n+30) = 10^-10;
            coef0 = [-1 1 1];
            f = @(coef) sum(abs(d.*(log10(z) - broken_lines(coef,n,len))));
            coef = fminsearch(f, coef0);
        else
            coef = [NaN NaN NaN];
        end
        
    case "broken_lines_and_laplace_with_weight"
        if n-30 > 1 & n+30 < len
            d = ones(size(z));
            d(n-30:n-20) = 10;
            d(n+20:n+30) = 10;
            coef0 = [-1 1 1 1 1];
            f = @(coef) sum(abs(d.*(log10(z) - broken_lines_and_laplace(coef,n,len))));
            coef = fminsearch(f, coef0);
        else
            coef = [NaN NaN NaN NaN NaN];
        end
        
    case "power_lines"
        coef0 = [1 1 1 1 1];
        f = @(coef) sum(abs((log10(z) - power_lines(coef,n,len))));
        coef = fminsearch(f, coef0);
        
    case "power_lines_with_hole"
        coef0 = [1 1 1 1 1];
        d = ones(size(z));
        d(n-5:n+5) = 0;
        f = @(coef) sum(abs(d.*(log10(z) - power_lines(coef,n,len))));
        coef = fminsearch(f, coef0);
        
    case "power_lines_L2"
        coef0 = [1 1 1 1 1];
        f = @(coef) norm(log10(z) - power_lines(coef,n,len));
        coef = fminsearch(f, coef0);
        
    case "normal_power_lines"
        coef0 = [1 1 1 1 1];
        f = @(coef) sum(abs((log10(z) - normal_power_lines(coef,n,len))));
        coef = fminsearch(f, coef0);
        
end