function E = epochExtraction(data,lag,eSz)
% Extracts epochs along the second dimension of N-dimensional array, 'data'
% and outputs an (N+1)dimensional array, E. In 'data' and 'E' the first 2
% dimensions represent channel number, and time index, respectively. along
% the third dimension of array E the different epochs are stored. All
% subsequent dimensions can be arbitrarily chosen and is equivalently
% represented in 'data' and in 'E'.
% data     : array of N dimensions
% lag       : the number of samples shiftet between the extracted epocs
% eSz      : the epoch size extracted
% E          : Extracted epochs along dimension 3.
% By Alexander B Kristensen - 06-04-2019

nSamp = size(data,2);
nChl = size(data,1);

%% Number of Epochs the data can be divided into
eN = epochCounter(nSamp,lag,eSz);


% The data is reshaped to three dimensions for consistent index extraction
iniSz = size(data);
iniSz(1:2) = [];        % Size of other dimensions than channel and time
broad = prod(iniSz);    % = 1 if iniSz is empty
data2 = reshape(data,[nChl,nSamp,broad]);

%  Preallocation of epoch array, e
e = nan(nChl,eSz,eN,broad);
for k = 1:eN
    % Start and stop indices of epoch
    idx1 = (lag-1)*k+1;
    idx2 = idx1-1+eSz;
    
    e(:,:,k,:) = data2(:,idx1:idx2,:);
end

% Reshape back into the respective dimensions
E = reshape(e,[nChl,eSz,eN,iniSz]);
% First index refers to the channel, second index refers to the time points
% of the epoch