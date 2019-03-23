%Title: OnSet ITD
%Author: Jorge Estrella
%Date: 2010
%Code version: 1.0
%Availability: https://www2.ak.tu-berlin.de/~akgroup/ak_pub/abschlussarbeiten/2011/EstrellaJorgos_StudA.pdf
%%
function [ itd ] = OnSetITD( left , right , onset_threshold_dB , fs,up)
% Function to calculate the ITD with detection of Onsets
% Input parameters are IR vectors left and right , the onset threshold in
% dB, the sample frequency and the upsampling factor that the IRs have.
%
tauUp = 1/( up*fs) ;
% calculate linear onset threshold from dB value
onset_threshold =10^(onset_threshold_dB/20) ;
% find peaks and compute the sample position : Left
[maxLeft,iLeft ] = max(left) ;
kL = 0;
while kL <= iLeft
kL = kL +1;
if abs( left (kL)) > abs(maxLeft*onset_threshold )
break ;
end;
end
if kL == 0,
fprintf ( ' Error #1 Left : Problem finding the onset \n') ;
kL = 1;
end
% find peaks and compute the sample position : Right
[maxRight,iRight] = max(right) ;
kR = 0;
while kR <= iRight
kR = kR + 1;
if abs( right (kR)) > abs(maxRight*onset_threshold )
break ;
end;
end
if kR == 0,
fprintf ( ' Error #1 Right: Problem finding the onset \n') ;
kR = 1;
end
% calculate the ITD in seconds instead of samples
itd = (kL-kR)*tauUp;