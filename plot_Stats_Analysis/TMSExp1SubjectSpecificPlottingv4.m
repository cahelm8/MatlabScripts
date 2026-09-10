

clc
clear
close all

% load in LLRa data for all subjects

dataTablePath = ['Z:\StudentFolders\Cody\Projects\TMS\'...
    'Statistical Analysis\Group Level Analysis']; %<- change this if data table is stored somewhere else
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(dataTablePath));
addpath(genpath(processingPath));


% LLRa [nu] with outliers removed by subject
LLRAllSubjDataTab = xlsread('llr-avg-group-level-ALLSubjects_20221206.xlsx','D2:D2401');


% load in LLR condition indexes and assign for each condition
[~,conditions] = xlsread('llr-avg-group-level-ALLSubjects_20221206.xlsx','F2:F2401');
cond1Idx = (find(strcmp(conditions,'T off-P off')));
cond2Idx = (find(strcmp(conditions,'T off-P on')));
cond3Idx = (find(strcmp(conditions,'T1')));
cond4Idx = (find(strcmp(conditions,'T2')));
cond5Idx = (find(strcmp(conditions,'T3')));


nSubj1 = 12;
nSubj2 = 12;
nReps = 20;


% All LLR data for all subjects for all reps by condition
LLRAllSubjPoff = LLRAllSubjDataTab(cond1Idx); % 480 by 1
LLRAllSubjToff = LLRAllSubjDataTab(cond2Idx); % 480 by 1
LLRAllSubjT1 = LLRAllSubjDataTab(cond3Idx); % 480 by 1
LLRAllSubjT2 = LLRAllSubjDataTab(cond4Idx);
LLRAllSubjT3 = LLRAllSubjDataTab(cond5Idx);


% All subject data
LLRAllSubj = cat(2,LLRAllSubjPoff,LLRAllSubjToff,LLRAllSubjT1,LLRAllSubjT2,LLRAllSubjT3);
LLRALLSubjMatrix = reshape(LLRAllSubj(:),[20,24,5]);

avgLLRALLSubjMatrix = squeeze(mean(LLRALLSubjMatrix))';



% 90 group 1
% ALL LLR data for all 90 group subjects for all reps by condition
LLRGroup1SubjPoff = LLRAllSubjPoff(1:(nReps*nSubj1)); % 240 by 1 for group 1
LLRGroup1SubjToff = LLRAllSubjToff(1:(nReps*nSubj1)); % 240 by 1 for group 1
LLRGroup1SubjT1 = LLRAllSubjT1(1:(nReps*nSubj1));
LLRGroup1SubjT2 = LLRAllSubjT2(1:(nReps*nSubj1));
LLRGroup1SubjT3 = LLRAllSubjT3(1:(nReps*nSubj1)); 

LLRGroup1Subj = [LLRGroup1SubjPoff LLRGroup1SubjToff LLRGroup1SubjT1...
    LLRGroup1SubjT2 LLRGroup1SubjT3];


% LLR data for all 90 group subjects by condition by repetition
LLRGroup1SubjRepPoff = reshape(LLRGroup1SubjPoff,nReps,nSubj1); % 20 by 12 for group 1
LLRGroup1SubjRepToff = reshape(LLRGroup1SubjToff,nReps,nSubj1); % 20 by 12 for group 1
LLRGroup1SubjRepT1 = reshape(LLRGroup1SubjT1,nReps,nSubj1);
LLRGroup1SubjRepT2 = reshape(LLRGroup1SubjT2,nReps,nSubj1); 
LLRGroup1SubjRepT3 = reshape(LLRGroup1SubjT3,nReps,nSubj1); 



% 95 group 2
% ALL LLR data for all gr 2 subjects for all reps by condition
LLRGroup2SubjPoff = LLRAllSubjPoff(((nReps*nSubj1)+1):end); % 240 by 1 for group 2
LLRGroup2SubjToff = LLRAllSubjToff(((nReps*nSubj1)+1):end); % 240 by 1 for group 2
LLRGroup2SubjT1 = LLRAllSubjT1(((nReps*nSubj1)+1):end); 
LLRGroup2SubjT2 = LLRAllSubjT2(((nReps*nSubj1)+1):end);
LLRGroup2SubjT3 = LLRAllSubjT3(((nReps*nSubj1)+1):end);

