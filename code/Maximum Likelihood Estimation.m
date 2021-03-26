%------------------------------------------------------------------------%
% Author: Antonio Jurlina                                                %
% Program: problem_set_03.m                                              %
%------------------------------------------------------------------------%

%% Start the code with a clean slate
clc         % Clear the output in the command window
clear       % Clear all data stored in memory
close all   % Close all open figure windows
format bank % Restrict output to 2-decimal places

%% Global parameters and pseudo-data
n_obs = 2500;  % number of observations 
theta = [5 1.5 -0.5 2]';

X_i = unifrnd(-3, 6, [n_obs, 1]);
error = normrnd(0, theta(4,1), [n_obs, 1]);

Y = theta(1,1) + theta(2,1) * exp(theta(3,1)*X_i) + error;

data = [X_i, Y];

%% Summary statistics and histograms
summary_stats = table([min(X_i), min(Y)]', ...
                      [mean(X_i), mean(Y)]', ...
                      [median(X_i), median(Y)]', ...
                      [max(X_i), max(Y)]', ...
                      [std(X_i), std(Y)]');
summary_stats.Properties.VariableNames = {'min' 'mean' 'median' 'max' 'std'};
summary_stats.Properties.RowNames = {'X' 'Y'};

summary_stats

figure % open new figure
subplot(3,1,1)
histogram(X_i)
xlabel('X')

subplot(3,1,2)
histogram(Y)
xlabel('Y')

subplot(3,1,3)
histogram(error)
xlabel('error')

%% Setting up the data
options = optimset('Display','iter');
ivalues = rand(4,1);
theta_grid = fminsearch(@(theta) objfun(theta,data), ivalues, options);
theta_grad = fminunc(@(theta) objfun(theta,data), ivalues, options);

theta_grid(4) = theta_grid(4)^2;
theta_grad(4) = theta_grad(4)^2;

table(theta_grid,theta_grad, theta) % comparing the outputs and actual values

%% initial value optimizer
initial_values = zeros(100,4);
answer = zeros(100,4);

parfor o = 1:100;
    ivalues = rand(4,1);
    answer(o,:) = fminsearch(@(theta) objfun(theta,data),...
                             ivalues, options);
    initial_values(o,:) = ivalues'
end

answer(:,4) = answer(:,4).^2

row_polish = round(sum((answer - median(answer)).^2, 2),2);
index = row_polish == min(row_polish);
choose_one = randi(sum(index), 1, 1);
initial_values_clean = initial_values(index,:);
ivalues = initial_values_clean(choose_one,:)';

%% bootstrap
rng('shuffle')      % Randomize draws for bootstrap

B = 10;
theta_grid_10 = zeros(B,4);
theta_grad_10 = zeros(B,4);
parfor b = 1:B;
    bsindex = randsample((1:n_obs),n_obs,true); 
    sample = [data(bsindex, 1), data(bsindex, 2)];
    grid = fminsearch(@(theta) objfun(theta,sample), ...
        ivalues, options);
    grad = fminunc(@(theta) objfun(theta,sample), ...
        ivalues, options); 
    
    theta_grid_10(b,:) = grid;
    theta_grad_10(b,:) = grad;
end;

B = 100;
theta_grid_100 = zeros(B,4);
theta_grad_100 = zeros(B,4);
parfor b = 1:B;
    bsindex = randsample((1:n_obs),n_obs,true); 
    sample = [data(bsindex, 1), data(bsindex, 2)];
    grid = fminsearch(@(theta) objfun(theta,sample), ...
        ivalues, options);
    grad = fminunc(@(theta) objfun(theta,sample), ...
        ivalues, options); 
    
    theta_grid_100(b,:) = grid;
    theta_grad_100(b,:) = grad;
end;

B = 200;
theta_grid_200 = zeros(B,4);
theta_grad_200 = zeros(B,4);
parfor b = 1:B;
    bsindex = randsample((1:n_obs),n_obs,true); 
    sample = [data(bsindex, 1), data(bsindex, 2)];
    grid = fminsearch(@(theta) objfun(theta,sample), ...
        ivalues, options);
    grad = fminunc(@(theta) objfun(theta,sample), ...
        ivalues, options); 
    
    theta_grid_200(b,:) = grid;
    theta_grad_200(b,:) = grad;
end;

B = 1000;
theta_grid_1000 = zeros(B,4);
theta_grad_1000 = zeros(B,4);
parfor b = 1:B;
    bsindex = randsample((1:n_obs),n_obs,true); 
    sample = [data(bsindex, 1), data(bsindex, 2)];
    grid = fminsearch(@(theta) objfun(theta,sample), ...
        ivalues, options);
    grad = fminunc(@(theta) objfun(theta,sample), ...
        ivalues, options); 
    
    theta_grid_1000(b,:) = grid;
    theta_grad_1000(b,:) = grad;
end;

theta_grid_10(:,4) = theta_grid_10(:,4).^2;
theta_grad_10(:,4) = theta_grad_10(:,4).^2;
theta_grid_100(:,4) = theta_grid_100(:,4).^2;
theta_grad_100(:,4) = theta_grad_100(:,4).^2;
theta_grid_200(:,4) = theta_grid_200(:,4).^2;
theta_grad_200(:,4) = theta_grad_200(:,4).^2;
theta_grid_1000(:,4) = theta_grid_1000(:,4).^2;
theta_grad_1000(:,4) = theta_grad_1000(:,4).^2;

%% new chunk
table(mean(theta_grid_1000)', mean(theta_grad_1000)', theta)

%% plots
figure % open new figure
sgtitle('Parameter estimates from MLE');

subplot(4,4,1)
histogram(theta_grid_1000(:,1), 100)
xline(theta(1,1),'r'); 
xlabel('\beta_1 - grid');

subplot(4,4,2)
histogram(theta_grid_1000(:,2), 100)
xline(theta(2,1),'r'); 
xlabel('\beta_2 - grid');

subplot(4,4,3)
histogram(theta_grid_1000(:,3), 100)
xline(theta(3,1),'r'); 
xlabel('\beta_3 - grid');

subplot(4,4,4)
histogram(theta_grid_1000(:,4), 100)
xline(theta(4,1),'r'); 
xlabel('\sigma^2 - grid');

subplot(4,4,5)
histogram(theta_grad_1000(:,1), 100)
xline(theta(1,1),'r'); 
xlabel('\beta_1 - gradient');

subplot(4,4,6)
histogram(theta_grad_1000(:,2), 100)
xline(theta(2,1),'r'); 
xlabel('\beta_2 - gradient');

subplot(4,4,7)
histogram(theta_grad_1000(:,3), 100)
xline(theta(3,1),'r'); 
xlabel('\beta_3 - gradient');

subplot(4,4,8)
histogram(theta_grad_1000(:,4), 100)
xline(theta(4,1),'r'); 
xlabel('\sigma^2 - gradient');

%% std errors
var_cov_grid_10 = (1/(10-1))*(theta_grid_10-mean(theta_grid_10))'...
                            *(theta_grid_10-mean(theta_grid_10));
var_cov_grad_10 = (1/(10-1))*(theta_grad_10-mean(theta_grad_10))'...
                            *(theta_grad_10-mean(theta_grad_10));

var_cov_grid_100 = (1/(100-1))*(theta_grid_100-mean(theta_grid_100))'...
                              *(theta_grid_100-mean(theta_grid_100));
var_cov_grad_100 = (1/(100-1))*(theta_grad_100-mean(theta_grad_100))'...
                              *(theta_grad_100-mean(theta_grad_100));

var_cov_grid_200 = (1/(200-1))*(theta_grid_200-mean(theta_grid_200))'...
                              *(theta_grid_200-mean(theta_grid_200));
var_cov_grad_200 = (1/(200-1))*(theta_grad_200-mean(theta_grad_200))'...
                              *(theta_grad_200-mean(theta_grad_200));

var_cov_grid_1000 = (1/(1000-1))*(theta_grid_1000-mean(theta_grid_1000))'...
                                *(theta_grid_1000-mean(theta_grid_1000));
var_cov_grad_1000 = (1/(1000-1))*(theta_grad_1000-mean(theta_grad_1000))'...
                                *(theta_grad_1000-mean(theta_grad_1000));

standard_errors = ...
 table(sqrt(diag(var_cov_grid_10)), sqrt(diag(var_cov_grad_10)),...
      sqrt(diag(var_cov_grid_100)), sqrt(diag(var_cov_grad_100)),...
      sqrt(diag(var_cov_grid_200)), sqrt(diag(var_cov_grad_200)),...
      sqrt(diag(var_cov_grid_1000)), sqrt(diag(var_cov_grad_1000)));
 
standard_errors.Properties.VariableNames=...
    {'grid_10' 'grad_10'...
     'grid_100' 'grad_100'...
     'grid_200' 'grad_200'...
     'grid_1000' 'grad_1000'};

standard_errors.Properties.RowNames=...
    {'beta_1' 'beta_2' 'beta_3' 'sigma^2'};

standard_errors

%% Monte Carlo
%R = 250;
%R = 500;
R = 25000;
theta_grid_MC = zeros(R,4);
theta_grad_MC = zeros(R,4);
parfor r=1:R;
    X_i = unifrnd(-3, 6, [n_obs, 1]);
    error = normrnd(0, theta(4,1), [n_obs, 1]);
    Y = theta(1,1) + theta(2,1) * exp(theta(3,1)*X_i) + error;
    data = [X_i, Y];
    
    starting_values = randn(4,1);
    
    grid = fminsearch(@(theta) objfun(theta,data), ...
        starting_values, options);
    grad = fminunc(@(theta) objfun(theta,data), ...
        starting_values, options); 
    
    theta_grid_MC(r,:) = grid;
    theta_grad_MC(r,:) = grad;
end

theta_grid_MC(:,4) = theta_grid_MC(:,4).^2;
theta_grad_MC(:,4) = theta_grad_MC(:,4).^2;

%% Monte Carlo summary statistics 
MC_grid = table(min(theta_grid_MC)', mean(theta_grid_MC)', ...
                median(theta_grid_MC)', max(theta_grid_MC)', ...
                std(theta_grid_MC)');
  
MC_grid.Properties.VariableNames = ...
    {'min' 'mean' 'median' 'max' 'std'};
MC_grid.Properties.RowNames=...
    {'beta_1' 'beta_2' 'beta_3' 'sigma^2'};
  
MC_grad = table(min(theta_grad_MC)', mean(theta_grad_MC)', ...
                median(theta_grad_MC)', max(theta_grad_MC)', ...
                std(theta_grad_MC)');

MC_grad.Properties.VariableNames = ...
    {'min' 'mean' 'median' 'max' 'std'};
MC_grad.Properties.RowNames=...
    {'beta_1' 'beta_2' 'beta_3' 'sigma^2'};
    
MC_grid
MC_grad

%% Monte Carlo plots
figure % open new figure
sgtitle('Monte Carlo estimates');

subplot(4,4,1)
histogram(theta_grid_MC(:,1), 100)
xline(theta(1,1),'g'); 
xlabel('\beta_1 - grid');

subplot(4,4,2)
histogram(theta_grid_MC(:,2), 100)
xline(theta(2,1),'g'); 
xlabel('\beta_2 - grid');

subplot(4,4,3)
histogram(theta_grid_MC(:,3), 100)
xline(theta(3,1),'g'); 
xlabel('\beta_3 - grid');

subplot(4,4,4)
histogram(theta_grid_MC(:,4), 100)
xline(theta(4,1),'g'); 
xlabel('\sigma^2 - grid');

subplot(4,4,5)
histogram(theta_grad_MC(:,1), 100)
xline(theta(1,1),'g'); 
xlabel('\beta_1 - gradient');

subplot(4,4,6)
histogram(theta_grad_MC(:,2), 100)
xline(theta(2,1),'g'); 
xlabel('\beta_2 - gradient');

subplot(4,4,7)
histogram(theta_grad_MC(:,3), 100)
xline(theta(3,1),'g'); 
xlabel('\beta_3 - gradient');

subplot(4,4,8)
histogram(theta_grad_MC(:,4), 100)
xline(theta(4,1),'g'); 
xlabel('\sigma^2 - gradient');





