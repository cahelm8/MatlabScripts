function [ EMGo ] = EMGProcessing( EMG, Order, F_low, F_high, F_envelope, Fs)


EMGd = detrend(EMG,0);
[b,a] = butter(Order,[F_high F_low]*2/Fs,'bandpass');
EMGh1 = filtfilt(b,a,EMGd); % bandpass filter
EMGp = abs(EMGh1); % rectification
[b,a] = butter(Order,F_envelope*2/Fs,'low');
EMGo = filtfilt(b,a,EMGp); % lowpass filter


end

