function [TestAccuracy,Sensitivity,Specificity,mTrainAccuracy,mTestAccuracy,mSensitivity,mSpecificity,C,ind_counts,ind_value_counts,Xsvm,Ysvm,AUCsvm] = mrmrsvmsub(m,sub1,sub2,fea1,fea2)

% Version 1.1 (Apr 2021)
% Author: Yen-Ling, Chen

k = 3;
rng(m);
c1 = cvpartition(sub1,'KFold',k);
c2 = cvpartition(sub2,'KFold',k);
ylabel_all = [];
score_all = [];
for i = 1:k
    train1 = training(c1,i);
    train2 = training(c2,i);
    test1 = ~train1;
    test2 = ~train2;
    TrainData = [fea1(train1,:);fea2(train2,:)];
    TestData = [fea1(test1,:);fea2(test2,:)];
    grouplabel = [ones(sum(train1),1);zeros(sum(train2),1)];
    testlabel = [ones(sum(test1),1);zeros(sum(test2),1)];
    [~,score_mrmr] = fscmrmr(TrainData,grouplabel);
    connmap{i} = find(score_mrmr>0);
    Conn = TrainData(:,connmap{i});
    Conn_test = TestData(:,connmap{i});
    rng(m);
    c = cvpartition(size(TrainData,1),'KFold',10);
    opts = struct('Optimizer','bayesopt','ShowPlots',false,'CVPartition',c,'Verbose',0,'AcquisitionFunctionName','expected-improvement-plus');
    svmmod = fitcsvm(Conn,grouplabel,'KernelFunction','rbf',...
        'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts);
    lossnew = kfoldLoss(fitcsvm(Conn,grouplabel,'CVPartition',c,'KernelFunction','rbf',...
        'BoxConstraint',svmmod.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint,...
        'KernelScale',svmmod.HyperparameterOptimizationResults.XAtMinObjective.KernelScale));
    TrainAccuracy(i) = 1-lossnew;
    [ylabel,score,~] = predict(svmmod,Conn_test);
    confuM{i} = confusionmat(ylabel,testlabel);
    TestAccuracy(i) = (confuM{i}(1,1)+confuM{i}(2,2))/length(testlabel);
    Sensitivity(i) = confuM{i}(2,2)/(confuM{i}(2,1) + confuM{i}(2,2)); % for label 1
    Specificity(i) = confuM{i}(1,1)/(confuM{i}(1,1) + confuM{i}(1,2));
    ylabel_all = [ylabel_all;ylabel];
    score_all = [score_all;score];
end
clear ylabel
mTrainAccuracy = nanmean(TrainAccuracy,2);
mTestAccuracy = nanmean(TestAccuracy,2);
mSensitivity = nanmean(Sensitivity,2);
mSpecificity = nanmean(Specificity,2);
a = [];
grouplabel = [];
for i = 1:k
    a = [a; connmap{i}'];
    g = [ones(c1.TestSize(i),1);zeros(c2.TestSize(i),1)];
    grouplabel = [grouplabel;g];
end
[C,~,ic] = unique(a,'rows');
ind_counts = accumarray(ic,1);
[b,c] = sort(ind_counts,'descend');
ind_value_counts = [C(c),b];
[Xsvm,Ysvm,~,AUCsvm] = perfcurve(grouplabel,score_all(:,2),svmmod.ClassNames(2));

