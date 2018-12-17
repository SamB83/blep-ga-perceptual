function [DFTdBFS, DFTFS, DFTdB, DFT, freqArray] = calDFT (fs, ...
       input, NDFT, needplot)
   
%      CALDFT  Calculates Discrete Fourier Transform (DFT) of an audio
%                    signal.
%        [DFTdBFS, DFTFS, DFTdB, DFT, freqArray] = calculateDFT (fs, ...
%         input, NDFT, plot)
%        Copyright 2016.
%        Samarth Behura
%        Music Engineering and Technology
%        University of Miami


%        INPUTS
%        fs (double): sampling rate of input audio signal.
%        input (1xn double array): input vector of audio signal (MONO).
%        NDFT (double): size of DFT.
%        plot (bool): true for drawing plots.


%        OUTPUTS
%        DFTdBFS (1xNDFT/2 double array): DFT in dB Full Scale (0dB=max).
%        DFTFS (1xNDFT/2 double array): DFT in linear Full Scale (1=max).
%        DFTdB (1xNDFT/2 double array): DFT in dB raw results.
%        DFT (1xNDFT/2 double array): DFT in linear raw results.
%        freqArray (1xNDFT/2 double array): frequency array from 0 to Nyquist
%                                                 (fs/2) Hz.

[a, ~] = size(input);

 if a ~= 1
      error('Audio signal must be MONO (1-channel)')
end

L = length(input);
lowerLimitdB = - 96;


% Use Dolph-Chebishev Windowing
window = chebwin(L);
inputWin = input.*window';


%DFT
input2FFT = fft(inputWin,NDFT);
%scaling step
inputFFT = input2FFT/L;
DFT = 2*abs(inputFFT(1:NDFT/2));

% DFTdB
DFTdB = 20.*log10(DFT);

% DFTdB
maxinputFFT = max(DFT);
inputFFTAbs = DFT/maxinputFFT;
DFTFS = inputFFTAbs;

% DFTdBFS
DFTdBFS = 20.*log10(DFTFS);

% Frequency Array
freqArray = fs/2*linspace(0,1,NDFT/2);

if needplot
    figure()
    plot(f/1000,DFT)
    title ('Frequency Domain (Spectrum) - Linear')
    xlabel 'Frequency (kHz)'
    ylabel 'Magnitude'
  
    figure()
    plot(f/1000,DFTdB)
    title ('Frequency Domain (Spectrum) - dB')
    xlabel 'Frequency (kHz)'
    ylabel 'Magnitude (dB)'
    ylim([lowerLimitdB 0]);
 
    figure()
    plot(freqArray,DFTFS)
    title ('Frequency Domain (Spectrum) - Linear-FS')
    xlabel 'Frequency (kHz)'
    ylabel 'Magnitude'

    figure()
    plot(freqArray,DFTdBFS)
    title ('Frequency Domain (Spectrum) - dB-FS')
    xlabel 'Frequency (kHz)'
    ylabel 'Magnitude (dB)'
    ylim([lowerLimitdB 0]);
   
end
end