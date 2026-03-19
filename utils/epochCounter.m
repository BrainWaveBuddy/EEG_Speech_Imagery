function nEpochs = epochCounter(nSamp, lag, eSz)
% how many epochs can the data be divided into? This allows for 'for'
% instead of 'while' loop, speeding up the process
% function describing the end sample of the K'th epoch:
fun = @(K)(lag-1)*K+eSz-nSamp;
nEpochs = floor(fzero(fun,1));   % The total amount of whole epochs