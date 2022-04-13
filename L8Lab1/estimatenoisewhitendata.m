clear;
clc;

load("testData.txt");

% The data is 15 seconds long, and has 16384 samples, along with a sampling
% frequency of 1024 Hz.

sampFreq = 1024; %Hz
%Number of samples to generate
nSamples = 16384;

%% Seperating signal free section of data.

% The signal begins at t = 5 sec, which starts at testData(5121,1) and
% continues to the end of the data. So we take the first 5120 data points
% for this.

noSignal = testData(1:5120,:);

[pxx1,f1] = pwelch(noSignal(:,2), 256, [], [], sampFreq);
figure;
plot(f1,pxx1);
title('PSD of noise from data')

%% Modelling target PSD
%FIXME Incorrect1: Review the tasks list carefully. No model PSD was needed.
%list
targetPSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/1600000;

% plot target PSD
%FIXME This figure is not connected to the lab
% freqVec = 0:0.1:512;
% psdVec = targetPSD(freqVec);
% figure;
% hold on;
% plot(freqVec,psdVec);
% plot(f1,pxx1);
% legend('target PSD','noise PSD');
% title('target PSD overlapped with noise psd');

%% Designing filter and passing data through it

filtrOrdr = 500;
%FIXME Incorrect2: You had to estimate the PSD from the noise part
%sqrtPSD = sqrt(psdVec);
sqrtPSD = sqrt(pxx1);
%%FIXME Incorrect3: Whitening filter transfer function is 1/sqrt(PSD)
%b = fir2(filtrOrdr,freqVec/(sampFreq/2),sqrtPSD);
b = fir2(filtrOrdr,f1/(sampFreq/2),1./sqrt(pxx1));
outData = sqrt(sampFreq)*fftfilt(b,testData(:,2));

[pxx2,f2] = pwelch(outData, 256, [], [], sampFreq);

% plotting data before and after whitening
figure;
hold on;
plot(f1,pxx1);
plot(f2, pxx2);
title('before and after whitening of data');
legend('data before whitening','data after whitening');

%FIXME Lab instructions required spectrograms and time series plots
%SDM Add titles, axes labels etc.
figure;
subplot(2,1,1);
[S,F,T] = spectrogram(testData(:,2),64,[],[],sampFreq);
imagesc(T,F,abs(S)); axis xy;
subplot(2,1,2);
[S,F,T] = spectrogram(outData,64,[],[],sampFreq);
imagesc(T,F,abs(S)); axis xy;

%FIXME Your conclusion was not supported by your original code and results.
% You can see very clearly that the power of the signal is increased after
% whitening, and the shape of the signal is also siginficantly improved.