function [spliLsqIR,numZc,order] = getSplineLsqIR2(fstop,widtrans,deltaStop,deltaPass,wtPass,wtStop,wtTrans1,wtTrans2,tableSize,getplot)
  %
  %   getSplineLsqIR2 Applies a Least squares filter to the given input
  %   filter parameters by fitting a cubic spline interpolated values for 
  %   the transition band. The filter response is then sinc interpolated to
  %   the required tableSize
  %   [splipmqIR,numZc,order] = getSplineLsqIR2(fstop,widtrans,deltaStop,
  %            deltaPass,wtPass,wtStop,wtTrans1,wtTrans2,tableSize,getplot)
  %
  %
  %   Copyright 2016.
  %   Samarth Behura
  %   Music Engineering and Technology
  %   University of Miami
  %   Inputs :
  %
  %   fstop : filter stop-band
  %   widtrans : width of transition band 
  %   deltaStop : the stop band attenuation in db
  %   deltaPass : the pass band ripple in db 
  %   wtStop : the weight for stopband
  %   wtPass  : the weight for passband
  %   wtTrans1:  the wt of 1st transition band
  %   wtTrans2:  the wt of 2nd transition band 
  %   tableSize: the length to which the sinc is interpolated,same as table
  %                 size
  %
  %   Output :
  %   
  %   pmqir: sinc function returned.
  %   numZc: Num of zc in sinc 
  %   order: Order of the filter
   
  % given fstopb and width of transition band calculate fpassband
    fpass = fstop - widtrans;
  % divide transition band into 4 equal bands
    f_inc =   (widtrans/5);
   %define additonal edges  
    f_1 = fpass + f_inc;
    f_2 = f_1   + f_inc;
    f_3 = f_2   + f_inc;
    f_4 = f_3   + f_inc;
    
   %original frequency vector
    origfrq = [0 fpass  fstop  1];
   %original amp vector 
    origAmp =  [1    1     0   0];
        
  % the frequency vector for the filter  
    freqvec = [0  fpass f_1  f_2  f_3  f_4  fstop    1];
  % the amplitude vector from spline
    ampvec = spline(origfrq,origAmp,freqvec);
  %deltas calc based on dB value % a higher stop band atten.(e.g -20 dB etc.)
  %relaxes the filter order
    deltas=10^(-deltaStop/20); %num is dB value  
  %deltap calc based on dB value% a higher value relaxes the filter order
    deltap = 10^(deltaPass/20)-1;%num is dB value
  % order based on deltap and deltas
    %Kaiser
    order = round(-(10*log10(deltap*deltas)+13)/(2.324*(fstop*pi-fpass*pi)));
  %stop band weight calc
 %   sbwt = deltap/deltas;
  %weight vect for filter
    wtvec = [wtPass wtTrans1 wtTrans2 wtStop];

  % b(k)=b(n+2-k),     k=1,...,n+1 symmtery relation of coeffs.
   bcoeffnum = firls(order,freqvec,ampvec,wtvec);

    %impulse response
    [hn,tn] = impz(bcoeffnum);

   
    %interpolate for table size
    newt = linspace(0,order,tableSize);
    [Ts,T] = ndgrid(newt,tn);
    spliLsqIR = sinc(Ts - T)*hn;

    %find zero-crossings in the interpolated sinc:
    i=1:length(spliLsqIR)-1;
    k=find ((spliLsqIR(i)>0 & spliLsqIR(i+1)<0) | (spliLsqIR(i)<0 & spliLsqIR(i+1)>0));
    numZc = length(k);

    if getplot
    figure()
    plot(tn,hn,'o',newt,spliLsqIR,newt(k),spliLsqIR(k),'x')
    grid on
    axis tight
    xlabel Time, ylabel Sinc
    title(['Least square design with order - ',num2str(order),',zero crossings - ',num2str(numZc)])
    xlabel Time, ylabel Signal
    legend('Sampled','Interpolated','Zero-crossings','Location','NorthEast')
    legend boxoff

    fvtool(bcoeffnum,1,'OverlayedAnalysis','phase')
    end


end