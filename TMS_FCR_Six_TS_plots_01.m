%% Processing the EMG data for the TMS experiment 4 study

close all
clear all
clc

%%
% add processing scripts folder paths as variables and load in the data files
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];

% Folder and subfolders that contain the scripts required to process the EMG data
processingScriptsPath = [processingPath '\BV_Processing_Scripts']; %<- change this if your scripts are stored somewhere else
addpath(genpath(processingScriptsPath));

EMGScriptsPath = [processingPath '\emg-processing']; %<- change this if your scripts are stored somewhere else
addpath(genpath(EMGScriptsPath));

plottingPath = [processingPath '\PlottingScripts']; %<- change this if your scripts are stored somewhere else
addpath(genpath(plottingPath));

%%

% this line sets the folder location for where the .png figures are going
% to be saved for that specific subject
Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];

subjID = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]; % subject ID list
T1List = [24, 21, 24, 22, 20, 21, 26, 20, 21, 26, 20, 20]; % MEP latency for each subject

%%

% load in the raw EMG for all subjects
load('SavedEMGData\EMGData_TMSExp4_3.mat') % load in the unprocessed EMG data for all subjects
load('SavedEMGData\EMGData_TMSExp4_2.mat') 

load('SavedEMGData\EMGData_TMSExp4.mat') 

% load in the event times for all subjects
% which("SavedEMGData\AllSubjEventTimesTMSExp4.mat")

load("SavedEMGData\AllSubjEventTimesTMSExp4.mat","AllSubjEventTimesTMSExp4");

% load in the processed emg(raw, nonnorm, norm, ptbnorm) for all previously processed subjects
load('SavedEMGData\allSubjData_norm_TMSExp4.mat') 


%%

% clc

for s = [5] % subject to process
s

close all

clear ECU ECUall ecufilt ECUMatrix FCR FCRall fcrfilt...
    FCRMatrix FCRMatrixN FCRMatrixP FCRMatrixTMS FCRMatrix3 FCRMatrixTMS_Supra FCRMatrix3_Supra...
    
sub_num = subjID(s);
sub_num;

% define the event times for each condition based on the saved event time
% matrix from the previous processing (3D matrix)
NoPTBorTMSFl = AllSubjEventTimesTMSExp4(:,1,s);
PTBnoTMSFl = AllSubjEventTimesTMSExp4(:,2,s);
NoPTBwTMSFl_Sub = AllSubjEventTimesTMSExp4(:,3,s);
PTBTMSFl_Sub = AllSubjEventTimesTMSExp4(:,4,s);
NoPTBwTMSFl_Supra = AllSubjEventTimesTMSExp4(:,5,s);
PTBTMSFl_Supra = AllSubjEventTimesTMSExp4(:,6,s);

t1 = T1List(s);
t2 = t1 + 20;
t3 = t1 + 50;

% define the raw EMG data based on the saved raw EMG data from the subject
% that is being processed
if s < 6
DATAraw = EMGData_TMSExp4(s).DATAraw;
elseif s < 12
DATAraw = EMGData_TMSExp4_2(s).DATAraw;
elseif s==12
DATAraw = EMGData_TMSExp4_3(s).DATAraw;
end

FCR = (DATAraw(1,:));
% ECU = (DATAraw(2,:)); % not processing the ECU so we can comment this
% line out
EMG = [FCR];

% first step in the EMG processing is to apply a 60 Hz notch filter to the
% raw FCR EMG. This step removes ambient or electrical noise that is in the
% environment which is known to oscillate at 60 Hz. 

Fs = 5000; % sampling rate, samples per second

%
% R2 - filtering technique
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',57,'HalfPowerFrequency2',63, ...
               'DesignMethod','butter','SampleRate',Fs);

% R1 filtering technique
f0 = 60;  % Notch frequency
% Normalize the frequencies
wo = f0 / (Fs / 2); % Notch frequency in radians per sample
q = 30;
bw = wo / q;     % Bandwidth (Q factor of 35)
% Design the filter
[b, a] = iirnotch(wo, bw);
%

FCRnotchf = filtfilt(d,FCR); % dual pass notch filter
% FCRnotchf = filtfilt(b,a,FCR); % dual pass notch filter
% FCRnotchf = filtfilt(d,FCR);
% ECUnotchf = filtfilt(d,ECU);

% next is a sequence of steps that fully filters the EMG. 1) the EMG
% signal is demeaned by removing the mean of the signal from the EMG. 2) a
% bandpass filter is create from 20 Hz - 500 Hz and applied to the demeaned
% EMG data. 3) The EMG signal is then rectified by taking the absolute
% value of the filtered EMG. 4) Finally a 60 Hz low-pass envelope filter is
% applied to the EMG data to smooth the data and give the fully filtered
% EMG. The fully filtered EMG is called fcrfilt and is the non-segmented processed EMG.
% 
% It may be beneficially to save this EMG data at this point so there is
% the raw EMG, the filtered EMG, and the event times for each condition for
% each subject. 
% 
% The remainder of this code segments the data in set
% intervals, normalizes it by the average background EMG and plots it for
% a single subject. 

%Band-pass filter
Order = 4;
fLP = 500; % low pass filter (Hz)
fHP = 20; % high pass filter (Hz)
% fENV = 60; % envelope
Fs = 5000; % sampling rate, samples per second
 
fcrfilt = EMGProcessing_noSmooth(FCRnotchf, Order, fLP, fHP, Fs); % filtered FCR
% ecufilt = EMGProcessing(ECUnotchf, Order, fLP, fHP, fENV, Fs); % filtered ECU  

