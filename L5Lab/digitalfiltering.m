clear
clc

addpath ../L3Lab/;
nSamples = 2048; % set number of samples
sampFreq = 1024; % sampling frquency

timeVec = (0:(nSamples-1))/sampFreq;

%% Sinusoid signals

% Signal parameters: parameters are generated in a 1x3 vector where the
% element number corresponds to the signal number.
A = [10 5 2.5]; % Amplitude of the sinusoid
f0 = [100 200 300]; % initial frequency
phi0 = [0 pi/6 pi/4]; % initial phase

% Generate sinusoid signals
sigVec1 = sinusoid(timeVec,A(1),f0(1),phi0(1));
sigVec2 = sinusoid(timeVec,A(2),f0(2),phi0(2));
sigVec3 = sinusoid(timeVec,A(3),f0(3),phi0(3));

% add the sinusoid signals together
sigVec = sigVec1 + sigVec2 + sigVec3;

%% plotting periodogram before filtering

dataLen = timeVec(end) - timeVec(1); % obtaining length of data
kNyq = floor(length(timeVec)/2)+1; % DFT point at nyquist frequency
posFreq = (0:(kNyq-1))*(1/dataLen); % positive frequencies in fft
fftSig = fft(sigVec); % fast fourier transform of signal
fftSig = fftSig(1:kNyq); % removing frequencies to the left of nyquist freq

figure;
plot(posFreq,abs(fftSig));
title('periodogram of 3 added sinusoids');
xlabel('Positive Frequencies (Hz)');
ylabel('Amplitude');
grid on; grid minor;

%% digital filtering

filtOrdr = 30; % set order of filter filt1.

% designing filter to remove signals above initial frequency for 1st
% sinusoid. We choose f0 as our max frequency.
%FIXME Cutoff frequency for FIR filter is at the signal frequency that
%needs to be passed: this is cutting off the power in the signal itself
%SDM: Set the low pass filter cutoff such that the sinusoid at 100Hz is
%passed while the others are reduced. Review the meaning of low, band, and
%high pass filters. Note that now the first sinusoid in the filtered data
%has the same magnitude in the periodogram instead of the factor of 2
%reduction in your code.
%b1 = fir1(filtOrdr, (f0(1))/(sampFreq/2));
b1 = fir1(filtOrdr, (150)/(sampFreq/2));
filtSig1 = fftfilt(b1,sigVec);

% b2 is bandpass removing signals higher or lower than initial frequency of
% 2nd sinusoid. We choose f0 as our max frequency and 
b2 = fir1(filtOrdr, [(f0(2)*0.75)/(sampFreq/2) (f0(2)*1.25)/(sampFreq/2)]);
filtSig2 = fftfilt(b2,sigVec);

% b3 is highpass filter removing signals lower than initial frequency of
% 3rd sinusoid. We choose f0 as our max frequency.
%FIXME Fix this part following the comment for the low pass filter above.
b3 = fir1(filtOrdr, f0(3)/(sampFreq/2), 'high');
filtSig3 = fftfilt(b3,sigVec);

% plot timeseries of sinusoids.
figure;
hold on;
plot(timeVec,sigVec);
plot(timeVec,filtSig1);
plot(timeVec,filtSig2);
plot(timeVec,filtSig3);
xlabel('time');
ylabel('amplitude');
legend('combined sinusoid', 'sinusoid 1', 'sinusoid 2', 'sinusoid 3');

%% Periodogram of signal after filtering

fftSig1 = fft(filtSig1); % fast fourier transform of signal 1
fftSig1 = fftSig1(1:kNyq); % removing frequencies to the left of nyquist freq

fftSig2 = fft(filtSig2); % fast fourier transform of signal 2
fftSig2 = fftSig2(1:kNyq); % removing frequencies to the left of nyquist freq

fftSig3 = fft(filtSig3); % fast fourier transform of signal 3
fftSig3 = fftSig3(1:kNyq); % removing frequencies to the left of nyquist freq

% plotting periodogram of signal before filtering vs signal after being
% filtered for sinusoid 1
figure;
subplot(2,1,1);
plot(posFreq,abs(fftSig));
title('periodogram of signal before filtering')
xlabel('frequency (Hz)');
ylabel('amplitude');
grid on; grid minor;
subplot(2,1,2);
plot(posFreq,abs(fftSig1));
title('periodogram of signal filtered for sinusoid 1');
xlabel('frequency (Hz)');
ylabel('amplitude');
grid on; grid minor;

% plotting periodogram of signal before filtering vs signal after being
% filtered for sinusoid 2
figure;
subplot(2,1,1);
plot(posFreq,abs(fftSig));
title('periodogram of signal before filtering');
xlabel('frequency (Hz)');
ylabel('amplitude');
grid on; grid minor;
subplot(2,1,2);
plot(posFreq,abs(fftSig2));
title('periodogram of signal filtered for sinusoid 2');
xlabel('frequency (Hz)');
ylabel('amplitude');
grid on; grid minor;

% plotting periodogram of signal before filtering vs signal after being
% filtered for sinusoid 3
figure;
subplot(2,1,1);
plot(posFreq,abs(fftSig));
title('periodogram of signal before filtering');
xlabel('frequency (Hz)');
ylabel('amplitude');
grid on; grid minor;
subplot(2,1,2);
plot(posFreq,abs(fftSig3));
title('periodogram of signal filtered for sinusoid 3');
xlabel('frequency (Hz)');
ylabel('amplitude');
grid on; grid minor;