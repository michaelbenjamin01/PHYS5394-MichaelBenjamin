function glrt = glrtqcsig(dataVec,snr,qcCoefs,sampFreq,psdVec)

phaseVec = qcCoefs(1)*dataVec + qcCoefs(2)*dataVec.^2 + qcCoefs(3)*dataVec.^3;
sigVec = sin(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);

normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdVec);
normFac = snr/sqrt(normSigSqrd);
normSigVec = normFac*sigVec;

llr = innerprodpsd(dataVec,normSigVec,sampFreq,psdVec);
glrt = llr^2;

end