  function [aliasPeaksabove,harmPeaksbelow] = evaluateMultiObjSincFunction (fc, fs, N, gaSinc, m, NDFT, window)
  % EVALUATIONFUNCTION Evaluates an output of the GA based on the Bosi PAM.
  %   Copyright 2016.
  %   Samarth Behura
  %   Music Engineering and Technology
  %   University of Miami
  %
  %   removed -  zero-crossings(n)
  %   added   - sinc function from GA - gaSinc
  %   added - harmonics masked by BLEP count to be calculated for each fc.
  %   added - Aweighted harmonic decay costs for each fc value to the total
  %           cost
  %
  %
  %   INPUTS
  %   fc (double): fundamental frequency of waveform.
  %   fs (double): sampling rate of input audio signal.
  %   N (double): BLEP table size.
  %   gaSinc (1xN double array):Sinc function generated by GA params.
  %   m (double): number of correction points on each side.
  %   NDFT (double): size of DFT.
  %   window (1xN double array): window array.
  %
  %   OUTPUTS
  %   aliasPeaksabove : Aliasing peaks above masking curve.
  %   harmPeaksbelow  : Harmonic peaks below masking curve.
 
  % Create the BLEP tables for window
  bleptable = doSincBLEPTable(fs,gaSinc, window, N, false);
  % Create the Trivial Sawtooth and the BLEP-Sawtooths % needed trivial
  [blep,trivial, ~] = constructBLEPWaveform(fc, fs, bleptable, m, NDFT, false);
  % Fix Clipping and extend to [-1, 1]
  blep = fixClipping (blep);
  % Obtain DFT of BLEPS
  [~, ~, ~, fftRawNormBlep, freqArray] = calDFT(fs, blep, NDFT, false);
  
  % Get the harmonic and non-harmonic locations and amplitudes for BLEP 
  [peaksBlepRaw, locsBlepRaw] = findpeaks(fftRawNormBlep, freqArray);
  
  %Identify harmonics and non-harmonics for BLEP 
  [harmonicPeaksBlepRaw, harmonicLocsBlepRaw, nonHarmonicPeaksBlepRaw, ...
      nonHarmonicLocsBlepRaw] = findHarmonics (peaksBlepRaw, ...
      locsBlepRaw, fs, fc);
  
  
  % Apply Bosi PAM for the BLEP case
  [ ~ , nonHarmonicsAboveBlepRaw, harmonicsBelowBlepRaw] = doBosiPAM ...
      (harmonicPeaksBlepRaw, harmonicLocsBlepRaw, ...
      nonHarmonicPeaksBlepRaw, nonHarmonicLocsBlepRaw, 'linear', false);

  %Cost of harmonic decay
%   harmDecCost = floor(harmDecaydB);
   
  %fitness value for the GA
  aliasPeaksabove = length(nonHarmonicsAboveBlepRaw); 
  harmPeaksbelow =  length(harmonicsBelowBlepRaw);      % + harmDecCost;
 
  end