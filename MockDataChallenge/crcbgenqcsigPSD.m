function sigVec = crcbgenqcsigPSD(dataX,snr,qcCoefs,psdVec,sampFreq)
% Generate a quadratic chirp signal
% S = CRCBGENQSIG(X,SNR,C,PSD,Fs)
% Generates a quadratic chirp signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S and C is the vector of
% three coefficients [a1, a2, a3] that parametrize the phase of the signal:
% a1*t+a2*t^2+a3*t^3. 

%Soumya D. Mohanty, May 2018

% PSD = psd data given to signal
% Fs = sampling frequency used in normalization
% Michael Benjamin

phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;
sigVec = sin(2*pi*phaseVec);

nSamples = length(dataX);
kNyq = floor(nSamples/2)+1;

fftSig = fft(sigVec);
negFStrt = 1-mod(nSamples,2);
psdVec4Norm = [psdVec,psdVec((kNyq-negFStrt):-1:2)];

dataLen = sampFreq*nSamples;
innProd = (1/dataLen)*(fftSig./psdVec4Norm)*fftSig';
normSigSqrd = real(innProd);

sigVec = snr*sigVec/sqrt(normSigSqrd);


