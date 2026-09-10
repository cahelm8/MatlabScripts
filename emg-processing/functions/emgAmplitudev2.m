function [EMGfcr, EMGecu, LLRfcr, LLRecu, t] = emgAmplitudev2(time, EMG, amt_of_triggers, indexes_pert, ind_LLR)

%This function is getting the EMG amplitude for the whole perturbation
% i=1;
% time = EMGtime{i};
% EMG=EMGfilt{i};
% amt_of_triggers= triggerCount(i);
% indexes_pert= indexes_perturbation{i};%full trial length
% ind_LLR=indexes_LLR{i}; %50ms-100ms after pert 

%TIME
for i=1:amt_of_triggers
    for j=1:length(indexes_pert(1,:))
        idx = indexes_pert(i,j);
        trueTime(i,j) = time(idx);
    end
end

%sets the time for each trial as starting at 0, not its continuous time (as stored in trueTime)
t_all = zeros(size(trueTime));
for i=1:length(t_all(:,1))
    for j=1:length(t_all(1,:))
        t_all(i,j) = trueTime(i,j)-trueTime(i,1);
    end
end

%FOR FCR taking the signal that corresponds to the first 200ms after
%perturbation, as stored in indexes_pert
%only return 1 time vector, as they are all the same.
t = t_all(1,:);

for i=1:amt_of_triggers
% Another way of indexing the same thing without a loop   
%         index_ex=indexes_pert(i,1:length(indexes_pert(1,:)));
%         EMGfcr2(i,:) = EMG(1,index_ex);
    for j=1:length(indexes_pert(1,:))
        idx = indexes_pert(i,j);
        EMGfcr(i,j) = EMG(1,idx);
    end
end

%FOR FCR taking the signal that corresponds to the 50ms after perturbaton
%onset to 100ms after perturbatoin (LLR), as stored in ind_LLR 
for i=1:amt_of_triggers
    for j=1:length(ind_LLR(1,:))
        idx = ind_LLR(i,j);
        LLRfcr(i,j) = EMG(1,idx);
    end
end

%FOR ECU taking the signal that corresponds to the first 200ms after
%perturbation, as stored in indexes_pert
%only return 1 time vector, as they are all the same.
for i=1:amt_of_triggers
    for j=1:length(indexes_pert(1,:))
        idx = indexes_pert(i,j);
        EMGecu(i,j) = EMG(2,idx);
    end
end

%FOR ECU taking the signal that corresponds to the 50ms after perturbaton
%onset to 100ms after perturbatoin (LLR), as stored in ind_LLR 
for i=1:amt_of_triggers
    for j=1:length(ind_LLR(1,:))
        idx = ind_LLR(i,j);
        LLRecu(i,j) = EMG(2,idx);
    end
end