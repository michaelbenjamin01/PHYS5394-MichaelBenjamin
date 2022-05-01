clear
clc

%% stepFM(data,A,ta,f0,f1)
%FIXME Doc: The function being called has a different input argument list than the one given here in the section header.

% parameters
fs = 128; %sampling frequency 1/128s
intvs = 1/fs; % sampling interval;
timeVec = 0:intvs:5;
A = 10;
ta = 1;
f0 = 10;
f1 = 20;
params = struct('ta',1,'f0',10,'f1',20);

% generating signal
sigVec = @(x) stepFM_new(timeVec,x,params);

% plotting signal
%FIXME Plots: no axis labels.
figure;
subplot(3,1,1);
plot(timeVec,sigVec(10));
title('step FM timeseries snr = 10');

subplot(3,1,2);
plot(timeVec,sigVec(12));
title('step FM timeseries snr = 12');

subplot(3,1,3);
plot(timeVec,sigVec(15))
title('step FM timeseries snr = 15');