% Given a windows, some data and their specification for their forms,
% display a graphics in logarythmic scale in ordinate, linear in abscissa,
% with a centrale zero axe which separate positive from negative values.
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
 

function bisemilogy_general(data, specs, ind, windows)
ax = windows;
pos = data;
pos(pos<=0) = NaN;
pos = log10(pos);
neg = data;
neg(neg>=0) = NaN;
neg = -log10(-neg);

l1 = max(max(log10(abs(data(data~=0))), [], "all"));
l2 = min(min(log10(abs(data(data~=0))), [], "all"));
l1 = 2*ceil(l1/2);
l2 = 2*floor(l2/2);
L = l1 + abs(l2)+2;
pos = pos + abs(l2)+2;
neg = neg - abs(l2)-2;

hold on
n = length(ind);

for i=1:n-1
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

end