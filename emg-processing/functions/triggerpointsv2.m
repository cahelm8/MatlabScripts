function [TriOut] = triggerpointsv2(Time, triggerEMG)

%Load data
t=reshape(Time,1,[]);
triggers=triggerEMG;

%Processing data

%Get indexes of triggers
uTriggerPts = [];

datadiff = diff(triggers);

%Used to find the first index of the trigger, high sampling rate
for i=1:length(datadiff)
    %EMG amplitude of triggers is around 3000
    if abs(datadiff(i))>500
        uTriggerPts = [uTriggerPts i];
    end
end

%If next trigger within 10ms of the last one, remove it
%(Really, only need to test if two triggers are right next to eachother due
%to them getting split due to sampling frequency)
TriggerPts = [];
%There should never be a trigger closer to eachother than 5 ms
tbetween = round(10240*0.005);
uTriggerPts = [uTriggerPts 999999999999];
idx_to_keep = find(diff(uTriggerPts) > tbetween);
TriggerPts = uTriggerPts(idx_to_keep);

%plot(Time, Data(:,4))


%To be valid, there should be two triggers within 0.205s (200+5ms) of eachother
%Get the index of the 
tmax = round(10240*.205);
idx_to_keep = find(diff(TriggerPts) < tmax);
perturbstart_idx = TriggerPts(idx_to_keep);

%Finding time that corresponds to pertubation indexes and to LLR indexes
perturb_time = [t(perturbstart_idx)];
TriggerPts_time = [t(TriggerPts)];

perturb_time_LLR50 = [];
perturb_time_LLR100 = [];
perturb_time_End = [];

for i=1:length(perturb_time)
    perturb_time_LLR50(i) = perturb_time(i)+0.05;
    perturb_time_LLR100(i) = perturb_time(i)+0.1;
    perturb_time_End(i) = perturb_time(i)+0.2;
end

perturb_time_Begin_index = [];
perturb_time_LLR50_index = [];
perturb_time_LLR100_index = [];
perturb_time_End_index = [];

a = ismembertol(t,perturb_time);
b = ismembertol(t,perturb_time_LLR50);
c = ismembertol(t,perturb_time_LLR100);
d = ismembertol(t,perturb_time_End);

perturb_time_Begin_index = find(a);
perturb_time_LLR50_index = find(b);
perturb_time_LLR100_index = find(c);
perturb_time_End_index = find(d);

% %quick error check
% if (length(perturb_time_Begin_index) ~= length(perturb_time) || length(perturb_time_LLR50_index) ~= length(perturb_time_LLR50) || length(perturb_time_LLR100_index) ~= length(perturb_time_LLR100) || length(perturb_time_End_index) ~= length(perturb_time_End))
%     msg = 'IsMember Tolerance';
%     error(msg)
% end
% 
TriOut = [perturb_time_Begin_index; perturb_time_LLR50_index; perturb_time_LLR100_index; perturb_time_End_index];