% Create a two_part curbs with each parts which are power function
% The abscissa of the function is fixed between 0 and 1 and the two part
% Input: len, length of the line
% coef (=[a, b, c, d, e, xi])
% a, b and c are coefficient of the first part
% d and e are coefficient for the second part
% xi is the break point were the two part crossed.

% Before the break point, the value is a*x^b+c, where x go from 1 to 0.
% So the function go from a to c with a curved from 0 until the break point
% After the break point, the value is d*x^e+c, where x go from  to 
% So the function go from a to c with a curved from the break point until
% the end.
% Example of the form: sqrt(abs(x)) is a reachable form.

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