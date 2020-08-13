function [xpair, ximpair] =  fft_divide_x_into_two(x)
xpair = x(1:2:end,:);
if size(x,2) == 1
    ximpair = [x(2:2:end) ; 0];
else
    t=size(x,2);
    ximpair = [x(2:2:end,:) ; zeros(1,t)];
end
end