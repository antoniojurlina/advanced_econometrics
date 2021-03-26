function [bhat, se, r2] = myols(X,y)
% MYOLS Perform OLS regression
%   [bhat, se, r2] = MYOLS(x,y). x is the data input. y is the output

%% Determine dimensions of data
[n, k] = size(X);   % sample size and number of parameters estimated
df = n-k;           % degrees of freedom


%% OLS parameter estimates
bhat = inv(X'*X)*X'*y % use OLS -- the matrix version is simplest.


%% Standard errors
ehat = y - X*bhat;          % residuals
sighat = (ehat'*ehat) / df; % calculate sigma hat
Vhat = inv(X'*X)*sighat;    % Var-Cov matrix on parameter estimates
se = sqrt(diag(Vhat))       % standard errors 


%% Coefficient of determination
RSS = ehat'*ehat;           % residual sum of squares
ybar = mean(y); 
yybar = y-ybar;
TSS = yybar'*yybar;         % total sum of squares
r2 = 1 - RSS/TSS           % R-squared


