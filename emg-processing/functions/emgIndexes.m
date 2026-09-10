function [perturbIC, LLRIC] = emgIndexes(numberOfTriggers, trigger1, trigger2, trigger3, trigger4)

%numberOfTriggers=triggerCount(i)
%trigger1 = Perturb_begin_index(i,:)
%trigger2 = LLR_50ms_index(i,:)
%trigger3 = LLR_100ms_index(i,:)
%trigger4 = Perturb_end_index(i,:)

%This function generates an entire array of where the perturbation is
%occuring, so it can be extracted from the EMG track
for i=1:numberOfTriggers
    idx = trigger1(i); %trial onset
    j=1;
    while(idx<=trigger4(i)) %trial end
        perturbIC(i,j) = idx;
        idx = idx+1;
        j=j+1;
    end
end

for i=1:numberOfTriggers
    idx = trigger2(i);
    j=1;
    while(idx<=trigger3(i))
        LLRIC(i,j) = idx;
        idx = idx+1;
        j=j+1;
    end
end