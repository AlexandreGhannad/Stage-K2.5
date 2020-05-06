function show_eigenvalue_theorem2(eigenvalue, features_theorem2, d1, d2)

rho_min_negative = features_theorem2(1,:);
rho_max_negative = features_theorem2(2,:);
rho_min_positive = features_theorem2(3,:);
rho_max_positive = features_theorem2(4,:);
lambda_max = features_theorem2(5,:);
lambda_min = features_theorem2(6,:);
sigma_max = features_theorem2(7,:);
sigma_min = features_theorem2(8,:);
xmax = features_theorem2(9,:);
xmin = features_theorem2(10,:);
n = (size(features_theorem2,1) - 10) /2;
x = features_theorem2(11:11+n-1,:);
z = features_theorem2(11+n:end,:);
limit = features_theorem2(1:4,:);

figure()
subplot(221)
%% bisemilogy copy in order to function inside the subplot
pos = eigenvalue';
pos(pos<=0) = NaN;
pos = log10(pos);
neg = eigenvalue';
neg(neg>=0) = NaN;
neg = -log10(-neg);
rmm = -log10(abs(limit(1,:)));
rMm = -log10(abs(limit(2,:)));
rmp = log10(abs(limit(3,:)));
rMp = log10(abs(limit(4,:)));

l1 = max(max(log10(abs(eigenvalue)), [], "all"), max(log10(abs(limit)), [], "all"));
l2 = min(min(log10(abs(eigenvalue)), [], "all"), min(log10(abs(limit)), [], "all"));
l1 = 2*ceil(l1/2);
l2 = 2*floor(l2/2);
L = l1 + abs(l2)+2;
pos = pos + abs(l2)+2;
neg = neg - abs(l2)-2;
rmp = rmp + abs(l2)+2;
rMp = rMp + abs(l2)+2;
rmm = rmm - abs(l2)-2;
rMm = rMm - abs(l2)-2;

ax = subplot(221);

hold on
plot(rmp, "LineWidth", 3, "Color", [0.9290 0.6940 0.1250])
plot(rMp, "LineWidth", 3, "Color", [0 0.4470 0.7410])
plot(rmm, "LineWidth", 3, "Color", [0 0.4470 0.7410])
plot(rMm, "LineWidth", 3, "Color", [0.9290 0.6940 0.1250])
plot(pos, "k.", "MarkerSize", 15)
plot(neg, "k.", "MarkerSize", 15)

ax.XAxisLocation = 'origin';
ylim([-L L]);
ax.YTick=-L:2:L;

t = l2:2:l1;

lbl = cell(size(t));
tmp = -1;
cpt = 0;
for i = -length(t):length(t)
    if i < 0
        lbl{i+length(t)+1} = ['-10^{',num2str(t(length(t)-cpt)),'}'];
        cpt = cpt+1;
    elseif i == 0
        lbl{i+length(t)+1} = ['0'];
        cpt = 1;
    elseif i > 0
        lbl{i+length(t)+1} = ['10^{',num2str(t(i)),'}'];
        cpt = cpt+1;
    end
    
end
    
ax.YTickLabel = lbl;
%%
xlabel("Iteration")
ylabel("Eigenvalues and bounds")
legend("Lower bounds", "Upper bounds", "Eigenvalues")

if exist("d1") & exist("d2")
    title("Eigenvalues and bounds (theorem2), (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title("Eigenvalues and bounds (theorem2), (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title("Eigenvalues and bounds (theorem2), (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title("Eigenvalues and bounds (theorem2)")
end

subplot(222)
semilogy(abs(lambda_max), "LineWidth", 2, "Color", [0 0 1])
hold on
semilogy(abs(lambda_min), "LineWidth", 2, "Color", [0.3010 0.7450 0.9330])
xlabel("Iteration")
ylabel("Eigenvalue of the hessien matrix")
legend("lambda max", "lambda min")

if lambda_max == 0 & lambda_min == 0
    title("Eigenvalues are 0")
end

subplot(223)
semilogy(abs(sigma_max), "LineWidth", 2, "Color", [0.4660 0.6740 0.1880])
hold on
semilogy(abs(sigma_min), "LineWidth", 2, "Color", [0 1 0])
xlabel("Iteration")
ylabel("Singular value of A")
legend("sigma max", "sigma min")

subplot(224)
semilogy(abs(xmax), "LineWidth", 2, "Color", [0.6350 0.0780 0.1840])
hold on
semilogy(abs(xmin), "LineWidth", 2, "Color", [1 0 0])
semilogy(abs(x'), "k.")
xlabel("Iteration")
ylabel("x and its optimum for inactive bounds")
legend("xmax", "xmin", "x")

end