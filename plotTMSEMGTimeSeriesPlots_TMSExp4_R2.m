
clc
% clear all
close all

% getting the MEP amplitudes and MEP thresholding for the TMS control group

processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
% addpath(genpath(processingPath));

processingScriptsPath = [processingPath '\emg-processing'];
addpath(genpath(processingScriptsPath));

%plotting Scripts
plottingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts'];
addpath(genpath(plottingPath));

% SPM_1DPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing\SPM_1D'];
% addpath(genpath(SPM_1DPath));

FigurePath = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\R2_Plots\'];


%%
% New1 = load('SavedEMGData\allSubjData_norm_TMSExp4.mat');
% OG1 = load('SavedEMGData\allSubjData_norm_TMSExp4_R1Data.mat');

load('SavedEMGData\allSubjData_norm_TMSExp4.mat');

size(allSubjData_nonnormRaw_TMSExp4)

%% Band pass filter raw EMG data for each subject

nReps = 20;
nConds = 6;
nSubjs = 12;

% Band-pass filter
Order = 4;
fLP = 500; % low pass filter
fHP = 20; % high pass filter
Fs = 5000; % sampling rate, samples per second

for r = 1:nReps
    for c = 1:nConds
        for s = 1:nSubjs
        EMGd = detrend(allSubjData_nonnormRaw_TMSExp4(r,:,c,s),0);
        [b,a] = butter(Order,[fHP fLP]*2/Fs,'bandpass');
        FCR_nonnormBP(r,:,c,s) = filtfilt(b,a,EMGd); % bandpass filter
        FCR_nonnorm_DT(r,:,c,s) = EMGd;
        end
    end
end

% save('allSubjData_norm.mat','allSubjData_norm','allSubjData_nonnorm','allSubjData_nonnormRaw',...
%     'FCR_nonnormBP')

% Removing mean during background
size(allSubjData_nonnormRaw_TMSExp4)


%% run this section if you are interested in comparing filtering methods
% for t = 1:20
%     for c = 1:6
%         for s = 1
%         FCR_nonnorm_demean(t,:,c,s) = allSubjData_nonnormRaw_TMSExp4(t,:,c,s) - ...
%             mean(allSubjData_nonnormRaw_TMSExp4(t,1:150,c,s));
%         end
%     end
% end
% 
% 
% %
% % Band-pass filter
% Order = 4;
% fLP = 500; % low pass filter
% fHP = 20; % high pass filter
% Fs = 5000; % sampling rate, samples per second
% % F_envelope = 60;
% 
% for r = 1:nReps
%     for c = 1:nConds
%         for s = 1
%         [b,a] = butter(Order,[fHP fLP]*2/Fs,'bandpass');
%         FCR_nonnormBP_v2 = filtfilt(b,a,FCR_nonnorm_demean(r,:,c,s)); % bandpass filter
%         FCR_nonnorm_rect = abs(FCR_nonnormBP_v2);
%         % [b,a] = butter(Order,F_envelope*2/Fs,'low');
%         % FCR_nonnorm_enveloped(r,:,c,s) = filtfilt(b,a,FCR_nonnorm_rect); % lowpass filter
%         end
%     end
% end


%%
%%%%%%%%%%%%%%%

% remove trials where the MEP exceeds a threshold of 200 uV
FCR_nonnormBP_crop = FCR_nonnormBP;

% can decide if you want to run the analysis with back norm or pert norm
% here

allSubjData_norm_crop = allSubjData_norm_TMSExp4;
% allSubjData_norm_crop = allSubjData_ptbnorm_TMSExp4;

nReps = 20;
nConds = 6;
nSubjs = 12;

Fs = 5000;
PertOnTime = 1000; % 200 ms into the cropped timeseries
MEPDuration = 0.050*Fs;
BackDuration = 0.050*Fs;

MEPtime(1,:) = [PertOnTime-0.070*Fs  PertOnTime-0.020*Fs];
MEPtime(2,:) = [PertOnTime-0.070*Fs  PertOnTime-0.020*Fs];
MEPtime(3,:) = [PertOnTime-0.070*Fs  PertOnTime-0.020*Fs];
MEPtime(4,:) = [PertOnTime-0.070*Fs  PertOnTime-0.020*Fs];
MEPtime(5,:) = [PertOnTime-0.070*Fs  PertOnTime-0.020*Fs];
MEPtime(6,:) = [PertOnTime-0.070*Fs  PertOnTime-0.020*Fs];

