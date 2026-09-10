clc
clear
close all

% Plotting TMS subject level stats analysis summary/graphic

% load in combined stats output JMP table for all subjects

dataTablePath = ['Z:\StudentFolders\Cody\Projects\TMS\Statistical Analysis'...
    '\Group Level Analysis\CHDec052022']; %<- change this if data table is stored somewhere else
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(dataTablePath));
addpath(genpath(processingPath));

% Load in subject order
subjectIds = xlsread('LLRSubjectLevelCombinedStatsAnalysisDataTable.xlsx','B2:B97');

% load in LLR condition indexes and assign for each condition
[~,conditions] = xlsread('LLRSubjectLevelCombinedStatsAnalysisDataTable.xlsx','E2:E97');

% Subject level stats analysis table
LLRAllSubjZscore = xlsread('LLRSubjectLevelCombinedStatsAnalysisDataTable.xlsx','I2:I97');

% Subject level stats p-valyue
LLRAllSubjpVal = xlsread('LLRSubjectLevelCombinedStatsAnalysisDataTable.xlsx','J2:J97');


cond1Idx = (find(strcmp(conditions,'T1')));
cond2Idx = (find(strcmp(conditions,'T2')));
cond3Idx = (find(strcmp(conditions,'T3')));
cond4Idx = (find(strcmp(conditions,'T off-P off')));

nSubj1 = 12;
nSubj2 = 12;
nReps = 20;

LLRAllSubjT1 = LLRAllSubjZscore(cond1Idx);
LLRAllSubjT2 = LLRAllSubjZscore(cond2Idx);
LLRAllSubjT3 = LLRAllSubjZscore(cond3Idx);
LLRAllSubjToffPoff = LLRAllSubjZscore(cond4Idx);

LLRAllSubjpValT1 = LLRAllSubjpVal(cond1Idx);
LLRAllSubjpValT2 = LLRAllSubjpVal(cond2Idx);
LLRAllSubjpValT3 = LLRAllSubjpVal(cond3Idx);
LLRAllSubjpValToffPoff = LLRAllSubjpVal(cond4Idx);

% all groups
% in order from subject 1 to subject 24
% cond (T1, T2, T3, ToffPoff
zScores = [LLRAllSubjT1 LLRAllSubjT2 LLRAllSubjT3 LLRAllSubjToffPoff];
zScores = -1*zScores;

pvalues = [LLRAllSubjpValT1 LLRAllSubjpValT2 LLRAllSubjpValT3 LLRAllSubjpValToffPoff];

group = {'90%','95%'};
zsteps = 200;
psteps = 20;

str = split(num2str(1:24'));
subjStr = strcat('S',str);
qValue = 2.43; % threshold value
pThres = 0.05; % p value threshold

%% Plot Subject Level Stats - Z scores
% Plotting subject Stats

% for all groups
fig = figure('units', 'pixels', 'Position', [300 100 800 650]);
% subplot = @(m,n,p) subtightplot(m,n,p,[0.03 0.03], [0.105 0.105], [0.08 0.05]);
% sgtitle('90% Group - Subject Level','FontSize',18)

imagesc((zScores))
hold on
set(gca,'TickLength',[0 0],'XTick',[1:4],'YTick',[1:24], 'YTickLabel',...
    [subjStr],'XTickLabel',{'T_{1}','T_{2}','T_{3}','BackOnly'},'FontSize',15);
colormap([[0 linspace(1,0,zsteps)]',[0 linspace(1,0.85,zsteps)]',[0 linspace(1,0,zsteps)]'])
caxis([qValue max((zScores(:)))]);
colorbar
title('Subject Level T-ratio','FontSize',18)

% Add in grid lines
xrange = [1 4];
yrange = [1 24];
dx = diff(xrange)/(4-1);
dy = diff(yrange)/(24-1);
xg = linspace(xrange(1)-dx/2,xrange(2)+dx/2,4+1);
yg = linspace(yrange(1)-dy/2,yrange(2)+dy/2,24+1);

hm = mesh(xg,yg,zeros(size(zScores)+1),'FaceColor','none','EdgeColor','k',...
    'LineWidth',2);


%% By Group Plotting
% Plotting subject Stats

% for all groups
fig = figure('units', 'pixels', 'Position', [300 100 1000 650]);
subplot = @(m,n,p) subtightplot(m,n,p,[0.05 0.1], [0.105 0.105], [0.1 0.06]);
% sgtitle('90% Group - Subject Level','FontSize',18)

for g = 1:2
    subplot(1,2,g)
    imagesc((zScores(12*g-11:12*g,:)))
    hold on
    set(gca,'TickLength',[0 0],'XTick',[1:4],'YTick',[1:12], 'YTickLabel',...
        [subjStr(12*g-11:12*g)],'XTickLabel',{'T_{1}','T_{2}','T_{3}','BackOnly'},'FontSize',15);
    colormap([[0 linspace(1,0,zsteps)]',[0 linspace(1,0.85,zsteps)]',[0 linspace(1,0,zsteps)]'])
    caxis([qValue max((zScores(:)))]);
    colorbar
    title(['(' group{g} ') ' 'Subject Level T-ratio'],'FontSize',18)

% Add in grid lines
    xrange = [1 4];
    yrange = [1 12];
    dx = diff(xrange)/(4-1);
    dy = diff(yrange)/(12-1);
    xg = linspace(xrange(1)-dx/2,xrange(2)+dx/2,4+1);
    yg = linspace(yrange(1)-dy/2,yrange(2)+dy/2,12+1);

    hm = mesh(xg,yg,zeros(size(zScores(1:12,:))+1),'FaceColor','none','EdgeColor','k',...
        'LineWidth',2);

end



%% By Group Plotting - P values
% Plotting subject Stats

% for all groups
fig = figure('units', 'pixels', 'Position', [300 100 1000 650]);
subplot = @(m,n,p) subtightplot(m,n,p,[0.05 0.1], [0.105 0.105], [0.1 0.06]);
% sgtitle('90% Group - Subject Level','FontSize',18)

for g = 1:2
    subplot(1,2,g)
    imagesc((pvalues(12*g-11:12*g,:)))
    hold on
    set(gca,'TickLength',[0 0],'XTick',[1:4],'YTick',[1:12], 'YTickLabel',...
        [subjStr(12*g-11:12*g)],'XTickLabel',{'T_{1}','T_{2}','T_{3}','BackOnly'},'FontSize',15);
    colormap([[linspace(0,1,psteps) 0]',[linspace(0.85,1,psteps) 0]',[linspace(0,1,psteps) 0]'])
    caxis([0 pThres]);
    colorbar
    title(['(' group{g} ') ' 'Subject Level P-values'],'FontSize',18)

% Add in grid lines
    xrange = [1 4];
    yrange = [1 12];
    dx = diff(xrange)/(4-1);
    dy = diff(yrange)/(12-1);
    xg = linspace(xrange(1)-dx/2,xrange(2)+dx/2,4+1);
    yg = linspace(yrange(1)-dy/2,yrange(2)+dy/2,12+1);

    hm = mesh(xg,yg,zeros(size(pvalues(1:12,:))+1),'FaceColor','none','EdgeColor','k',...
        'LineWidth',2);

end




%%

aboveThres = (zScores)>=qValue;
aboveThresCond = sum(aboveThres,1)

k = [[(zScores)-qValue]<0.08].*[[(zScores)-qValue]>0];
find(sum(k,2));


abovePthres = (pvalues)<=pThres;
abovePthresCond = sum(abovePthres,1)


%%













