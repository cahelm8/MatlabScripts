% This section adds a new subject's data to the FCRtot dataset *WORKS WITH PARIA AND CODY DATA
% You must have ran other anaylsis scripts before running this one: Main_Code -> load modesmat -> tmsptb_eventtimes_withdelay -> FCR_five_plots -> load FCRtot_norm -> *this script*


% Load in the processing path to have the SPM folder in the pathway
%processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(processingPath));


% Load in the FCRtot dataset which includes the response for all subjects
% for all conditions
load('FCRtot_norm','-mat','FCRtot_norm')


% Enter the specific subject ID for subject level analysis and plotting
sub_num = 47; % Set the index number of FCRtot_norm that you want to correspond with the loaded subject's data


% Save the FCRtot for the subject ID if analysing a new subject
% FCRend=cat(3,FCRMatrix_normN,FCRMatrix_normP,FCRMatrix_norm1,FCRMatrix_norm2,FCRMatrix_norm3);
% FCRtot_norm(:,:,:,sub_num)=FCRend;
% save('FCRtot_norm.mat', 'FCRtot_norm')
% size(FCRtot_norm) % check the size of the FCRtot matrix


% num_part = [1,2.1 ; 2,2.2 ; 3,3 ; 4,0 ; 5,0 ; 6,6 ; 7,0 ; 8,8 ; 9,9 ; 10,0 ; 11,12.1 ; 12,12.2 ; 13,13 ; 14,14 ; 15,15 ; 16,16 ; 17,17 ; 18,18 ; 19,0 ; 20,20 ; 22,22; 23,23; 24,24; 35,35];
% num_part is just to keep a record of which indexes correspond to which subject's data

Y = FCRtot_norm(:,:,2:5,sub_num); % Y is all trials with perturbations (i.e. conditions 2-5) from 1 subject, change last dimension's value to adjust which subject's data is used

upperlim = max(max(max(Y)))+5; % Adjusting the limits of the plot based on the amplitude of subject's EMG data, these limits only effect left side plots
lowerlim = min(min(min(Y)))-5;

% FCRMatrix_normP(1,1)
% Y(1,1,1)

% group 1 - [22:33]
% group 2 - [34:36 37:39 41:42 44:47]


% For group 1
% Load in the group data into Ygroup1
Ygroup1 = FCRtot_norm(:,:,2:5,[22:33]);


numSubj1 = size(Ygroup1,4); % sets the number of subjects depending on the TMS group
% concatenates the data in order of condition for each subject

% for group 1 - 90% group
Ygroup1s = [];
for s = 1:numSubj1
    Ygroup1s = cat(1,Ygroup1s, Ygroup1(:,:,:,s));
end

% concatenates the data in the 1st dimension in terms of subjects
Ygroup1sr = [];
for cond = 1:4
    Ygroup1sr = cat(1,Ygroup1sr, Ygroup1s(:,:,cond));
end

% Ygroup1 - 20 by 1250 by 4 by 12
% Ygroup1s - 240 by 1250 by 4
% Ygroup1sr - 960 by 1250


% FOR GROUP 2


% Load in the group data into Ygroup2
Ygroup2 = FCRtot_norm(:,:,2:5,[34:39 41:42 44:47]);

numSubj2 = size(Ygroup2,4); % sets the number of subjects depending on the TMS group
% concatenates the data in order of condition for each subject


% for group 2 - 95% group
Ygroup2s = [];
for s = 1:numSubj2
    Ygroup2s = cat(1,Ygroup2s, Ygroup2(:,:,:,s));
end

% concatenates the data in the 1st dimension in terms of subjects
Ygroup2sr = [];
for cond = 1:4
    Ygroup2sr = cat(1,Ygroup2sr, Ygroup2s(:,:,cond));
end

% Ygroup2s - 240 by 1250 by 4
% Ygroup2sr - 960 by 1250



% FOR BOTH GROUPS


% Load in the group data into Ygroup
Ygroup = FCRtot_norm(:,:,2:5,[22:39 41:42 44:47]);

numSubj = size(Ygroup,4); % sets the number of subjects depending on the TMS group
% concatenates the data in order of condition for each subject

% for all groups
Ygroups = [];
for s = 1:numSubj
    Ygroups = cat(1,Ygroups, Ygroup(:,:,:,s));
end


% concatenates the data in the 1st dimension in terms of subjects
Ygroupsr = [];
for cond = 1:4
    Ygroupsr = cat(1,Ygroupsr, Ygroups(:,:,cond));
end

% Ygroups - 480 by 1250 by 4
% Ygroupsr - 1920 by 1250


