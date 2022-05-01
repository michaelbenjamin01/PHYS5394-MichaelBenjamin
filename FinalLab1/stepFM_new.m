%FIXME Doc: Function name was not updated (does not match file name).
%function sigVec = stepFM(dataX, snr, params)
%SDM
function sigVec = stepFM_new(dataX, snr, params)
% Generates a frequency modulated step function. 
%FIXME Doc: The help documentation was not updated.
% dataX - time vector, the rest of the values are scalar parameters
% snr - the signal-to-noise ratio of signal sigVec.
% ta - the beginning of the time window in which our signal appears in.
% f0 - initial frequency of sinusoid before ta.
% f1 - initial frequency of sinusoid after ta.

% Michael Benjamin, April 2022

sigVec = zeros(1,length(dataX)); % initializes sigVec vector before filling it with values

% the following for loop/if statements check if dataX(t) is dataX is less
% than or equal to ta. It then applies the step function accordingly.


ta = params.ta;
f0 = params.f0;
f1 = params.f1;
%FIXME Error: Signal not normalized properly. See the L3Lab video around the 27min mark.
for t = 1:length(dataX)
    if dataX(t) <= ta
        %FIXME Error: Signal should be normalized first
        %sigVec(t) = snr*sin(2*pi*f0*dataX(t));
        sigVec(t) = sin(2*pi*f0*dataX(t));
    else
        %sigVec(t) = snr*sin(2*pi*f1*(dataX(t)-ta) + 2*pi*f0*ta);
        sigVec(t) = sin(2*pi*f1*(dataX(t)-ta) + 2*pi*f0*ta);
    end
end
%SDM: Proper normalization
sigVec = sigVec/norm(sigVec);
sigVec = snr*sigVec;