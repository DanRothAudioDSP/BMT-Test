%% MIT KEMAR HRTF data import
pos = 10; %angle in degrees rounded to nearest 5 degrees
%load HRTF data   
if(pos<10)       
     f=['H0e00',int2str(pos),'a.wav'];    
elseif(pos<100)
     f=['H0e0',int2str(pos),'a.wav'];   
else
     f=['H0e',int2str(pos),'a.wav'];   
end
c = audioread(f);
%you can leave it in f, or copy it elsewhere
HRTF.l = c(:,2);
HRTF.r = c(:,1);

%load audio for testing
[dry, Fs] = audioread('dry.wav');
sampletime = length(dry);

%convolve with original MIT HRTF's
wet(:,2) = filter(HRTF.l,1,dry);
wet(:,1) = filter(HRTF.r,1,dry);

%create state space models from impulses
min_phase = false; %minimum phase switch
HRTF_minphaseL = minphase(HRTF.l);
HRTF_minphaseR = minphase(HRTF.r);
if(min_phase == false)
    HRTFss_L = imp2ss(HRTF.l);
    HRTFss_R = imp2ss(HRTF.r);
elseif(min_phase == true)
    HRTFss_L = imp2ss(HRTF_minphaseL);
    HRTFss_R = imp2ss(HRTF_minphaseR);
end
    
%% Perform balanced truncation on LTI system
Order = 10; %target filter order

%Define System to reduce
%left channel
SystemL = HRTFss_L; 
%right channel
SystemR = HRTFss_R;
%Create option set for balred command
Options = balredOptions();
%Compute reduced order approximation
HRTFreduced_L = balred(SystemL,Order,Options);
HRTFreduced_R = balred(SystemR,Order,Options);

%extract impulses from reduced models
HRIR_reducedL = impulse(HRTFreduced_L, sampletime);
HRIR_reducedR = impulse(HRTFreduced_R, sampletime);

%convolve audio with reduced IR's
wetreduced(:,2) = conv(dry,HRIR_reducedL);
wetreduced(:,1) = conv(dry,HRIR_reducedR);

%play audio for comparison
dryplayer = audioplayer(dry,Fs);
playblocking(dryplayer); %original audio
wetplayer = audioplayer(wet,Fs);
playblocking(wetplayer); %audio with original HRTF's
wetreducedplayer = audioplayer(wetreduced,Fs);
play(wetreducedplayer); %audio with reduced HRTF's

%write audio to file
if min_phase == true
    label = 'minphase';
else
    label = 'nonminphase';
end
filename = 'MITKEMAR_binaural.wav';
filename_reduced = ['ReducedHRTFbinaural_', int2str(Order),'thorder_',label,'.wav'];
audiowrite(filename, wet, Fs);
audiowrite(filename_reduced, wetreduced, Fs);

%FFT impulses
fft_size = 4096;
HRTF_fftL = fft(HRTF.l, fft_size);
HRTF_fftR = fft(HRTF.r, fft_size);
HRTFreduced_fftL = fft(HRIR_reducedL, fft_size);
HRTFreduced_fftR = fft(HRIR_reducedR, fft_size);

%% Analysis
%plot
figure(1);
subplot(2,1,1);
bodeplot(SystemL,HRTFreduced_L)
title('Left HRTF Comparison')
xlim([10^-2.5 3])
legend('Original HRTF Response','Reduced HRTF Response')
legend('boxoff')

subplot(2,1,2);
bodeplot(SystemR,HRTFreduced_R)
title('Right HRTF Comparison')
xlim([10^-2.5 3])
legend('Original HRTF Response','Reduced HRTF Response')
legend('boxoff')

%calculate log spectral distance
sampleRate = 48000;
LSD_average = (LogSpectralDistance(HRTF_fftL, HRTFreduced_fftL, sampleRate) + LogSpectralDistance(HRTF_fftR, HRTFreduced_fftR, sampleRate)) / 2;
LSDformatSpec = "The Log Spectral Distortion is: %f dB";
LSD = sprintf(LSDformatSpec, LSD_average)

%ILD differences
ILD_original = mean((mag2db(abs(HRTF_fftL)) - mag2db(abs(HRTF_fftR))));
ILD_reduced = mean((mag2db(abs(HRTFreduced_fftL)) - mag2db(abs(HRTFreduced_fftR))));
ILD_difference = abs(ILD_original - ILD_reduced);
ILDformatSpec = "The ILD difference is: %f dB";
ILD = sprintf(ILDformatSpec, ILD_difference)

%ITD differences
ITD_original = OnSetITD(HRTF_fftL, HRTF_fftR, -3, sampleRate, 1);
ITD_reduced = OnSetITD(HRTFreduced_fftL, HRTFreduced_fftR, -3, sampleRate, 1);
ITD_difference = abs(ITD_original - ITD_reduced);
ITDformatSpec = "The ITD difference is: %f";
ITD = sprintf(ITDformatSpec, ITD_difference)

%cross-correlation differences
crosscorr_original = xcorr(HRTF_fftL, HRTF_fftR);
crosscorr_reduced = xcorr(HRTFreduced_fftL, HRTFreduced_fftR);
crosscorr_diff = abs(mean(crosscorr_original - crosscorr_reduced));
xCorrformatSpec = "The Cross Correlation difference is: %f";
xCorr = sprintf(xCorrformatSpec, crosscorr_diff)

