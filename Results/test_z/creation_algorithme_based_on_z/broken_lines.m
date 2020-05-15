function y = broken_lines(coef,n,len)
y = 1:len;
a = coef(1);
b = coef(2);
c = coef(3);
d = (a-c) * n + b;
y(1:n) = a*y(1:n) + b;
y(n+1:end) = c*y(n+1:end) + d;
% l1 = coef(4);
% l2 = coef(5);

% if n <= 20
%     y2 = -(1/(2*l1)) * exp(-abs(-n:n)/l1);
%     y(1:2*n+1) = y(1:2*n+1) + y2;
% elseif n+20>len
%     u = len-n;
%     y2 = -(1/(2*l1)) * exp(-abs(-u:u)/l1);
%     y(n-u:n+u) = y(n-u:n+u) + y2;
% else
%     y2 = -(1/(2*l1)) * exp(-abs(-20:20)/l1);
%     y(-20+n:n+20) = y(-20+n:n+20) + y2;
% end
end