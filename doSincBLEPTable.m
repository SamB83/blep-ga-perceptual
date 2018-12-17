  function [bleptable] = doSincBLEPTable(fs, insinc, window, N, needplot)
  % DOBLEPTABLE Creates a BLEP table for an specific input and window
  %
  %   [bleptable] = doBLEPTable(fs, input, window, n, m)
  %   Copyright 2016.
  %   Samarth Behura
  %   Music Engineering and Technology
  %   University of Miami
  %   
  %
  %   INPUTS
  %   fs (double): sampling rate of input audio signal.
  %   input (handle): handle of the input function (i.e. '@sinc').
  %   window (1xN double array): window in an array.
  %   N (double): size of BLEP table.
  %   n (double): number of zero crossings on each side of function.
  %   plot (bool): true for drawing plots.
  %
  %   OUTPUTS
  %   bleptable (1xn double array): BLEP table.

 % Ts = 1/fs;
 
  % 1. DEFINE INPUT

   impulse = insinc;
  if needplot
      figure()
      plot((-((N/2) - 1):1:(N/2)),window)
      title(['GA Window with N = ' num2str(N) ' samples'])
      xlabel('Samples');
      ylabel('Amplitude');
      axis tight
  end

  % 2. APPLY WINDOW % added window' to transpose
    windowed = impulse.*window;
  if needplot
      figure()
      plot((-((N/2) - 1):1:(N/2)),windowed)
      title(['GA Windowed Input Function with N = ' num2str(N) ' samples'])
      xlabel('Samples');
      ylabel('Amplitude');
      axis tight
  end

  % 3. INTEGRATE AND CONVERT TO BIPOLAR
  sum = 0;
  sum2 = 0;
  integral = zeros(1,N);
  for i = 1:N
      sum = sum+windowed(i);
      integral(i)=sum;
      sum2 = sum2 + integral(i);
  end
  bipolar = integral/sum;
  bipolar = bipolar.*2-1;
  if needplot
      figure()
      plot((-((N/2) - 1):1:(N/2)),bipolar)
      title(['GA Bipolar Integrated Input Function with N = ' ...
      num2str(N) ' samples'])
      xlabel('Samples');
      ylabel('Amplitude');
      axis tight
  end

  % 4. SUBTRACT STEP FUNCTION
  step = zeros(1,N);
  for i = 1:N
     if i<=(N/2)
         step(i) = -1;
     else
         step(i) = 1;
     end
  end
  residual = bipolar - step;
  invresidual = residual.*-1;
  bleptable = residual;
  if needplot
      figure()
      plot((-((N/2) - 1):1:(N/2)), residual)
      title (['GA BLEP Residual with N = ' num2str(N) ' Samples'])
      xlabel('Samples');
      ylabel('Amplitude');
      axis tight

      figure()
      plot((-((N/2) - 1):1:(N/2)), invresidual)
      title('BLEP Residual Inverted')
      title (['GA BLEP Residual Inverted with N = ' num2str(N) ' Samples'])
      xlabel('Samples');
      ylabel('Amplitude');
      axis tight
  end

  end