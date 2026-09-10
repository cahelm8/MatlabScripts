

clc
clear
close all

dataTablePath = ['Z:\StudentFolders\Cody\Projects\TMS\Statistical Analysis\Group Level Analysis']; %<- change this if data table is stored somewhere else
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(dataTablePath));
addpath(genpath(processingPath));

LLRAllSubjDataTab = xlsread('llr-avg-group-level-ALLSubjects_20221206.xlsx','D2:D2401');

[~,conditions] = xlsread('llr-avg-group-level-ALLSubjects_20221206.xlsx','F2:F2401');
cond1Idx = (find(strcmp(conditions,'T off-P off')));
cond2Idx = (find(strcmp(conditions,'T off-P on')));
cond3Idx = (find(strcmp(conditions,'T1')));
cond4Idx = (find(strcmp(conditions,'T2')));
cond5Idx = (find(strcmp(conditions,'T3')));

LLRAllSubjT1 = LLRAllSubjDataTab(cond3Idx);
LLRAllSubjT2 = LLRAllSubjDataTab(cond4Idx);
LLRAllSubjT3 = LLRAllSubjDataTab(cond5Idx);

% 90 group 1
nSubj1 = 12;
LLRGroup1SubjT1 = LLRAllSubjT1(1:(20*nSubj1));
LLRGroup1SubjT2 = LLRAllSubjT2(1:(20*nSubj1));
LLRGroup1SubjT3 = LLRAllSubjT3(1:(20*nSubj1));

LLRGroup1SubjectTabT1 = reshape(LLRGroup1SubjT1,20,nSubj1);
LLRGroup1SubjectTabT2 = reshape(LLRGroup1SubjT2,20,nSubj1);
LLRGroup1SubjectTabT3 = reshape(LLRGroup1SubjT3,20,nSubj1);


% 95 group 2
nSubj2 = 12;
LLRGroup2SubjT1 = LLRAllSubjT1(((20*nSubj1)+1):end);
LLRGroup2SubjT2 = LLRAllSubjT2(((20*nSubj1)+1):end);
LLRGroup2SubjT3 = LLRAllSubjT3(((20*nSubj1)+1):end);

LLRGroup2SubjectTabT1 = reshape(LLRGroup2SubjT1,20,nSubj2);
LLRGroup2SubjectTabT2 = reshape(LLRGroup2SubjT2,20,nSubj2);
LLRGroup2SubjectTabT3 = reshape(LLRGroup2SubjT3,20,nSubj2);

%%
close all
% Plotting
% group 1 90%
figure(1)
subplot(2,1,1)
boxplot ([LLRGroup1SubjectTabT1 LLRGroup1SubjectTabT2 LLRGroup1SubjectTabT3],'Positions',[1:12 3+[13:24] 6+[25:36]],'PlotStyle','Compact','Symbol','','Color','rgbcmykrgbcm');
set (gca,'ylim',[-2 14]);
set (gca,'xTickLabel','');
grid on;
set (gca,'xlim',[-2 45]);
xticks ([6.5 21.5 36.5]);
xticklabels ({'T_1','T_2','T_3'});
ylabel ('LLRa [nu]');
set (gca,'FontSize',16);
title('Group 1 Subject Analysis')

subplot(2,1,2)
boxplot ([LLRGroup2SubjectTabT1 LLRGroup2SubjectTabT2 LLRGroup2SubjectTabT3],'Positions',[1:12 3+[13:24] 6+[25:36]],'PlotStyle','Compact','Symbol','','Color','rgbcmykrgbcm');
set (gca,'ylim',[-2 40]);
set (gca,'xTickLabel','');
grid on;
set (gca,'xlim',[-2 33]);
xticks ([4.5 15.5 26.5]);
xticklabels ({'T_1','T_2','T_3'});
ylabel ('LLRa [nu]');
set (gca,'FontSize',16);
title('Group 2 Subject Analysis')




%%

%addpath ('Violinplot-Matlab-master');

% T1 = horzcat(AllSubData(41:60), AllSubData(741:760), AllSubData(141:160), AllSubData(241:260), AllSubData(341:360), AllSubData (441:460), AllSubData(541:560), AllSubData(641:660));
% T2 = horzcat(AllSubData(61:80), AllSubData(761:780), AllSubData(161:180), AllSubData(261:280), AllSubData(361:380), AllSubData (461:480), AllSubData(561:580), AllSubData(661:680));
% T3 = horzcat(AllSubData(81:100), AllSubData(781:800), AllSubData(181:200), AllSubData(281:300), AllSubData(381:400), AllSubData (481:500), AllSubData(581:600), AllSubData(681:700));

% boxplot ([T1 T2 T3],'Positions',[1:8 3+[9:16] 6+[16:23]],'PlotStyle','Compact','Symbol','','Color','rrgbmckk');
% set (gca,'ylim',[-1 1.5]);
% set (gca,'xTickLabel','');
% grid on;
% set (gca,'xlim',[0 30]);
% xticks ([4.5 16.5 26.5]);
% xticklabels ({'T_1','T_2','T_3'});
% ylabel ('LLRa [nu]');
% set (gca,'FontSize',16);
%hLegend = legend(findall(gca,'Tag','Box'), {'S1 - Rep1','S1 - Rep2', 'S2','S3','S4','S5','S6 - Rep 1','S6 - Rep2'},'Location','NorthEast');

% violin ([T1 T2 T3],'faceColor',[0 1 0]');
% set (gca,'ylim',[-1 1.5]);
% set (gca,'xTickLabel','');
% grid on;
% set (gca,'xlim',[0 30]);
% xticks ([4.5 16.5 26.5]);
% xticklabels ({'T_1','T_2','T_3'});
% ylabel ('LLRa [nu]');
% set (gca,'FontSize',16);

% figure;
% violinplot ([T1 T2 T3],[],'ShowData',false);