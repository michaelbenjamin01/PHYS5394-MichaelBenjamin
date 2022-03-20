clear
clc

addpath ..\L3Lab
%% stepFM(data,A,ta,f0,f1)
% This function has two different forms depending if t =< t_a or if t >
% t_a. As a result, we will find the nyquist sampling frequency for both
% conditions.
%FIXME There is only one Nyquist sampling frequency: 2*(the highest freq.)
%NOTE It just so happens that your f1 is not high enough to overshoot 5*f0.

% for t =< t_a:
% s(t) = A*sin(2*pi*f_0*t)
% This means that phi(t) = f_0 * t, and d(phi)/dt = f_0.
% This means nyquist sampling frequency is 2*f_0.

% for t > t_a:
% s(t) = A*sin(2*pi*f_1*(t-t_a) + 2*pi*f_0*t_a)
% so, phi(t) = f_1*(t-t_a) + f_0*t_a.
% then, d(phi)/dt = f_1 and nyquist sampling frequency is 2*f_1.

% parameters
SNR = 10;
ta = 2;
f0 = 10;
f1 = 30;
%nqstfs = 2*f0; % Nyquist sampling frequency
%FIXME 2*(max(f0,f1))
nqstfs = 2*max(f0,f1);

%% plotting for sampling frequency as 5 times nyquist sampling frequency.

fs = 5 * nqstfs; % sampling frequency
samplIntvl = 1/fs; % sampling interval;
timeVec = 0:samplIntvl:5;
% generating signal
sigVec = stepFM(timeVec,SNR,ta,f0,f1);

% plotting signal
figure;
plot(timeVec,sigVec);
title('step FM timeseries, sampling frequency fs = 5*nqstfs')
grid on; grid minor;

% plotting periodogram
dataLen = timeVec(end) - timeVec(1);
kNyq = floor(length(timeVec)/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
fftSig = fft(sigVec);
fftSig = fftSig(1:kNyq);

figure;
plot(posFreq,abs(fftSig));
title('step FM periodogram, sampling frequency fs = 5*nqstfs');
grid on; grid minor;

% plotting spectrogram
winLen = 0.4; % in seconds
ovrlp = 0.01; % in seconds

winLenSmpls = floor(winLen*fs);
ovrlpSmpls = floor(ovrlp*fs);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],fs);
figure;
imagesc(T,F,abs(S)); axis xy;
title('step FM spectrogram, sampling frequency fs = 5*nqstfs');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');

%% plotting for sampling frequency as 1/2 of the nyquist sampling frequency

fs = 0.5 * nqstfs; % sampling frequency
samplIntvl = 1/fs; % sampling interval;
timeVec = 0:samplIntvl:5;
% generating signal
sigVec = stepFM(timeVec,SNR,ta,f0,f1);

% plotting signal
figure;
plot(timeVec,sigVec);
xlabel('time (s)');
ylabel('Amplitude');
title('step FM timeseries, sampling frequency fs = 1/2*nqstfs')
grid on; grid minor;

% plotting periodogram
dataLen = timeVec(end) - timeVec(1);
kNyq = floor(length(timeVec)/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
fftSig = fft(sigVec);
fftSig = fftSig(1:kNyq);

figure;
plot(posFreq,abs(fftSig));
xlabel('frequency (Hz)');
ylabel('Power');
title('step FM periodogram, sampling frequency fs = 1/2*nqstfs');
grid on; grid minor;

% plotting spectrogram
winLen = 2.0; % in seconds
ovrlp = 1.9; % in seconds

winLenSmpls = floor(winLen*fs);
ovrlpSmpls = floor(ovrlp*fs);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],fs);
figure;
imagesc(T,F,abs(S)); axis xy;
title('step FM spectrogram, sampling frequency fs = 1/2*nqstfs');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');