LLRGroup2Subj = [LLRGroup2SubjPoff LLRGroup2SubjToff LLRGroup2SubjT1...
    LLRGroup2SubjT2 LLRGroup2SubjT3];

% LLR data for all group 2 subjects by condition by repetition
LLRGroup2SubjRepPoff = reshape(LLRGroup2SubjPoff,nReps,nSubj2); % 20 by 12 for group 2
LLRGroup2SubjRepToff = reshape(LLRGroup2SubjToff,nReps,nSubj2); % 20 by 12 for group 2
LLRGroup2SubjRepT1 = reshape(LLRGroup2SubjT1,nReps,nSubj2); % 20 by 12
LLRGroup2SubjRepT2 = reshape(LLRGroup2SubjT2,nReps,nSubj2); % 20 by 12
LLRGroup2SubjRepT3 = reshape(LLRGroup2SubjT3,nReps,nSubj2); % 20 by 12




%%

% plotting all data points for each condition with subject for marker point

% Plotting subject LLRa
%col = [{'r','g','b','c','m','y','k','r','g','b','c','m'}];
col = [linspace(0,0.8,nSubj1);linspace(0,0.8,nSubj1);linspace(1,1,nSubj1)]';
ylim = [-1 18];
xlim = [0.5 5.5];
position = [1:5];

% group 1 90%
fig = figure('units', 'pixels', 'Position', [100 100 1300 650]);
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.07], [0.105 0.105], [0.08 0.05]);


subplot(1,2,1)
for s = 1:nSubj1
hold all
% box plot of all reps for that subject
plot([1:5],[LLRGroup1SubjRepT1(:,s) LLRGroup1SubjRepT2(:,s) ...
    LLRGroup1SubjRepT3(:,s) LLRGroup1SubjRepPoff(:,s)...
    LLRGroup1SubjRepToff(:,s)],'*','Color',col(s,:),'LineWidth',1.5);
set (gca,'xTickLabel','');
set (gca,'yTickLabel','');
set (gca,'FontSize',18);
title('90% Group - Subject Level','FontSize',26)
xticks ([1:5]);
yticks ([0:5:15]);
grid on;
end

% boxplot for all subjects for all reps
bh = boxplot([LLRGroup1SubjT1(:) LLRGroup1SubjT2(:) ...
    LLRGroup1SubjT3(:) LLRGroup1SubjPoff(:)...
    LLRGroup1SubjToff(:)],'Positions',position,'Symbol','','Color','k');
set(bh,'LineWidth', 2);
hold on

set(gca,'TickLabelInterpreter', 'tex');
xticklabels({'T_1','T_2','T_3','BackOnly','PertOnly',});
yticklabels([0:5:15]);
ylabel('LLRa [nu]','FontSize',18);
set (gca,'ylim',ylim);
set (gca,'xlim',xlim);



% plotting all data points for each condition with subject for marker point

% Plotting subject LLRa
%col = [{'r','g','b','c','m','y','k','r','g','b','c','m'}];
col = [linspace(0,0.8,nSubj2);linspace(1,1,nSubj2);linspace(0,0.8,nSubj2)]';

% group 2 95%
%fig = figure('units', 'pixels', 'Position', [200 100 1100 650]);
%subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.04], [0.105 0.105], [0.08 0.05]);

subplot(1,2,2)
for s = 1:nSubj2
hold all
% plotting all reps for only that subject
plot([1:5],[LLRGroup2SubjRepT1(:,s) LLRGroup2SubjRepT2(:,s) ...
    LLRGroup2SubjRepT3(:,s) LLRGroup2SubjRepPoff(:,s)...
    LLRGroup2SubjRepToff(:,s)],'*','Color',col(s,:),'LineWidth',1.5);

set (gca,'FontSize',18);
title('95% Group - Subject Level','FontSize',26)
set (gca,'xTickLabel','');
set (gca,'yTickLabel','');
xticks ([1:5]);
yticks ([0:5:15]);
grid on;
end

% boxplot of all subject for all reps
bh = boxplot([LLRGroup2SubjT1(:) LLRGroup2SubjT2(:) ...
    LLRGroup2SubjT3(:) LLRGroup2SubjPoff(:)...
    LLRGroup2SubjToff(:)],'Positions',position,'Symbol','','Color','k');
