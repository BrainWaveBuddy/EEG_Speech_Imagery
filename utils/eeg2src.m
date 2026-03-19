function S = eeg2src(data,W)
% This function takes EEG data as input array, 'data'. The first dimension
% is channel index, second is time index, subsequent dimensions can be of
% any order. 
% data          : Data input
% W             : 2-dimensional weight matrix

sz = size(data);
nChl = sz(1);           % Channels
nSamp = sz(2);          % Time samples
sz(1:2) = [];
pr = prod(sz);

% Matrix multiplication in 2-dimensions
data2 = reshape(data,nChl,nSamp*pr);  % One huge ass matrix
S2 = W*data2;

% Bring back to initial array dimensions
S = reshape(S2,[nChl,nSamp,sz]);