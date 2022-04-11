clear;
clc;

load("iLIGOSensitivity.txt");

freqVec = iLIGOSensitivity(:,1);
psdVec = iLIGOSensitivity(:,2);
Signaln = psdVec.^2;

figure;
loglog(freqVec,psdVec);

% frequency = 50 Hz at item no. 42
% frequency = 700 Hz at item no.70

for i = 1:length(iLIGOSensitivity)
    if freqVec(i) <= 50
        % Signaln(i) = Signaln(42);
        psdVec(i) = psdVec(42);
    elseif freqVec(i) >= 700
        psdVec(i) = psdVec(70);
        % Signaln(i) = Signaln(70);
    end
end

figure;
plot(freqVec,psdVec);
xlim([0 2000]);

%% Desigining filter and passing data through it

filtrOrdr = 500;
sampFreq = 1024;
nSamples = 16384;
normfreq = normalize(freqVec,'range');
sqrtPSD = sqrt(psdVec);
b = fir2(filtrOrdr,normfreq,sqrtPSD);
outData = sqrt(sampFreq)*fftfilt(b,psdVec);

[pxx2,f2] = pwelch(outData, 10, [], [], sampFreq);

% plotting noise produced
figure;
plot(f2,pxx2);