set(bh,'LineWidth', 2);
hold on

set(gca,'TickLabelInterpreter', 'tex');
xticklabels({'T_1','T_2','T_3','BackOnly','PertOnly',});
yticklabels([0:5:15]);
ylabel('LLRa [nu]','FontSize',18);
set (gca,'ylim',ylim);
set (gca,'xlim',xlim);



%%
close all

% plotting all data points for each condition with subject for marker point

% Plotting subject LLRa
%col = [{'r','g','b','c','m','y','k','r','g','b','c','m'}];
col = [linspace(0.5,0.5,24);linspace(0.5,0.5,24);linspace(0.5,0.5,24)]';
col = [.5 .5 .5];
ylim = [-1 12];
xlim = [0.5 5.5];
position = [1:5];

% All subjects
fig = figure('units', 'pixels', 'Position', [300 100 750 650]);
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.07], [0.105 0.105], [0.08 0.05]);

subplot(1,1,1)


% boxplot for all subjects
% bh = boxplot([avgLLRALLSubjMatrix(3,:)', avgLLRALLSubjMatrix(4,:)', avgLLRALLSubjMatrix(5,:)',...
%     avgLLRALLSubjMatrix(1,:)', avgLLRALLSubjMatrix(2,:)'],...
%     'Positions',position,'Symbol','','Color','k');
bh = boxplot([LLRAllSubj(:,3),LLRAllSubj(:,4),LLRAllSubj(:,5),LLRAllSubj(:,1),...
    LLRAllSubj(:,2)],...
    'Positions',position,'Symbol','','Color','k');
set(bh,'LineWidth', 2);

hold on


for s = 1:24
hold all
% box plot of all reps for that subject
scatter([1:5],[avgLLRALLSubjMatrix(3,s), avgLLRALLSubjMatrix(4,s), avgLLRALLSubjMatrix(5,s),...
    avgLLRALLSubjMatrix(1,s), avgLLRALLSubjMatrix(2,s)],30,col,'filled','jitter','on', 'jitterAmount',0.1);
set (gca,'xTickLabel','');
set (gca,'yTickLabel','');
set (gca,'FontSize',22);
title('','FontSize',26)
xticks ([1:5]);
yticks ([0:2:12]);
grid on;
end


sigline([2 5],[],10);sigline([3 5],[],9);sigline([4 5],[],8)

set(gca,'TickLabelInterpreter', 'tex');
xticklabels({'T_1','T_2','T_3','BackOnly','PertOnly',});
xlabel('TMS Mode','FontSize',26)
yticklabels([0:2:12]);
ylabel({'LLR Amplitude [nu]'}, 'FontSize',25, 'FontWeight','bold')
set (gca,'ylim',ylim);
set (gca,'xlim',xlim);
grid on



%%
close all

% plotting all data points for each condition with subject for marker point

% Plotting subject LLRa
%col = [{'r','g','b','c','m','y','k','r','g','b','c','m'}];
col = [linspace(0,0,12);linspace(0,0,12);linspace(0,0,12)]';
ylim = [-1 12];
xlim = [0.5 5.5];
position = [1:5];

% All subjects
fig = figure('units', 'pixels', 'Position', [100 100 1400 650]);
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.07], [0.08 0.08], [0.05 0.05]);

subplot(1,2,1)

% boxplot for all subjects
bh1 = boxplot([LLRGroup1Subj(:,3), LLRGroup1Subj(:,4),LLRGroup1Subj(:,5),...
    LLRGroup1Subj(:,1), LLRGroup1Subj(:,2)],...
    'Positions',position,'Symbol','','Color','r');
set(bh1,'LineWidth', 2);

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    p1 = patch(get(h(j),'XData'),get(h(j),'YData'),'r','FaceAlpha',.1);
end

hold on


for s = 1:12
hold all
% box plot of all reps for that subject
scatter([1:5],[avgLLRALLSubjMatrix(3,s), avgLLRALLSubjMatrix(4,s), avgLLRALLSubjMatrix(5,s),...
    avgLLRALLSubjMatrix(1,s), avgLLRALLSubjMatrix(2,s)],30,col(s,:),'filled','jitter','on', 'jitterAmount',0.1);
set (gca,'xTickLabel','');
set (gca,'yTickLabel','');
set (gca,'FontSize',18);
title('','FontSize',26)
xticks ([1:5]);
yticks ([0:2:12]);
grid on;
end

