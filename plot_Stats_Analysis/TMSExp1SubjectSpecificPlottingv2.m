clc
clear
close all

% load in LLRa data for all subjects

dataTablePath = ['Z:\StudentFolders\Cody\Projects\TMS\Statistical Analysis\'...
    'Group Level Analysis']; %<- change this if data table is stored somewhere else
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
nConds = 5;

LLRAllPoff = LLRAllSubjDataTab(cond1Idx); % 480 by 1
LLRAllToff = LLRAllSubjDataTab(cond2Idx); % 480 by 1
LLRAllT1 = LLRAllSubjDataTab(cond3Idx); % 480 by 1
LLRAllT2 = LLRAllSubjDataTab(cond4Idx); % 480 by 1
LLRAllT3 = LLRAllSubjDataTab(cond5Idx);



% 90 group 1
LLRGroup1Poff = LLRAllPoff(1:(nReps*nSubj1)); % 240 by 1
LLRGroup1Toff = LLRAllToff(1:(nReps*nSubj1));
LLRGroup1T1 = LLRAllT1(1:(nReps*nSubj1));
LLRGroup1T2 = LLRAllT2(1:(nReps*nSubj1));
LLRGroup1T3 = LLRAllT3(1:(nReps*nSubj1)); 

LLRGroup1 = [LLRGroup1T1;LLRGroup1T2;LLRGroup1T3;LLRGroup1Poff;LLRGroup1Toff];

LLRGroup1Mat = reshape(LLRGroup1, nReps, nSubj1, nConds);

LLRGroup1TabPoff = reshape(LLRGroup1Poff,nReps,nSubj1); %20 by 12
LLRGroup1TabToff = reshape(LLRGroup1Toff,nReps,nSubj1); % 20 by 12
LLRGroup1TabT1 = reshape(LLRGroup1T1,nReps,nSubj1); % 20 by 12
LLRGroup1TabT2 = reshape(LLRGroup1T2,nReps,nSubj1); % 20 by 12
LLRGroup1TabT3 = reshape(LLRGroup1T3,nReps,nSubj1); % 20 by 12



% 95 group 2
LLRGroup2Poff = LLRAllPoff(((nReps*nSubj1)+1):end); % 240
LLRGroup2Toff = LLRAllToff(((nReps*nSubj1)+1):end); % 240
LLRGroup2T1 = LLRAllT1(((nReps*nSubj1)+1):end);
LLRGroup2T2 = LLRAllT2(((nReps*nSubj1)+1):end);
LLRGroup2T3 = LLRAllT3(((nReps*nSubj1)+1):end); 

LLRGroup2 = [LLRGroup2T1;LLRGroup2T2;LLRGroup2T3;LLRGroup2Poff;LLRGroup2Toff];

LLRGroup2Mat = reshape(LLRGroup2, nReps, nSubj2, nConds);


LLRGroup2TabPoff = reshape(LLRGroup2Poff,nReps,nSubj2); % 20 by 12
LLRGroup2TabToff = reshape(LLRGroup2Toff,nReps,nSubj2); % 20 by 12
LLRGroup2TabT1 = reshape(LLRGroup2T1,nReps,nSubj2);
LLRGroup2TabT2 = reshape(LLRGroup2T2,nReps,nSubj2);
LLRGroup2TabT3 = reshape(LLRGroup2T3,nReps,nSubj2);



%%

