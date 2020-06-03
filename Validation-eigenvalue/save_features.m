function res = save_features(res, o1,o2,o3,o4)
%% Iteration
res(1,1) = o1.PDitns;
res(2,1) = o2.PDitns;
if exist("o3")
    res(3,1) = o3.PDitns;
end
if exist("o4")
    res(4,1) = o4.PDitns;
end
%% Reason of arrest
res(1,2) = o1.inform;
res(2,2) = o2.inform;
if exist("o3")
    res(3,2) = o3.inform;
end
if exist("o4")
    res(4,2) = o4.inform;
end
%% Residu
res(1,3) = o1.Cinf0;
res(2,3) = o2.Cinf0;
if exist("o3")
    res(3,3) = o3.Cinf0;
end
if exist("o4")
    res(4,3) = o4.Cinf0;
end
%% Execution time
res(1,3) = o1.time;
res(2,3) = o2.time;
if exist("o3")
    res(3,3) = o3.time;
end
if exist("o4")
    res(4,3) = o4.time;
end
%% Recuperate values
x1 = o1.x; z1 = o1.z; obj1 = o1.obj;
x2 = o2.x; z2 = o2.z; obj2 = o2.obj;
x3 = o3.x; z3 = o3.z; obj3 = o3.obj;
x4 = o4.x; z4 = o4.z; obj4 = o4.obj;
%% Objective
res(1,4) = obj1;
res(2,4) = obj2;
if exist("o3")
    res(3,4) = obj3;
end
if exist("o4")
    res(4,4) = obj4;
end
%% Difference in norm for x, z and obj for o1
res(1,5) = norm(x1-x2);
res(1,6) = norm(x1-x3);
res(1,7) = norm(x1-x4);
res(1,8) = norm(z1-z2);
res(1,9) = norm(z1-z3);
res(1,10) = norm(z1-z4);
res(1,11) = norm(obj1-obj2);
res(1,12) = norm(obj1-obj3);
res(1,13) = norm(obj1-obj4);
res(1,14) = norm(x1-x2)/norm(x1);
res(1,15) = norm(x1-x3)/norm(x1);
res(1,16) = norm(x1-x4)/norm(x1);
res(1,17) = norm(z1-z2)/norm(z1);
res(1,18) = norm(z1-z3)/norm(z1);
res(1,19) = norm(z1-z4)/norm(z1);
res(1,20) = norm(obj1-obj2)/abs(obj1);
res(1,21) = norm(obj1-obj3)/abs(obj1);
res(1,22) = norm(obj1-obj4)/abs(obj1);
%% difference in norm for x, z and obj for o2
res(2,5) = norm(x2-x1);
res(2,6) = norm(x2-x3);
res(2,7) = norm(x2-x4);
res(2,8) = norm(z2-z1);
res(2,9) = norm(z2-z3);
res(2,10) = norm(z2-z4);
res(2,11) = norm(obj2-obj1);
res(2,12) = norm(obj2-obj3);
res(2,13) = norm(obj2-obj4);
res(2,14) = norm(x2-x1)/norm(x2);
res(2,15) = norm(x2-x3)/norm(x2);
res(2,16) = norm(x2-x4)/norm(x2);
res(2,17) = norm(z2-z1)/norm(z2);
res(2,18) = norm(z2-z3)/norm(z2);
res(2,19) = norm(z2-z4)/norm(z2);
res(2,20) = norm(obj2-obj1)/abs(obj2);
res(2,21) = norm(obj2-obj3)/abs(obj2);
res(2,22) = norm(obj2-obj4)/abs(obj2);
%% difference in norm for x, z and obj for o3
if exist("o3")
    res(3,5) = norm(x3-x2);
    res(3,6) = norm(x3-x1);
    res(3,7) = norm(x3-x4);
    res(3,8) = norm(z3-z2);
    res(3,9) = norm(z3-z1);
    res(3,10) = norm(z3-z4);
    res(3,11) = norm(obj3-obj2);
    res(3,12) = norm(obj3-obj1);
    res(3,13) = norm(obj3-obj4);
    res(3,14) = norm(x3-x2)/norm(x3);
    res(3,15) = norm(x3-x1)/norm(x3);
    res(3,16) = norm(x3-x4)/norm(x3);
    res(3,17) = norm(z3-z2)/norm(z3);
    res(3,18) = norm(z3-z1)/norm(z3);
    res(3,19) = norm(z3-z4)/norm(z3);
    res(3,20) = norm(obj3-obj2)/abs(obj3);
    res(3,21) = norm(obj3-obj1)/abs(obj3);
    res(3,22) = norm(obj3-obj4)/abs(obj3);
end
%% difference in norm for x, z and obj for o4
if exist("o4")
    res(4,5) = norm(x4-x2);
    res(4,6) = norm(x4-x3);
    res(4,7) = norm(x4-x1);
    res(4,8) = norm(z4-z2);
    res(4,9) = norm(z4-z3);
    res(4,10) = norm(z4-z1);
    res(4,11) = norm(obj4-obj2);
    res(4,12) = norm(obj4-obj3);
    res(4,13) = norm(obj4-obj1);
    res(4,14) = norm(x4-x2)/norm(x4);
    res(4,15) = norm(x4-x3)/norm(x4);
    res(4,16) = norm(x4-x1)/norm(x4);
    res(4,17) = norm(z4-z2)/norm(z4);
    res(4,18) = norm(z4-z3)/norm(z4);
    res(4,19) = norm(z4-z1)/norm(z4);
    res(4,20) = norm(obj4-obj2)/abs(obj4);
    res(4,21) = norm(obj4-obj3)/abs(obj4);
    res(4,22) = norm(obj4-obj1)/abs(obj4);
end
end