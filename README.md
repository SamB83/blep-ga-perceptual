# blep-ga-perceptual
Band limited step functions using IRs from optimized filters arrived through  genetic algorithm(GA) search.
The matlab functions were developed on the Matlab2016b version. The code is in support of the paper 
Perceptually Alias-Free Waveform Generation Using the Bandlimited Step Method and Genetic Algorithm
(http://www.aes.org/e-lib/browse.cfm?elib=18471). The GA can be started using a wrapper like the following code example:
%% Run sinc GA for table size 4096
% NDFT = 16384;
% fs = 48000;
% N = 4096;
% [output, fval,extflag,ouput,finpopln,finpopscore] = GAMultiObjSplinOptimSinc(NDFT, fs, N);
