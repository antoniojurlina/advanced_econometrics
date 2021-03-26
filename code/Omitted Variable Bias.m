%------------------------------------------------------------------------%
% Author: Antonio Jurlina                                                %
% Program: problem_set_02.m                                              %
%------------------------------------------------------------------------%

%% Start the code with a clean slate
clc         % Clear the output in the command window
clear       % Clear all data stored in memory
close all   % Close all open figure windows
format bank % Restrict output to 2-decimal places

%% Global parameters
nobs = 20000;                     % number of observations 
betas = [-3 2 0.5]';
alphas = [1.5 -3]';

%% (a)
X_i = normrnd(10, 5, [nobs, 1]);
%% (b)
e_1 = normrnd(0, 1, [nobs, 1]);
e_2 = normrnd(0, 0.75, [nobs, 1]);
%% (c)
D = alphas(1,1) + alphas(2,1)*X_i + e_2;

X = [ones(nobs,1), X_i, D]; 

%% (d)
y = betas(1,1) + betas(2,1)*X_i + betas(3,1)*D + e_1;

%% (e)
[bhat, se, r2] = myols(X,y);
tstat = bhat./se;
p = 2*(1-tcdf(abs(tstat), nobs - size(betas,1)));
ols = table(betas, bhat, se, p);
ols.Properties.VariableNames = {'actual' 'estimate' 't-stat' 'p-value'};
ols.Properties.RowNames = {'beta_0' 'beta_1' 'beta_2'};
ols

% My estimates cdiffer slightly from the parameters used in generating data
% but it is faiyl evident they vary around those values.

%% (f) 
nobs = 20000;
X_i = normrnd(10, 5, [nobs, 1])
e_1 = normrnd(0, 1, [nobs, 1])
e_2 = normrnd(0, 0.75^2, [nobs, 1])
D = alphas(1,1) + alphas(2,1)*X_i + e_2;
X = [ones(nobs,1), X_i, D]; 
y = betas(1,1) + betas(2,1)*X_i + betas(3,1)*D + e_1;
[bhat, se, r2] = myols(X,y);
tstat = bhat./se;
p = 2*(1-tcdf(abs(tstat), nobs - size(betas,1)));
ols = table(betas, bhat, se, p);
ols.Properties.VariableNames = {'actual' 'estimate' 't-stat' 'p-value'};
ols.Properties.RowNames = {'beta_0' 'beta_1' 'beta_2'};
ols

% If the sample size is increased, the values of my estimates get closer
% to the parameter values used in generating the data.

nobs = 20;
X_i = normrnd(10, 5, [nobs, 1])
e_1 = normrnd(0, 1, [nobs, 1])
e_2 = normrnd(0, 0.75^2, [nobs, 1])
D = alphas(1,1) + alphas(2,1)*X_i + e_2;
X = [ones(nobs,1), X_i, D]; 
y = betas(1,1) + betas(2,1)*X_i + betas(3,1)*D + e_1;
[bhat, se, r2] = myols(X,y);
tstat = bhat./se;
p = 2*(1-tcdf(abs(tstat), nobs - size(betas,1)));
ols = table(betas, bhat, se, p);
ols.Properties.VariableNames = {'actual' 'estimate' 't-stat' 'p-value'};
ols.Properties.RowNames = {'beta_0' 'beta_1' 'beta_2'};
ols

% If the sample size is decreased, the values of my estimates get further
% away from the parameter values used in generating the data.

%% (g) (h)
[summary data] = myMC(500, 200, alphas, betas, 0);
[summary_o data_o] = myMC(500, 200, alphas, betas, 1);

figure % open new figure
subplot(2,2,1)
histogram(data(:, 1))
xlabel('Beta 0')

subplot(2,2,2)
histogram(data(:, 2))
xlabel('Beta 1')

subplot(2,2,3)
histogram(data_o(:, 1))
xlabel('Beta 0 with omission')

subplot(2,2,4)
histogram(data_o(:, 2))
xlabel('Beta 1 with omission')
    
%% (i)
% Given that the Beta 2 parameter (used for generating the data) is
% positive, and that the correlation between D and X_i is negative, 
% omitting variable D would result in a negative bias on Beta 1, that is
% Beta 1 would be smaller in our estimates than it actually is.

%% (j)
nobs = 2000; 
% theoretical bias
X_i = normrnd(10, 5, [nobs, 1]);
e_2 = normrnd(0, 0.75^2, [nobs, 1]);
D = alphas(1,1) + alphas(2,1)*X_i + e_2;
bhat = myols([ones(nobs,1), X_i], D);
theoretical_bias = bhat(2,:)*betas(3,:);
% estimated bias
estimated_bias = mean(data_o(:,2))- betas(2,:);

table(theoretical_bias, estimated_bias)

% The bias is consistent with the theoretic value. 

%% (k)
tstat_table = table([min(data(:, 6)), mean(data(:, 6)), max(data(:, 6))]', ...
                    [min(data_o(:, 6)), mean(data_o(:, 6)), max(data_o(:, 6))]');
tstat_table.Properties.VariableNames = {'tstat' 'tstat with omission'};
tstat_table.Properties.RowNames = {'min' 'mean' 'max'};
tstat_table

% If we were to assume that the underlying process generating the data is
% unknown, the t-statistics themselves do not help us identify any relevant 
% omissions. Potentially, these higher t-statistics might lead us to
% falsely attach more significane to our results as we our now more likely
% to reject the null (that parameters are equal to zero). This would lead
% to us rejecting the null based on biased premises. On their own,
% t-statistics did not help identify the presence of omitted variable bias.
