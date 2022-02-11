function sigVec = expdampsin(data,A,ta,f0,tau,phi0,L)
% Generates exponentially damped sinusoid signal
% data is the time vector, the rest of the values are scalar parameters.

sigVec = zeros(1,length(data));

    for t = 1:length(data)
        if data(t) <= ta || data(t) >= (ta + L)
            sigVec(t) = 0;
        else
            sigVec(t) = A*exp(-(data(t)-ta)/tau) .* sin(2*pi*f0*data(t) + phi0);
        end
    end
end