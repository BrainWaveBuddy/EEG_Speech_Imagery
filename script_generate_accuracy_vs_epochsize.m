% This script plots the accuracy of the Common Spatial Pattern (CSP) method
% on Vocal Imagery (VIm) and Vocal Intention (VInt). This code has been
% used to generate Fig. 2 of the manuscript: https://ieeexplore.ieee.org/abstract/document/9125958
% Code has been refactored for readability - 2026/03/19 - A.B.Kristensen

clear; close all; clc;
addpath('.')

% The target .mat-files to store intermediate computed results
pNTS_VInt = './computedResults/EpochVSAccuracySInt.mat';
pNTS_VIm =   './computedResults/EpochVSAccuracySI.mat';

% Parameters defining for the k-fold validation method
K = 10;                 % k-fold validation
eSz = 50:50:1500;       % Epoch sizes to test
lag = 500;              % Sample shift between epochs
Subjects = 1:17;        % Subject indexes to include
N = length(Subjects);

% Compute Accuracy vs SINT paradigm, if not computed
if ~exist(pNTS_VInt,'file')
    accurTable = zeros(length(eSz),N);
    for k = 1:N
        tic
        subjidx = strcat('Subj',num2str(Subjects(k)));
        [nts,m,vim,vint] = SubjectFind(subjidx);
        for JJ = 1:length(eSz)
            [TP,FP,TN,FN] = KFoldValidate(nts', vint',K,lag,eSz(JJ),'new');
            accurTable(JJ,k) = (TP+TN)/(TP+FP+TN+FN);
        end
        toc
    end
    % Save data
    save(pNTS_VInt,'eSz','accurTable')
end

% Compute Accuracy vs SI paradigm, if not computed
if ~exist(pNTS_VIm,'file')
    accurTable = zeros(length(eSz),N);
    for k = 1:N
        tic
        subjidx = strcat('Subj',num2str(Subjects(k)));
        [nts,m,vim,vint] = SubjectFind(subjidx);
        for JJ = 1:length(eSz)
            [TP,FP,TN,FN] = KFoldValidate(nts', vim',K,lag,eSz(JJ),'new');
            accurTable(JJ,k) = (TP+TN)/(TP+FP+TN+FN);
        end
        toc
    end
    % Save data
    save(pNTS_VIm,'eSz','accurTable')
end


%% Make and save figures
% Figure parameters
lwfactor = 1.5;   % line width factor
fsfactor = 25;    % font size factor
fig1 = figure;
load(pNTS_VIm);

errorbar(eSz,mean(accurTable,2),var(accurTable,[],2),'LineWidth',lwfactor)
hold on

load(pNTS_VInt)
errorbar(eSz,mean(accurTable,2),var(accurTable,[],2),'LineWidth',lwfactor)

% Figure adjustments
ylabel('Accuracy')
xlabel('Epoch size [samples]')
xticks(100:200:1500)
fig1.Position = [39.6667 278.3333 1.2227e+03 339.6667];
set(gca,'FontSize',fsfactor)
xlim([0,1550])
ylim([0.76 0.94])
legend('NTS vs SI','NTS vs SInt','location','southeast')

% Saving figure
saveas(fig1,'./plotsAndFigures/NTSvsSIandSInt','epsc')
saveas(fig1,'./plotsAndFigures/NTSvsSIandSInt','jpg')