% Plotting subject LLRa
% col = [{'r','g','b','c','m','y','k','r','g','b','c','m'}];
% ylim = [-2 11];
% xlim = [0.75 5.25];
% position = [1:5];
% 
% % group 1 90%
% fig = figure('units', 'pixels', 'Position', [200 100 1100 650]);
% subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.04], [0.105 0.105], [0.08 0.05]);
% sgtitle('90% Group - Subject Level','FontSize',18)
% 
% for s = 1:nSubj1
% sp(s) = subplot(3,4,s);
% hold on
% boxplot ([LLRGroup1TabT1(:,s) LLRGroup1TabT2(:,s) LLRGroup1TabT3(:,s)...
%     LLRGroup1SubTabPoff(:,s) LLRGroup1TabToff(:,s)],...
%     'Positions',position,'PlotStyle','compact','Symbol','','Color',col{s});
% set (gca,'ylim',ylim);
% set (gca,'xlim',xlim);
% set (gca,'xTickLabel','');
% set (gca,'yTickLabel','');
% xticks ([1:5]);
% yticks ([0:5:10]);
% grid on;
% end
% set (sp(:),'FontSize',15);
% xticklabels(sp(9:12),{'T_1','T_2','T_3','NoPTB','PTB'});
% yticklabels(sp([1,5,9]),[0:5:10]);
% slY = suplabel(' \rm LLRa [nu]', 'y' ,[.07 .090 .84 .84]);
% slY.FontSize = 18;
% 
% 
% % group 2 95%
% figure('units', 'pixels', 'Position', [200 100 1100 650])
% subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.04], [0.105 0.105], [0.08 0.05]);
% sgtitle('95% Group - Subject Level','FontSize',18)
% 
% for s = 1:nSubj2
% sp(s) = subplot(3,4,s);
% hold on
% boxplot ([LLRGroup2SubjectTabT1(:,s) LLRGroup2TabT2(:,s) LLRGroup2TabT3(:,s)...
%     LLRGroup2TabPoff(:,s) LLRGroup2TabToff(:,s)]...
%     ,'Positions', position,'PlotStyle','compact','Symbol','','Color',col{s});
% set (gca,'ylim',[ylim]);
% set (gca,'xlim',[xlim]);
% set (gca,'yTickLabel','');
% set (gca,'xTickLabel','');
% xticks ([1:5]);
% yticks ([0:5:10]);
% grid on;
% end
% set (sp(:),'FontSize',15);
% xticklabels(sp(9:12),{'T_1','T_2','T_3','NoPTB','PTB'});
% yticklabels(sp([1,5,9]),[0:5:10]);
% slY = suplabel(' \rm LLRa [nu]', 'y' ,[.075 .075 .84 .84]);
% slY.FontSize = 18;


%% Plot LLR data for each subject and subject steel with control significance
close all

% Plotting subject LLRa
col = [linspace(0,0.1,12)' linspace(0,0.1,12)' linspace(0,1,12)'];
col = turbo(12);

position = [1:5];

group1Sig = [0 0 3 4;1 0 0 4;0 0 3 0;1 2 3 4;1 2 0 4;0 0 3 4;1 0 3 4;...
    0 0 3 4;0 0 0 4;1 2 3 4;0 0 0 4;0 0 0 4];

% group 1 90%
fig = figure('units', 'pixels', 'Position', [100 100 1250 650]);
subplot = @(m,n,p) subtightplot(m,n,p,[0.034 0.03], [0.12 0.105], [0.08 0.02]);
sgtitle('90% Group - Subject Level','FontSize',25)

for s = 1:nSubj1
    
sp(s) = subplot(3,4,s);

hold on

swarmchart(repelem([position],1,20), [LLRGroup1TabT1(:,s)' LLRGroup1TabT2(:,s)' LLRGroup1TabT3(:,s)'...
    LLRGroup1TabPoff(:,s)' LLRGroup1TabToff(:,s)'],'MarkerEdgeColor',col(s,:),...
    'MarkerFaceColor',col(s,:))

hold on

boxplot ([LLRGroup1TabT1(:,s) LLRGroup1TabT2(:,s) LLRGroup1TabT3(:,s)...
    LLRGroup1TabPoff(:,s) LLRGroup1TabToff(:,s)],...
    'Positions',position,'PlotStyle','traditional',...
    'Symbol','','Color',col(s,:));

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),get(h(j),'Color'),'FaceAlpha',0.60);
end

lowLim = min([LLRGroup1TabT1(:,s);LLRGroup1TabT2(:,s);LLRGroup1TabT3(:,s);...
    LLRGroup1TabPoff(:,s);LLRGroup1TabToff(:,s)]);
upLim = max([LLRGroup1TabT1(:,s);LLRGroup1TabT2(:,s);LLRGroup1TabT3(:,s);...
    LLRGroup1TabPoff(:,s);LLRGroup1TabToff(:,s)]);

ylim = [0 10];
xlim = [0.5 5.50];

