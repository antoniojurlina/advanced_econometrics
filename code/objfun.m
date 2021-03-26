function [neg_LL] = objfun(theta, data)

sigmasq = exp(theta(4,1));

error = data(:,2) - theta(1,1) - theta(2,1)*exp(theta(3,1)*data(:,1));

[n, k] = size(data);

LL = -n/2*log(2*pi)-n/2*log(sigmasq)-(1/(2*sigmasq))*error'*error;

neg_LL = -1 * LL

end