sigline([3 5],[],10);sigline([4 5],[],9)

set(gca,'TickLabelInterpreter', 'tex');
xticklabels({'T_1','T_2','T_3','BackOnly','PertOnly',});
xlabel('TMS Mode','FontSize',26)
yticklabels([0:2:12]);
ylabel({'LLR Amplitude [nu]'}, 'FontSize',25, 'FontWeight','bold')
set (gca,'ylim',ylim);
set (gca,'xlim',xlim);
grid on


subplot(1,2,2)

col = [linspace(0,0,24);linspace(0,0,24);linspace(0,0,24)]';

% boxplot for all subjects
bh2 = boxplot([LLRGroup2Subj(:,3),LLRGroup2Subj(:,4),LLRGroup2Subj(:,5),...
    LLRGroup2Subj(:,1),LLRGroup2Subj(:,2)],...
    'Positions',position,'Symbol','','Color','b');
set(bh2,'LineWidth', 2);

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    p2 = patch(get(h(j),'XData'),get(h(j),'YData'),'b','FaceAlpha',.1);
end

hold on


for s = 13:24
hold all
% box plot of all reps for that subject
scatter([1:5],[avgLLRALLSubjMatrix(3,s), avgLLRALLSubjMatrix(4,s), avgLLRALLSubjMatrix(5,s),...
    avgLLRALLSubjMatrix(1,s), avgLLRALLSubjMatrix(2,s)],30,col(s,:),'filled','jitter','on', 'jitterAmount',0.1);
set (gca,'xTickLabel','');
set (gca,'yTickLabel','');
set (gca,'FontSize',18);
title('','FontSize',26)
xticks ([1:5]);
yticks ([0:2:12]);
grid on;
end

sigline([3 5],[],10);sigline([4 5],[],9)

set(gca,'TickLabelInterpreter', 'tex');
xticklabels({'T_1','T_2','T_3','BackOnly','PertOnly',});
xlabel('TMS Mode','FontSize',26)
yticklabels([0:2:12]);
ylabel({''}, 'FontSize',25, 'FontWeight','bold')
set (gca,'ylim',ylim);
set (gca,'xlim',xlim);
grid on

legend([p1,p2],'90% AMT','95% AMT','location','northwest')




%%

% Plotting LLR effects for 1 subject

% col = [0 0 1]';
col = [linspace(0,0.8,nReps);linspace(0,0.8,nReps);linspace(1,1,nReps)]';
ylim = [-0.25 9];
xlim = [0.5 5.5];
position = [1:5];

% group 1 90%
fig = figure('units', 'pixels', 'Position', [250 100 900 650]);
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.07], [0.105 0.105], [0.08 0.05]);

s = 1; % subject index here

subplot(1,1,1)
hold all

% plot all reps for that subject
plot([1:5],[LLRGroup1SubjRepT1(:,s) LLRGroup1SubjRepT2(:,s) ...
    LLRGroup1SubjRepT3(:,s) LLRGroup1SubjRepPoff(:,s)...
    LLRGroup1SubjRepToff(:,s)],'*','LineWidth',1.5);
set (gca,'xTickLabel','');
set (gca,'yTickLabel','');
set (gca, 'ColorOrder',col);
set (gca,'FontSize',22);
title('Subject Level - subTMS Effect','FontSize',26)
ylabel('LLR Amplitude [nu]','FontSize',22,'FontWeight','Bold');
xticks ([1:5]);
yticks ([0:2:8]);
grid on;

% box plot of all reps for that subject
bh = boxplot([LLRGroup1SubjRepT1(:,s) LLRGroup1SubjRepT2(:,s)...
    LLRGroup1SubjRepT3(:,s) LLRGroup1SubjRepPoff(:,s)...
    LLRGroup1SubjRepToff(:,s)],'Positions',position,'Symbol','','Color','k');
set(bh,'LineWidth', 2);
hold on

sigline([4 5],[],6);sigline([3 5],[],7);

set(gca,'TickLabelInterpreter', 'tex');
xticklabels({'T_1','T_2', 'T_3', 'BackOnly','PertOnly'});
yticklabels([0:2:8]);
set (gca,'ylim',ylim);
set (gca,'xlim',xlim);













