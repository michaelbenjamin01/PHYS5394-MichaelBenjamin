function sigVec = stepFM(data,A,ta,f0,f1)
% Generates step FM signal
% data is the time vector, the rest of the values are scalar parameters.

    for t = 1:length(data)
        if data(t) <= ta
            sigVec(t) = A*sin(2*pi*f0*data(t));
        else
            sigVec(t) = A*sin(2*pi*f1*(data(t)-ta) + 2*pi*f0*ta);
        end
    end
end