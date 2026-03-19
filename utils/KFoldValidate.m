function [TP,FP,TN,FN, W, Xout,Yout,Tout,AUCout,CMout] = KFoldValidate(data1, data2,k,lag,eSz, Warg)
% Takes the parameter k, do the k-fold cross validation and determine
% average true positive, false positive, true negative and false negative

% Flag if Reciever Operator Curves should be computed
if nargout < 6
    rocFlag = false;
else
    rocFlag = true;
end

% Assuming data1 and data2 are equally long
len = size(data1,2);
nChl = size(data1,1);
nSamp = floor(len/k);

% Pre allocation
TP = zeros(k,1);FP = zeros(k,1);TN = zeros(k,1);FN = zeros(k,1);
W = zeros(nChl,nChl,k);

if rocFlag
    % The number of points for which the ROC curve is computed depends on the
    % size of the test dataset
    nROCpoints = 2*epochCounter(size(data2,2)/k,lag,eSz) + 1;
    X = zeros(nROCpoints,k); Y = zeros(nROCpoints,k); T = zeros(nROCpoints,k);
    AUC = zeros(k,1); CM = zeros(2,2,k);
end

for II = 1:k
    idx1 = nSamp*(II-1)+1;
    idx2 = nSamp*II;
    
    if II == k
        idx2 = len;
    end
    
    testDat1 = data1(:,idx1:idx2);
    testDat2 = data2(:,idx1:idx2);
    
    trainDat1 = data1; trainDat1(:,idx1:idx2)=[];
    trainDat2 = data2; trainDat2(:,idx1:idx2)=[];
    
    testT = cat(3,testDat1,testDat2);
    trainT = cat(3,trainDat1,trainDat2);
    clear testDat1 testDat2  trainDat1 trainDat2;
    
    if rocFlag
        [TP(II),FP(II),TN(II),FN(II), W(:,:,II), X(:,II),Y(:,II),T(:,II),AUC(II), CM(:,:,II)] = SingleValidate(trainT,testT,lag,eSz,Warg);
    else
        [TP(II),FP(II),TN(II),FN(II), W(:,:,II)] = SingleValidate(trainT,testT,lag,eSz,Warg);
    end
end

total = sum([TP(1),FP(1),TN(1),FN(1)]);     % Total number of classifications stays same
TP = mean(TP)/total; 
FP = mean(FP)/total;
TN = mean(TN)/total;
FN = mean(FN)/total;
if rocFlag
    Xout = mean(X,2);
    Yout = mean(Y,2);
    Tout = mean(T,2);
    AUCout = mean(AUC);
    CMout = sum(CM,3);
end