Backtime(1,:) = [PertOnTime-0.125*Fs  PertOnTime-0.075*Fs];

Indexes = nan(nSubjs,nConds,nReps);
FCR_EMG_LowMEP = nan(nReps,2251,nConds,nSubjs);
FCR_EMG_HighMEP = nan(nReps,2251,nConds,nSubjs);

for s = 1:nSubjs
    for c = [1:nConds]
    
    index200 = any(abs(FCR_nonnormBP_crop(:,MEPtime(c,1):MEPtime(c,2),c,s)) >= 200, 2);
    % index_95CI = any(abs(FCR_nonnormBP_crop(:,MEPtime(c,1):MEPtime(c,2),c,s)) >= x_value(s), 2);

    FCR_EMG_LowMEP(~index200,:,c,s) = allSubjData_norm_TMSExp4(~index200,:,c,s);
    FCR_EMG_HighMEP(index200,:,c,s) = allSubjData_norm_TMSExp4(index200,:,c,s);
     
    % peak, mean and std of the EMG signal during the MEP window
    MEPpeak(:,c,s) = max(abs(FCR_nonnormBP(:,MEPtime(c,1):MEPtime(c,2),c,s)),[],2);

    MEPmean(:,c,s) = mean(abs(FCR_nonnormBP(:,MEPtime(c,1):MEPtime(c,2),c,s)),2);

    MEPstd(:,c,s) = nanstd(FCR_nonnormBP(:,MEPtime(c,1):MEPtime(c,2),c,s),[],2);

    IndCount(:,c,s) = sum(index200);
    IndSave(:,c,s) = index200;
    Indexes(find(index200),c,s) = find(index200);

    % IndCount_95CI(:,c,s) = sum(index_95CI);
    % IndSave_95CI(:,c,s) = index_95CI;
    
    end
end


%% Subject MEP threshold values used during the AMT procedure

x_MEP_values_AMT = [80,140,110,90,125,170,60,110,130,70,130,80];


for s = 1:nSubjs

MEPpeakCat(:,s) = cat(1,MEPpeak(:,1,s), MEPpeak(:,2,s));
MEPstdCat(:,s) = cat(1,MEPstd(:,1,s), MEPstd(:,2,s));

x_value(s) = norminv(0.95, mean(MEPpeakCat(:,s)), std(MEPpeakCat(:,s)));
end

x_value

mean(MEPpeakCat);
std(MEPpeakCat);

mean(MEPstdCat);
max(MEPstdCat);

%%

% within trial standard deviation threshold
% MEPControlMean = backMean(:,:,:);
% MEPControlSTD = backstd(:,:,:);

MEPControl = MEPpeak(:,1:2,:);
MEPControl = reshape(MEPControl,40,nSubjs);
MEPControlMean = squeeze(mean(MEPControl));
MEPControlSTD = squeeze(std(MEPControl,0,1));

threshold_10x = 10*MEPControlSTD + MEPControlMean;
threshold_3x = 3*MEPControlSTD + MEPControlMean; % mean plus the standard deviation
threshold_2x = 2*MEPControlSTD + MEPControlMean;
threshold_1x = 1*MEPControlSTD + MEPControlMean;
threshold_0_75x = 0.75*MEPControlSTD + MEPControlMean;

threshold_10x = reshape(threshold_10x,[],[nSubjs]);
threshold_3x = reshape(threshold_3x,[],[nSubjs]);
threshold_2x = reshape(threshold_2x,[],[nSubjs]);
threshold_1x = reshape(threshold_1x,[],[nSubjs]);
threshold_0_75x = reshape(threshold_0_75x,[],[nSubjs]);


%%
clear index_95CI IndCount_95CI IndSave_95CI index_MEP_AMT IndCount_MEP_AMT IndSave_MEP_AMT

FCR_nonnormBP_crop = FCR_nonnormBP;

