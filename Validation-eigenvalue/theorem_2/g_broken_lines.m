function Cf = g_broken_lines(z,n)
obj = @(C) sum(abs(log10(z)-f_broken_lines(length(z), C)));
bl = [-Inf -Inf -Inf 1];
bu = [Inf Inf Inf length(z)];
Cf = fmincon(obj,[1 1 1 n],[],[],[],[],bl,bu)
end