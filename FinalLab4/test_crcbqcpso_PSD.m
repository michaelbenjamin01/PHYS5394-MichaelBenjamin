clear;
clc;

addpath ../../SDMBIGDAT19/CODES/
nSamples = 512; % number of samples
sampFreq = 512; % sampling frequency

% Quadratic chirp signal with the following parameters
snr = 10; % signal to nosie ratio
a1 = 10;
a2 = 3;
a3 = 3;

% Search range of phase coefficients
rmin = [1, 1, 1];
rmax = [180, 10, 10];

% number of independent PSO runs
nRuns = 8;

% Generate data  realization
timeVec = (0:(nSamples-1))/sampFreq;
freqVec = 0:0.1:256;

targetPSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;
psdVec = targetPSD(freqVec);
sqrtPSD = sqrt(psdVec);
%FIXME Error: filter order is comparable to the length of the data itself!
%filtrOrdr = 500;
filtrOrdr = 100;

% Design a filter and pass white gaussian noise to pass through it.
b = fir2(filtrOrdr, freqVec/(sampFreq/2), sqrtPSD);
% now apply the filter to white gaussian noise to get our colored gaussian
% noise.
%NOTE We can first generate a much longer noise realization and then ...
%extract the number of samples we want. This can help us check if the PSD
%was designed correctly or not. This is not required for this assignment
%but included here as a guide.
%SDM Note how filter startup transient is handled
inNoise = randn(1,10*nSamples+filtrOrdr);
outNoise = sqrt(sampFreq)*fftfilt(b,inNoise);
%SDM Check PSD of noise
figure;
[pxx,f] = pwelch(outNoise, 128,[],[], sampFreq);
plot(f, pxx/2);%Taking care of factor of 2 for one-side vs. two-sided PSD
hold on;
plot(freqVec,psdVec);
%Extract the required number of samples
outNoise = outNoise((filtrOrdr+1):(filtrOrdr+1+nSamples-1));
figure;
plot(timeVec,outNoise);

% generate signal and combine it to noise
phaseVec = a1*timeVec + a2*timeVec.^2 + a3*timeVec.^3;
sigVec = sin(2*pi*phaseVec);
%FIXME Error: The normalized signal should be computed for colored noise (e.g., using normsig4psd). The 'norm' function is valid for the white noise case only.
%sigVec = snr*sigVec/norm(sigVec);
%FIXME The PSD vector has to be computed at positive DFT frequencies in order to use normsig4psd
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = targetPSD(posFreq); 
sigVec = normsig4psd(sigVec,sampFreq,psdPosFreq,snr);

dataVec = sigVec+outNoise;
%NOTE Plot data and signal
figure;
plot(timeVec,dataVec);
hold on;
plot(timeVec,sigVec);

% Input parameters for CRCBQCHRPPSO
inParams = struct('dataX', timeVec,...
                  'dataY', dataVec,...
                  'dataXSq',timeVec.^2,...
                  'dataXCb',timeVec.^3,...
                  'rmin',rmin,...
                  'rmax',rmax);

%FIXME Error: you were supposed to write your own version of crcbqcpso that handles a colored noise PSD. CRCBQCPSO assumes white noise. For the specified PSD, this does not affect the estimated amplitude significantly, but this will not be the case for some other PSD.
outStruct = crcbqcpso(inParams,struct('maxSteps',1000),nRuns);

% Plotting results
figure;
hold on;
plot(timeVec, dataVec, '.');
plot(timeVec, sigVec);
for lpruns = 1:nRuns
    plot(timeVec,outStruct.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',4.0);
end
plot(timeVec,outStruct.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
legend('Data','Signal',...
       ['Estimated signal: ',num2str(nRuns),' runs'],...
       'Estimated signal: Best run');
disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3=',num2str(outStruct.bestQcCoefs(3))]);