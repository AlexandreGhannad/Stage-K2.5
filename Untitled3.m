m=15;
j2 = transpose(-m:m);
Xis = j2*rho1/m;
Etas = Xis;
DarkHole = [];
mask2 = zeros(2*m+1);
map = zeros(2*m+1);
for i=-m:m
    for j=-m:m
        xi = Xis(i+m+1);
        eta = Etas(j+m+1);
        tmp2 = xi^2 + eta^2;
        if rho0^2 <= tmp2 && tmp2 <= rho1^2 && abs(eta) <= abs(xi)
            DarkHole = [DarkHole ; [xi eta]];
            mask2(i+m+1,j+m+1) = 1;
            map(i+m+1,j+m+1) = tmp2;
        end
    end
end