xticks ([1:5]);
yticks ([0 5 10]);

set (gca,'ylim',ylim);
set (gca,'xlim',xlim);

set (gca,'xTickLabel','');
set (gca,'yTickLabel','');

set(gca,'TickLabelInterpreter', 'tex');

grid on;

if s == 1
    sigline([3 5],[],upLim + 2)
    sigline([4 5],[],upLim + 1)
elseif s == 2
    sigline([1 5],[],upLim + 1.75)
    sigline([4 5],[],upLim + 1)
elseif s == 3
    sigline([3 5],[],upLim + 1)
elseif s == 4
    sigline([1 5],[],upLim + 2.5)
    sigline([2 5],[],upLim + 1.75)
    sigline([3 5],[],upLim + 1)
    sigline([4 5],[],upLim + 0.25)
elseif s == 5
    sigline([1 5],[],upLim + 2)
    sigline([2 5],[],upLim + 1.25)
    sigline([4 5],[],upLim + 0.5)
elseif s == 6
    sigline([3 5],[],upLim + 1.25)
    sigline([4 5],[],upLim + 0.5)
elseif s == 7
    sigline([1 5],[],upLim + 2)
    sigline([3 5],[],upLim + 1.25)
    sigline([4 5],[],upLim + 0.5)
elseif s == 8
    sigline([3 5],[],upLim + 1.75)
    sigline([4 5],[],upLim + 1)
elseif s == 9
    sigline([4 5],[],upLim + 0.25)
elseif s == 10
    sigline([1 5],[],upLim + 2.75)
    sigline([2 5],[],upLim + 2)
    sigline([3 5],[],upLim + 1.25)
    sigline([4 5],[],upLim + 0.5)
elseif s == 11
    sigline([4 5],[],upLim + 1)
elseif s == 12
    sigline([4 5],[],upLim + 1)
end



end

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth',2);

% set(sp([2 3 8]), 'ylim', [0 6], 'yTickLabel', [0:2:6], 'yTick', [0:2:6])
set(sp([2 3 6 8]), 'ylim', [0 8], 'yTickLabel', [0:2:8], 'yTick', [0:2:8])
set(sp([1 4 5 7 10]), 'ylim', [0 10], 'yTickLabel', [0:2:10], 'yTick', [0:2:10])
set(sp([9 11 12]), 'ylim', [0 15], 'yTickLabel', [0:5:15], 'yTick', [0:5:15])
set(sp([12]), 'ylim', [0 20], 'yTickLabel', [0:5:20], 'yTick', [0:5:20])

set (sp(:),'FontSize',18);
set( sp(9:12), 'xTickLabel', {'T_1','T_2','T_3','Back','Pert'}, 'FontSize',18);
%xticklabels(sp(9:12),{'T_1','T_2','T_3','BackOnly','PertOnly'});
slY = suplabel(' \rm LLRa [n.u.]', 'y' ,[.100 .09 .84 .84]);
slY.FontSize = 25;
slY.FontWeight = 'bold';

slX = suplabel(' \rm TMS Mode', 'x' ,[.08 .145 .84 .84]);
slX.FontSize = 25;
slX.FontWeight = 'bold';


%%%%%%%%%%%%



% group 2 95%
figure('units', 'pixels', 'Position', [100 100 1250 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.034 0.03], [0.12 0.105], [0.08 0.02]);
sgtitle('95% Group - Subject Level','FontSize',25)

group2Sig = [1 2 3 4;0 0 3 0;0 0 0 4;1 0 0 4;1 2 3 4;0 0 0 4;0 2 0 4;...
    0 0 3 4;0 0 3 4;0 2 3 4;1 2 3 4;0 0 3 0];

for s = 1:nSubj2
sp(s) = subplot(3,4,s);

hold on

swarmchart(repelem([position],1,20), [LLRGroup2TabT1(:,s)' LLRGroup2TabT2(:,s)' LLRGroup2TabT3(:,s)'...
    LLRGroup2TabPoff(:,s)' LLRGroup2TabToff(:,s)'],'MarkerEdgeColor',col(s,:),...
    'MarkerFaceColor',col(s,:))

hold on

