function [freq] = convMIDI2freq (MIDI)

% convMIDI2freq  Calculates the frequency in Hz correspondent to a MID value.
%   [freq] = convMIDI2freq (MIDI)
%   Copyright 2016.
%   Samarth Behura
%   Music Engineering and Technology
%   University of Miami
%   INPUTS
%   MIDI (1xn double array): frequency in MIDI.
%   OUTPUTS
% freq (1xn double array): frequency in Hz.
 freq = 2.^((MIDI-69)./12).*440; 
 end