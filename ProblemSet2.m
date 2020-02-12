%% ECE3614 Homework 3 - Christopher Mitchell

%% Removing DC

filename = '106miles.wav'; %declares the file that will be read in
[y,Fs] = audioread(filename); %reads the data from the audio file

%Transforms y into the freq domain, scales it, and shifts it to be centered
%on f = 0
N = length(y);
YfreqDomain = fft(y);
YfreqDomain(1) = 0;

%Reverses both of the ffts and undoes the scaling and scales up y
y_NoDC = ifft(YfreqDomain, N,'symmetric');

%% Modulation

%the carrier frequency and the new sample rate
f = 25000;
Fs_new = 5*f;
[p,q] = rat(Fs_new / Fs);

%resamples the signal and sets up the time vector and scales
y_NoDC = resample(y_NoDC,p,q);
t = 0:(length(y_NoDC)-1);
t = t/(Fs_new);
t = t';

%gives the modulated signal
sender = cos(2*pi*f*t) .* y_NoDC;

fprintf('The new resampling frequency is %d Hz\n',Fs_new);

%Plots the first 100 samples of the non modulated signal
figure(1);
stem(t(1:100),y_NoDC(1:100))
title('Time Domain No DC Signal over 100 Samples')
xlabel('Time (seconds)');
ylabel('Signal (volts)');

%Plots the first 100 samples of the DSB-SC modulated signal
figure(2)
plot(t(1:100),sender(1:100))
title('Time Domain DSB-SC Modulated No DC Signal over 100 Samples')
xlabel('Time (seconds)');
ylabel('Signal (volts)');

%Plots the non modulated signal
figure(3)
plot(t,y_NoDC);
xlim([0,t(length(t))])
title('Time Domain No DC Signal');
xlabel('Time (seconds)');
ylabel('Signal (volts)');

%Plots the DSB-SC modulated signal
figure(4)
plot(t,sender);
xlim([0,t(length(t))])
title('Time Domain DSB-SC Modulated No DC Signal');
xlabel('Time (seconds)');
ylabel('Signal (volts)');

%% Fourier Analysis

%Scale the frequency axis
N = length(sender);
if mod(N,2)==0
    k = -N/2:N/2-1;
else
    k = -(N-1)/2:(N-1)/2;
end
T = N/Fs_new;
freq = k/T;

%transforms the modulated signal to the frequency domain, scales, and
%converts to psd
SenderFreqDomain = fft(sender)/N;
SenderFreqDomain = fftshift(SenderFreqDomain);
psd = 20*log10(abs(SenderFreqDomain));

%Plots the PSD of the DSB-SC modulated signal
figure(5)
plot(freq,psd);
title('Power Spectral Density Plot of the DSB-SC Modulated Signal');
xlabel('Frequency (Hz)');
ylabel('Power Spectrum Density (dBW/Hz)');
xlim([-Fs_new/2,Fs_new/2])

