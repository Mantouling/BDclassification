function fea_perm = mrmrperm(fea,label,thr)

% Version 1.1 (Apr 2021)
% Author: Yen-Ling, Chen

idx_subj = randperm(size(fea,1),round(0.9*size(fea,1)));
[~,fc_mrmr_perm] = fscmrmr(fea(idx_subj,:),label(idx_subj));
fea_perm = find(fc_mrmr_perm > thr);