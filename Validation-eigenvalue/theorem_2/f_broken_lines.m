% Create a broken line with one break point.
% The abscissa of the broken line is fixed 1:n
% Input: len, length of the broken line
% coef (=[a, b, c, xi]): coefficient a, b and c and xi abscissa of the
% break point
% Before the break point, the value is a*x+b with x the abscissa
% After, it's c*x+d.
% d is a coefficient defined by the four others in order to have
% a*xi+b = c*xi+d (the two lines of the broken line crossed in the abscissa
% of the break point)


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