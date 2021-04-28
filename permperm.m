function perm_counts = permperm(conX,label)

% Version 1.1 (Apr 2021)
% Author: Yen-Ling, Chen

parfor i = 1:1000
    fea_perm{i} = mrmrperm(conX(1:98,:),label(1:98),0);
end
aa = [];
for i = 1:1000
    aa = [aa,fea_perm{i}];
end
[C,~,ic] = unique(aa','rows');
ind_perm_counts = accumarray(ic,1);
[b,c] = sort(ind_perm_counts,'descend');
perm_counts = [C(c),b];