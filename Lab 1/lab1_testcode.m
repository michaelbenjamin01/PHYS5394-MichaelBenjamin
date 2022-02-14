clear
clc

%% expdampsin(data,A,ta,f0,tau,phi0,L)
%FIXME: Add a few lines here about this script. The title above should be
%reserved for the function's documentation.

% parameters
% timeVec = linspace(0,2*pi,300);
%FIXME The comment for fs is incorrect.
fs = 128; %sampling frequency 1/100s
%FIXME The meaning of 'Itvs' is not evident; standard variable name
%convention is to start with lowercase. Whichever convention you pick,
%follow it consistently ('timeVec' starts with lowercase but 'Itvs' does
%not).
Itvs = 1/fs; % sampling interval;
timeVec = 0:Itvs:5;
A = 10; % amplitude of our signal
ta =  1; % beginning of the window for the exponentially damped sinusoid
f0 = 10; 
tau = 10;
phi0 = 5;
L = pi;

% generating signal
sigVec = expdampsin(timeVec,A,ta,f0,tau,phi0,L);

% plotting signal
figure;
plot(timeVec,sigVec);
title('exponentially damped sinusoid timeseries')
grid on; grid minor;

% plotting periodogram
dataLen = timeVec(end) - timeVec(1); % obtaining length of data
kNyq = floor(length(timeVec)/2)+1; % DFT point at nyquist frequency
posFreq = (0:(kNyq-1))*(1/dataLen); % positive frequencies in fft
fftSig = fft(sigVec); % fast fourier transform of signal
fftSig = fftSig(1:kNyq); % removing frequencies to the left of nyquist freq

%FIXME Add axes labels 
figure;
plot(posFreq,abs(fftSig));
title('exponentially damped sinusoid periodogram')
grid on; grid minor;

% plotting spectrogram
winLen = 0.02; % in seconds
ovrlp = 0.01; % in seconds

winLenSmpls = floor(winLen*fs);
ovrlpSmpls = floor(ovrlp*fs);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],fs);
figure;
imagesc(T,F,abs(S)); axis xy;
title('exponentially damped sinusoid spectrogram');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');

%% stepFM(data,A,ta,f0,f1)

% parameters
% t = linspace(0,2*pi,300);
% A = 10;
% ta = 1;
f0 = 10;
f1 = 20;

% generating signal
sigVec = stepFM(timeVec,A,ta,f0,f1);

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

% plotting spectrogram
winLen = 0.02; % in seconds
ovrlp = 0.01; % in seconds

winLenSmpls = floor(winLen*fs);
ovrlpSmpls = floor(ovrlp*fs);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],fs);
figure;
imagesc(T,F,abs(S)); axis xy;
title('step FM spectrogram');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
