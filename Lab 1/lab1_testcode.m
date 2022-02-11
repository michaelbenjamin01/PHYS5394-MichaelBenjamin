clear
clc

%% expdampsin(data,A,ta,f0,tau,phi0,L)

% parameters
t = linspace(0,2*pi,300);
A = 10; % input for A
ta =  1; 
f0 = 10; 
tau = 10;
phi0 = 5;
L = pi;

% generating signal
sigVec = expdampsin(t,A,ta,f0,tau,phi0,L);

% plotting signal
figure;
plot(t,sigVec);

% plotting periodogram


% plotting spectrogram
%% stepFM(data,A,ta,f0,f1)

% parameters
% t = linspace(0,2*pi,300);
% A = 10;
% ta = 1;
f0 = 10;
f1 = 20;

% generating signal
sigVec = stepFM(t,A,ta,f0,f1);

% plotting signal
figure;
plot(t,sigVec);

% plotting periodogram

% plotting spectrogram