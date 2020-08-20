function display_and_save_evolution(x, iter)
n = 70;

vecF = x(1:n^2);
F = reshape(vecF, [n n]);

res = zeros(2*n, 2*n);
res(1:n, 1:n) = F(end:-1:1 , end:-1:1);
res(1:n, n+1:end) = F(end:-1:1,:);
res(n+1:end, 1:n) = F(:,end:-1:1);
res(n+1:end, n+1:end) = F(:,:);

fig = figure(1);
clf(1)
imshow(res)
title("Iteration "+ num2str(iter))

filename = "D:\git_repository\Stage-K2.5\space_problem\Result\fig"+num2str(iter);
save_figure_pdf(fig, filename)
end