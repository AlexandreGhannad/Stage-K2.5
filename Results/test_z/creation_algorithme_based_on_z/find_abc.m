function coef = find_abc(z, n, method, coef0)
Y = log10(z);
len = length(z);
if not(exist("method"))
    method = "broken_lines"
end
switch method
    case "broken_lines"
        if not(exist("coef0"))
            coef0 = [-1 1 1];
        end
        f = @(coef) sum(abs((log10(z) - broken_lines(coef,n,len))));
        coef = fminsearch(f, coef0);
        
    case "power_lines"
        if not(exist("coef0"))
            coef0 = [1 1 1 1 1];
        end
        f = @(coef) sum(abs((log10(z) - power_lines(coef,n,len))));
        coef = fminsearch(f, coef0);
        
    case "normal_power_lines"
        if not(exist("coef0"))
            coef0 = [1 1 1 1 1];
        end
        f = @(coef) sum(abs((log10(z) - normal_power_lines(coef,n,len))));
        coef = fminsearch(f, coef0);
        
end