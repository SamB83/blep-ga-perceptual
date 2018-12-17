  function [fitnessVect, fval,extflag,outpt,finpopln,finpopscore] = GAMultiObjSplinOptimSinc(NDFT, fs, N)
  %  Runs a Genetic Algorithm(GA) and finds an optimal LPF coeffs given
  %               a table size N,sample rate fs, DFT size NDFT.
  %   [fitnessVect, fval,extflag,outpt,finpopln,finpopscore] = GAMultiObjSplinOptimSinc(NDFT, fs, N)
  %   Copyright 2016.
  %   Samarth  Behura
  %   Music Engineering and Technology
  %   University of Miami
  %   
  %   INPUTS
  %
  %   NDFT (double): size of DFT.
  %   fs (double): sampling rate of input audio signal.
  %   N (double): size of BLEP table.
  % 
  %   OUTPUTS
  %
  %   fitnessVect(vector) : The solution to the GA or the minimum cost offspring 
  %   fval(vector) : fitness score(s) of the offspring for each objective
  %   extflag(int) : exitflag
  %   outpt: Output struct (see gamultiobj)
  %   finpopln(matrix): Final population; each row denotes an individual
  %   finpopscore(matrix): The score of finpopln:each row denotes an
  %                         individual score
  %

   parpool % Parallel computing
    tic;
  
 % lower bound and upper bound for the GA params 
  %   all of the following mapped in sincMultiObjSplinfitnessFunction
  %
  %   fstopb: the bounds for the stopband frequency;                                      
  %   wtrans: the bounds for the width of the transition band;
  %   deltas: the bounds for the stop band attenuation in db;
  %   deltap: the bounds for the pass band ripple in db; 
  %   wtPass: the bounds for the wt for the Pass band : 1:100;
  %   wtTrans1: the bounds for the wt of 1st transition band : 1:100;
  %   wtTrans2: the bounds for the wt of 2nd transition band : 1:100;
  %   wtStop: the wt for the stop band : 1:100
  %   filterType : 1 for Parks Mclellan , 2 for Least Squares
  %   m : the points to correct each side : 1:5
  
  
 lb = [0.65 0.1667  60  0.2  1   1  1    1   1 1];
 ub = [0.95 0.4167  220  5  100 100 100  100 2 5];


  %variables set by the GA
      
  
 options =  gaoptimset('SelectionFcn',{@selectiontournament,4},...
               'PopulationSize',100,...
               'HybridFcn',@fgoalattain,...
               'DistanceMeasureFcn',{@distancecrowding,'phenotype'},...
               'ParetoFraction',0.5,'PlotFcns',{@gaplotpareto,@gaplotscorediversity},...
           'UseParallel',true,'Vectorized', 'off');   
 
  [fitnessVect,fval,extflag,outpt,finpopln,finpopscore] = gamultiobj(@(x)sincMultiObjSplinfitnessFunction(x, fs, NDFT, ...
      N),10,[],[],[],[],lb,ub,options);
  toc;
  delete(gcp)
  end