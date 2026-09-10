

% TMS Experiment 1 Group Level Analysis Plotting

close all
clc
clear

dataTablePath = ['Z:\StudentFolders\Cody\Projects\TMS\Statistical Analysis\Subject Level Analysis']; %<- change this if data table is stored somewhere else
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(dataTablePath));
addpath(genpath(processingPath));

%plotting Scripts
plottingPath = 'Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts';
addpath(genpath(plottingPath));


   
%% Exp 1 Method 1 - 90% Group
estPar = [2.5346013	0.41609911;
2.2610846	0.41617492;
1.9085877	0.41617687;
3.2682444	0.41609912];
  
%Plot     
figure('units', 'inches', 'Position', [50 50 8 6])
set(gcf, 'WindowState','maximized')
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.04], [0.105 0.085], [0.105 0.015]);
offset  = 0.05;


subplot(1,2,1)
xVec = (1:4);
plot(xVec, estPar(1:4,1),'rd', 'MarkerSize', 6, 'MarkerFaceColor', 'r' ); hold on
p(1) = errorbar(xVec, estPar(1:4,1), 1.96*estPar(1:4,2), '--r', 'LineWidth', 1.5);
sigline([1 1],[],4);sigline([2 2],[],4);sigline([3 3],[],4)

set(gca, 'FontSize', 14);
title('90% AMT', 'FontSize', 20)
xlim([0.75 4.25])
xticks(1:4)
xticklabels({'T_1','T_2', 'T_3', 'PertOnly'})
ylim([0 6])
ylabel({'Method 1';'LLRa (nu)'}, 'FontSize', 18, 'FontWeight','bold')

%% Exp 1 Method 1 - 95% Group
estPar = [3.1702781	0.93451848;
2.7841329	0.93481591;
2.2516152	0.93471670;
3.1213970	0.93451848];
  
%Plot     
subplot(1,2,2)
xVec = (1:4);
plot(xVec, estPar(1:4,1),'bd', 'MarkerSize', 6, 'MarkerFaceColor', 'b' ); hold on
p(1) = errorbar(xVec, estPar(1:4,1), 1.96*estPar(1:4,2), '--b', 'LineWidth', 1.5);
sigline([3 3],[],5)

set(gca, 'FontSize', 14);
title('95% AMT', 'FontSize', 20)
xlim([0.75 4.25])
xticks(1:4)
xticklabels({'T_1','T_2', 'T_3', 'PertOnly'})
ylim([0 6])
ylabel({'';'LLRa (nu)'}, 'FontSize', 18, 'FontWeight','bold')





%% Exp 1 Method 2 - 90% Group
estPar = [2.5265952	0.45640450;
2.2572694	0.45646637;
1.9032889	0.45647219;
3.2665352	0.45640450];
  


%Plot     
figure('units', 'inches', 'Position', [50 50 8 6])
set(gcf, 'WindowState','maximized')
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.04], [0.105 0.085], [0.105 0.015]);
offset  = 0.05;

subplot(1,2,1)
xVec = (1:4);
plot(xVec, estPar(1:4,1),'rd', 'MarkerSize', 6, 'MarkerFaceColor', 'r' ); hold on
p(1) = errorbar(xVec, estPar(1:4,1), 1.96*estPar(1:4,2), '--r', 'LineWidth', 1.5);
sigline([2 2],[],4);sigline([3 3],[],4)

set(gca, 'FontSize', 14);
title('90% AMT', 'FontSize', 20)
xlim([0.75 4.25])
xticks(1:4)
xticklabels({'T1','T2', 'T3', 'PertOnly'})
ylim([0 6])
ylabel({'Method 2';'LLRa (nu)'}, 'FontSize', 18, 'FontWeight','bold')


%% Exp 1 Method 2 - 95% Group
estPar = [3.1702781	0.94562722;
2.7813698	0.94592022;
2.2512653	0.94582456;
3.1213970	0.94562722];
  
% Plot
subplot(1,2,2)
xVec = (1:4);
plot(xVec, estPar(1:4,1),'bd', 'MarkerSize', 6, 'MarkerFaceColor', 'b' ); hold on
p(1) = errorbar(xVec, estPar(1:4,1), 1.96*estPar(1:4,2), '--b', 'LineWidth', 1.5);
sigline([3 3],[],5)

set(gca, 'FontSize', 14);
title('95% AMT', 'FontSize', 20)
xlim([0.75 4.25])
xticks(1:4)
xticklabels({'T_1','T_2', 'T_3', 'PertOnly'})
ylim([0 6])
ylabel({'';'LLRa (nu)'}, 'FontSize', 18, 'FontWeight','bold')

