function y = power_lines(coef,n,len)
y = 1:len;
a = coef(1);
b = coef(2);
c = coef(3);
d = coef(4);
e = coef(5);

y(1:n) = a * (n-y(1:n)).^b + c;
y(n+1:len) = d * (y(n+1:len)-n).^e + c;
end