% NO TMS NO PTB
 for j=1:length(NoPTBorTMSFl) % 25 trials per condition
   
        FCRall = fcrfilt; % filtered FCR
        % ECUall = ecufilt; % filtered ECU
        
        IstartN = round((NoPTBorTMSFl(j)-0.200)*Fs); % time 200 ms before target met
        IendN = round(IstartN + 0.450*Fs); % 450 ms after IstartN
        
        FCRMatrixN(j,:) = FCRall(IstartN:IendN); % FCR data
        % ECUMatrixN(j,:) = ECUall(IstartN:IendN); % ECU data
        FCRMatrixNRaw(j,:) = FCR(IstartN:IendN); % raw FCR EMG data
        
        avg_FCR_btN(j,:) = mean(FCRall((IstartN+(0.075*Fs)):(IstartN+(0.125*Fs)))); % average FCR 50 ms of background torque for each rep
 end

clear FCRall ECUall IstartN IendN ECUMatrixN


% PTB NO TMS
for j=1:length(PTBnoTMSFl)
   
        FCRall = fcrfilt;
        % ECUall = ecufilt;
        
        IstartP = round((PTBnoTMSFl(j)-0.200)*Fs); % 200 ms before time ptb onset
        IendP = round(IstartP + 0.450*Fs); % 450 ms after IstartP
        
        FCRMatrixP(j,:) = FCRall(1,IstartP:IendP);
        % ECUMatrixP(j,:) = ECUall(1,IstartP:IendP);
        FCRMatrixPRaw(j,:) = FCR(1,IstartP:IendP);
       
        avg_FCR_btP(j,:) = mean(FCRall((IstartP+(0.075*Fs)):(IstartP+(0.125*Fs)))); % average FCR 50 ms of background torque
        
        avg_FCR_ptbP(j,:) = mean(FCRall((IstartP+(0.250*Fs)):(IstartP+(0.300*Fs)))); % average FCR 50 ms of background torque

end

clear FCRall ECUall IstartP IendP ECUMatrixP


% No PTB w TMS (TMS Only)
count = 0;
for j=1:length(NoPTBwTMSFl_Sub)
   
        FCRall = fcrfilt;
        % ECUall = ecufilt;
        
        IstartTMS = round((NoPTBwTMSFl_Sub(j)-0.200)*Fs); % 100 ms before ptb
        IendTMS = round(IstartTMS + .450*Fs); % 250 ms after Istart1
        
        FCRMatrixTMS(j,:) = FCRall(IstartTMS:IendTMS);
        % ECUMatrixTMS(j,:) = ECUall(IstartTMS:IendTMS);
        FCRMatrixTMSRaw(j,:) = FCR(IstartTMS:IendTMS);
        
        avg_FCR_btTMS(j,:) = mean(FCRall((IstartTMS+(0.075*Fs)):(IstartTMS+(0.125*Fs)))); % average FCR 50 ms of background torque (100-50 ms before ptb onset)
end

clear FCRall ECUall IstartTMS IendTMS ECUMatrixTMS


% No PTB w TMS (TMS Only)
count = 0;
for j=1:length(NoPTBwTMSFl_Supra)
   
        FCRall = fcrfilt;
        % ECUall = ecufilt;
        
        IstartTMS = round((NoPTBwTMSFl_Supra(j)-0.200)*Fs); % 100 ms before ptb
        IendTMS = round(IstartTMS + .450*Fs); % 250 ms after Istart1
        
        FCRMatrixTMS_Supra(j,:) = FCRall(IstartTMS:IendTMS);
        % ECUMatrixTMS(j,:) = ECUall(IstartTMS:IendTMS);
        FCRMatrixTMSRaw_Supra(j,:) = FCR(IstartTMS:IendTMS);
        
        avg_FCR_btTMS_Supra(j,:) = mean(FCRall((IstartTMS+(0.075*Fs)):(IstartTMS+(0.125*Fs)))); % average FCR 50 ms of background torque (100-50 ms before ptb onset)
end

clear FCRall ECUall IstartTMS IendTMS ECUMatrixTMS



% PTB & TMS T3 subthreshold
count = 0;
for j=1:length(PTBTMSFl_Sub)
   
        FCRall = fcrfilt;
        % ECUall = ecufilt;
        
        Istart3 = round((PTBTMSFl_Sub(j)-0.200)*Fs); % 100 ms before ptb
        Iend3 = round(Istart3 + .450*Fs); % 250 ms after Istart3
        
        FCRMatrix3(j,:) = FCRall(Istart3:Iend3);
        % ECUMatrix3(j,:) = ECUall(Istart3:Iend3);
        FCRMatrix3Raw(j,:) = FCR(Istart3:Iend3);
        
        avg_FCR_bt3(j,:) = mean(FCRall((Istart3+(0.075*Fs)):(Istart3+(0.125*Fs)))); % average FCR 50 ms of background torque

clear FCRall ECUall Istart3 Iend3 ECUMatrix3

end


% PTB & TMS T3
count = 0;
for j=1:length(PTBTMSFl_Supra)
   
        FCRall = fcrfilt;
        % ECUall = ecufilt;
        
        Istart3 = round((PTBTMSFl_Supra(j)-0.200)*Fs); % 100 ms before ptb
        Iend3 = round(Istart3 + .450*Fs); % 250 ms after Istart3
        
        FCRMatrix3_Supra(j,:) = FCRall(Istart3:Iend3);
        % ECUMatrix3(j,:) = ECUall(Istart3:Iend3);
        FCRMatrix3Raw_Supra(j,:) = FCR(Istart3:Iend3);
        
        avg_FCR_bt3_Supra(j,:) = mean(FCRall((Istart3+(0.075*Fs)):(Istart3+(0.125*Fs)))); % average FCR 50 ms of background torque

clear FCRall ECUall Istart3 Iend3 ECUMatrix3

end

% Normalization
% the background EMG data that is collected for each trial (100) is then
% averaged within trial and then averaged again across trial to produce one
% number for that subject. The average background activation across all
% trials
totalBackgroundAct = [avg_FCR_btN(:);avg_FCR_btP(:); ...
    avg_FCR_btTMS(:);avg_FCR_bt3(:);avg_FCR_btTMS_Supra(:);avg_FCR_bt3_Supra(:)];

