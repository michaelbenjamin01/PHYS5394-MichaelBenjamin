function randData = customrandn(y, a, b)
% This function creates a random normal distribution of variables Y in the
% form of N(Y;mu,sigma) in the range where mu is the mean of the
% distribution, and sigma is the standard deviation of the distribution. We
% get the distribution N(Y;mu,sigma) from the base normal distribution
% N(X;0,1). We can get the distribution for Y using the following:
% Y + mu*X + sigma

% y = size of array used to produce data. This can be a matrix of size mxn
% a = mu, mean of distribution
% b = sigma, standard deviation of distribution

randData = a * randn(y) + b;