% set the upper and lower limits for the left side plots for the group
% level max and min
upperlimgr = max(max(max(mean(Ygroup,1))))+5; % group level upper limit
lowerlimgr = min(min(min(mean(Ygroup,1))))-5; % group level lower limit


% clearvars -except FCRtot_norm
% you can run the above line afterwards to make a new FCRtot_norm workspace with just that variable


%% Make a JMP Table

% subjectID = repmat(repelem([1:24]',20),4,1);
% group = repmat(repelem([90;95],240),4,1);
% conditions = repelem([1;2;3;4],480);
% 
% timepoint0 = 500; % 0 ms post pert onset
% timepoint1 = 750; % 50 ms post per onset
% timepoint2 = 875; % 75 ms post pert onset
% timepoint3 = 1000; % 100 ms post pert onset
% 
% LLR = [(Ygroupsr(:,timepoint2))];
% 
% JMPtable = table(LLR, conditions, group, subjectID);





%% Figure 1: EMG and LLR mean plots for all subjects
% Makes figure that includes entire timeseries for all subjects 
% (100 ms prior to 150 ms after pert)

close all

groupPlotting = Ygroup;% all subjects EMG

Y0 = Ygroupsr; % all subjects

subjID = repmat(repelem([1:24]',20),4,1);
TMSmode = repelem([1;2;3;4],480);
TMSinten = repmat(repelem([90;95],240),4,1);


% plot
figure('units', 'pixels', 'Position', [250 100 900 650])
subplot = @(m,n,p) subtightplot(m,n,p, [0.12 0.09], [0.105 0.115], [0.1 0.06]);

sgtitle(['TMS Mode - All Subjects']) 
legTit = [{'LLR','Pert Only','T_1','T_2','T_3'}];

p(1) = patch ([150 200 200 150], [upperlimgr upperlimgr, lowerlimgr lowerlimgr], ...
    [0.17 0.17 0.17],'EdgeColor','none');
set(p(1),'FaceAlpha',0.2)
hold on

col = jet(4);

for i = 1:4
  
p(i+1) = plot([0:0.0002:0.25]*1000,squeeze(mean(mean(groupPlotting(:,:,i,:),1),4)),'LineWidth',1.5,...
    'Color',col(i,:));
hold on
std_plot(squeeze(mean(groupPlotting(:,:,i,:),1))',[0:0.0002:0.25]*1000, col(i,:), 0.2);
hold on;

end

ylim([0 10]);
xlim([0 250])
yticks([0:5:10])
ylabel('EMG (nu)')
set(gca,'box','off', 'XGrid', 'on', ...
    'XTick', [0 50 100 150 200 250], 'XTickLabel',[-100 -50 0 50 100 150],'FontSize',16)
xlabel ('Time (ms)');
legend(p, legTit)



%% Figure 2: EMG and LLRa means for one group
% Makes figure that includes entire timeseries for one group
% (100 ms before to 150 ms after pert)

g = 95; % group

if g == 90
groupPlotting = Ygroup1; % one group EMG data
Y0 = Ygroup1sr; % one group EMG data
elseif g == 95
    groupPlotting = Ygroup2; % one group EMG data
    Y0 = Ygroup2sr; % one group EMG data
end

subjID = repmat(repelem([1:12]',20),4,1); % subject ID
TMSmode = repelem([1;2;3;4],240); %tms mode
TMSinten = repelem([g],960); %tms intensity

% plot
figure('units', 'pixels', 'Position', [250 100 900 650])
subplot = @(m,n,p) subtightplot(m,n,p, [0.12 0.09], [0.105 0.115], [0.1 0.06]);

sgtitle(['TMS Mode - ' num2str(g) '% AMT']) 
legTit = [{'LLR','Pert Only','T_1','T_2','T_3'}];

p(1) = patch ([150 200 200 150], [upperlimgr upperlimgr, lowerlimgr lowerlimgr], ...
    [0.17 0.17 0.17],'EdgeColor','none');
set(p(1),'FaceAlpha',0.2)
hold on

col = jet(4);

for i = 1:4
  
p(i+1) = plot([0:0.0002:0.25]*1000,squeeze(mean(mean(groupPlotting(:,:,i,:),1),4)),'LineWidth',1.5,...
    'Color',col(i,:));
hold on
std_plot(squeeze(mean(groupPlotting(:,:,i,:),1))',[0:0.0002:0.25]*1000, col(i,:), 0.2);
hold on;

end

ylim([0 10]);
xlim([0 250])
yticks([0:5:10])
ylabel('EMG (nu)')
set(gca,'box','off', 'XGrid', 'on', ...
    'XTick', [0 50 100 150 200 250], 'XTickLabel',[-100 -50 0 50 100 150],'FontSize',18)
xlabel ('Time (ms)');
legend(p, legTit)





%%


