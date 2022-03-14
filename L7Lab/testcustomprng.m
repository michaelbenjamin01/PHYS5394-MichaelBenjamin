clear
clc

trial = [1 10000];
%% making data with U(x;-2,1) distribution and plotting it's PDF

aU = -2; % value of a for uniform distribution
bU = 1; % value of b for uniform distribution

xU = linspace(-2.5,1.5,10000); % linearly spaced data between -2.5 & 1.5. This is just so that the PDF has something to plot against
valU = customrand(trial,-2,1); % creating uniformly distributed array of random data

pU = zeros(trial); % initializing zeroes for pdf

% the for loop & if statement below represents the conditial equation to
% find the pdf for the uniform distribution
for i = 1:10000
    if aU <= xU(i) && xU(i) <= bU
        pU(i) = 1/(bU-aU);
    end
end

% plotting for uniform distribution
figure; hold on;
histogram(valU,'Normalization','pdf');
plot(xU,pU);
grid on;
title('Histogram & pdf for a Uniform dist U(X; a, b)')
xlabel('y (values of random variable Y)');
ylabel('p_Y(y) = U(X; a, b)');

%% making data with N(x;1.5,2.0) distribution and plotting it's PDF

aN = 1.5; % value of a for normal distribution (mu)
bN = 2; % value of b for normal distribution (sigma)
xN = linspace(-6,8,10000); % linearly spaced data between -6 & 8. this is just so that the PDF has something to plot against.

valN = customrandn(trial,aN,bN); % creating normally distributed set of random data
pN = 1/(sqrt(2*pi)*bN)*exp(-(xN-aN).^2/(2*bN^2)); % pdf equation for normally distributed data

% plotting for normal distribution;
figure; hold on;
histogram(valN,'Normalization','pdf');
plot(xN,pN);
grid on;
title('Histogram and pdf for a Normal dist N(X; \mu, \sigma)');
xlabel('y (values of random variable Y)');
ylabel('p_Y(y) = N(X; \mu, \sigma)');