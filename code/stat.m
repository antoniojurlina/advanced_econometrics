function [mean, stdev] = stat(x)
% STAT Mean and standard deviation
%   [M S] = STAT(x) is the mean and standard deviation of the elements in 
%   X if X is a vector. For matrices, [M S] are row vectors containing the 
%   mean and standard deviation of each column. 

% Adjust algorithm for vectors and matrices
[m n] = size(x);                        % determine the dimensions of x
if m == 1           
    m = n;                              % handle case of a row vector
end

% Calculate statistics
mean = sum(x)/m;                        % sample mean
stdev = sqrt(sum(x.^2)/m-mean.^2);      % sample standard deviation