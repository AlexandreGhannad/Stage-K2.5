function Y = f_power_lines(len, coef)
a = coef(1);
b = coef(2);
c = coef(3);
d = coef(4);
e = coef(5);
xi = coef(6);
Y = 1:len;

Y(Y<=xi) = a * ((xi-Y(Y<=xi))/xi).^b + c;
Y(Y>xi) = d * ((Y(Y>xi)-xi)/xi).^e + c;
end