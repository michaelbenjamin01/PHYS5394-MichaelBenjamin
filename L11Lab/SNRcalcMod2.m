%% How to normalize a signal for a given SNR
%% 
% We will normalize a signal such that the Likelihood ratio (LR) test for it has
% a given signal-to-noise ratio (SNR) in noise with a given Power Spectral 
% Density (PSD). [We often shorten this statement to say: "Normalize the
% signal to have a given SNR." ]

clear all;
close all;
%%
% Path to folder containing signal and noise generation codes
%format long g
addpath ../L3Lab
addpath ../L8Lab2
%addpath ../NOISE

%%
% This is the target SNR for the LR
snr = 10;

%%
% Data generation parameters
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;


%%
% Generate the signal that is to be normalized
ta = 1;
%FIXME Changed signal parameters to make it more centrally located in the frequency range of the data
f0 = 100;
f1 = 200;
% Amplitude value does not matter as it will be changed in the normalization
A = 1; 
sigVec = stepFM(timeVec,A,ta,f0,f1);

%%
% We will use the noise PSD used in colGaussNoiseDemo.m but add a constant
% to remove the parts that are zero. (Exercise: Prove that if the noise PSD
% is zero at some frequencies but the signal added to the noise is not,
% then one can create a detection statistic with infinite SNR.)
load("iLIGOSensitivity.txt");
% 0noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;

%%
% Generate the PSD vector to be used in the normalization. Should be
% generated for all positive DFT frequencies. 
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
% psdPosFreq = noisePSD(posFreq);
%FIXME Error: The PSD should have been cutoff as was done in Lab8
%FIXME Error: The iLIGOSensitivity.txt file stores sqrt(PSD) while innerprodpsd requires PSD.
%FIXME Error: Because of these errors, the results were incorrect (including a NaN output for some unknown reason)
%psdPosFreq = interp1(iLIGOSensitivity(:,1),iLIGOSensitivity(:,2),posFreq);

%FIXME Error: Replacing with code from another student's submission (Note: this is not the best implementation)
%Reading the LIGO sensitivity PSD 
iLIGOS= load('iLIGOSensitivity.txt', 'ascii'); 
%Low & high cutoff frequency 
low = iLIGOS(40,2); 
iLIGOS(1:42,2) = low;

high = iLIGOS(71,2);
iLIGOS(71:end,2) = high;

iLIGOS(2:end+1,:) = iLIGOS;
iLIGOS(1,1) = 0; %Hz
iLIGOS(1,2) = low;

iLIGOS = iLIGOS(1:85,:); % Cut window to 85
iLIGOS(85,1) = 3000; %Hz

%Interpolate the PSD iLIGOS data irregularly spaced frequencies to the
%required DT frequency
psdPosFreq = interp1(iLIGOS(:,1),iLIGOS(:,2),posFreq);
psdPosFreq = psdPosFreq.^2; 

figure;
%FIXME use loglog for LIGO PSD
%plot(posFreq,psdPosFreq);
loglog(posFreq,psdPosFreq);
axis([0,posFreq(end),0,max(psdPosFreq)]);
xlabel('Frequency (Hz)');
ylabel('PSD ((data unit)^2/Hz)');

%% Calculation of the norm
% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
sigVec = snr*sigVec/sqrt(normSigSqrd);

%% Test
%Obtain LLR values for multiple noise realizations
nH0Data = 1000;
llrH0 = zeros(1,nH0Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    llrH0(lp) = innerprodpsd(noiseVec,sigVec,sampFreq,psdPosFreq);
end
%Obtain LLR for multiple data (=signal+noise) realizations
nH1Data = 1000;
llrH1 = zeros(1,nH1Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    % Add normalized signal
    dataVec = noiseVec + sigVec;
    llrH1(lp) = innerprodpsd(dataVec,sigVec,sampFreq,psdPosFreq);
end
%%
% Signal to noise ratio estimate
estSNR = (mean(llrH1)-mean(llrH0))/std(llrH0);

figure;
histogram(llrH0);
hold on;
histogram(llrH1);
xlabel('LLR');
ylabel('Counts');
legend('H_0','H_1');
title(['Estimated SNR = ',num2str(estSNR)]);

%%
% A noise realization
figure;
plot(timeVec,noiseVec);
xlabel('Time (sec)');
ylabel('Noise');
%%
% A data realization
figure;
plot(timeVec,dataVec);
hold on;
plot(timeVec,sigVec);
xlabel('Time (sec)');
ylabel('Data');

% % plotting periodogram
% dataLen = timeVec(end) - timeVec(1);
% kNyq = floor(length(timeVec)/2)+1;
% posFreq = (0:(kNyq-1))*(1/dataLen);
% fftSig = fft(sigVec);
% fftSig = fftSig(1:kNyq);
% 
% figure;
% plot(posFreq,abs(fftSig));
% title('step FM periodogram, sampling frequency fs = 5*nqstfs');
% grid on; grid minor;
% 
% % Plotting spectrogram
% winLen = 0.4; % in seconds
% ovrlp = 0.01; % in seconds
% 
% winLenSmpls = floor(winLen*sampFreq);
% ovrlpSmpls = floor(ovrlp*sampFreq);
% [S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],sampFreq);
% figure;
% imagesc(T,F,abs(S)); axis xy;
% title('step FM spectrogram');
% xlabel('Time (sec)');
% ylabel('Frequency (Hz)');

