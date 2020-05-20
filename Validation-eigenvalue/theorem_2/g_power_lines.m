function [Cf,err] = g_power_lines(z,n)
obj = @(C) sum(abs(log10(z')-f_power_lines(length(z), C)));
bl = [-Inf -Inf -Inf -Inf -Inf 1];
bu = [Inf Inf Inf Inf Inf length(z)];
options = optimoptions('fmincon','Display','off');
Cf = fmincon(obj,[1 1 1 1 1 n],[],[],[],[],bl,bu,[], options);
err = obj(Cf);
end