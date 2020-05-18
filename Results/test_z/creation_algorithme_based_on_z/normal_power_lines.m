function y = normal_power_lines(coef,n,len)
y1 = linspace(1,0,n);
y2 = linspace(0,1,len-n);
a = coef(1);
b = coef(2);
c = coef(3);
d = coef(4);
e = coef(5);
y = zeros([1 len]);
y(1:n) = a * y1.^b + c;
y(n+1:len) = d * y2.^e +c;
end