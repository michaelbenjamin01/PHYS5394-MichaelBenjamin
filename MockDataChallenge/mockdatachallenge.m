clear
clc

addpath ../../DATASCIENCE_COURSE/DETEST/

%% Estimate noise PSD

load("TrainingData.mat");

% Target PSD for stationary gaussian noise in frequency range [0,50] Hz
targetPSD = @(f) (f>=0 & f<=50).*(f-0).*(50-f)/(1e46) + 1e-45;

% Plot target PSD
freqVec = 0:0.1:512;
psdVec = targetPSD(freqVec);
sqrtPSD = sqrt(psdVec);
figure;
plot(freqVec, psdVec);
title('target PSD');
xlabel('Frequency (Hz)');
ylabel('PSD');

% Plot training data PSD
[pxx,f] = pwelch(trainData,256,[],[],sampFreq);
figure;
plot(f,pxx);
title('PSD of training data');
xlabel('Frequency (Hz)');
ylabel('PSD');

% Plotting the two on top of eachother to assist in modelling target PSD
figure;
hold on;
plot(freqVec,psdVec);
plot(f,pxx);
title('target PSD plotted against training data PSD')
legend('target PSD','training PSD');
xlabel('Frequency (Hz)');
ylabel('PSD');

%% Estimate parameters using PSO method

load("AnalysisData.mat");
nSamples = length(dataVec);
timeVec = (0:(nSamples-1))/sampFreq;

% Generate PSD vector to be used in normalization for all positive DFT
% frequencies.
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = targetPSD(posFreq);

% Search range of phase coefficients
rmin = [40, 1, 1];
rmax = [100, 50, 15];

% number of independent PSO runs
nRuns = 8;

% Input parameters for PSO function
inParams = struct('dataX', timeVec,...
                  'dataY', dataVec,...
                  'dataXSq',timeVec.^2,...
                  'dataXCb',timeVec.^3,...
                  'rmin',rmin,...
                  'rmax',rmax,...
                  'psdVec', psdPosFreq,...
                  'sampFreq',sampFreq);

outStruct = crcbqcpsoPSD(inParams,struct('maxSteps',2000),nRuns);

% Display best coefficients
disp(outStruct.bestQcCoefs);

% plot signal estimation on top of given data
figure;
hold on;
plot(timeVec,dataVec)
plot(timeVec,outStruct.bestSig);
title('Signal estimation plotted alongside given data');
legend('Analysis Data','Best estimation for signal');
xlabel('time (s)');
ylabel('Amplitude');

%% Calculate GLRT for data

sigVec = crcbgenqcsigPSD(timeVec,1,outStruct.bestQcCoefs,psdPosFreq,sampFreq);
% Normalize template signal generated
[templateVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1);
llrObs = innerprodpsd(dataVec,templateVec,sampFreq,psdPosFreq);

%GLRT is the square of the inner product
llrObs = llrObs^2;
disp(llrObs);

%% Determine significance for data

% Set SNR to a specificed value
snr = 10;
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
sigVec = snr*sigVec/sqrt(normSigSqrd);

numtimes = 0;
nH0Data = 10000;
llrH0 = zeros(1,nH0Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    llrH0(lp) = innerprodpsd(noiseVec,sigVec,sampFreq,psdPosFreq);
    llrH0(lp) = llrH0(lp)^2;
    if llrH0(lp) >= llrObs
        numtimes = numtimes + 1;
    end
end

% Find significance of GLRT
alpha = numtimes/nH0Data;
disp(alpha);
% When I ran the code, I got an alpha value of 0.5677, which is too high to
% say that we have a signal, but i believe I did something wrong.