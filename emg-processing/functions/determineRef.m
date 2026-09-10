function [avgrefFlexion, avgrefExtension] = determineRef(subjnum, velTrialNum, Fs, timeToPerturb, Perturb_begin_index, fcrfilt, ecufilt)

%This function returns arrays of the average EMG values for both FCR and ECU experienced prior to
%perturbation generated in the torque state. This should generate an average EMG value when the muscles are loaded and pushing towards the target. This function utilizes the "timeToPerturb"
%values created in the runDeviceVariablesMRSW file that is stored in each subject's Q2
%data. Function gets the index values that correspond to each perturbation event, converts the randomly generated times to index
%values, and turns it into a range of indices by subtraction. EMG is filtered, and then average
%values are obtained for each instance. (In the main
%script these averages are then averaged again to obtain one number for
%normalization). Generates a plot to visualize these averages.

trials = length(velTrialNum);
emgline_yf = []; emgline_ye = []; emgline_rf = []; emgline_re = []; 
for i=1:trials
    if i<=(trials/2) && velTrialNum(i,4) == 0.2 && velTrialNum(i,3) == 0 
        emgline_yf = [emgline_yf velTrialNum(i,1)];
    elseif i>(trials/2) && velTrialNum(i,4) == 0.2 && velTrialNum(i,3) == 0 
        emgline_ye = [emgline_ye velTrialNum(i,1)];
    elseif i<=(trials/2) && velTrialNum(i,4) == 0.2 && velTrialNum(i,3) == 1
        emgline_rf = [emgline_rf velTrialNum(i,1)];
    elseif i>(trials/2) && velTrialNum(i,4) == 0.2 && velTrialNum(i,3) == 1
        emgline_re = [emgline_re velTrialNum(i,1)];
    else
        %nothing
    end
end

emgline_f = sort([emgline_yf emgline_rf]);
emgline_e = sort([emgline_ye emgline_re]);

refidx_f2 = Perturb_begin_index(emgline_f);
refidx_e2 = Perturb_begin_index(emgline_e);

refidx_f1 = Perturb_begin_index(emgline_f)-ceil(Fs/1000*(timeToPerturb(emgline_f)))';
refidx_e1 = Perturb_begin_index(emgline_e)-ceil(Fs/1000*(timeToPerturb(emgline_e)))';


refFlexion = {}; refExtension = {}; 
for i=1:(length(emgline_f))    
    refFlexion{i} = fcrfilt(refidx_f1(i):refidx_f2(i));
    refExtension{i} = ecufilt(refidx_e1(i):refidx_e2(i));
end

avgrefFlexion = []; avgrefExtension = [];
for i=1:(length(emgline_f))
   avgrefFlexion = [avgrefFlexion mean(refFlexion{i})];
   avgrefExtension = [avgrefExtension mean(refExtension{i})];
end

figure()
plot(avgrefFlexion,'wo','MarkerFaceColor','b')
hold on
plot(avgrefExtension,'wo','MarkerFaceColor','r')
plot(1:60,ones(1,60)*mean(avgrefFlexion),':b')
plot(1:60,ones(1,60)*mean(avgrefExtension),':r')
hold off
title(strcat('Reference held EMG for array subject #', num2str(subjnum)))