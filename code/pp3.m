function [m i] = pp3(mu, sigma, n)

A = normrnd(mu, sigma, n, 1);

m = median(A);
i = iqr(A);

end
