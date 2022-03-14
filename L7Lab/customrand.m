function randY = customrand(y, a, b)
% This function creates a random uniform distribution of variables Y in the
% form of U(Y;a,b) in the range where the distribution is in the range of
% [a,b]. We get this from the uniform distribution of variables X, which
% has the form U(X;0,1). We find U(Y;a,b) using the following equation:
% Y = (b - a)X + a. X is found as the rand(n) function in matlab.

% y = size of array used to produce data. This can be a matrix of size mxn.
% a = lower bound for uniform distribution.
% b = upper bound for uniform distribution.

randY = a + (b - a)*rand(y);