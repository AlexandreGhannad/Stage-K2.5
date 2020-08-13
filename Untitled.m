close all
x = vecF;
transpose = 1;
Y1 = Ax3(x, n, m, rho1, epsilon, transpose);
Y2 = Ax7(x, n, m, N, epsilon, transpose);
transpose = 2;
Y3 = Ax3(Y2, n, m, rho1, epsilon, transpose);
Y4 = Ax7(Y2, n, m, N, epsilon, transpose);

t1=Y1(1:(m+1)^2);
t1=reshape(t1, [m+1, m+1]);
t2=Y2(1:(m+1)^2);
t2=reshape(t2, [m+1, m+1]);

figure
surf(t1)
figure;
surf(t2)
figure()
surf(t1/norm(t1)-t2/norm(t2))
%%
t1=Y3(1:(n)^2);
t1=reshape(t1, [n, n]);
t2=Y4(1:(n)^2);
t2=reshape(t2, [n, n]);

figure()
surf(t1)
figure;
surf(t2)
figure()
surf(t1/norm(t1))
figure()
surf(t2/norm(t2))
figure()
surf((t1/norm(t1)-t2/norm(t2)) ./ (t1/norm(t1)))
%% test gradient

[Fx1, Fy1] = gradient(t1);
Ftot1 = abs(Fx1)+ abs(Fy1);
[Fx2, Fy2] = gradient(t2);
Ftot2 = abs(Fx2)+ abs(Fy2);

figure()
surf(Ftot1)
figure;
surf(Ftot2)



