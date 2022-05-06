function [fitVal,varargout] = crcbpsoackleyfunc(xVec,params)
%Compute the Ackley fitness function for each row of X. The code was
%modified from the original crcbpsotestfunc.m from the SDMBIGDAT19 git
%page, with the only major modification being in the for loop, as I chose
%the Ackley fitness function as opposed to the Rastrigin fitness function.

%rows: points
%columns: coordinates of a point
%FIXME Error: 'D' in Ackley is the number of dimensions; nrows is the number of PSO particles
%[nrows,~]=size(xVec);
%SDM
[nrows,nDims]=size(xVec);

%storage for fitness values
fitVal = zeros(nrows,1);
validPts = ones(nrows,1);

%Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
%Set fitness for invalid points to infty
fitVal(~validPts)=inf;
%Convert valid points to actual locations
xVec(validPts,:) = s2rv(xVec(validPts,:),params);

for lpc = 1:nrows
    if validPts(lpc)
        % this is the only block that was changed from the original
        % fucntion
        x = xVec(lpc,:);
        %FIXME Error: 'D' in Ackley is the number of dimensions; nrows is the number of PSO particles
        %fitVal(lpc) = -20*exp(-0.2*sqrt(sum(x.^2)/nrows))-exp(sum(cos(2*pi*x))/nrows)+20+exp(1);
        fitVal(lpc) = -20*exp(-0.2*sqrt(sum(x.^2)/nDims))-exp(sum(cos(2*pi*x))/nDims)+20+exp(1);
    end
end

% Return to real coordinates if requested
if nargout > 1
    varargout{1} = xVec;
    if nargout > 2
        varargout{2} = r2sv(xVec, params);
    end
end
