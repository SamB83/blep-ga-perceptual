function [harmonicPeaks, harmonicLocs, nonHarmonicPeaks, ...
                                nonHarmonicLocs] = findHarmonics (peaks, locs, fs, fc)

% findHarmonics  Separates the harmonic and non harmonic peaks of the
%                    power spectrum of a signal.
%   [harmonicPeaks, harmonicLocs, nonHarmonicPeaks, ...
%   nonHarmonicLocs] = findHarmonics (peaks, locs, fs, fc)
%
%   Copyright 2016.
%   Samarth Behura
%   Music Engineering and Technology
%   University of Miami
%
%
%   INPUTS
%   peaks (1xn double array): array with the magnitudes of the peaks of the
%                             power spectrum of a signal.
%   locs (1xn double array): array with the frequencies of the peaks of the
%                            power spectrum of a signal.
%   fs (double): sampling rate of input audio signal.
%   fc (double): fundamental frequency of waveform.
%
%
%   OUTPUTS
%   harmonicLocsBLEP (1xn double array): array with the frequencies of the
%                                        harmonic peaks of a BLEP signal.
%   harmonicPeaksBLEP (1xn double array): array with the magnitudes of the
%                                         harmonic peaks of a BLEP signal.
%   nonHarmonicLocsBLEP (1xm double array): array with the frequencies of
%                                           the non harmonic peaks of a
%                                           BLEP signal.
%   nonHarmonicPeaksBLEP (1xm double array): array with the magnitudes of
%                                           the non harmonic peaks of a
%                                            BLEP signal.

nHarmonics = floor(fs/(2*fc));
nonHarmonicPeaks = peaks;
nonHarmonicLocs = locs;
harmonicPeaks = zeros(1, nHarmonics);
harmonicLocs = zeros(1, nHarmonics);

% Original harmonics

originalHarmonics = zeros(1, nHarmonics);
for i=1:1:nHarmonics
  originalHarmonics(i) = i*fc;
end

% Assign 0.0 to all undesired data
for k=1:1:nHarmonics
    absValues = abs(locs - originalHarmonics(k));
    [ ~, index] = min(absValues);
    harmonicPeaks(k) = peaks(index);
    harmonicLocs(k) = locs(index);
    nonHarmonicPeaks(index) = 0.0;
    nonHarmonicLocs(index) = 0.0;
end
% Eliminate all 0.0
nonHarmonicPeaks(nonHarmonicPeaks == 0.0) = [];
nonHarmonicLocs(nonHarmonicLocs == 0.0) = [];

end



