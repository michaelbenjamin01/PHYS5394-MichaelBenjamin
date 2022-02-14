function sigVec = expdampsin(data,A,ta,f0,tau,phi0,L)
%FIXME Put usage instructions; see example codes provided in
%DATASCIENCE_COURSE
%FIXME Calling the time vector 'data' is very confusing! Follow the
%terminology introduced in the lectures.
%FIXME Documentation is not good: Each input parameter should be explained
%clearly
%
% Generates exponentially damped sinusoid signal
% data is the time vector, the rest of the values are scalar parameters.

%FIXME Put author name, date etc.

sigVec = zeros(1,length(data));
%FIXME Code indentation is not correct; see example codes provided in
%DATASCIENCE_COURSE
    for t = 1:length(data)
        if data(t) <= ta || data(t) >= (ta + L)
            sigVec(t) = 0;
        else
            sigVec(t) = A*exp(-(data(t)-ta)/tau) .* sin(2*pi*f0*data(t) + phi0);
        end
    end
end