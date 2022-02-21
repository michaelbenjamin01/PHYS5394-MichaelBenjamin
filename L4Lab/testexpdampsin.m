clear
clc
%% Exponentially damped sinusoid
% This function is windowed for t in the range [t_a, t_a + L], everywhere else it is
% zero. Because of this, we will only be finding the sampling frequency for
% the function in the window [t_a, t_a + L].

% signal has the form s(t) = a(t)*cos(2*pi*phi(t)) with the following:
% a(t) = A*exp(-(t-t_a)/tau)
% phi(t) = (f_0 * t + phi_0/(2pi))

% f(t) = d(phi)/dt = f_0
% f_0 is constant throughout the signal so the nyquist rate is 2*f_0.

% parameters
SNR = 10; % amplitude of our signal
ta =  1; % beginning of the window for the exponentially damped sinusoid
f0 = 5; % initial frequency as discussed in the above description, f0  
tau = 10;
phi0 = 5; % initial phase
L = pi; % end of the window for exponentially damped sinusoid
nqstfs = 2*f0; % nyquist sampling frequency

%% plotting for sampling frequency as 5 times nyquist sampling frequency.

fs = 5 * nqstfs; % sampling frequency
samplIntvl = 1/fs; % sampling interval;
timeVec = 0:samplIntvl:5;

% generating signal
sigVec = expdampsin(timeVec,SNR,ta,f0,tau,phi0,L);

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
winLen = 0.4; % in seconds
ovrlp = 0.01; % in seconds

winLenSmpls = floor(winLen*fs);
ovrlpSmpls = floor(ovrlp*fs);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],fs);
figure;
imagesc(T,F,abs(S)); axis xy;
title('exponentially damped sinusoid spectrogram');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');

%% plotting for sampling frequency as 1/2 of nyquist sampling frequency.

fs = 0.5 * nqstfs; % sampling frequency
samplIntvl = 1/fs; % sampling interval;
timeVec = 0:samplIntvl:5;

% generating signal
sigVec = expdampsin(timeVec,SNR,ta,f0,tau,phi0,L);

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
winLen = 0.4; % in seconds
ovrlp = 0.01; % in seconds

winLenSmpls = floor(winLen*fs);
ovrlpSmpls = floor(ovrlp*fs);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],fs);
figure;
imagesc(T,F,abs(S)); axis xy;
title('exponentially damped sinusoid spectrogram');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');