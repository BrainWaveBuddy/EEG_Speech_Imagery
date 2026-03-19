%% A&Y
% 26/05/19
% CSP filter
% If not provided then compute Covariance matrices of the two classes as 
% input. Compute the CSP weights from covariance matrices
function [W,LAMBDA] = CSP_Weight(E1,E2,Warg,S1,S2)
    % find Sigma 1 and Sigma 2 if they are not provided
    if (nargin < 4 && ~isempty(E1) && ~isempty(E2)) || isempty(S1) || isempty(S2)
        S1 = (E1*E1')/(trace(E1*E1'));
        S2 = (E2*E2')/(trace(E2*E2'));
    end
    SigSum = S1 + S2;

    % Eigenvalue decomposition
    [U,D,~] = svd(SigSum);
    P = sqrt(inv(D)) * U';
    
%     % Create V, with random matrix
%     
%     v = randn(size(E1,1));
%     V = orth(v);
%     
%     % Apply V to achieve W
%     
%     W = P'*V;
    
    W = P';         

    if strcmp(Warg,'non')
        W = eye(16);
    elseif  strcmp(Warg,'new')
        [V1,LAMBDA,~] = svd(P*S1*(P'));
        W = P'*V1;
    elseif  strcmp(Warg,'new2')
        [V2,~,~] = svd(P*S2*(P'));
        W = P'*V2;
    end
end