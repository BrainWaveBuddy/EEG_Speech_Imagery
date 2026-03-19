%% P-value analysis

% H_0: my = no difference
% H_0: my = 0.5 (TP)
% H_a: binary = 1.0
% Arbitary significance threshold of 5 percent .. alpha = 0.05
% sample mean xi

%%
close all; clear all; clc;
%% load data

load('BothTable.mat')
load('MaleTable.mat')
load('FemaleTable.mat')

%% remove outliers (subj 6 (M))

B_out = BothTable
B_out(6,:) = []

M_out = MaleTable
M_out(6,:) = []

%% extract TP, TN, FP, FN
% multiply by 2, since range is 0-0.5

TP_b = BothTable(:,1) * 2
TN_b = BothTable(:,2) * 2
FP_b = BothTable(:,3) * 2
FN_b = BothTable(:,4) * 2

TP_m = MaleTable(:,1) * 2
TN_m = MaleTable(:,2) * 2
FP_m = MaleTable(:,3) * 2
FN_m = MaleTable(:,4) * 2

TP_f = FemaleTable(:,1) * 2
TN_f = FemaleTable(:,2) * 2
FP_f = FemaleTable(:,3) * 2
FN_f = FemaleTable(:,4) * 2

TP_b_out = B_out(:,1) * 2
TP_m_out = M_out(:,1) * 2
%% Mean of true positives (sample mean)

TP_b_mean = sum(TP_b)/length(TP_b)
TP_m_mean = sum(TP_m)/length(TP_m)
TP_f_mean = sum(TP_f)/length(TP_f)
TP_b_out_mean = sum(TP_b_out)/length(TP_b_out)
TP_m_out_mean = sum(TP_m_out)/length(TP_m_out)

%% standard deviation

TP_b_std = std(TP_b)
%% Test null hypothesis

H_0 = 0.5

%% chi square

%x2 = ((TP_b_mean-H_0)^2/H_0) * 100

%% t-test

% t value

x_bar1 = TP_b_mean
x_bar2 = H_0

signal = x_bar1 - x_bar2

% variance

s1 = TP_b_std^2
s2 = std(H_0)^2

n1 = 17
n2 = 1

t_value = (x_bar1 - x_bar2) / (sqrt((s1 / 17) + (s2 / 1)))

% t test
% alternatively using ttest()

[h, p, ci, stats] = ttest(TP_b)