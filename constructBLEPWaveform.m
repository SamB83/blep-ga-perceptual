  function [blepWaveform, trivialWaveform, timeArray] = constructBLEPWaveform ...
      (fc, fs, bleptable, m, NDFT, needplot)
  %
  %   [blepWaveform, trivialWaveform, timeArray] = constructBLEPWaveform ...
  %   (fc, fs, bleptable, m, NDFT, plot)
  %   Copyright 2016.
  %   Samarth Behura
  %   Music Engineering and Technology
  %   University of Miami
  %
  %   INPUTS
  %   fc (double): fundamental frequency of waveform.
  %   fs (double): sampling rate of input audio signal.
  %   bleptable (1xN double array): BLEP table.
  %   m (double): number of correction points on each side.
  %   NDFT (double): size of DFT.
  %   plot (bool): true for drawing plots.
  %
  %   OUTPUTS
  %   blepWaveform (1xn double array): BLEP corrected waveform.
  %   trivialWaveform (1xn double array): trivial waveform.
  %   timeArray (1xn double array): time array for the waveforms.
 
  % Define time array
  Ts = 1/fs;
  timeArray = 0:Ts:(NDFT/fs)-Ts;

  % Create sawtooth
  modulo = 0.5;
  inc = fc/fs;
  sampleschanged = 0;
  center = length(bleptable)/2.0 - 1.0;
  trivialWaveform = zeros(1, length(timeArray));
  blepWaveform = zeros(1, length(timeArray));
  for i = 1:length(timeArray)
     if (modulo >= 1.0)
         modulo = modulo - 1.0;
     end
     trivialWaveform(i) = 2.0*modulo - 1.0;
     blepWaveform(i) = trivialWaveform(i);
     % Apply BLEP
     % Left side of discontinuity -1 < d < 0
     for j = 1:m
      if (modulo > (1.0 - j*inc))
          d = (modulo - 1.0)/(m*inc);
          index = (1.0 + d)*center;
          index = floor(index);
          blepvalue = bleptable(index + 1.0);
          blepvalue = blepvalue*-1.0;
          blepWaveform(i) = trivialWaveform(i) + blepvalue;
          sampleschanged = sampleschanged+1;
          break
      end
     end
     % Right side of discontinuity 0 <= d < 1
     for j = 1:m
      if (modulo < j*inc)
          d = modulo/(m*inc);
          index = d*center + (center+1.0);
          index = floor(index);
          blepvalue = bleptable(index + 1.0);
          blepvalue = blepvalue*-1.0;
          blepWaveform(i) = trivialWaveform(i) + blepvalue;
          sampleschanged = sampleschanged+1;
          break
      end
     end
     modulo = modulo + inc;
  end

  if needplot
      cyclesToShow = 3;
      samplesToShow = ceil(fs*cyclesToShow/fc);
      figure()
      plot(timeArray(1:samplesToShow)/Ts, trivialWaveform(1:samplesToShow))
      title (['Sawtooth Trivial - Time Domain for fc = ' num2str(fc) ' Hz'])
      xlabel 'Samples'
      ylabel 'Amplitude'
      axis tight

      figure()
      plot(timeArray(1:samplesToShow)/Ts, blepWaveform(1:samplesToShow))
      title (['Sawtooth BLEP - Time Domain for fc = ' num2str(fc) ' Hz'])
      xlabel 'Samples'
      ylabel 'Amplitude'
      axis tight

      figure()
      plot(timeArray(1:samplesToShow)/Ts, trivialWaveform(1:samplesToShow))
      hold on
      plot(timeArray(1:samplesToShow)/Ts, blepWaveform(1:samplesToShow))
      title (['Time Domain Comparison for fc = ' num2str(fc) ' Hz'])
      legend('Sawtooth Trivial', 'Sawtooth BLEP')
      xlabel 'Samples'
      ylabel 'Amplitude'
      axis tight
  end

  end