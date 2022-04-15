clear;
clc;
%SDM Added close all
close all;

load("iLIGOSensitivity.txt");

freqVec = iLIGOSensitivity(:,1);
%FIXME The ligo sensitivity curve is already sqrt(PSD): review the lab slides
%SDM renaming the variable appropriately
%psdVec = iLIGOSensitivity(:,2);
sqrtPsdVec = iLIGOSensitivity(:,2);
Signaln = sqrtPsdVec.^2;

%FIXME Plots: No plot titles, axes labels
figure;
loglog(freqVec,sqrtPsdVec);
%SDM
hold on;

% frequency = 50 Hz at item no. 42
% frequency = 700 Hz at item no.70

for i = 1:length(iLIGOSensitivity)
    if freqVec(i) <= 50
        % Signaln(i) = Signaln(42);
        sqrtPsdVec(i) = sqrtPsdVec(42);
    elseif freqVec(i) >= 700
        sqrtPsdVec(i) = sqrtPsdVec(70);
        % Signaln(i) = Signaln(70);
    end
end

%SDM compare the two PSDs
%figure;
loglog(freqVec,sqrtPsdVec);
%xlim([0 2000]);

%% Desigining filter and passing data through it

filtrOrdr = 500;
%FIXME Error: 1024 Hz sampling frequency means highest DFT freq = 512 Hz < 700 Hz cutoff
%sampFreq = 1024;
sampFreq = 2048;
%FIXME Generate a longer noise realization (16384 is only 8 sec long at the new sampling frequency)
nSamples = 16384*8;
%FIXME Error: the function normalize is for statistical analysis! 
%normfreq = normalize(freqVec,'range');
%SDM Restrict the psd vector to half the specified sampling frequency
sqrtPsdVec = sqrtPsdVec(freqVec <= sampFreq/2);
freqVec = freqVec(freqVec <= sampFreq/2);
%SDM Make sure 0 and sampFreq/2 are part of the frequency vector before sending it to the filter design function
freqVec = [0; freqVec; sampFreq/2];
%SDM Extend the psd vector correspondingly (preserve flatness below 50 Hz and above 700 Hz
sqrtPsdVec = [sqrtPsdVec(1); sqrtPsdVec; sqrtPsdVec(end)];

%FIXME The ligo sensitivity curve is already sqrt(PSD): review the lab slides
%sqrtPSD = sqrt(psdVec);
%SDM send in the properly normalized frequency
%b = fir2(filtrOrdr,normfreq,sqrtPSD);
b = fir2(filtrOrdr,freqVec/(sampFreq/2),sqrtPsdVec);
%FIXME Error: The filter is to be run on a realization of white noise
%SDM Generate WGN
inData = randn(1,nSamples);
%SDM run filter on WGN
%outData = sqrt(sampFreq)*fftfilt(b,psdVec);
outData = sqrt(sampFreq)*fftfilt(b,inData);

%FIXME Window length should be longer than tiny 10 samples
%[pxx2,f2] = pwelch(outData, 10, [], [], sampFreq);
[pxx2,f2] = pwelch(outData, 1024, [], [], sampFreq);

% plotting noise produced
figure;
%FIXME loglog is better
%FIXME Plots: No plot titles, axes labels
loglog(f2,pxx2);
%SDM compare with design sensitivity (need to square it) and take care of one-side vs two-sided PSD
hold on;
loglog(freqVec,2*sqrtPsdVec.^2);
