%% Test harness for CRCBPSO 
% The fitness function called is crcbpsoackleyfunc. 
ffparams = struct('rmin',-100,...
                     'rmax',100 ...
                  );
% Fitness function handle.
addpath ../../SDMBIGDAT19/CODES/

fitFuncHandle = @(x) crcbpsoackleyfunc(x,ffparams);
%%
% Call PSO.
rng('default')
psoOut = crcbpso(fitFuncHandle,2);

%% Estimated parameters
% Best standardized and real coordinates found.
stdCoord = psoOut.bestLocation;
[~,realCoord] = fitFuncHandle(stdCoord);
disp(['Best location:',num2str(realCoord)]);
disp(['Best fitness:', num2str(psoOut.bestFitness)]);

%%
% Call PSO with optional inputs
psoparams = struct('popSize',10,...
                     'maxSteps',1000, ...
                       'boundaryCond', '', ...
                         'nbrhdSz',3 ...
                  );
rng('default')
psoOut = crcbpso(fitFuncHandle,2,psoparams,5);
%Plot the trajectory of the best particle
figure;
plot(psoOut.allBestLoc(:,1),psoOut.allBestLoc(:,2),'.-');
figure;
plot(psoOut.allBestFit);