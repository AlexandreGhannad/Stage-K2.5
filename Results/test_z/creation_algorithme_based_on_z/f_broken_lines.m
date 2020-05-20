function Y = f_broken_lines(len, coef)
a = coef(1);
b = coef(2);
c = coef(3);
xi = coef(4);
d = (a-c) * xi + b;

Y = 1:len;
Y(Y<=xi) = a*Y(Y<=xi)+b;
Y(Y>xi) = c*Y(Y>xi)+d;
end