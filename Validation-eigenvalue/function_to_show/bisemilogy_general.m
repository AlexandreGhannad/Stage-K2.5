% Given a windows, some data and their specification for their forms,
% display a graphics in logarythmic scale in ordinate, linear in abscissa,
% with a centrale zero axe which separate positive from negative values.
% 
% Centrale zero axe allow to display the zeros values (contrary to a
% standard semilog graphic). Moreover, a blank space will be add between
% the zeros axe and the different values.This blank space has no
% mathematical sense, his function is to help to display values
% 
% Inputs:
% data: matrix of all the data to display. Warning: display the line one by
% one
% Example: [inferior bounds (vector 1*50)
%           superior bounds (vector 1*50)
%           value between those bounds (matrix 30*50)]
% Specs: cell array with specification on the display for each different
% data. Empty specs is possible.
% Example: cell size 3*5
%     {["LineWidth"]}    {[           3]}    {["Color"]}    {[0.9290 0.6940 0.1250]}
%     {["LineWidth"]}    {[           3]}    {["Color"]}    {[0 0.4470 0.7410]}
%     {["k."       ]}    {["MarkerSize"]}    {[      5]}    {0×0 double}
% Advise to create specs: create an empty cell array. The width should be
% the maximum
% ind: int array to precise which specs is for which data. The numbers
% must indicate the index of beginning of the data.
% Example: ind = [1 2 3]
% The first specs is for the data for the first line, the second for the
% second line of data, and the third specs is for the data from the third
% lines to the end.
% windows: indicate the figure or the subplot where the graphics is
% displayed.
% Example:
% fig = figure();
% bisemilogy_general(data, specs, ind, fig);
% or:
% figure();
% windows = subplot(211);
% bisemilogy_general(data, specs, ind, windows);
% 
% To explain the algorithm, we will use an example of data which comes from
% 10^-7 to 10^1 in magnitude (those values colb be positive or negative).


function bisemilogy_general(data, specs, ind, windows)
% Distinction of the positive and negative values ad us of logarythmic
% scaling.
if isequal(class(windows),'matlab.ui.Figure')
    ax = axes
elseif isequal(class(windows),'matlab.graphics.axis.Axes')
    ax = windows;
end
pos = data;
pos(pos<=0) = NaN;
pos = log10(pos);
neg = data;
neg(neg>=0) = NaN;
neg = -log10(-neg);
% Logarythmic values come from -7 to +1 for positive values, and from -1 to
% +7 for negative.

% Register in l1 and l2 the minimum and maximum logarythmic values (which
% means the lowest and highest exponents of the originale data).
l1 = max(max(log10(abs(data(data~=0))), [], "all"));
l2 = min(min(log10(abs(data(data~=0))), [], "all"));
% Example: l1 = -7, l2 = +1

% Round them to the nearest multiples of 2 (because ordinate will be
% graduate by even power of ten (10^2,^10^4, 10^6...)
l1 = 2*ceil(l1/2);
l2 = 2*floor(l2/2);
% Example: l1 = -8 and l2 = 2

L = l1 + abs(l2)+2; % Expanse of the data
% Positive and negative values are currently mixed up (if lowest value are 
% inferior to 1) (see the example). Those commands separate them
pos = pos + abs(l2)+2;
neg = neg - abs(l2)-2;
% Example: our positive values are now from 3  to 11. Negative values are
% from -11 to -3. Compare to precedent and orginal values, the values at 3
% is equivalent to the former -7 and to the original 10^-7 values. 

% Creation of the graphic
hold on
n = length(ind);

for i=1:n-1
    % Specs are put in an format which can be read by plot.
    % Empty specs (cell array = {}) could be read, but not empty variable 
    % (specs must be given, even if it's an empty cell array)
    spec = specs(i,:);
    spec = spec(~cellfun('isempty',spec));
    for k = ind(i):ind(i+1)-1
        plot(pos(k,:), spec{:});
        plot(neg(k,:), spec{:});
    end
end
spec = specs(end,:);
spec = spec(~cellfun('isempty',spec));
for k = ind(end):length(data)
    plot(pos(k,:), spec{:});
    plot(neg(k,:), spec{:});
end

% Set the ordinate and the central axe
ax.XAxisLocation = 'origin';
ylim([-L L]);
ax.YTick=-L:2:L;

% Graduate the ordinate by even power of ten (10^2,^10^4, 10^6...)
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

end