boxplot ([LLRGroup2TabT1(:,s) LLRGroup2TabT2(:,s) LLRGroup2TabT3(:,s)...
    LLRGroup2TabPoff(:,s) LLRGroup2TabToff(:,s)]...
    ,'Positions', position,'PlotStyle','traditional','Symbol','',...
    'Color',col(s,:));

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),get(h(j),'Color'),'FaceAlpha',0.75);
end

lowLim = min([LLRGroup2TabT1(:,s);LLRGroup2TabT2(:,s);LLRGroup2TabT3(:,s);...
    LLRGroup2TabPoff(:,s);LLRGroup2TabToff(:,s)]);
upLim = max([LLRGroup2TabT1(:,s);LLRGroup2TabT2(:,s);LLRGroup2TabT3(:,s);...
    LLRGroup2TabPoff(:,s);LLRGroup2TabToff(:,s)]);

ylim = [0 10];
xlim = [0.50 5.50];

set (gca,'ylim',[ylim]);
set (gca,'xlim',[xlim]);

set(gca,'TickLabelInterpreter', 'tex');

set (gca,'yTickLabel','');
set (gca,'xTickLabel','');
xticks ([1:5]);
yticks ([0 5 10]);
grid on;

if s == 1
    sigline([1 5],[],upLim + 1.75)
    sigline([2 5],[],upLim + 1.25)
    sigline([3 5],[],upLim + 0.75)
    sigline([4 5],[],upLim + 0.25)
elseif s == 2
    sigline([3 5],[],upLim + 1)
elseif s == 3
    sigline([4 5],[],upLim + 0)
elseif s == 4
    sigline([1 5],[],upLim + 1)
    sigline([4 5],[],upLim + 0.25)
elseif s == 5
    sigline([1 5],[],upLim + 2.75)
    sigline([2 5],[],upLim + 2)
    sigline([3 5],[],upLim + 1.25)
    sigline([4 5],[],upLim + 0.5)
elseif s == 6
    sigline([4 5],[],upLim + 0.5)
elseif s == 7
    sigline([2 5],[],upLim + 1)
    sigline([4 5],[],upLim + 0)
elseif s == 8
    sigline([3 5],[],upLim + 1.75)
    sigline([4 5],[],upLim + 1)
elseif s == 9
    sigline([3 5],[],upLim + 1.50)
    sigline([4 5],[],upLim + 0.5)
elseif s == 10
    sigline([2 5],[],upLim + 2)
    sigline([3 5],[],upLim + 1.25)
    sigline([4 5],[],upLim + 0.5)
elseif s == 11
    sigline([1 5],[],upLim + 2.25)
    sigline([2 5],[],upLim + 1.5)
    sigline([3 5],[],upLim + 0.75)
    sigline([4 5],[],upLim + 0)
elseif s == 12
    sigline([3 5],[],upLim + 1.25)
end


end

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth',2);

set(sp(3), 'ylim', [0 20], 'yTickLabel', [0:5:20], 'yTick', [0:5:20])
set(sp([1 2 6 8 10 12]), 'ylim', [0 6], 'yTickLabel', [0:2:6], 'yTick', [0:2:6])
% set(sp([5 7]), 'ylim', [0 8], 'yTickLabel', [0:2:8], 'yTick', [0:2:8])
set(sp([4 5 7 9 11]), 'ylim', [0 10], 'yTickLabel', [0:2:10], 'yTick', [0:2:10])

set (sp(:),'FontSize',18);
set(sp(9:12), 'xTickLabel', {'T_1','T_2','T_3','Back','Pert'}, 'FontSize',18);
%xticklabels(sp(9:12),{'T_1','T_2','T_3','BackOnly','PertOnly'});
slY = suplabel(' \rm LLRa [n.u.]', 'y' ,[.10 .090 .84 .84]);
slY.FontSize = 25;
slY.FontWeight = 'bold';

slX = suplabel(' \rm TMS Mode', 'x' ,[.080 .145 .84 .84]);
slX.FontSize = 25;
slX.FontWeight = 'bold';


%% Combine both groups into one figure and label with subject ID

