function y = Tx(T,x,mode)
if mode == 1
    y = T*x;
elseif mode == 2
    y = T'*x;
end
end