function [fitVal,varargout] = glrtqcsig4pso(xVec,params)
%Fitness function for quadratic chirp regression
%F = CRCBQCFITFUNC(X,P)
%Compute the fitness function (log-likelihood ratio for colored noise 
%maximized over the amplitude parameter) for data containing the
%quadratic chirp signal. X.  The fitness values are returned in F. X is
%standardized, that is 0<=X(i,j)<=1. The fields P.rmin and P.rmax  are used
%to convert X(i,j) internally before computing the fitness:
%X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j).
%The fields P.dataY and P.dataX are used to transport the data and its
%time stamps. The fields P.dataXSq and P.dataXCb contain the timestamps
%squared and cubed respectively.
%
%[F,R] = CRCBQCFITFUNC(X,P)
%returns the quadratic chirp coefficients corresponding to the rows of X in R. 
%
%[F,R,S] = CRCBQCFITFUNC(X,P)
%Returns the quadratic chirp signals corresponding to the rows of X in S.

%Soumya D. Mohanty
%June, 2011
%April 2012: Modified to switch between standardized and real coordinates.

%Shihan Weerathunga
%April 2012: Modified to add the function rastrigin.

%Soumya D. Mohanty
%May 2018: Adapted from rastrigin function.

%Soumya D. Mohanty
%Adapted from QUADCHIRPFITFUNC
%==========================================================================

%rows: points
%columns: coordinates of a point
[nVecs,~]=size(xVec);

%storage for fitness values
fitVal = zeros(nVecs,1);

%Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
%Set fitness for invalid points to infty
fitVal(~validPts)=inf;
xVec(validPts,:) = s2rv(xVec(validPts,:),params);

for lpc = 1:nVecs
    if validPts(lpc)
    % Only the body of this block should be replaced for different fitness
    % functions
        x = xVec(lpc,:);
        fitVal(lpc) = ssrqc(x, params);
    end
end

%Return real coordinates if requested
if nargout > 1
    varargout{1}=xVec;
end

%Sum of squared residuals after maximizing over amplitude parameter
function ssrVal = ssrqc(x,params)
%Generate normalized quadratic chirp
phaseVec = x(1)*params.dataX + x(2)*params.dataXSq + x(3)*params.dataXCb;
qc = sin(2*pi*phaseVec);
% norm of signal squared is inner product of signal with itself

%FIXME Error: Why is normqcsqrd being computed twice? once through innerprodpsd and then separately again?
%FIXME Use DATASCIENCE_COURSE/DETEST/normsig4psd.m here.
normqcsqrd = innerprodpsd(qc, qc, params.sampFreq, params.psdVec);
nSamples = length(qc);
kNyq = floor(nSamples/2)+1;
fftqc = fft(qc);
negFStrt = 1-mod(nSampleqc,2);
psdVec4Norm = [params.psdVals,params.psdVals((kNyq-negFStrt):-1:2)];
dataLen = sampFreq*nSamples;
normqcsqrd = (1/dataLen)*(fftqc./psdVec4Norm)*fftqc';
normFac = params.snr/sqrt(normqcsqrd);
normqc = normFac*qc;
qc = qc/normqc;

%Compute fitness
nSamples = length(params.dataX);
fftY = fft(params.dataY);
%We take care of even or odd number of samples when replicating PSD values
%for negative frequencies
negFStrt = 1-mod(nSamples,2);
psdVec4Norm = [params.psdVals,params.psdVals((kNyq-negFStrt):-1:2)];

dataLen = sampFreq*nSamples;
%FIXME Error: Un-normalized signal used in computing the GLRT.
%Normalization was done on line 80 but fftqc was computed before
%normalization.
innProd = (1/dataLen)*(fftY./psdVec4Norm)*fftqc';
ssrVal = real(innProd);
