function [gTestAccuracy,gSensitivity,gSpecificity,mTrainAccuracy,mTestAccuracy,mSensitivity,mSpecificity,paramC,ind_counts,ind_value_counts,Xsvm,Ysvm,AUCsvm] = parclass(ff,label)

% Version 1.1 (Apr 2021)
% Author: Yen-Ling, Chen

L = length(thr_counts);
age1 = sum(label==2);
age2 = sum(label==1);
parfor m = 1:100
    for i = 1:L
        [gTestAccuracy{i,m},gSensitivity{i,m},gSpecificity{i,m},mTrainAccuracy(i,m),mTestAccuracy(i,m),mSensitivity(i,m),mSpecificity(i,m),paramC{i,m},...
            ind_counts{i,m},ind_value_counts{i,m},Xsvm{i,m},Ysvm{i,m},AUCsvm(i,m)] = mrmrsvmsub(m,age1,age2,ff{i}(label==2,:),ff{i}(label==1,:));
    end
end
