function [EMGbyConditionFCR, EMGbyConditionECU, LLRfcr_sorted, LLRecu_sorted, conditionsarray] = EMGtypesplitv3(pertTorq, pertDur, EMG_fcr, EMG_ecu, LLR_fcr, LLR_ecu, per_Mode, DurTrialNumber)

%This file organizes the EMG for the perturbations, and the EMG for the LLR
%by flexion/extension, instruction, torque, and velocity.
%Each subject is in its own cell

% % %Dummy Variables 
% i=1;
% pertTorq=pertTorque{i};
% pertDur=pertDuration{i};
% EMG_fcr = EMGfcr{i};
% EMG_ecu=EMGecu{i};
% LLR_fcr=LLRfcr{i};
% LLR_ecu=LLRecu{i};
% per_Mode= perMode(i);
% DurTrialNumber = DurTrialNum{i};

torques=unique(pertTorq);
durations=unique(pertDur);

flexionFCR_Matrix = [];
extensionFCR_Matrix = [];
flexionECU_Matrix = [];
extensionECU_Matrix = [];
LLRFCRf_Matrix = [];
LLRFCRe_Matrix = [];
LLRECUf_Matrix = [];
LLRECUe_Matrix = [];

%trials per muscle (ECU or FCR)
trials = length(durations)*length(torques)*per_Mode;

%Flexion trials
flexionFCR_Matrix = EMG_fcr(DurTrialNumber(DurTrialNumber(:,2)==1,1),:);
flexionECU_Matrix = EMG_ecu(DurTrialNumber(DurTrialNumber(:,2)==1,1),:);
LLRFCRf_Matrix = LLR_fcr(DurTrialNumber(DurTrialNumber(:,2)==1,1),:);
LLRECUf_Matrix = LLR_ecu(DurTrialNumber(DurTrialNumber(:,2)==1,1),:);

extensionFCR_Matrix = EMG_fcr(DurTrialNumber(DurTrialNumber(:,2)==0,1),:);
extensionECU_Matrix = EMG_ecu(DurTrialNumber(DurTrialNumber(:,2)==0,1),:);
LLRFCRe_Matrix = LLR_fcr(DurTrialNumber(DurTrialNumber(:,2)==0,1),:);
LLRECUe_Matrix = LLR_ecu(DurTrialNumber(DurTrialNumber(:,2)==0,1),:);

% % Purposeful wrong indexing, to confirm our results
% flexionFCR_Matrix = EMG_fcr((DurTrialNumber(:,2)==1),:);
% flexionECU_Matrix = EMG_ecu((DurTrialNumber(:,2)==1),:);
% LLRFCRf_Matrix = LLR_fcr((DurTrialNumber(:,2)==1),:);
% LLRECUf_Matrix = LLR_ecu((DurTrialNumber(:,2)==1),:);
% 
% extensionFCR_Matrix = EMG_fcr((DurTrialNumber(:,2)==0),:);
% extensionECU_Matrix = EMG_ecu((DurTrialNumber(:,2)==0),:);
% LLRFCRe_Matrix = LLR_fcr((DurTrialNumber(:,2)==0),:);
% LLRECUe_Matrix = LLR_ecu((DurTrialNumber(:,2)==0),:);

conditionsarray = DurTrialNumber(:,2:4);
%redefine extension condition from 0 coding to the number 2
conditionsarray(conditionsarray(:,1)==0)=2; 

%% Previous Code, re-wrote 08/21/2020 for clarity, same function 
%constructs a matrix of EMG tracks for extension and flexion, using
%presorted list of indexes from above
% for fe = 1:2
%     for d = 1:length(durations)
%         for q = 1:length(torques)
%             for k = 1:per_Mode %number of repititions
%                 y = (fe-1)*(trials/length(fe)) + per_Mode*length(torques)*(d-1) + per_Mode*(q-1) + k;
%                 idx = DurTrialNumber(y,1);
%                 if y<=(trials/length(fe))
%                     fprintf('Flexion trial, index = %d,  Flexion/Extension = %d, Duration %d\n', idx, DurTrialNumber(y,2), DurTrialNumber(y,3));
%                     flexionFCR_Matrix(y,:) = EMG_fcr(idx,:);
%                     flexionECU_Matrix(y,:) = EMG_ecu(idx,:);
%                     LLRFCRf_Matrix(y,:) = LLR_fcr(idx,:);
%                     LLRECUf_Matrix(y,:) = LLR_ecu(idx,:);
%                     conditionsarray(y,:) = [fe durations(d) torques(q)];
%                 elseif y>=(trials/length(fe))+1
%                     extensionFCR_Matrix(y-trials,:) = EMG_fcr(idx,:);
%                     extensionECU_Matrix(y-trials,:) = EMG_ecu(idx,:);
%                     LLRFCRe_Matrix(y-trials,:) = LLR_fcr(idx,:);
%                     LLRECUe_Matrix(y-trials,:) = LLR_ecu(idx,:);
%                     conditionsarray(y,:) = [fe durations(d) torques(q)];
%                 end
%             end
%             
%         end
%     end
% end

%combine
EMGbyConditionFCR = [flexionFCR_Matrix; extensionFCR_Matrix];
EMGbyConditionECU = [flexionECU_Matrix; extensionECU_Matrix];
LLRfcr_sorted = [LLRFCRf_Matrix; LLRFCRe_Matrix];
LLRecu_sorted = [LLRECUf_Matrix; LLRECUe_Matrix];
