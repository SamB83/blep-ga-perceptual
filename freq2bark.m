function [bark] = freq2bark (freq)
% FREQ2BARK
%   [bark] = freq2bark (freq)
%   Copyright 2016.
%   Samarth Behura
%   Music Engineering and Technology
%   University of Miami
%   INPUTS
%   freq (1xn double array): frequency in Hz.
%   OUTPUTS
%   bark (1xn double array): frequency in Bark Scale.
% Calculates the bark correspondent to a frequency in Hz based on the paper Zwicker, E., and Terhardt, E. (1980).
% "Analytical expressions for critical band rate and critical bandwidth as a function of frequency," J. Acoust. Soc. Am. 68, 1523-1524.
bark = 13*atan(0.00076*freq) + 3.5*atan((freq/7500).^2);

end