for s = 1:nSubjs
    for c = [1:nConds]
    index_95CI = any(abs(FCR_nonnormBP_crop(:,MEPtime(c,1):MEPtime(c,2),c,s)) >= x_value(s), 2);
    IndCount_95CI(:,c,s) = sum(index_95CI);
    IndSave_95CI(:,c,s) = index_95CI;

    index_MEP_AMT = any(abs(FCR_nonnormBP_crop(:,MEPtime(c,1):MEPtime(c,2),c,s)) >= x_MEP_values_AMT(s), 2);
    IndCount_MEP_AMT(:,c,s) = sum(index_MEP_AMT);
    IndSave_MEP_AMT(:,c,s) = index_MEP_AMT;

    end
end

%%

for s = 1:nSubjs
    MEPpeakCheck = MEPpeak(:,:,s);
    MEPthres_10X_I(:,s) = logical(MEPpeakCheck(:) >= threshold_10x(:,s)); % 1 where it is high MEP
    MEPthres_3X_I(:,s) = logical(MEPpeakCheck(:) >= threshold_3x(:,s)); % 1 where it is high MEP
    MEPthres_2X_I(:,s) = logical(MEPpeakCheck(:) >= threshold_2x(:,s)); % 1 where it is high MEP
    MEPthres_1X_I(:,s) = logical(MEPpeakCheck(:) >= threshold_1x(:,s)); % 1 where it is high MEP
    
    MEPthres_0_75X_I(:,s) = logical(MEPpeakCheck(:) >= threshold_0_75x(:,s)); % 1 where it is high MEP

    MEPpeakCheck2 = MEPpeak(:,3:6,s);
    MEPthres_median(s) = median(MEPpeakCheck2(:));
    MEPthresP(:,s) = logical(MEPpeakCheck(:) > median(MEPpeakCheck2(:)));  % 1 where it is high MEP
   
    for c = 1:6
    MEPthresP2(:,c,s) = logical(squeeze(MEPpeak(:,c,s)) > median(squeeze(MEPpeak(:,c,s))));  % 1 where it is high MEP
    end
    
end

% reshape MEP peak matrix

% MEPpeak(:,1:2,:) = 0;
% MEPpeak(:,1:2,:) = NaN;

MEPpeak_JMP = MEPpeak(:);

MEPthresP = MEPthresP + 1;
MEPthresP(1:40,:) = 0;
MEPthresP_JMP = double(MEPthresP(:));

MEPthresP_2 = double(MEPthresP2(:))+1;

MEPthres_10X_I = MEPthres_10X_I + 1;
MEPthres_10X_I(1:40,:) = 0;
MEPthres_10X_I_JMP = double(MEPthres_10X_I(:));

MEPthres_3X_I = MEPthres_3X_I + 1;
MEPthres_3X_I(1:40,:) = 0;
MEPthres_3X_I_JMP = double(MEPthres_3X_I(:));

MEPthres_2X_I = MEPthres_2X_I + 1;
MEPthres_2X_I(1:40,:) = 0;
MEPthres_2X_I_JMP = double(MEPthres_2X_I(:));

MEPthres_1X_I = MEPthres_1X_I + 1;
MEPthres_1X_I(1:40,:) = 0;
MEPthres_1X_I_2 = MEPthres_1X_I;
MEPthres_1X_I_2([81:120],:) = 0;
MEPthres_1X_I_JMP = double(MEPthres_1X_I_2(:));

MEPthres_0_75X_I = MEPthres_0_75X_I + 1;
MEPthres_0_75X_I(1:40,:) = 0;
MEPthres_0_75X_I_JMP = double(MEPthres_0_75X_I(:));

IndSave2 = double(IndSave)+1;
IndSave2(:,1:2,:) = 0;
MEP_200Thres_JMP = IndSave2(:);
MEP_200Thres = reshape(IndSave2(:),120,nSubjs);

IndSave2_95CI = double(IndSave_95CI)+1;
IndSave2_95CI(:,1:2,:) = 0;
MEP_95CIThres_JMP = IndSave2_95CI(:);
MEP_95CIThres = reshape(IndSave2_95CI(:),120,nSubjs);

IndSave2_MEP_AMT = double(IndSave_MEP_AMT)+1;
IndSave2_MEP_AMT(:,1:2,:) = 0;
MEP_AMT_Thres_JMP = IndSave2_MEP_AMT(:);
MEP_AMT_Thres = reshape(IndSave2_MEP_AMT(:),120,nSubjs);




%% Compute the average EMG timeseries on the group level

nSubjs