AVGbackgroundAct = mean(totalBackgroundAct);

AVGptbAct = mean(avg_FCR_ptbP); % average peak during the perturbation only condition


% normalized filtered FCR data by background activity
FCRMatrix_normN(:,:) = (FCRMatrixN(:,:)) ./ AVGbackgroundAct; %FCR EMG for trial divided by mean background activity for all trials
FCRMatrix_normP(:,:)= (FCRMatrixP(:,:)) ./ AVGbackgroundAct;

FCRMatrix_normTMS(:,:) = (FCRMatrixTMS(:,:)) ./ AVGbackgroundAct;
FCRMatrix_norm3(:,:) = (FCRMatrix3(:,:)) ./ AVGbackgroundAct; % normalized FCR for all time

FCRMatrix_normTMS_Supra(:,:) = (FCRMatrixTMS_Supra(:,:)) ./ AVGbackgroundAct;
FCRMatrix_norm3_Supra(:,:) = (FCRMatrix3_Supra(:,:)) ./ AVGbackgroundAct; % normalized FCR for all time


% normalized filtered FCR data by perturbation activity (max-min
% normalization)
FCRMatrix_normptbN(:,:) = (FCRMatrixN(:,:) - AVGbackgroundAct) ./ (AVGptbAct - AVGbackgroundAct); %FCR EMG for trial divided by mean background activity for all trials
FCRMatrix_normptbP(:,:)= (FCRMatrixP(:,:) - AVGbackgroundAct) ./ (AVGptbAct - AVGbackgroundAct);

FCRMatrix_normptbTMS(:,:) = (FCRMatrixTMS(:,:) - AVGbackgroundAct) ./ (AVGptbAct - AVGbackgroundAct);
FCRMatrix_normptb3(:,:) = (FCRMatrix3(:,:) - AVGbackgroundAct) ./ (AVGptbAct - AVGbackgroundAct); % normalized FCR for all time

FCRMatrix_normptbTMS_Supra(:,:) = (FCRMatrixTMS_Supra(:,:) - AVGbackgroundAct) ./ (AVGptbAct - AVGbackgroundAct);
FCRMatrix_normptb3_Supra(:,:) = (FCRMatrix3_Supra(:,:) - AVGbackgroundAct) ./ (AVGptbAct - AVGbackgroundAct); % normalized FCR for all time


LLRperiod = [1250:1500];
% The LLR period is 50 - 100 ms following perturbation onset. In our EMG
% index that is 1250 to 1500. 1 ms = 5 indexes. We start 200 ms before the
% perturbation starts and go 250 ms after perturbation starts
LLRa(:,1) = mean(FCRMatrix_normN(:,LLRperiod),2);
LLRa(:,2) = mean(FCRMatrix_normP(:,LLRperiod),2);
LLRa(:,3) = mean(FCRMatrix_normTMS(:,LLRperiod),2);
LLRa(:,4) = mean(FCRMatrix_norm3(:,LLRperiod),2);
LLRa(:,5) = mean(FCRMatrix_normTMS_Supra(:,LLRperiod),2);
LLRa(:,6) = mean(FCRMatrix_norm3_Supra(:,LLRperiod),2);

LLRaPertNorm(:,1) = mean(FCRMatrix_normptbN(:,LLRperiod),2);
LLRaPertNorm(:,2) = mean(FCRMatrix_normptbP(:,LLRperiod),2);
LLRaPertNorm(:,3) = mean(FCRMatrix_normptbTMS(:,LLRperiod),2);
LLRaPertNorm(:,4) = mean(FCRMatrix_normptb3(:,LLRperiod),2);
LLRaPertNorm(:,5) = mean(FCRMatrix_normptbTMS_Supra(:,LLRperiod),2);
LLRaPertNorm(:,6) = mean(FCRMatrix_normptb3_Supra(:,LLRperiod),2);

SLRperiod = [1100:1250];

% The SLR period 20 - 50 ms following perturbation onset. In our EMG index
% that is 1100 - 1250
SLRa(:,1) = mean(FCRMatrix_normN(:,SLRperiod),2);
SLRa(:,2) = mean(FCRMatrix_normP(:,SLRperiod),2);
SLRa(:,3) = mean(FCRMatrix_normTMS(:,SLRperiod),2);
SLRa(:,4) = mean(FCRMatrix_norm3(:,SLRperiod),2);
SLRa(:,5) = mean(FCRMatrix_normTMS_Supra(:,SLRperiod),2);
SLRa(:,6) = mean(FCRMatrix_norm3_Supra(:,SLRperiod),2);


load('Exp4_ReflexAvg.mat','ReflexAverages')

ReflexAverages(:,:,:,s) = cat(3,LLRa,LLRaPertNorm,SLRa);

save('Exp4_ReflexAvg.mat','ReflexAverages')


% load('Exp4_Subj_RawTimeSeries.mat','allSubjData_Saved_FullTimeSeries')
% allSubjData_Saved_FullTimeSeries(s) = struct('FCR',FCR,'FCRnotchf',FCRnotchf,'FCRfilt',fcrfilt);
if s == 12
% save('Exp4_Subj_RawTimeSeries.mat','allSubjData_Saved_FullTimeSeries')
end


% Save the FCRtot for the subject ID if analyzing a new subject
% saves the raw segmented EMG data, filtered segmented EMG data, and
% normalized and filtered segmented EMG data
allSubjData = cat(3,FCRMatrix_normN,FCRMatrix_normP,FCRMatrix_normTMS,FCRMatrix_norm3,...
    FCRMatrix_normTMS_Supra, FCRMatrix_norm3_Supra);
allSubjData_norm_TMSExp4(:,:,:,s) = allSubjData;

allSubjDataptbNorm = cat(3,FCRMatrix_normptbN,FCRMatrix_normptbP,FCRMatrix_normptbTMS,FCRMatrix_normptb3,...
    FCRMatrix_normptbTMS_Supra, FCRMatrix_normptb3_Supra);
