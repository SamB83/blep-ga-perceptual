function [output] = fixClipping (input)

% FIXCLIPPING  Fixes clipping in an audio signal.
%   [output] = fixClipping (input)
%   Copyright 2016.
%   Samarth Behura
%   Music Engineering and Technology
%   University of Miami
%   INPUTS
%   input (1xn double array): clipped signal.
%   OUTPUTS
%   output (1xn double array): corrected signal.
% 



fromMax = max(abs(input));
[output] = input/fromMax;
end