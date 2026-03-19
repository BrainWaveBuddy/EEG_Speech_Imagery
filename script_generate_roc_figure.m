% This script plots Reciever-Operator Curves (ROC) when using the Common 
% Spatial Pattern (CSP) method and Support Vector Machine (SVM) classifier 
% on Vocal Imagery (VIm) and Vocal Intention (VInt) EEG-data. This code has
% been used to generate Fig. 3 of the manuscript: https://ieeexplore.ieee.org/abstract/document/9125958
% Code has been refactored for readability - 2026/03/19 - A.B.Kristensen

clear; close all; clc;
eSz = 600;      % Epoch size
lag = 500;      % Epoch step size
K = 10;         % 10-fold cross validation
addpath('./utils')
dOutput = './computedResults/ROCandConfusionmatrix.mat';
if ~exist(dOutput,"file")
    Subjects = 1:17;
    M = length(Subjects);
    
    for k = 1:M
        tic
        subjidx = strcat('Subj',num2str(Subjects(k)));
        [nts,m,vi,vint] = SubjectFind(subjidx);
        
        % using the k-fold validation method to get the mean ROC-curve
        % coordinates for each subject
        % Check the 'perfcurve' function for the meaning of each output
        % parameter meaning.
        [~,~,~,~,~,X(:,k),Y(:,k),T(:,k),AUC(k), CM(:,:,k)]      = KFoldValidate(nts', m', K, lag, eSz,'new');
        [~,~,~,~,~,X2(:,k),Y2(:,k),T2(:,k),AUC2(k), CM2(:,:,k)] = KFoldValidate(nts', vi', K, lag, eSz,'new');
        [~,~,~,~,~,X3(:,k),Y3(:,k),T3(:,k),AUC3(k), CM3(:,:,k)] = KFoldValidate(nts', vint', K, lag, eSz,'new');
        [~,~,~,~,~,X4(:,k),Y4(:,k),T4(:,k),AUC4(k), CM4(:,:,k)] = KFoldValidate(m', vi', K, lag, eSz,'new');
        [~,~,~,~,~,X5(:,k),Y5(:,k),T5(:,k),AUC5(k), CM5(:,:,k)] = KFoldValidate(m', vint', K, lag, eSz,'new');
        [~,~,~,~,~,X6(:,k),Y6(:,k),T6(:,k),AUC6(k), CM6(:,:,k)] = KFoldValidate(vi', vint', K, lag, eSz,'new');
    
        toc
    end
    
    % Save result
    save(dOutput,'X','Y','T','AUC','CM', ...
                    'X2','Y2','T2','AUC2','CM2', ...
                    'X3','Y3','T3','AUC3','CM3', ...
                    'X4','Y4','T4','AUC4','CM4', ...
                    'X5','Y5','T5','AUC5','CM5', ...
                    'X6','Y6','T6','AUC6','CM6')
else
    load(dOutput);
end

%% Plot and save ROC-curves for each paradigm comparison
[fig1,~] = ROCplotter(X,X2,X3,X4,X5,X6,Y,Y2,Y3,Y4,Y5,Y6,'mean');

saveas(fig1,'./plotsAndFigures/ROC_means','epsc')   % Subject mean ROC median cross subject
saveas(fig1,'./plotsAndFigures/ROC_means','jpg')   % Subject mean ROC median cross subject