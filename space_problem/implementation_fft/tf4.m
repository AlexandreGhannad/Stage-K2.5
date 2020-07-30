function output = tf4(x, m, N)
n = (size(x,1))/2;
% wN = exp(2*pi*1j/N);
t = transpose((0.5-m):(m-0.5))*((0.5-n):(n-0.5));
t = exp(2*pi*1j*t/N)/(2*n);
% t=real(t);
output = t*x;
end