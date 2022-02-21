function sigVec = stepFM(dataX,snr,ta,f0,f1)
% Generates a frequency modulated step function. 

% dataX - time vector, the rest of the values are scalar parameters
% snr - the signal-to-noise ratio of signal sigVec.
% ta - the beginning of the time window in which our signal appears in.
% f0 - initial frequency of sinusoid before ta.
% f1 - initial frequency of sinusoid after ta.

% Michael Benjamin, Febuary 2022

sigVec = zeros(1,length(dataX)); % initializes sigVec vector before filling it with values

% the following for loop/if statements check if dataX(t) is dataX is less
% than or equal to ta. It then applies the step function accordingly.
for t = 1:length(dataX)
    if dataX(t) <= ta
        sigVec(t) = snr*sin(2*pi*f0*dataX(t));
    else
        sigVec(t) = snr*sin(2*pi*f1*(dataX(t)-ta) + 2*pi*f0*ta);
    end
end