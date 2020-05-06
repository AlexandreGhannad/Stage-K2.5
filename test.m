%%
figure(1)
clf(1)

n = 20;
a = randn([1,n]);
ind = randi(n,n);
for i = 1 : 3
    a(ind) = a(ind) .* randn(size(ind));
end
ind = randi(n,n);
for i = 1 : 3
    a(ind) = 100*a(ind) .* randn(size(ind));
end
for i = 1 : 3
    a(ind) = 0.1*a(ind) .* randn(size(ind));
end

subplot(211)
plot(a,"k.")
subplot(212)
semilogy(abs(a), "k.")
%%
b = a;
b(b<=0) = NaN;
c = a;
c(c>=0) = NaN;

figure(1)
clf(1)
subplot(211)
semilogy(abs(a), "k.", "MarkerSize", 30)
hold on
semilogy(b, "r.", "MarkerSize", 15)

subplot(212)
semilogy(abs(a), "k.", "MarkerSize", 30)
hold on
semilogy(-c, "r.", "MarkerSize", 15)
%%
b = a;
b(b<=0) = NaN;
c = a;
c(c>=0) = NaN;

figure(1)
clf(1)
subplot(211)
semilogy(b, "r.", "MarkerSize", 15)

subplot(212)
semilogy(-c, "r.", "MarkerSize", 15)
%%
b = a;
b(b<=0) = NaN;
b = log10(b)
c = a;
c(c>=0) = NaN;
c = log10(-c)

figure(1)
clf(1)
subplot(211)
plot(log10(abs(a)), "k.", "MarkerSize", 30)
hold on
plot(b, "r.", "MarkerSize", 15)

subplot(212)
plot(-log10(abs(a)), "k.", "MarkerSize", 30)
hold on
plot(-c, "r.", "MarkerSize", 15)
%%
clf(1)
b = a;
b(b<=0) = NaN;
b = log10(b);
c = a;
c(c>=0) = NaN;
c = -log10(-c);

l1 = max(log10(abs(a)));
l2 = min(log10(abs(a)));
l1 = 2*ceil(l1/2);
l2 = 2*floor(l2/2);
L = l1 + abs(l2)+2;
b = b + abs(l2)+2;
c = c - abs(l2)-2;

ax = axes;

plot(b, "k.", "MarkerSize", 30)
hold on
plot(c, "k.", "MarkerSize", 30)

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






