function Fhat = fhat(F,m,n, Xs, Etas, mask)
K = cos(2*pi*Etas*Xs')/2.*n;
Fhat = K*(F.*mask)*K';

% gpuArray(K);
% gpuArray(F);
% gpuArray(mask);
% Fhat = K*(F.*mask)*K';
end