function glrt = glrtqcsig(timestampVec,snr,qcCoefs,sampFreq,psdVec)
%FIXME Doc: No documentation of GLRTQCSIG function

phaseVec = qcCoefs(1)*timestampVec + qcCoefs(2)*timestampVec.^2 + qcCoefs(3)*timestampVec.^3;
sigVec = sin(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);

normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdVec);
normFac = snr/sqrt(normSigSqrd);
normSigVec = normFac*sigVec;

llr = innerprodpsd(timestampVec,normSigVec,sampFreq,psdVec);
glrt = llr^2;

end