% This script uses Spatial Pattern (CSP) method and Support Vector Machine
% (SVM) classifier on Vocal Imagery (VIm) and Vocal Intention (VInt)
% EEG-data. This code has been used to generate Fig. 5 of the manuscript:
% https://ieeexplore.ieee.org/abstract/document/9125958
% Code has been refactored for readability - 2026/03/19 - A.B.Kristensen

% The script computes population (excluding subject 4, 8, 12 and 16) wide
% covariance matrices for each task. From the population covariance
% matrices the CSP weights can be computed maximizing differentiability 
% between two particular paradigms, based on source variance. Then the
% average PSD across subject were computed

clear; close all; clc;
addpath('./utils')
pTopoMatOutput = './computedResults/TopoData2.mat';
if ~exist(pTopoMatOutput, "file")
    Subjects = [1:3,5:7,9:11,13:15,17];        % Subject indexes for females to include
    N = length(Subjects);
    for k = 1:N
        tic
        subjidx = strcat('Subj',num2str(Subjects(k)));
        [nts,m,si,sint] = SubjectFind(subjidx);
    
        nts = nts./trace((nts')*nts);
        m = m./trace((m')*m);
        si = si./trace((si')*si);
        sint = sint./trace((sint')*sint);
    
        E1 = nts';
        E2 = m';
        E3 = si';
        E4 = sint';
    
        % Covariance matrices stacked in 3rd dimension
        C1(:,:,k) = (E1*E1')/(trace(E1*E1'));
        C2(:,:,k) = (E2*E2')/(trace(E2*E2'));
        C3(:,:,k) = (E3*E3')/(trace(E3*E3'));
        C4(:,:,k) = (E4*E4')/(trace(E4*E4'));
        toc
    end
    
    
    % %% Save data
    save(pTopoMatOutput, 'C1', 'C2', 'C3', 'C4')
end

%% Load data to save time
% The loaded data is from script containing covariance matrices
% based only on subjects: [1:3,5:7,9:11,13:15,17]. Make sure these saved
% matrices haven't been overwritten by matrices using other subjects
load(pTopoMatOutput)
S1 = mean(C1,3);            % Average population covariance matrices
S2 = mean(C2,3);
S3 = mean(C3,3);
S4 = mean(C4,3);
% Non-task specific vs Motor intention
[W,~] = CSP_Weight([],[],'new',S1,(S2+S3+S4)/3);
subs = [1:3,5:7,9:11,13:15,17]; 

%% PSD average of selected filters
% The PSDPlotter is used with the subject indices 'subs', W, is the
% computed CSP matrix, filters 1 and 16 are selected from W to filter the
% EEG signal. For each subject the average PSD is computed for 100 equally
% sized subsegment and the population PSD is computed by averaging across
% subjects. The 'rectwin' function is an optional filtering of the EEG
% data.
fig1 = PSDPlotter(subs, W, [1, 16], 100,'rectwin');
% Manually adjust xlabel position to stay inside the figure
fig1.Children(2).XLabel.Position(2) = -0.47;

fig2 = PSDPlotter(subs, W, [2,3,15], 100,'rectwin');
% Manually adjust xlabel position to stay inside the figure
fig2.Children(2).XLabel.Position(2) = -0.029;

%% PSD
fig3 = PSDPlotter(subs, W, [1, 3], 100,'rectwin');
% Manually adjust xlabel position to stay inside the figure
fig3.Children(2).XLabel.Position(2) = -0.08;

fig4 = PSDPlotter(subs, W, [12, 16], 100,'rectwin');
% Manually adjust xlabel position to stay inside the figure
fig4.Children(2).XLabel.Position(2) = -0.3;
%% Saving figures
for k = 1:4
    eval(strcat('saveas(fig',num2str(k),',''./plotsAndFigures/periodograms',num2str(k),''',''epsc'')'));
    eval(strcat('saveas(fig',num2str(k),',''./plotsAndFigures/periodograms',num2str(k),''',''jpg'')'));
end