MEPthres_10X_ID2 = reshape(MEPthres_10X_I,[nReps,nConds,nSubjs]);
MEPthres_10X_low = logical(MEPthres_10X_ID2 == 1);
MEPthres_10X_high = logical(MEPthres_10X_ID2 == 2);

MEPthres_3X_ID2 = reshape(MEPthres_3X_I,[nReps,nConds,nSubjs]);
MEPthres_3X_low = logical(MEPthres_3X_ID2 == 1);
MEPthres_3X_high = logical(MEPthres_3X_ID2 == 2);

MEPthres_2X_ID2 = reshape(MEPthres_2X_I,[nReps,nConds,nSubjs]);
MEPthres_2X_low = logical(MEPthres_2X_ID2 == 1);
MEPthres_2X_high = logical(MEPthres_2X_ID2 == 2);

MEPthres_1X_ID2 = reshape(MEPthres_1X_I,[nReps,nConds,nSubjs]);
MEPthres_1X_low = logical(MEPthres_1X_ID2 == 1);
MEPthres_1X_high = logical(MEPthres_1X_ID2 == 2);

MEPthres_0_75X_ID2 = reshape(MEPthres_0_75X_I,[nReps,nConds,nSubjs]);
MEPthres_0_75X_low = logical(MEPthres_0_75X_ID2 == 1);
MEPthres_0_75X_high = logical(MEPthres_0_75X_ID2 == 2);

MEP_200Thres_ID2 = reshape(MEP_200Thres,[nReps,nConds,nSubjs]);
MEP_200Thres_low = logical(MEP_200Thres_ID2 == 1);
MEP_200Thres_high = logical(MEP_200Thres_ID2 == 2);

MEP_95CIThres_ID2 = reshape(MEP_95CIThres,[nReps,nConds,nSubjs]);
MEP_95CIThres_low = logical(MEP_95CIThres_ID2 == 1);
MEP_95CIThres_high = logical(MEP_95CIThres_ID2 == 2);

MEPthresP_ID2 = reshape(MEPthresP,[nReps,nConds,nSubjs]);
MEPthresP_low = logical(MEPthresP_ID2 == 1);
MEPthresP_high = logical(MEPthresP_ID2 == 2);


allSubjData_norm_cropS = allSubjData_norm_crop(:,:,:,1:nSubjs);

allSubjData_norm_cropS_low = allSubjData_norm_cropS;
allSubjData_norm_cropS_high = allSubjData_norm_cropS;

allSubjData_norm_cropS_high_1X = allSubjData_norm_cropS_high;
allSubjData_norm_cropS_low_1X = allSubjData_norm_cropS_low;

allSubjData_norm_cropS_high_2X = allSubjData_norm_cropS_high;
allSubjData_norm_cropS_low_2X = allSubjData_norm_cropS_low;

allSubjData_norm_cropS_high_200 = allSubjData_norm_cropS_high;
allSubjData_norm_cropS_low_200 = allSubjData_norm_cropS_low;

allSubjData_norm_cropS_high_95CI = allSubjData_norm_cropS_high;
allSubjData_norm_cropS_low_95CI = allSubjData_norm_cropS_low;

% allSubjData_norm_cropS_low_Median = allSubjData_norm_cropS_low;
% allSubjData_norm_cropS_low_200 = allSubjData_norm_cropS_low;

for i = 3:6
    for s = 1:nSubjs
    % allSubjData_norm_cropS_low_3X(MEPthres_3X_high(:,i,s),:,i,s) = nan;
    % allSubjData_norm_cropS_high_3X(MEPthres_3X_low(:,i,s),:,i,s) = nan;

    allSubjData_norm_cropS_low_2X(MEPthres_2X_high(:,i,s),:,i,s) = nan;
    allSubjData_norm_cropS_high_2X(MEPthres_2X_low(:,i,s),:,i,s) = nan;

    allSubjData_norm_cropS_low_1X(MEPthres_1X_high(:,i,s),:,i,s) = nan;
    % allSubjData_norm_cropS_high_1X(MEPthres_1X_low(:,i,s),:,i,s) = nan;

    % allSubjData_norm_cropS_low_200(MEP_200Thres_high(:,i,s),:,i,s) = nan;
    % allSubjData_norm_cropS_high_200(MEP_200Thres_low(:,i,s),:,i,s) = nan;

    allSubjData_norm_cropS_low_95CI(MEP_95CIThres_high(:,i,s),:,i,s) = nan;
    allSubjData_norm_cropS_high_95CI(MEP_95CIThres_low(:,i,s),:,i,s) = nan;
    
    end
