clear
clc

%% stepFM(data,A,ta,f0,f1)

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
sigVec = stepFM_new(timeVec,A,params);

% plotting signal
figure;
plot(timeVec,sigVec);
title('step FM timeseries')
grid on; grid minor;

% plotting periodogram
dataLen = timeVec(end) - timeVec(1);
kNyq = floor(length(timeVec)/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
fftSig = fft(sigVec);
fftSig = fftSig(1:kNyq);

figure;
plot(posFreq,abs(fftSig));
title('step FM periodogram');
grid on; grid minor;
