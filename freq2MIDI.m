function [MIDI] = freq2MIDI (freq)

% FREQ2MIDI  Calculates the MIDI correspondent value to a frequency in Hz.
%   [bark] = freq2bark (freq)
%   Copyright 2016.
%   Samarth Behura
%   Music Engineering and Technology
%   University of Miami
%   INPUTS
%   freq (1xn double array): frequency in Hz.
%   OUTPUTS
%   MIDI (1xn double array): frequency in MIDI.
 MIDI = 69 + 12.*log2(freq./440); 
end