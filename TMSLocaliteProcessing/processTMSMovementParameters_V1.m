
% loading, processing, and analyzing TMS experiments marker locations

clc
clear all
close all

processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(processingPath));

processingScriptsPath = [processingPath '\ProcessingScripts'];
addpath(genpath(processingScriptsPath));

FigurePath = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\'...
    'Figs4Paper_R3\TMSExp4\Subject_Specific\'];


%% Load in target and entry marker locations for each participant

TMSExcelPath = ['Z:\StudentFolders\Cody\Projects\TMS\Dataset\LocaliteSessions\TMS-Exp4-Group\TMS-P06\'];
addpath(genpath(TMSExcelPath))

which(['20250630 - HeadMovementControl.xlsx'])

excelFilePath1 = [which(['20250630 - HeadMovementControl.xlsx'])];

TMSHeadMoveTable1 = xlsread([excelFilePath1]);
T1 = array2table(TMSHeadMoveTable1);

contrParameters = double(T1{1:end,3:5});
contrParamChange = double(T1{1:end-1,8:10});

%%

sID = 6; % enter in the subject ID

close all
figure('Position',[300 100 1100 500])

subplot(1,2,1)
plot(contrParameters(:,:),'LineWidth',2.5)
colororder(gca,'sail')
hold on
xlabel('Sample')
ylabel('Parameter')
set(gca, 'FontSize',20)
title('Head Movement Parameters')

legend('\alpha','\beta','\delta','location','best')

subplot(1,2,2)
plot(contrParamChange(:,:),'LineWidth',2.5)
colororder(gca,'sail')
hold on
xlabel('Sample')
ylabel('Parameter')
set(gca, 'FontSize',20)
title('Head Movement Change')

fileName = ['Localite_'  'P0' num2str(sID) '_HeadMovementControl'];

saveas(gcf, [FigurePath 'P0' num2str(sID) '\Localite\' fileName '.png'])



%%
