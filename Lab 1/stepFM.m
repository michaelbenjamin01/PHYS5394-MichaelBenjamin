function sigVec = stepFM(data,A,ta,f0,f1)

    for t = 1:length(data)
        if t <= ta
            sigVec(t) = A*sin(2*pi*f0*data(t));
        else
            sigVec(t) = A*sin(2*pi*f1*(t-ta) + 2*pi*f0*ta);
        end
    end
end