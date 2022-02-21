function sigVec = expdampsin(dataX,snr,ta,f0,tau,phi0,L)
% Generates exponentially damped sinusoid signal. This function has a
% window applied to it so that only in the range of [t_a,t_a + L] is when
% we have our signal.

% dataX - time vector, the rest of the values are scalar parameters.
% snr - the signal-to-noise ratio of signal sigVec.
% ta - the beginning of the time window in which our signal appears in.
% f0 - initial frequency of the signal.
% tau - time constant
% phi0 - initial phase value of the signal.
% L - length of the window starting at ta.

% Michael Benjamin, Febuary 2022

sigVec = zeros(1,length(dataX)); % initializes sigVec vector before filling it with values

% the following for loop/if statements check if dataX(t) is in the range
% of [ta, ta + L]. Otherwise it keeps sigVec as 0.
for t = 1:length(dataX)
    if dataX(t) <= ta || dataX(t) >= (ta + L)
        sigVec(t) = 0;
    else
        sigVec(t) = snr*exp(-(dataX(t)-ta)/tau) .* sin(2*pi*f0*dataX(t) + phi0);
    end
end