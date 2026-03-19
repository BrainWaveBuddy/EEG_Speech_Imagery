clc, clear all, close all

% Load data
load('BothTable.mat')
load('MaleTable.mat')
load('FemaleTable.mat')

TP_b = BothTable(:,1)
TN_b = BothTable(:,2)
FP_b = BothTable(:,3)
FN_b = BothTable(:,4)

TP_m = MaleTable(:,1)
TN_m = MaleTable(:,2)
FP_m = MaleTable(:,3)
FN_m = MaleTable(:,4)

TP_f = FemaleTable(:,1)
TN_f = FemaleTable(:,2)
FP_f = FemaleTable(:,3)
FN_f = FemaleTable(:,4)

% Boxplot True Positives (both, male, female)
figure(1)
boxplot(TP_b)
figure(2)
boxplot(TP_m)
figure(3)
boxplot(TP_f)