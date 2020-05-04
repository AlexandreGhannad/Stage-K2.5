p = Problem1.M;
h = eigs(p, 20, "smallestabs");
min(abs(h))

u = Problem1.eigenvalue;
min(abs(u), [], "all")

if exist("Problem2")
    p = Problem2.M;
    h = eigs(p,20, "smallestabs");
    min(abs(h))
    
    u = Problem2.eigenvalue;
    min(abs(u), [], "all")
end