% Plotting subject LLRa
% col = [{'r','g','b','c','m','y','k','r','g','b','c','m'}];
% ylim = [-2 11];
% xlim = [0.75 5.25];
% position = [1:5];
% 
% % group 1 90%
% fig = figure('units', 'pixels', 'Position', [100 50 1300 700]);
% subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.04], [0.105 0.105], [0.08 0.05]);
% sgtitle('Subject Specific Plotting','FontSize',18)
% 
% for s = 1:nSubj1
% sp(s) = subplot(6,4,s);
% hold on
% boxplot ([LLRGroup1TabT1(:,s) LLRGroup1TabT2(:,s) LLRGroup1TabT3(:,s)...
%     LLRGroup1TabPoff(:,s) LLRGroup1TabToff(:,s)],...
%     'Positions',position,'PlotStyle','compact','Symbol','','Color',col{s});
% set (gca,'ylim',ylim);
% set (gca,'xlim',xlim);
% set (gca,'xTickLabel','');
% set (gca,'yTickLabel','');
% xticks ([1:5]);
% yticks ([0:5:10]);
% grid on;
% end
% set (sp(:),'FontSize',15);
% %xticklabels(sp(9:12),{'T_1','T_2','T_3','NoPTB','PTB'});
% yticklabels(sp([1,5,9]),[0:5:10]);
% slY = suplabel(' \rm LLRa [nu]', 'y' ,[.07 .090 .84 .84]);
% slY.FontSize = 18;
% 
% for s = 1:nSubj2
% sp(s) = subplot(6,4,12+s);
% hold on
% boxplot ([LLRGroup2TabT1(:,s) LLRGroup2TabT2(:,s) LLRGroup2TabT3(:,s)...
%     LLRGroup2TabPoff(:,s) LLRGroup2TabToff(:,s)]...
%     ,'Positions', position,'PlotStyle','compact','Symbol','','Color',col{s});
% set (gca,'ylim',[ylim]);
% set (gca,'xlim',[xlim]);
% set (gca,'yTickLabel','');
% set (gca,'xTickLabel','');
% xticks ([1:5]);
% yticks ([0:5:10]);
% grid on;
% end
% set (sp(:),'FontSize',15);
% xticklabels(sp(9:12),{'T_1','T_2','T_3','Back','Pert'});
% yticklabels(sp([1,5,9]),[0:5:10]);
% slY = suplabel(' \rm LLRa [nu]', 'y' ,[.075 .075 .84 .84]);
% slY.FontSize = 18;

%% Combine both groups into one figure on one plot

ylim = [-2 15];
xlim = [0 58];

% Plotting
% group 1 90%
fig = figure('units', 'pixels', 'Position', [100 50 1300 700]);
subplot = @(m,n,p) subtightplot(m,n,p,[0.08 0.04], [0.105 0.105], [0.05 0.05]);

subplot(2,1,1)
boxplot ([LLRGroup1TabT1 LLRGroup1TabT2 LLRGroup1TabT3 LLRGroup1TabToff],...
    'Positions',[1:12 3+[13:24] 6+[25:36] 9+[37:48]],'PlotStyle','Compact','Symbol','',...
    'Color','rgbcmykrgbcm');
set (gca,'ylim',ylim);
set (gca,'xlim',xlim);
set (gca,'xTickLabel','');

set (gca,'FontSize',16);
title('90% AMT Group - Subject Level')
xticks ([6.5 21.5 36.5 51.5]);
% xticklabels ({'T_1','T_2','T_3'});
ylabel ('LLRa [nu]');
grid on;

subplot(2,1,2)
boxplot ([LLRGroup2TabT1 LLRGroup2TabT2 LLRGroup2TabT3 LLRGroup2TabToff],...
    'Positions',[1:12 3+[13:24] 6+[25:36] 9+[37:48]],'PlotStyle','Compact','Symbol','',...
    'Color','rgbcmykrgbcm');
set (gca,'ylim',ylim);
set (gca,'xlim',xlim);
set (gca,'xTickLabel','');

set (gca,'FontSize',16);
title('95% AMT Group - Subject Level')
xticks ([6.5 21.5 36.5 51.5]);
xticklabels ({'T_1','T_2','T_3','PertOnly'});
ylabel ('LLRa [nu]');
grid on;


%%













