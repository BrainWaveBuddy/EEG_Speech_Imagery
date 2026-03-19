% This script computes subject specific accuracy computed using the Common
% Spatial Pattern (CSp) method combined with Support Vector Machine (SVM)
% classification. The code has been used to generate Table 1 of the
% manuscript: https://ieeexplore.ieee.org/abstract/document/9125958
% Code has been refactored for readability - 2026/03/19 - A.B.Kristensen

clear; close all; clc;
pOutput = './computedResults/paradigmCombosAccuracies.mat';

if ~exist(pOutput,'file')
    eSz = 600;              % Epoch size
    lag = 500;              % Epoch step size
    K = 10;                 % 10-fold cross validation
    Subjects = 1:17;        % Subject indexes for subjects to include
    N = length(Subjects);
    AccTable = zeros(N,6);
    
    for k = 1:N
        tic
        subjidx = strcat('Subj',num2str(Subjects(k)));
        [nts,m,vim,vint] = SubjectFind(subjidx);
        
        % Non-task specific (NTS) vs Motor (M) paradigm classification
        [TP, FP, TN, FN] = KFoldValidate(nts', m', K, lag, eSz,'new');
        AccTable(k,1) = (TP+TN)/(TP+FP+TN+FN);
        % NTS vs Vocal Imagery (VIm) paradigm classification
        [TP, FP, TN, FN] = KFoldValidate(nts', vim', K, lag, eSz,'new');
        AccTable(k,2) = (TP+TN)/(TP+FP+TN+FN);
        % NTS vs Vocal Intention (VInt) paradigm classification
        [TP, FP, TN, FN] = KFoldValidate(nts', vint', K, lag, eSz,'new');
        AccTable(k,3) = (TP+TN)/(TP+FP+TN+FN);
        % M vs VIm
        [TP, FP, TN, FN] = KFoldValidate(m', vim', K, lag, eSz,'new');
        AccTable(k,4) = (TP+TN)/(TP+FP+TN+FN);
        % M vs VInt
        [TP, FP, TN, FN] = KFoldValidate(m', vint', K, lag, eSz,'new');
        AccTable(k,5) = (TP+TN)/(TP+FP+TN+FN);
        % VIm vs VInt
        [TP, FP, TN, FN] = KFoldValidate(vim', vint', K, lag, eSz,'new');
        AccTable(k,6) = (TP+TN)/(TP+FP+TN+FN);
        
        toc
    end
    save(pOutput, "AccTable")
else
    load(pOutput)
end

%%  Save results
FemaleSubs = AccTable(1:6,:);
MaleSubs = AccTable(7:end,:);

% Making a matrix including the subgroup mean and standard deviation and
% the overall mean and standard deviation.
TTab = [FemaleSubs; mean(FemaleSubs,1); std(FemaleSubs,[],1); ...
        MaleSubs; mean(MaleSubs,1); std(MaleSubs,[],1); ...
        mean(AccTable,1); std(AccTable,[],1)];

TotalTable = round(TTab,3);   % Round to 3rd decimal

% File type for easy import into table generator:
csvwrite('./computedResults/FemaleMaleTable.csv',TotalTable);