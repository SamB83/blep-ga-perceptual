function [hearingThresholdBSPL] = hearThres (freq)

% HEARTHRES Calculates the hearing threshold correspondent to a frequency in Hz based on the paper E. Terhardt, 
% ...Calculating virtual pitch, Hearing Res., vol. 1, pp. 155 1 8 2 , 1979.
%   [hearingThresholdSPLdB] = hearingThreshold (freq)
%   Copyright 2016.
%   Samarth Behura
%   Music Engineering and Technology
%   University of Miami
%   INPUTS
%   freq (1xn double array): frequency in Hz.


hearingThresholdBSPL = 3.64.*(freq./1000).^(-0.8) - ...
    6.5.*exp(-0.6.*(freq./1000 - 3.3).^2) + (10.^(-3)).*(freq./1000).^4;


end