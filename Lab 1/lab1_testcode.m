clear
clc

%% expdampsin(data,A,ta,f0,tau,phi0,L)

% parameters
% timeVec = linspace(0,2*pi,300);
fs = 128; %sampling frequency 1/100s
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

% plotting periodogram
dataLen = timeVec(end) - timeVec(1);
kNyq = floor(length(timeVec)/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
fftSig = fft(sigVec);
fftSig = fftSig(1:kNyq);

figure;
plot(posFreq,abs(fftSig));

% plotting spectrogram
winLen = 0.02; % in seconds
ovrlp = 0.01; % in seconds

winLenSmpls = floor(winLen*fs);
ovrlpSmpls = floor(ovrlp*fs);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],fs);
figure;
imagesc(T,F,abs(S)); axis xy;
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

% plotting periodogram
dataLen = timeVec(end) - timeVec(1);
kNyq = floor(length(timeVec)/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
fftSig = fft(sigVec);
fftSig = fftSig(1:kNyq);

figure;
plot(posFreq,abs(fftSig));

% plotting spectrogram
winLen = 0.02; % in seconds
ovrlp = 0.01; % in seconds

winLenSmpls = floor(winLen*fs);
ovrlpSmpls = floor(ovrlp*fs);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],fs);
figure;
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