allSubjData_ptbnorm_TMSExp4(:,:,:,s) = allSubjDataptbNorm;

allSubjData_nonNorm=cat(3,FCRMatrixN,FCRMatrixP,FCRMatrixTMS,FCRMatrix3,...
    FCRMatrixTMS_Supra,FCRMatrix3_Supra);
allSubjData_nonnorm_TMSExp4(:,:,:,s) = allSubjData_nonNorm;

allSubjData_nonNormRaw=cat(3,FCRMatrixNRaw,FCRMatrixPRaw,FCRMatrixTMSRaw,FCRMatrix3Raw,...
    FCRMatrixTMSRaw_Supra,FCRMatrix3Raw_Supra);
allSubjData_nonnormRaw_TMSExp4(:,:,:,s) = allSubjData_nonNormRaw;

% if s == 1
save('SavedEMGData\allSubjData_norm_TMSExp4.mat', 'allSubjData_norm_TMSExp4',...
    'allSubjData_nonnorm_TMSExp4','allSubjData_nonnormRaw_TMSExp4','allSubjData_ptbnorm_TMSExp4')
% % end


size(allSubjData_norm_TMSExp4);
size(allSubjData_nonnorm_TMSExp4);
size(allSubjData_nonnormRaw_TMSExp4);


% Mean Calculations for each condition, used for plotting the means
FCRMatrix_normN_Mean_Matrix(1,:) = zeros(1,max(size(FCRMatrixN)));
FCRMatrix_normN_Mean_Matrix(1,:) = mean(FCRMatrix_normN);

FCRMatrix_normP_Mean_Matrix(1,:) = zeros(1,max(size(FCRMatrixP)));
FCRMatrix_normP_Mean_Matrix(1,:) = mean(FCRMatrix_normP);

FCRMatrix_normTMS_Mean_Matrix(1,:) = zeros(1,max(size(FCRMatrixTMS)));
FCRMatrix_normTMS_Mean_Matrix(1,:) = mean(FCRMatrix_normTMS);

FCRMatrix_norm3_Mean_Matrix(1,:) = zeros(1,max(size(FCRMatrix3)));
FCRMatrix_norm3_Mean_Matrix(1,:) = mean(FCRMatrix_norm3);

FCRMatrix_normTMS_Supra_Mean_Matrix(1,:) = zeros(1,max(size(FCRMatrixTMS_Supra)));
FCRMatrix_normTMS_Supra_Mean_Matrix(1,:) = mean(FCRMatrix_normTMS_Supra);

FCRMatrix_norm3_Supra_Mean_Matrix(1,:) = zeros(1,max(size(FCRMatrix3_Supra)));
FCRMatrix_norm3_Supra_Mean_Matrix(1,:) = mean(FCRMatrix_norm3_Supra);



% Mean Calculations for each condition, used for plotting the means
FCRMatrix_normN_Mean_ptbMatrix(1,:) = zeros(1,max(size(FCRMatrixN)));
FCRMatrix_normN_Mean_ptbMatrix(1,:) = mean(FCRMatrix_normptbN);

FCRMatrix_normP_Mean_ptbMatrix(1,:) = zeros(1,max(size(FCRMatrixP)));
FCRMatrix_normP_Mean_ptbMatrix(1,:) = mean(FCRMatrix_normptbP);

FCRMatrix_normTMS_Mean_ptbMatrix(1,:) = zeros(1,max(size(FCRMatrixTMS)));
FCRMatrix_normTMS_Mean_ptbMatrix(1,:) = mean(FCRMatrix_normptbTMS);

FCRMatrix_norm3_Mean_ptbMatrix(1,:) = zeros(1,max(size(FCRMatrix3)));
FCRMatrix_norm3_Mean_ptbMatrix(1,:) = mean(FCRMatrix_normptb3);

FCRMatrix_normTMS_Supra_Mean_ptbMatrix(1,:) = zeros(1,max(size(FCRMatrixTMS_Supra)));
FCRMatrix_normTMS_Supra_Mean_ptbMatrix(1,:) = mean(FCRMatrix_normptbTMS_Supra);

FCRMatrix_norm3_Supra_Mean_ptbMatrix(1,:) = zeros(1,max(size(FCRMatrix3_Supra)));
FCRMatrix_norm3_Supra_Mean_ptbMatrix(1,:) = mean(FCRMatrix_normptb3_Supra);


targetMetIndex = 500;


% % MEP Counts
% M1 = max(abs(FCRMatrixTMS(:,targetMetIndex-(t3/1000*Fs):targetMetIndex-(t3/1000*Fs)+targetMetIndex/2)),[],2)>200;%counts MEPs 0-50ms after T1
% count = sum(M1);
% FCR_MEP_Count1 = count;
% 
% 
% M3 = max(abs(FCRMatrix3(:,targetMetIndex-(t3/1000*Fs):targetMetIndex-(t3/1000*Fs)+targetMetIndex/2)),[],2)>200;%counts MEPs 0-50ms after T3
% count = sum(M3);
% FCR_MEP_Count3 = count;



end



%% PLOTS



