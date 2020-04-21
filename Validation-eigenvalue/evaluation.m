function result = evaluation(xf1, xf2, xf3, zf1, zf2 , zf3 , obj1 , obj2 , obj3, rapport, err)
% Input description
% xf1 : final value on x for K25
% xf2 : final value on x for K35
% xf3 : final value on x for K2
% zf1 : final value on z for K25
% zf2 : final value on z for K35
% zf3 : final value on z for K2
% objf1 : final value on objective for K25
% objf2 : final value on objective for K35
% objf3 : final value on objective for K2

% order comparison:
% K25/K35
% K25/K2
% K2/K35

% Absolute error on x, z and objective
abs_err_x =[ norm(xf1 - xf2) norm(xf1 - xf3) norm(xf2-xf3)];
abs_err_z =[ norm(zf1 - zf2) norm(zf1 - zf3) norm(zf2-zf3)];
abs_err_obj = [ abs(obj1 - obj2) abs(obj1 - obj3) abs(obj2 - obj3) ];

% Ranking of method
[~,rank] = sort([obj1 obj2 obj3]);

% relative error
rel_err_x =[ sum(abs(xf1 - xf2)./xf2) sum(abs(xf1 - xf3)./xf1) sum(abs(xf2 - xf3)./xf2) ];
rel_err_z =[ sum(abs(zf1 - zf2)./zf2) sum(abs(zf1 - zf3)./zf1) sum(abs(zf2 - zf3)./xf2) ];
rel_err_obj = [ abs(obj1 - obj2)/obj2 abs(obj1 - obj3)/obj1 abs(obj2 - obj3)/obj2 ];

% Print result
obj = [obj1 obj2 obj3];
eigenvalue_validation = isequal(rapport, ones(size(rapport)));
error = full(max(err, [], "all"));

result = [obj1 obj2 obj3;...
    abs_err_x; abs_err_z ; abs_err_obj ; ...
    rel_err_x ; rel_err_z ; rel_err_obj;...
    rank; [eigenvalue_validation error 0]];

end