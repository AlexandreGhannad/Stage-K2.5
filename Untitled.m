method1 = "MaxGap";
method2 = "FirstBigGap";
method3 = "broken_lines";
method4 = "power_lines";
ind1 = detect_active_inactive_constraint(x, method1, z);
ind2 = detect_active_inactive_constraint(x, method2, z);
ind3 = detect_active_inactive_constraint(x, method3, z);
ind4 = detect_active_inactive_constraint(x, method4, z);

t = zeros(1,length(z));
t1 = t; t1(ind1) = 1;
t2 = t; t2(ind2) = 1;
t3 = t; t3(ind3) = 1;
t4 = t; t4(ind4) = 1;

figure(1)
clf(1)
plot(t1)
hold on
plot(t2, ".")
plot(t3, "-")
plot(t4, "-.")
legend({method1, method2, method3, method4}, "location", "best")


%%
[tmpx, perm] = sort(abs(x));
tmpz = abs(z(perm));
figure(2)
clf(2)
semilogy(tmpx)
hold on
semilogy(tmpz, ".")


