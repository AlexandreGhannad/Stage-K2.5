function r = perf(T, logplot, grayscale)
%PERF    Performance profiles
%
% This function is a simple modification of Jorge Moré's original.
% D. Orban, 2019.
%
% PERF(T,logplot)-- produces a performance profile as described in
%   Benchmarking optimization software with performance profiles,
%   E.D. Dolan and J.J. More',
%   Mathematical Programming, 91 (2002), 201--213.
% Each column of the matrix T defines the performance data for a solver.
% Failures on a given problem are represented by a NaN or negative value.
% The optional argument logplot is used to produce a
% log (base 2) performance plot.
% If set to true, the optional argument grayscale produces curves in
% shades of gray, that may be more suited for printing in black and white.
%
% This function is based on the perl script of Liz Dolan.
%
% Jorge J. More', June 2004

if (nargin < 2) logplot = false; end
if (nargin < 3) grayscale = false; end

[np,ns] = size(T);

colors  = [[0.4660 0.6740 0.1880];[0 0.4470 0.7410]; [0.8500 0.3250 0.0980];[0.4940 0.1840 0.5560]];
lines   = [":" "-" "-." "--"];
markers = ['' 'x' '*' 's' 'd' 'v' '^' 'o'];
N = exp(-linspace(1, ns, ns)/ns);   % Exclude grays close to 1 (= white).
grays = repmat(N', 1, 3);           % Each row is a shade of gray.

% Negative values also indicate failures.
T(find(T<0)) = NaN;

% Minimal performance per solver
minperf = min(T, [], 2);

minmin = min(minperf(minperf > 0));
minperf(minperf == 0) = minmin/2;     % To guard against zero cpu times.

% Compute ratios and divide by smallest element in each row.
r = zeros(np,ns);
for p = 1: np
  r(p,:) = T(p,:)/minperf(p);
end

if (logplot) r = log2(r); end

max_ratio = max(max(r));

% Replace all NaN's with twice the max_ratio and sort.
r(find(isnan(r))) = 2*max_ratio;
r = sort(r);

% Plot stair graphs with markers.
clf;
for s = 1:ns
 [xs,ys] = stairs([r(:,s) ; 2*max_ratio],[1:np+1]/np);
 %option = ['-' colors(s) markers(s)];
 option = ['-']; % markers(s)];
 if grayscale
   color = grays(s,:);
 else
   color = colors(s,:);
 end
 plot(xs, ys, option, 'Color', color, 'LineWidth', 2, 'LineStyle', lines(s), 'MarkerSize', 3);
 hold on;
end

axis([ 0 1.1*max_ratio 0 1 ]);

% Legends and title should be added.
