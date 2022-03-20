function randY = customrand(y, a, b)
%NOTE Missing user interface description
%R = CUSTOMRAND(N,A,B)
% Draw N trial values, R, from the uniform PDF U(Y;a,b) over the range 
% [a,b]. We get this from the uniform distribution of variables X, which
% has the form U(X;0,1). We find U(Y;a,b) using the following equation:
% Y = (b - a)X + a. X is found as the rand(n) function in matlab.

% y = size of array used to produce data. This can be a matrix of size mxn.
% a = lower bound for uniform distribution.
% b = upper bound for uniform distribution.

%FIXME 'y' is not a good variable name; use 'nTrials' instead.
randY = a + (b - a)*rand(y);