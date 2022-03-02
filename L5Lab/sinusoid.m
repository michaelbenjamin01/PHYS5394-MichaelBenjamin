function sigVec = sinusoid(dataX,snr,f0,phi0)

sigVec = snr*sin(2*pi*f0*dataX+phi0);