end
 

%%

checkLowNan = squeeze(mean(isnan(allSubjData_norm_cropS_low_1X),2));
checkHighNan = squeeze(mean(isnan(allSubjData_norm_cropS_high_1X),2));

checkLowNan1 = squeeze(sum(checkLowNan));
checkHighNan1 = squeeze(sum(checkHighNan));

checkHighIndex1 = find(checkHighNan1(6,:));
checkHighIndex2 = find(checkHighNan1(5,:));

removeIDlow = unique([checkHighIndex1 checkHighIndex2]);

totalLowNan = sum(checkLowNan1);
totalHighNan = sum(checkHighNan1);

removeIDs = find(totalLowNan>70)

% removeIDs = [1 2 4 5 7]; % 3 6 8 9


%%
% Remove subjects with all TMS trials removed
% 1X SD
% removeIDs = [11 12 14 22 23];
% allSubjData_norm_cropS_low_1X(:,:,:,removeIDs) = nan;
% allSubjData_norm_cropS_high_1X(:,:,:,removeIDs) = nan;

% allSubjData_norm_cropS_low_95CI(:,:,:,removeIDs) = nan;
% allSubjData_norm_cropS_high_95CI(:,:,:,removeIDs) = nan;

allSubjData_norm_cropS_low_1X(:,:,:,[removeIDs]) = nan;
allSubjData_norm_cropS_low_1X(:,:,5:6,:) = nan;

% allSubjData_norm_cropS_high_1X(:,:,:,:) = nan;
% allSubjData_norm_cropS_high_1X(:,:,3:4,:) = nan;

% allSubjData_norm_cropS_high_1X(:,:,:,removeIDs) = nan;

% Remove subject IDs if needed
% removeIDs = [2 4 6 12];
% allSubjData_norm_cropS_low(:,:,:,removeIDs) = [nan];
% allSubjData_norm_cropS_high(:,:,:,removeIDs) = [nan];


%% EMG timeseries processing

% taking the median EMG data within subject over all repetitions
allSubjAvg_norm = squeeze(nanmedian(allSubjData_norm_cropS,1));

allSubjAvg_norm_low = squeeze(nanmedian(allSubjData_norm_cropS_low,1));
allSubjAvg_norm_high= squeeze(nanmedian(allSubjData_norm_cropS_high,1));

allSubjAvg_norm_low_1X = squeeze(nanmedian(allSubjData_norm_cropS_low_1X,1));
allSubjAvg_norm_high_1X = squeeze(nanmedian(allSubjData_norm_cropS_high_1X,1));

allSubjAvg_norm_low_2X = squeeze(nanmedian(allSubjData_norm_cropS_low_2X,1));
allSubjAvg_norm_high_2X = squeeze(nanmedian(allSubjData_norm_cropS_high_2X,1));

allSubjAvg_norm_low_200 = squeeze(nanmedian(allSubjData_norm_cropS_low_200,1));
allSubjAvg_norm_high_200 = squeeze(nanmedian(allSubjData_norm_cropS_high_200,1));

allSubjAvg_norm_low_95CI = squeeze(nanmedian(allSubjData_norm_cropS_low_95CI,1));
allSubjAvg_norm_high_95CI = squeeze(nanmedian(allSubjData_norm_cropS_high_95CI,1));



% taking the mean over all subjects
allEMGAVG_norm = squeeze(nanmean(allSubjAvg_norm,3));

allEMGAVG_norm_low = squeeze(nanmean(allSubjAvg_norm_low,3));
allEMGAVG_norm_high = squeeze(nanmean(allSubjAvg_norm_high,3));

allEMGAVG_norm_low_1X = squeeze(nanmean(allSubjAvg_norm_low_1X,3));
allEMGAVG_norm_high_1X = squeeze(nanmean(allSubjAvg_norm_high_1X,3));

allEMGAVG_norm_low_2X = squeeze(nanmean(allSubjAvg_norm_low_2X,3));
allEMGAVG_norm_high_2X = squeeze(nanmean(allSubjAvg_norm_high_2X,3));