%% Raw EMG Plots
% upperlim=round(max([max(max(NoTMSorPTB_MatrixRaw)),max(max(PTBnoTMS_MatrixRaw)),max(max(Delay1_MatrixRaw)),max(max(Delay2_MatrixRaw)),max(max(Delay3_MatrixRaw))]),-1)+10;
% lowerlim=round(min([min(min(NoTMSorPTB_MatrixRaw)),min(min(PTBnoTMS_MatrixRaw)),min(min(Delay1_MatrixRaw)),min(min(Delay2_MatrixRaw)),min(min(Delay3_MatrixRaw))]),-1)-10;
% 
% figure;
% 
% subplot (4,2,1); 
% plot ([0:0.0002:0.25]*1000, NoTMSorPTB_MatrixRaw(:,:));
% xlabel ('Time [ms]');
% ylabel ('FCR EMG [uV]');
% title (['PTBOff-TMSOff']);
% xline (100, '--g', 'Target Met');
% ylim([lowerlim upperlim]);
% xticks(sort([0:50:250]));
% xticklabels(sort([-100 -50 0 50 100 150]));
% 
% hold on;
% 
% subplot (4,2,2); 
% patch ([150 200 200 150], [upperlim upperlim, lowerlim lowerlim], [0.9 0.9 0.9]);
% text (170, (upperlim-5), 'LLR');
% hold on;
% subplot (4,2,2); 
% plot ([0:0.0002:0.25]*1000, PTBnoTMS_MatrixRaw(:,:));
% xlabel ('Time [ms]');
% ylabel ('FCR EMG [uV]');
% yline (200, '--m', '+200');
% yline (-200, '--m', '-200');
% xline (100, '--m', 'PTB');
% title (['PTBOn-TMSOff']);
% ylim([lowerlim upperlim]);
% xticks(sort([0:50:250]));
% xticklabels(sort([-100 -50 0 50 100 150]));
% 
% hold on;
% 
% subplot (4,2,4); 
% patch ([150 200 200 150], [upperlim upperlim, lowerlim lowerlim], [0.9 0.9 0.9]);
% text (170, (upperlim-5), 'LLR');
% text ((98-t1), lowerlim+3, '\uparrow TMS', 'FontSize',14); 
% hold on;
% subplot (4,2,4);
% plot ([0:0.0002:0.25]*1000, Delay1_MatrixRaw(:,:));
% xlabel ('Time [ms]');
% ylabel ('FCR EMG [uV]');
% yline (200, '--m', '+200');
% yline (-200, '--m', '-200');
% xline (100, '--m', 'PTB');
% title (['PTBOn-TMSOn-' num2str(t1) 'ms']);
% ylim([lowerlim upperlim]);
% xticks(sort([0:50:250]));
% xticklabels(sort([-100 -50 0 50 100 150]));
% hold on
% 
% subplot (4,2,6); 
% patch ([150 200 200 150], [upperlim upperlim, lowerlim lowerlim], [0.9 0.9 0.9]);
% text (170, (upperlim-5), 'LLR');
% text ((98-t1-20), lowerlim+3, '\uparrow TMS', 'FontSize',14); 
% hold on;
% subplot (4,2,6); 
% plot ([0:0.0002:0.25]*1000, Delay2_MatrixRaw(:,:));
% xlabel ('Time [ms]');
% ylabel ('FCR EMG [uV]');
% yline (200, '--m', '+200');
% yline (-200, '--m', '-200');
% xline (100, '--m', 'PTB');
% title (['PTBOn-TMSOn-' num2str(t1+20) 'ms']);
% ylim([lowerlim upperlim]);
% xticks(sort([0:50:250]));
% xticklabels(sort([-100 -50 0 50 100 150]));
% hold on
% 
% subplot (4,2,8); 
% patch ([150 200 200 150], [upperlim upperlim, lowerlim lowerlim], [0.9 0.9 0.9]);
% text (170, (upperlim-5), 'LLR');
% text ((98-t1-50), lowerlim+3, '\uparrow TMS', 'FontSize',14); 
% hold on;
% subplot (4,2,8);
% plot ([0:0.0002:0.25]*1000, Delay3_MatrixRaw(:,:));
% xlabel ('Time [ms]');
% ylabel ('FCR EMG [uV]');
% yline (200, '--m', '+200');
% yline (-200, '--m', '-200');
% xline (100, '--m', 'PTB');
% title (['PTBOn-TMSOn-' num2str(t1+50) 'ms']);
% ylim([lowerlim upperlim]);
% xticks(sort([0:50:250]));
% xticklabels(sort([-100 -50 0 50 100 150]));




%% Normalized EMG Plots
% Normalized EMG Plots

upperlim=round(max([max(max(FCRMatrix_normN)),max(max(FCRMatrix_normP)),max(max(FCRMatrix_normTMS)),...
    max(max(FCRMatrix_norm3)),max(max(FCRMatrix_normTMS_Supra)),max(max(FCRMatrix_norm3_Supra))]),-1);

lowerlim=round(min([min(min(FCRMatrix_normN)),min(min(FCRMatrix_normP)),min(min(FCRMatrix_normTMS)),...
    min(min(FCRMatrix_norm3)),min(min(FCRMatrix_normTMS_Supra)),min(min(FCRMatrix_norm3_Supra))]),-1)-2;

upperlim = [15];

colTime = 0.450;

close all
figure('units', 'pixels', 'Position', [300 80 1000 700])
subplot = @(m,n,p) subtightplot(m,n,p,[0.13 0.09], [0.12 0.11], [0.08 0.05]);

backGroundPos = [75 125 125 75];
LLRPos = [250 300 300 250];
pertOnsetPos = 200;
yLabel = 'EMG [nu]';
xLabel = 'Time [ms]';
LLRpos = upperlim-2;

plotCol = [linspace(0.7,1,25)',linspace(0.7,0.2,25)',linspace(0.7,0.2,25)'];
plotCol= jet(20);

subplot (3,2,1); 
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
text (75, (LLRpos), {'BKG'},'FontSize',15);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normN(:,:));
xlabel (xLabel);
ylabel (yLabel);
set(gca,'ColorOrder',plotCol)
title (['Back']);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xticks(sort([0:100:colTime*1000]));
xticklabels('');
xlim([0 450])
hold on;
box on
ax = gca; 
ax.FontSize = 18; 


subplot (3,2,2); 
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
text (75, (LLRpos), {'BKG'},'FontSize',15);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normP(:,:));
xlabel (xLabel);
ylabel (yLabel);
set(gca,'ColorOrder',plotCol)
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
title (['Pert']);
ylim([lowerlim upperlim]);
xlim([0 450]);
xticks(sort([0:100:colTime*1000]));
xticklabels('');
hold on;
box on
ax = gca; 
ax.FontSize = 18; 


