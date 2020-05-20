function bisemilogy_general(data, windows, )

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

end