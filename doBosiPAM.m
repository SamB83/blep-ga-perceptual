function [aliasPresent, nonHarmonicsAbove, harmonicsBelow] = doBosiPAM ...
    (harmonicPeaks, harmonicLocs, nonHarmonicPeaks, nonHarmonicLocs, ...
    type, wplot)

%     doBosiPAM Applies the Bosi Pyschoacoutic Model (PAM) to an audio signal based on the paper 
%     Bosi, M. (2003). Audio Coding: Basic Principles and Recent Developments. 
%     Proceedings 6th International Conference on Humans and Computers, 117.
%     
%     [aliasPresent, nonHarmonicsAbove, harmonicsBelow] = doBosiPAM ...
%     (harmonicPeaks, harmonicLocs, nonHarmonicPeaks, nonHarmonicLocs, ...
%      type, plot)
%     Copyright 2016.
%     Samarth Behura
%     Music Engineering and Technology
%     University of Miami
%     
%     INPUTS
%     harmonicPeaks (1xn double array): array with the magnitudes of the
%                                       harmonic peaks of a signal.
%     harmonicLocs (1xn double array): array with the frequencies of the
%                                      harmonic peaks of a signal.
%     nonHarmonicPeaks (1xm double array): array with the magnitudes of the
%                                          non harmonic peaks of a signal.
%     nonHarmonicLocs (1xm double array): array with the frequencies of the
%                                          non harmonic peaks of a signal.
%     type (string): 'dB' or 'linear' magnitudes of the peaks.
%     plot (bool): true for drawing plots.
%     
%     
%     OUTPUTS
%     aliasPresent (bool): Determines if there is aliasing.
%     nonHarmonicsAbove (1xp double array): array of frequencies of aliased
%                                           peaks above the PAM curve
%     harmonicsBelow (1xk double array): array of frequencies of harmonic
%                                        peaks below the PAM curve



harmonicLocsBark = freq2bark(harmonicLocs);
nonHarmonicLocsBark = freq2bark(nonHarmonicLocs);

% Factors for downshift and scaling
downshift = 10; % dB for BL ocillator that contain nearly tonal maskers
refSPLdB = 96; % dB for the first harmonic
refSPL = 10^(refSPLdB/20); % Linear for the first harmonic

 % Pre-processing on dB
 if (strcmpi(type, 'dB'))
     if (isempty(nonHarmonicPeaks))
     minOffset = min(harmonicPeaks);
     else
     minHarmonicdB = min(harmonicPeaks);
     minNonHarmonicdB = min(nonHarmonicPeaks);
     minOffset = min(minHarmonicdB, minNonHarmonicdB);
     end
 harmonicPeaks = harmonicPeaks - minOffset; %Offset for negative numbers
 nonHarmonicPeaks = nonHarmonicPeaks - minOffset;
 maxHarmonicdB = max(harmonicPeaks);
 harmonicPeaks = harmonicPeaks.*refSPLdB./maxHarmonicdB;
 nonHarmonicPeaks = nonHarmonicPeaks.*refSPLdB./maxHarmonicdB;
 % Pre-processing on Linear
 elseif (strcmpi(type, 'linear'))
     maxHarmonic = max(harmonicPeaks);
     harmonicPeaks = harmonicPeaks*refSPL/maxHarmonic;
     nonHarmonicPeaks = nonHarmonicPeaks*refSPL/maxHarmonic;
     harmonicPeaks = 20*log10(harmonicPeaks);
     nonHarmonicPeaks = 20*log10(nonHarmonicPeaks);
 else
 error('Must enter dB or linear')
 end
 
 % Hearing Threshold calculation
 
 f=zeros(1, 22050-19);
 
for i = 20:1:22050
    f(1, i-19) = i;
end
hearingThres = hearThres(f);
b = freq2bark(f);
S = zeros(length(b));

% Implement the masking curve

for i=1:1:length(harmonicLocsBark) %masker
    for j=1:1:length(b) %maskee
        
        dz = b(j) - harmonicLocsBark(i); 
        if  dz<0
            thetadz = 0;
        else
        thetadz = 1;        
        end

    S(i, j) = (harmonicPeaks(i)-downshift) + (-27 + ...
    0.37*max((harmonicPeaks(i)-downshift)-40, 0)*thetadz)*abs(dz); 
    end
end 

% Draw the masking curve
masking = S(1, :);
for i=1:1:length(b)
    for j=2:1:length(harmonicLocsBark)
     if(S(j,i) > masking(i))
        masking(i) = S(j, i);
      end
    end
end

 % Find the maximum of Hearing Threshold Curve and the Masking Curve
 curve = hearingThres;
for i=1:1:length(b)
    for j=1:1:length(harmonicLocsBark)
        if(S(j,i) > curve(i))
        curve(i) = S(j, i);
        end

    end
 end
 
% Plot the curve, harmonic peaks, and non harmonic peaks
 if wplot
     figure()
     plot(b,curve, 'b--')
     hold on
     plot(b,hearingThres, 'k--')
     hold on
     plot(b,masking, 'g--')
     hold on
     stem(harmonicLocsBark, harmonicPeaks,'BaseValue',-20, 'Color', 'g')
     hold on
     stem(nonHarmonicLocsBark, nonHarmonicPeaks,'BaseValue',-20, ...
                     'Color', 'r', 'Marker', 'x')
     title('Masking spectrum')
     xlabel('Frequency (Bark)') 
     ylabel('Magnitude (dB)')
     if(isempty(nonHarmonicLocs))
         legend('PAM Curve', 'Hearing Threshold Curve', ...
         'Masking Curve', 'Harmonics')
     else
         legend('PAM Curve', 'Hearing Threshold Curve', ...
         'Masking Curve', 'Harmonics', 'Non-Harmonics')
     end
     axis tight
     ylim([-20 100]);
 end
% Check for first non-harmonic peak above the curve
nonHarmonicsAbove = nonHarmonicLocs;
for i=1:1:length(nonHarmonicLocs)
    % Find closest b value for the location
    absBark = abs(b - nonHarmonicLocsBark(i));
    [~,index] = min(absBark);
    if (nonHarmonicPeaks(i) < curve(index))
        nonHarmonicsAbove(i) = 0.0; %Hz
    end
end
nonHarmonicsAbove(nonHarmonicsAbove == 0.0) = [];

% Check for first harmonic peak below the curve
harmonicsBelow = harmonicLocs;
for i=1:1:length(harmonicLocs)
    % Find closest b value for the location
    absBark = abs(b - harmonicLocsBark(i));
    [~,index] = min(absBark);
    if (harmonicPeaks(i) > curve(index))
        harmonicsBelow(i) = 0.0; %Hz
    end
end
harmonicsBelow(harmonicsBelow == 0.0) = [];

% Check if there is any aliasing above the curve
        if isempty(nonHarmonicsAbove)
         aliasPresent = false;
         else
         aliasPresent = true;
        end
end





