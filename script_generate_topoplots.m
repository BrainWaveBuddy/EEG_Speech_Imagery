% This script uses Spatial Pattern (CSP) method and Support Vector Machine
% (SVM) classifier on Vocal Imagery (VIm) and Vocal Intention (VInt)
% EEG-data. This code has been used to generate Fig. 4 of the manuscript:
% https://ieeexplore.ieee.org/abstract/document/9125958
% Code has been refactored for readability - 2026/03/19 - A.B.Kristensen

% The script computes population wide covariance matrices for each task.
% From the population covariance matrices the CSP weights can be computed
% maximizing differentiability between two particular paradigms, based on
% source variance.

clear; close all; clc;
addpath('./utils')
pTopoMatOutput = './computedResults/TopoData.mat';
if ~exist("pTopoMatOutput", "file")
    Subjects = 1:17;        % Subject indexes for females to include
    N = length(Subjects);
    for k = 1:N
        tic
        subjidx = strcat('Subj',num2str(Subjects(k)));
        [nts,m,vim,vint] = SubjectFind(subjidx);
    
        nts = nts./trace((nts')*nts);
        m = m./trace((m')*m);
        vim = vim./trace((vim')*vim);
        vint = vint./trace((vint')*vint);
        
        E1 = nts';
        E2 = m';
        E3 = vim';
        E4 = vint';
    
        % Covariance matrices stacked in 3rd dimension
        C1(:,:,k) = (E1*E1')/(trace(E1*E1'));
        C2(:,:,k) = (E2*E2')/(trace(E2*E2'));
        C3(:,:,k) = (E3*E3')/(trace(E3*E3'));
        C4(:,:,k) = (E4*E4')/(trace(E4*E4'));
        toc
    end
    
    
    % %% Save data
    save(pTopoMatOutput, 'C1', 'C2', 'C3', 'C4')
else
    load(pTopoMatOutput)   % Contains all subjects
end
%% Mean across subject-specific covariance matrices to gain population average

S1 = mean(C1,3);
S2 = mean(C2,3);
S3 = mean(C3,3);
S4 = mean(C4,3);

%% Compute CSP and plotting of filters
Q = 3;      % Number of filters/patterns to display per class
pos = [488.2000   41.8000  349.6000  740.8000]; % suitable for 8 per class plots

% Non-task specific vs Motor action
[W,~] = CSP_Weight([],[],'new',S1,S2);
fig1 = TopoPlotColumns(W,Q);
A1 = inv(W)';

% Non-task specific vs Vocal Imagery
[W,~] = CSP_Weight([],[],'new',S1,S3);
fig2 = TopoPlotColumns(W,Q);
A2 = inv(W)';

% Non-task specific vs Motor intention (SInt)
[W,~] = CSP_Weight([],[],'new',S1,S4);
fig3 = TopoPlotColumns(W,Q);
A3 = inv(W)';

% Motor action vs VInt
[W,~] = CSP_Weight([],[],'new',S2,S4);
fig4 = TopoPlotColumns(W,Q);
A4 = inv(W)';

%% Looking at how sources influence individual electrodes (Irrelevant just for fun)
fig5 = TopoPlotColumns(A1,Q);
fig6 = TopoPlotColumns(A2,Q);
fig7 = TopoPlotColumns(A3,Q);
fig8 = TopoPlotColumns(A4,Q);

%% Figure reposition to screen size - shits-n-giggles
screen_size = get(groot, 'ScreenSize');
w_d_4 = (screen_size(3) / 4);
h_d_4 = (screen_size(4)/2);
lpos = [0:3,0:3]*w_d_4;  % Figure distances from left side
bpos = [0,0,0,0,1,1,1,1]*h_d_4; % Figure distances from bottom
% Bottom figures are filters, top filters are sources
for k = 1:8
    substr1 = num2str(k);
    substr2 = num2str(lpos(k));
    substr3 = num2str(bpos(k));
    substr4 = num2str(w_d_4);
    substr5 = num2str(h_d_4);
    str = strcat('fig',substr1,'.Position = [',substr2,',',substr3,',',substr4,',',substr5,'];');
    eval(str);
end

%% Save to file
% Make folder if it doesn't exist
dFolder = './plotsAndFigures/topoplots';
if(~exist(dFolder , 'dir'))
    str = strcat("mkdir ", dFolder);
    eval(str)
end

% Looping through the figures and saving them one by one
for k = 1:8
    substr1 = num2str(k);
    str = strcat('saveas(fig',substr1,', ''',dFolder,'/topoplot_',substr1,''',''epsc'');');
    eval(str)
    str = strcat('saveas(fig',substr1,', ''',dFolder,'/topoplot_',substr1,''',''jpg'');');
    eval(str)
end
