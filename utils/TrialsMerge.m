function [NTS,M,SMI,MI] = TrialsMerge
% NTS = Non-Task specific
% M = Motor function
% SMI = Speech Motor Imaging
% MI = Motor Intention
NTS = [];
M = [];
SMI = [];
MI = [];

for k = 2:11
    str1 = strcat('trial',num2str(k),'.mat');
    load(str1);
    mat = FullsingleData.SessionStream;
    NTS = [NTS; mat];
end

for k = 13:22
    str1 = strcat('trial',num2str(k),'.mat');
    load(str1);
    mat = FullsingleData.SessionStream;
    M = [M; mat];
end

for k = 24:33
    str1 = strcat('trial',num2str(k),'.mat');
    load(str1);
    mat = FullsingleData.SessionStream;
    SMI = [SMI; mat];
end

for k = 35:44
    str1 = strcat('trial',num2str(k),'.mat');
    load(str1);
    mat = FullsingleData.SessionStream;
    MI = [MI; mat];
end