allEMGAVG_norm_low_200 = squeeze(nanmean(allSubjAvg_norm_low_200,3));
allEMGAVG_norm_high_200 = squeeze(nanmean(allSubjAvg_norm_high_200,3));

allEMGAVG_norm_low_95CI  = squeeze(nanmean(allSubjAvg_norm_low_95CI,3));
allEMGAVG_norm_high_95CI  = squeeze(nanmean(allSubjAvg_norm_high_95CI,3));


LLRaPeriod = [1250:1500];

postMEPPeriod = [900:1100]; % -20 to +20 ms % from 30 ms post TMS to 70 ms post TMS at SLR onset

% Compute LLR amplitude on the group level for each repetition and subject
size(allSubjData_norm_crop)
% for each trial
AllSubjLLRa = squeeze(nanmean(allSubjData_norm_crop(:,LLRaPeriod,:,1:nSubjs),2));
AllSubjLLRa_JMP_Vector = AllSubjLLRa(:);

% LLRa vector normed by PTB
AllSubjLLRa_PTB = squeeze(nanmean(allSubjData_ptbnorm_TMSExp4(:,LLRaPeriod,:,1:nSubjs),2));
AllSubjLLRa_PTB_JMP_Vector = AllSubjLLRa_PTB(:);

AllSubjCondLLRaExp4 = squeeze(nanmean(AllSubjLLRa,1));

% T3ReductionExp4 = (AllSubjCondLLRaExp4(4,:) - AllSubjCondLLRaExp4(2,:)) ./ ...
%     (AllSubjCondLLRaExp4(2,:) - AllSubjCondLLRaExp4(1,:)) .* 100;

AllSubjLLRa_JMP = repelem(squeeze(nanmean(nanmean(AllSubjLLRa,1),2)),120);
size(AllSubjLLRa_JMP)

MEPpeak_JMP_norm = MEPpeak_JMP./AllSubjLLRa_JMP;



% LLR amplitude mean for each trial
allSubjLLRa_norm = squeeze(nanmean(allSubjData_norm_cropS(:,LLRaPeriod,:,:),2));
allSubjLLRa_norm_low = squeeze(nanmean(allSubjData_norm_cropS_low(:,LLRaPeriod,:,:),2));
allSubjLLRa_norm_high = squeeze(nanmean(allSubjData_norm_cropS_high(:,LLRaPeriod,:,:),2));

allSubjLLRa_low_1X = squeeze(nanmean(allSubjData_norm_cropS_low_1X(:,LLRaPeriod,:,:),2));
allSubjLLRa_high_1X = squeeze(nanmean(allSubjData_norm_cropS_high_1X(:,LLRaPeriod,:,:),2));

allSubjLLRa_low_2X = squeeze(nanmean(allSubjData_norm_cropS_low_2X(:,LLRaPeriod,:,:),2));
allSubjLLRa_high_2X = squeeze(nanmean(allSubjData_norm_cropS_high_2X(:,LLRaPeriod,:,:),2));

allSubjLLRa_low_200 = squeeze(nanmean(allSubjData_norm_cropS_low_200(:,LLRaPeriod,:,:),2));
allSubjLLRa_high_200 = squeeze(nanmean(allSubjData_norm_cropS_high_200(:,LLRaPeriod,:,:),2));

allSubjLLRa_low_95CI = squeeze(nanmean(allSubjData_norm_cropS_low_95CI(:,LLRaPeriod,:,:),2));
allSubjLLRa_high_95CI = squeeze(nanmean(allSubjData_norm_cropS_high_95CI(:,LLRaPeriod,:,:),2));


allSubjPostMEPa_low_2X = squeeze(nanmean(allSubjData_norm_cropS_low_2X(:,postMEPPeriod,:,:),2));
allSubjPostMEPa_high_2X = squeeze(nanmean(allSubjData_norm_cropS_high_2X(:,postMEPPeriod,:,:),2));

allSubjPostMEPa_low_1X = squeeze(nanmean(allSubjData_norm_cropS_low_1X(:,postMEPPeriod,:,:),2));
allSubjPostMEPa_high_1X = squeeze(nanmean(allSubjData_norm_cropS_high_1X(:,postMEPPeriod,:,:),2));




%% Saving and load processed EMG data

% save('SavedEMGData\FinalEMGData_TMSExp4.mat')


%%

