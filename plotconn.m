function plotconn(inc,dec)

% Version 1.1 (Apr 2021)
% Author: Yen-Ling, Chen

cmap = [lines(7);103/255,189/255,170/255];
nn = readtable('E:\Documents\Yen-Ling\shen_parcellation\shen_268_parcellation_networklabels.csv');
[~,~,ic] = unique(nn.Network,'rows');
a_counts = accumarray(ic,1);
for i = 1:length(a_counts)
    numarray{i} = find(nn.Network==i);
end
k = 0;
r = 1;
figure;
for i = 1:length(a_counts)
    ang{i} = linspace(k,k+2*pi*(a_counts(i)/size(nn,1)),a_counts(i)+2);
    x{i} = r*cos(ang{i});
    y{i} = r*sin(ang{i});
    plot(x{i},y{i},'Color',cmap(i,:),'LineWidth',8)
    hold on
    k = k+2*pi*(a_counts(i)/size(nn,1));
end
axis square
box off
set(gca,'XTick',[],'YTick',[],'XTickLabel','','YTickLabel','','XColor','none','YColor','none')
set(gcf,'Color',[1 1 1],'InvertHardcopy','off')
FCmrmr = ones(268);
FCmrmr(tril(FCmrmr,-1)==1)=1:267*134;
FCmrmr = tril(FCmrmr,-1);
a = [];
b = [];
for i = 1:length(inc)
    [a(i),b(i)] = find(FCmrmr==inc(i));
end
for i = 1:length(a)
    hold on
    nnidx_a = nn.Network(a(i));
    nnidx_b = nn.Network(b(i));
    numidx_a = find(numarray{nnidx_a}==a(i));
    numidx_b = find(numarray{nnidx_b}==b(i));
    plotarc([x{nnidx_a}(numidx_a+1);y{nnidx_a}(numidx_a+1)],[x{nnidx_b}(numidx_b+1);y{nnidx_b}(numidx_b+1)],[204/255,102/255,0/255])
end
a = [];
b = [];
for i = 1:length(dec)
    [a(i),b(i)] = find(FCmrmr==dec(i));
end
for i = 1:length(a)
    hold on
    nnidx_a = nn.Network(a(i));
    nnidx_b = nn.Network(b(i));
    numidx_a = find(numarray{nnidx_a}==a(i));
    numidx_b = find(numarray{nnidx_b}==b(i));
    plotarc([x{nnidx_a}(numidx_a+1);y{nnidx_a}(numidx_a+1)],[x{nnidx_b}(numidx_b+1);y{nnidx_b}(numidx_b+1)],[51/255,102/255,204/255])
end
legend('String',{'Medial frontal','Frontoparietal','Default mode','Subcortical-cerebellum','Motor',...
    'Visual I','Visual II','Visual association'},'Location','northeastoutside')
