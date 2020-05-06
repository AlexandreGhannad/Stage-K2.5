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


% Plot negative eigenvalue
figure()
subplot(221)
semilogy(rho_min_negative, "LineWidth", 3)
hold on
semilogy(rho_max_negative, "LineWidth", 3)
tmp = eigenvalue';
tmp(tmp>0) = NaN; % Positive eigenvalue are set at NaN in order to have gaps when we display them
semilogy(tmp, "k.")
xlabel("Iteration")
ylabel("Eigenvalues and bounds")
legend("Inferior negative bound", "Superior negative bound", "Eigenvalues")

if exist("d1") & exist("d2")
    title("Negative eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title("Negative eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title("Negative eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title("Negative eigenvalues)")
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

% Plot positive eigenvalue
figure()
subplot(221)
semilogy(rho_min_positive, "LineWidth", 3)
hold on
semilogy(rho_max_positive, "LineWidth", 3)
tmp = eigenvalue';
tmp(tmp<0) = NaN; % Negative eigenvalue are set at NaN in order to have gaps when we display them
semilogy(tmp, "k.")
xlabel("Iteration")
ylabel("Eigenvalues and bounds")
legend("Inferior positive bound", "Superior positive bound", "Eigenvalues")

if exist("d1") & exist("d2")
    title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + "), (d2 = " + sprintf("%7.1e", d2) + ")")
elseif exist("d1")
    title("Positive eigenvalues, (d1 = " + sprintf("%7.1e", d1) + ")")
elseif exist("d2")
    title("Positive eigenvalues, (d2 = " + sprintf("%7.1e", d2) + ")")
else
    title("Positive eigenvalues)")
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