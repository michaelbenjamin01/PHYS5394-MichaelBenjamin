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
filtrOrdr = 500;

% Design a filter and pass white gaussian noise to pass through it.
b = fir2(filtrOrdr, freqVec/(sampFreq/2), sqrtPSD);
% now apply the filter to white gaussian noise to get our colored gaussian
% noise.
inNoise = randn(1,nSamples);
outNoise = sqrt(sampFreq)*fftfilt(b,inNoise);

% generate signal and combine it to noise
phaseVec = a1*timeVec + a2*timeVec.^2 + a3*timeVec.^3;
sigVec = sin(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);

dataVec = sigVec+outNoise;

% Input parameters for CRCBQCHRPPSO
inParams = struct('dataX', timeVec,...
                  'dataY', dataVec,...
                  'dataXSq',timeVec.^2,...
                  'dataXCb',timeVec.^3,...
                  'rmin',rmin,...
                  'rmax',rmax);

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