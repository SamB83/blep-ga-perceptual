  function [output] = sincMultiObjSplinfitnessFunction (x, fs, NDFT, N)
  % FITNESSFUNCTION Evaluates an output of the GA based on an evaluation
  %                 function. It verifies all the MIDI notes from 84 to 108.
  %
  %   [output] = fitnessFunction (x, fs, NDFT, N)
  %   Copyright 2016.
  %   Samarth Behura
  %   Music Engineering and Technology
  %   University of Miami
  %
  %
  %
  %   INPUTS
  %   x (1x8 double array):  GA output.
  %                          x(1) = fstopb : filter stop-band
  %                          x(2) = wtrans : width of transition band 
  %                          x(3) = deltas : the stop band attenuation in db
  %                          x(4) = deltap : the pass band ripple in db 
  %                          x(5) = wtPass : the weight for passband
  %                          x(6) = wtTrans1:  the wt of 1st transition band
  %                          x(7) = wtTrans1:  the wt of 2nd transition band 
  %                          x(8) = wtStop : the weight for stopband
  %                          x(9) = filter : Choose either PMclellan or
  %                                             Least square
  %                          x(10) = m      : no. of points to correct on
  %                                          each side
  %
  %   fs (double): sampling rate of input audio signal.
  %   NDFT (double): size of DFT.
  %   N: size of the BLEP table
  %
  %   OUTPUTS
  %   output (double): Bosi PAM value for the output.

  MIDITable = 21:1:108;
  freqTable = convMIDI2freq(MIDITable);
  
  % Establish the fundamental frequency array (fixed to bins)
  factorsFundamental = 1:1:floor(4200/(fs/NDFT)); %MIDI 127
  fundamentalsFixedBins = (fs/NDFT)*factorsFundamental;
  freqTableFixedBins = freqTable;
  
  for i=1:1:length(freqTable)
      [~, indexFundamental] = min(abs(fundamentalsFixedBins - freqTable(i)));
      freqTableFixedBins(i) = fundamentalsFixedBins(indexFundamental);
  end
  
  fc = freqTableFixedBins;

  
 % setting fixed windows --- either Rectwin/Blackman
   window  = blackman(N);
   
  
  %actual values remapped
  
  fstpb = x(1);
  widTransb = x(2);
  deltStop = x(3);
  deltPass = x(4);
  
  wtPass = x(5);
  wtStop = x(6);
  
  wtTrans1 = x(7);
  wtTrans2 = x(8);
  
  filterType = round(x(9));
  %setting m points to correct each side 
  m = ceil(x(10));
  
   
  
% sinc function from the ga parameters
  if filterType == 1
  [gasinc,~,~]  = getSplinePMIR(fstpb, widTransb, deltStop,deltPass,wtPass,wtStop,wtTrans1,wtTrans2,N,false);
  else 
  [gasinc,~,~] = getSplineLsqIR2(fstpb, widTransb, deltStop,deltPass,wtPass,wtStop,wtTrans1,wtTrans2,N,false);   
  end

trivialHarmBelow = [353,332,309,294,276,258,245,229,216,203,190,180,170,...
    158,149,139,132,123,116,110,103,96,90,85,81,75,71,67,63,59,56,52,49,...
    46,43,41,39,36,34,32,30,28,27,25,23,22,21,19,18,17,16,15,15,13,13,12,...
    11,11,10,9,9,8,8,7,7,7,6,6,6,5,5,5,4,4,4,4,3,3,3,3,2,3,2,2,2,2,2,1];
    
 %Run through all notes on the MIDI Keyboard 
  totalAliasoutput = 0;
  totalHarmoutput = 0;
  actualharmonicCost = 0;
  for i=1:1:length(fc)
     [aliasValue , harmValue] = evaluateMultiObjSincFunction (fc(i), fs, N, gasinc, m, ...
          NDFT, window);   
     
      totalAliasoutput = totalAliasoutput + aliasValue;
      
      actualharmonicCost = harmValue  - trivialHarmBelow(i);
      totalHarmoutput = totalHarmoutput + actualharmonicCost;
      actualharmonicCost = 0;
  end

  output(1) = totalAliasoutput;
  output(2) = totalHarmoutput;


  end