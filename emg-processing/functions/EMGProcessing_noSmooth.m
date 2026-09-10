function [ EMGo ] = EMGProcessing_noSmooth( EMG, Order, F_low, F_high, Fs)

% mean EMG value is removed from the EMG signal - center at zero
EMGd = detrend(EMG,0);

% EMGd = EMG;
[b,a] = butter(Order,[F_high F_low]*2/Fs,'bandpass');
EMGh1 = filtfilt(b,a,EMGd); % bandpass filter
EMGp = abs(EMGh1); % rectification

% F_envelope = 500;
% removed the linear envelope to be similar to other stretch reflex studies
% [b,a] = butter(Order,F_envelope*2/Fs,'low');
% EMGo = filtfilt(b,a,EMGp); % lowpass filter

EMGo = EMGp;


end