subplot (3,2,3); 
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normTMS(:,:));
xlabel (xLabel);
ylabel (yLabel);
set(gca,'ColorOrder',plotCol)
xline (pertOnsetPos-t3, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
title (['Back:Sub']);
ylim([lowerlim upperlim]);
xlim([0 450]);
xticks(sort([0:100:colTime*1000]));
xticklabels('');
xtickangle(0)
hold on
box on
ax = gca; 
ax.FontSize = 18; 


subplot (3,2,4); 
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_norm3(:,:));
xlabel (xLabel);
ylabel (yLabel);
set(gca,'ColorOrder',plotCol)
xline (pertOnsetPos-t1-50, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
title (['Pert:Sub']);
ylim([lowerlim upperlim]);
xlim([0 450]);
xticks(sort([0:100:colTime*1000]));
xticklabels('');
xtickangle(0)
box on
ax = gca; 
ax.FontSize = 18; 


subplot (3,2,5); 
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normTMS_Supra(:,:));
xlabel (xLabel);
ylabel (yLabel);
set(gca,'ColorOrder',plotCol)
xline (pertOnsetPos-t3, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
title (['Back:Supra']);
ylim([lowerlim upperlim]);
xlim([0 450]);
xticks(sort([0:100:colTime*1000]));
xticklabels(sort([-200:100:250]));
xtickangle(0)
hold on
box on
ax = gca; 
ax.FontSize = 18; 



subplot (3,2,6); 
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_norm3_Supra(:,:));
xlabel (xLabel);
ylabel (yLabel);
set(gca,'ColorOrder',plotCol)
xline (pertOnsetPos-t1-50, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
title (['PTB:Supra']);
ylim([lowerlim upperlim]);
xlim([0 450]);
xticks(sort([0:100:colTime*1000]));
xticklabels(sort([-200:100:250]));
xtickangle(0)
box on
ax = gca; 
ax.FontSize = 18; 


sgtitle(['\bf' 'P0' num2str(s) ' - FCR EMG'],'FontSize',20);


% this line of code sets the file name of the figure and saves it as a .png
% file in the defined figure_path for that subject's folder

fileName = ['P0' num2str(s) '-FCREMGPlotsv2.png'];
saveas(gcf,[Figure_path 'P0' num2str(s) '\' fileName]);



%% Mean STD Plots

close all
figure('units', 'pixels', 'Position', [300 80 1000 700])
subplot = @(m,n,p) subtightplot(m,n,p,[0.12 0.09], [0.12 0.11], [0.08 0.05]);

upperlim = 13;

colTime = 0.450;
LLRpos = upperlim-3;

subplot (3,2,1); 
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
text (75, (LLRpos), {'BKG'},'FontSize',15);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normN_Mean_Matrix(:,:),'LineWidth',2,'Color','k');
ylabel (yLabel);
xlabel (xLabel);
title (['Back']);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels('');
hold on;
box on
std_plot(squeeze(FCRMatrix_normN), [0:01/Fs:colTime]*1000, 'r', 0.2);
hold on;
ax = gca; 
ax.FontSize = 18; 


subplot (3,2,2);
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
text (75, (LLRpos), {'BKG'},'FontSize',15);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normP_Mean_Matrix(:,:),'LineWidth',2,'Color','k');
xlabel (xLabel);
ylabel (yLabel);
xlim([0 colTime*1000])
title (['Pert']);
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xticks(sort([0:100:colTime*1000]));
xticklabels('');
hold on;
box on
std_plot(squeeze(FCRMatrix_normP), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
ax = gca; 
% ylim([0 10])
ax.FontSize = 18; 


subplot (3,2,3); 
patch ([75 125 125 75], [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normTMS_Mean_Matrix(1,:),'LineWidth',2,'Color','k');
ylabel (yLabel);
xlabel (xLabel);
title (['Back:Sub']);
xline (pertOnsetPos-t3, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels('');
xtickangle(0)
hold on;
box on
std_plot(squeeze(FCRMatrix_normTMS(:,:)), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
ax = gca; 
ax.FontSize = 18; 


subplot (3,2,4); 
patch ([75 125 125 75], [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_norm3_Mean_Matrix(1,:),'LineWidth',2,'Color','k');
xlabel (xLabel);
ylabel (yLabel);
title (['PTB:Sub']);
xline (pertOnsetPos-t1-50, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels('');
xtickangle(0)
hold on;
std_plot(squeeze(FCRMatrix_norm3(:,:)), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
box on
ax = gca; 
ax.FontSize = 18;


subplot (3,2,5); 
patch ([75 125 125 75], [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;
% patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
% text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normTMS_Supra_Mean_Matrix(1,:),'LineWidth',2,'Color','k');
xlabel (xLabel);
ylabel (yLabel);
title (['Back:Supra']);
xline (pertOnsetPos-t1-50, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels(sort([-200:100:250]));
xtickangle(0)
hold on;
std_plot(squeeze(FCRMatrix_normTMS_Supra(:,:)), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
box on
ax = gca; 
ax.FontSize = 18;


subplot (3,2,6); 
patch ([75 125 125 75], [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_norm3_Supra_Mean_Matrix(1,:),'LineWidth',2,'Color','k');
xlabel (xLabel);
ylabel (yLabel);
title (['PTB:Supra']);
xline (pertOnsetPos-t1-50, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels(sort([-200:100:250]));
xtickangle(0)
hold on;
std_plot(squeeze(FCRMatrix_norm3_Supra(:,:)), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
box on
ax = gca; 
ax.FontSize = 18;


sgtitle(['\bf' 'P0' num2str(s) ' - Average FCR EMG'],'FontSize',20);


% this line of code sets the file name of the figure and saves it as a .png
% file in the defined figure_path for that subject's folder

fileName = ['P0' num2str(s) '-MeanFCREMGPlotsv2.png'];
saveas(gcf,[Figure_path 'P0' num2str(s) '\' fileName]);



%% Mean EMG Timeseries plot - normalized by mean PTB peak

close all
figure('units', 'pixels', 'Position', [300 80 1000 700])
subplot = @(m,n,p) subtightplot(m,n,p,[0.12 0.09], [0.12 0.11], [0.08 0.05]);

upperlim = 4;
lowerlim = -1;

colTime = 0.450;
LLRpos = upperlim-0.8;

subplot (3,2,1); 
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
text (75, (LLRpos), {'BKG'},'FontSize',15);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normN_Mean_ptbMatrix(:,:),'LineWidth',2,'Color','k');
ylabel (yLabel);
xlabel (xLabel);
title (['Back']);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels('');
hold on;
box on
std_plot(squeeze(FCRMatrix_normptbN), [0:01/Fs:colTime]*1000, 'r', 0.2);
hold on;
ax = gca; 
ax.FontSize = 18; 


subplot (3,2,2);
patch (backGroundPos, [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
text (75, (LLRpos), {'BKG'},'FontSize',15);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normP_Mean_ptbMatrix(:,:),'LineWidth',2,'Color','k');
xlabel (xLabel);
ylabel (yLabel);
xlim([0 colTime*1000])
title (['Pert']);
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xticks(sort([0:100:colTime*1000]));
xticklabels('');
hold on;
box on
std_plot(squeeze(FCRMatrix_normptbP), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
ax = gca; 
% ylim([0 10])
ax.FontSize = 18; 


subplot (3,2,3); 
patch ([75 125 125 75], [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normTMS_Mean_ptbMatrix(1,:),'LineWidth',2,'Color','k');
ylabel (yLabel);
xlabel (xLabel);
title (['Back:Sub']);
xline (pertOnsetPos-t3, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels('');
xtickangle(0)
hold on;
box on
std_plot(squeeze(FCRMatrix_normptbTMS(:,:)), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
ax = gca; 
ax.FontSize = 18; 


subplot (3,2,4); 
patch ([75 125 125 75], [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_norm3_Mean_ptbMatrix(1,:),'LineWidth',2,'Color','k');
xlabel (xLabel);
ylabel (yLabel);
title (['PTB:Sub']);
xline (pertOnsetPos-t1-50, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels('');
xtickangle(0)
hold on;
std_plot(squeeze(FCRMatrix_normptb3(:,:)), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
box on
ax = gca; 
ax.FontSize = 18;


subplot (3,2,5); 
patch ([75 125 125 75], [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;
% patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
% text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_normTMS_Supra_Mean_ptbMatrix(1,:),'LineWidth',2,'Color','k');
xlabel (xLabel);
ylabel (yLabel);
title (['Back:Supra']);
xline (pertOnsetPos-t1-50, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--g', {'Target';'Disappears'},'LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels(sort([-200:100:250]));
xtickangle(0)
hold on;
std_plot(squeeze(FCRMatrix_normptbTMS_Supra(:,:)), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
box on
ax = gca; 
ax.FontSize = 18;


subplot (3,2,6); 
patch ([75 125 125 75], [upperlim upperlim, lowerlim lowerlim], [0.70 1 0.70]);
hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (LLRpos), 'LLR','FontSize',14);
hold on;

plot ([0:1/Fs:colTime]*1000, FCRMatrix_norm3_Supra_Mean_ptbMatrix(1,:),'LineWidth',2,'Color','k');
xlabel (xLabel);
ylabel (yLabel);
title (['PTB:Supra']);
xline (pertOnsetPos-t1-50, '--b', 'TMS','LineWidth',3,'FontSize',12);
xline (pertOnsetPos, '--m', 'PTB','LineWidth',3,'FontSize',12);
ylim([lowerlim upperlim]);
xlim([0 colTime*1000])
xticks(sort([0:100:colTime*1000]));
xticklabels(sort([-200:100:250]));
xtickangle(0)
hold on;
std_plot(squeeze(FCRMatrix_normptb3_Supra(:,:)), [0:1/Fs:colTime]*1000, 'r', 0.2);
hold on;
box on
ax = gca; 
ax.FontSize = 18;


sgtitle(['\bf' 'P0' num2str(s) ' - Average FCR EMG - Norm PTB'],'FontSize',20);


% this line of code sets the file name of the figure and saves it as a .png
% file in the defined figure_path for that subject's folder

fileName = ['P0' num2str(s) '-MeanFCREMGPlots_NormPTBv2.png'];
saveas(gcf,[Figure_path 'P0' num2str(s) '\' fileName]);



%% LLRa Boxplot visualization

nReps = size(LLRa,1);
col = jet(nReps);

s = 3;

close all
LLRa = ReflexAverages(:,:,1,s);

% this just reorders the LLR amplitude conditions so that the Back and TMS
% are next to each other and PTB and PTB&TMS are next to each other
LLRa2 = LLRa;
LLRa2(:,[2 3]) = LLRa(:,[3 5]);
LLRa2(:,[4 5]) = LLRa(:,[2 4]);

% reshape all conditions and trials into one continuous column (100 x 1)
LLRaVector = reshape(LLRa2,120,1);


figure('Position',[100 100 1000 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.1], [0.12 0.12], [0.1 0.1]);

ax = subplot(1,1,1);
hold on
% creates a boxplot for each condition
h = boxplot(LLRa2,'Boxstyle','outline','Colors','k');
set(h,'linew',2)
hold on
xdata = repmat([1:size(LLRa,2)],size(LLRa,1),1);

% plots the LLR amplitude for each trial as a dot
for c = 1:size(LLRa,2)
scatter(xdata(:,c), LLRa2(:,c),'filled','jitter',0.2)
hold on
end

box on
hold on
xtickangle(0)
xlabel('\bf TMS Mode')
ylabel('\bf LLRa [n.u.]')
xticks([1:6])
xlim([0 7])
xticklabels({'B','B:Sub','B:Supra','P','P:Sub','P:Supra'})
ax.TickLabelInterpreter = 'tex';
set(gca,'FontSize',20)

sgtitle(['\bf' 'P0' num2str(s) ' - LLR Amplitude'],'FontSize',20);

% this line of code sets the file name of the figure and saves it as a .png
% file in the defined figure_path for that subject's folder

fileName = ['P0' num2str(s) '-LLRaPlotsv2.png'];
saveas(gcf,[Figure_path 'P0' num2str(s) '\' fileName]);



%% LLRa Boxplot visualization (normalized by LLR signal during perturbation)

nReps = size(LLRaPertNorm,1);
col = jet(nReps);

for s = 3

close all

LLRaPertNorm = ReflexAverages(:,:,2,s);

% this just reorders the LLR amplitude conditions so that the Back and TMS
% are next to each other and PTB and PTB&TMS are next to each other
LLRaPertNorm2 = LLRaPertNorm;
LLRaPertNorm2(:,[2 3]) = LLRaPertNorm(:,[3 5]);
LLRaPertNorm2(:,[4 5]) = LLRaPertNorm(:,[2 4]);

% reshape all conditions and trials into one continuous column (100 x 1)
LLRaPertNormVector = reshape(LLRaPertNorm2,120,1);


figure('Position',[100 100 1000 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.1], [0.12 0.12], [0.1 0.1]);

ax = subplot(1,1,1);
hold on
% creates a boxplot for each condition
h = boxplot(LLRaPertNorm2,'Boxstyle','outline','Colors','k');
set(h,'linew',2)
hold on
xdata = repmat([1:size(LLRaPertNorm,2)],size(LLRaPertNorm,1),1);

% plots the LLR amplitude for each trial as a dot
for c = 1:size(LLRaPertNorm,2)
scatter(xdata(:,c), LLRaPertNorm2(:,c),'filled','jitter',0.2)
hold on
end

box on
hold on
xtickangle(0)
xlabel('\bf TMS Mode')
ylabel('\bf LLRa [n.u.]')
xticks([1:6])
xlim([0 7])
xticklabels({'B','B:Sub','B:Supra','P','P:Sub','P:Supra'})
ax.TickLabelInterpreter = 'tex';
set(gca,'FontSize',20)

sgtitle(['\bf' 'P0' num2str(s) ' - LLR Amplitude - Norm LLR'],'FontSize',20);

% this line of code sets the file name of the figure and saves it as a .png
% file in the defined figure_path for that subject's folder

fileName = ['P0' num2str(s) '-LLRaPlots_NormalizedbyPTBv2.png'];
saveas(gcf,[Figure_path 'P0' num2str(s) '\' fileName]);

end


%% SLRa Boxplot visualization

nReps = size(SLRa,1);
col = jet(nReps);
close all
s = 3;

SLRa = ReflexAverages(:,:,3,s);

% this just reorders the LLR amplitude conditions so that the Back and TMS
% are next to each other and PTB and PTB&TMS are next to each other
SLRa2 = SLRa;
SLRa2(:,[2 3]) = SLRa(:,[3 5]);
SLRa2(:,[4 5]) = SLRa(:,[2 4]);

% reshape all conditions and trials into one continuous column (100 x 1)
SLRaVector = reshape(SLRa2,120,1);


figure('Position',[100 100 1000 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.1], [0.12 0.12], [0.1 0.1]);

ax = subplot(1,1,1);
hold on
% creates a boxplot for each condition
h = boxplot(SLRa2,'Boxstyle','outline','Colors','k');
set(h,'linew',2)
hold on
xdata = repmat([1:size(SLRa,2)],size(SLRa,1),1);

% plots the LLR amplitude for each trial as a dot
for c = 1:size(SLRa,2)
scatter(xdata(:,c), SLRa2(:,c),'filled','jitter',0.2)
hold on
end

box on
hold on
xtickangle(0)
xlabel('\bf TMS Mode')
ylabel('\bf SLRa [n.u.]')
xticks([1:6])
xlim([0 7])
xticklabels({'B','B:Sub','B:Supra','P','P:Sub','P:Supra'})
ax.TickLabelInterpreter = 'tex';
set(gca,'FontSize',20)

sgtitle(['\bf' 'P0' num2str(s) ' - SLR Amplitude'],'FontSize',20);


% this line of code sets the file name of the figure and saves it as a .png
% file in the defined figure_path for that subject's folder

fileName = ['P0' num2str(s) '-SLRaPlotsv2.png'];
saveas(gcf,[Figure_path 'P0' num2str(s) '\' fileName]);


% end




%% EMG plotting/figure making

% this section of code has been used for figure making or plotting of a
% subject example of what the EMG data looks like with a PTB or with TMS or
% with both for presentations

% This does not need to run each time and will need to be updated with new
% limits

close all
figure('units', 'pixels', 'Position', [300 80 1000 700])

pertOnsetPos = 200;
upperlim = 20;

hold on;
patch (LLRPos, [upperlim upperlim, lowerlim lowerlim], [0.85 1 1]);
text (255, (upperlim-4), '\bf LLR','FontSize',25);
hold on;
plot ([0:1/Fs:0.45]*1000, FCRMatrix_normP_Mean_Matrix(:,:),'k','LineWidth',4);

xlim([0 450])
ylim([0 20])
xlabel('\bf Time [ms]')
ylabel('\bf EMG [n.u.]')
xline(pertOnsetPos, '--m', 'Pert Onset','LineWidth',4,'FontSize',25);
xticks(sort([0:100:2250]));
xticklabels(sort([-200 -100 0 100 200]));
hold on;
box on

std_plot(squeeze(PTBnoTMS_Matrix), [0:1/Fs:0.45]*1000, 'r', 0.3);
hold on;
ax = gca; 
ax.FontSize = 18; 






%%