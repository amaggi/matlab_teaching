function [p] = poisson(lambda,k)
p = exp(-lambda)*(lambda.^k)./factorial(k);
end