%% Clean
close all
clear all
clc
%%
rho0 = 4;
rho1 = 20;
epsilon = 10^-5;

n = 70;
m = 35;

dx = 1/(2*n);
dy = dx;
j1 = transpose(0.5:n-0.5);
Xs = j1/(2*n);
Ys = Xs;
mask = zeros(n);
for a = 1:n
    for b = 1:n
        tmp2 = Xs(a)^2 + Ys(b)^2;
        if tmp2 < 0.25
            mask(a,b) = 1;
        end
    end
end
[row,col] = ind2sub(size(mask),find(mask==1));
Pupil = [Xs(col) Ys(row)];

F = ones(n).*mask;


j2 = transpose(0:m);
Xis = j2*rho1/m;
Etas = Xis;

DarkHole = [];
mask2 = zeros(m+1);
map = zeros(m+1);
for i=1:m+1
    for j=1:m+1
        xi = Xis(i);
        eta = Etas(j);
        tmp2 = xi^2 + eta^2;
        if rho0^2 <= tmp2 && tmp2 <= rho1^2 && eta <=xi
            DarkHole = [DarkHole ; [xi eta]];
            mask2(i,j) = 1;
            map(i,j) = tmp2;
        end
    end
end
%% Creation optim prob
prob = optimproblem;
prob.ObjectiveSense = "maximize";
F = optimvar("F", n,n);
Fhat = optimvar("Fhat", m+1,m+1);

prob.Objective = ones(1,n*n) * reshape( mask.*F, [n*n,1]);

cons1 = F >= 0;
cons2 = F <= 1;
prob.Constraints.cons1 = cons1;
prob.Constraints.cons2 = cons2;

cons3 = Fhat.*mask2 >= -epsilon*Fhat(1,1);
cons4 = Fhat.*mask2 <= epsilon*Fhat(1,1);
prob.Constraints.cons3 = cons3;
prob.Constraints.cons4 = cons4;

cons5 = Fhat == fhat(F,m,n, Xs, Etas, mask);
prob.Constraints.cons5 = cons5;
%% Solve
[sol,fval,exitflag] = solve(prob);
f = sol.F;
fh = sol.Fhat;
tmp = fhat(f,m,n, Xs, Etas, mask);
disp("gap between theoritical fhat and real fh")
disp(norm(fh-tmp))

res = zeros(2*n, 2*n);
res(1:n, 1:n) = f(end:-1:1,end:-1:1);
res(1:n, n+1:end) = f(end:-1:1,:);
res(n+1:end, 1:n) = f(:,end:-1:1);
res(n+1:end, n+1:end) = f(:,:);

resh = zeros(2*m+1, 2*m+1);
resh(1:m, 1:m) = fh(end:-1:2,end:-1:2);
resh(1:m, m+1:end) = fh(end:-1:2,:);
resh(m+1:end, 1:m) = fh(:,end:-1:2);
resh(m+1:end, m+1:end) = fh(:,:);
%% Display graphics
% figure()
% subplot(121)
% surf(f)
% colormap("pink")
% 
% subplot(122)
% surf(fh)
% colormap("pink")
%% Display symmetrised graphics
res = zeros(2*n, 2*n);
res(1:n, 1:n) = f(end:-1:1 , end:-1:1);
res(1:n, n+1:end) = f(end:-1:1,:);
res(n+1:end, 1:n) = f(:,end:-1:1);
res(n+1:end, n+1:end) = f(:,:);

resh = zeros(2*m+2, 2*m+2);
resh(1:m+1, 1:m+1) = fh(end:-1:1,end:-1:1);
resh(1:m+1, m+2:end) = fh(end:-1:1,:);
resh(m+2:end, 1:m+1) = fh(:,end:-1:1);
resh(m+2:end, m+2:end) = fh(:,:);

figure()
imshow(res)
% subplot(121)
% surf(res)
% colormap("pink")
% 
% subplot(122)
% surf(resh)
% colormap("pink")








