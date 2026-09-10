% TMS Exp 1 Group Level Figure Plotting

close all
clc
clear

% plotting for TMS paper figures

dataTablePath = ['Z:\StudentFolders\Cody\Projects\TMS\Statistical Analysis'...
    '\Group Level Analysis']; %<- change this if data table is stored somewhere else
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(dataTablePath));
addpath(genpath(processingPath));

%plotting Scripts
plottingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts'];
addpath(genpath(plottingPath));


%% Display F ratio table for full mixed model

FixedEffect = [{'Mode';'Intensity';'Intensity*Mode'}];
DFDen = [96;22.0;96];
F_Ratio = [16.84767;0.196;0.228];
ProbF = [{'<.0001*';'0.6624';'0.9218'}];

FullTable = table(FixedEffect,DFDen,F_Ratio,ProbF)


%% Exp 1 - Effect of TMS
% LS Means Table for the effect of TMS mode
estPar = [2.5137021	0.30106259
2.2317309	0.30025529
1.8322409	0.29915369
1.0023565	0.29296282
2.9259541	0.30142883];

%Plot     
figure('units', 'pixels', 'Position', [300 70 775 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.05], [0.16 0.04], [0.1 0.04]);
offset  = 0.05;

% Color scale
gray = [0.7 0.7 0.7];

subplot(1,1,1)
% X data points
xVec = (1:5);
plot(xVec, estPar(1:5,1),'d','Color','k', 'MarkerSize', 16, 'MarkerFaceColor', 'k' ); hold on
% error bars (95% confidence interval)
p(1) = errorbar(xVec, estPar(1:5,1), 1.96*estPar(1:5,2), '--','Color','k', 'LineWidth', 4);
% significant comparison lines
sigline([2 5],[],4.8);sigline([3 5],[],4.25);sigline([4 5],[],3.7)

texline([2 5],4.8,'(8/24)');
texline([3 5],4.3,'(15/24)');
texline([4 5],3.725,'(21/24)');

set(gca, 'FontSize', 22);
title('', 'FontSize', 26)

% x tick and tick labels
xticks(xVec)
xticklabels({'T_1','T_2', 'T_3', 'BackOnly','PertOnly'})

% x and y labels
xlabel('TMS Mode','FontSize',26)
ylabel({'LLRa [n.u.]'}, 'FontSize',20, 'FontWeight','bold')

% x and y limits
xlim([0.75 5.25])
ylim([0 5.5])

yticks(0:1:5.5)
grid on


%% Exp 1 - Effect of TMS
% LS Means Table for the effect of TMS mode
estPar = [2.5137021	0.30106259
2.2317309	0.30025529
1.8322409	0.29915369
1.0023565	0.29296282
2.9259541	0.30142883];

%Plot     
figure('units', 'pixels', 'Position', [300 70 775 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.05], [0.16 0.04], [0.1 0.04]);
offset  = 0.05;

% plot color
gray = [0.7 0.7 0.7];

subplot(1,1,1)
% x data points
xVec = (1:5);
plot(xVec, estPar(1:5,1),'d','Color','k', 'MarkerSize', 16, 'MarkerFaceColor', 'k' ); hold on
% error bars (confidence interval)
p(1) = errorbar(xVec, estPar(1:5,1), 1.96*estPar(1:5,2), '--','Color','k', 'LineWidth', 4);
% significant different line
sigline([2 5],[],4.8);sigline([3 5],[],4.25);sigline([4 5],[],3.7)

texline([2 5],4.8,'(8/24)',18);
texline([3 5],4.3,'(15/24)',18);
texline([4 5],3.725,'(21/24)',18);

set(gca, 'FontSize', 22);
title('', 'FontSize', 26)
xticklabels({'T_1','T_2', 'T_3', 'BackOnly','PertOnly'})
xlabel('TMS Mode','FontSize',26)
ylabel({'LLRa [n.u.]'}, 'FontSize',20, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
grid on

   
%% Exp 1 - Mixed Model effect of TMS separated by Group

% clc
close all


 % 90% group
estPar = [2.6557493	0.39771271;
2.3218230	0.39789812;
1.9595050	0.39624085;
0.9833586	0.38448674;
3.1392235	0.40059471];


 % 95% group
estPar2 = [2.3715630	0.45214597;
2.1413724	0.44975992;
1.7049285	0.44826987;
1.0213544	0.44214641;
2.7133380	0.45060254];
  

%Plot     
figure('units', 'pixels', 'Position', [100 70 1250 600])
subplot = @(m,n,p) subtightplot(m,n,p,[0.02 0.05], [0.16 0.04], [0.08 0.04]);
offset  = 0.05;
% sgtitle('Norm LLRa by Group', 'FontSize', 20)

% TMS intensity colors
group1Col = [1 0 0]; % red
group2Col = [0 0 1]; % blue

subplot(1,2,1)
xVec = (1:5);
plot(xVec, estPar(1:5,1),'d','Color',group1Col, 'MarkerSize', 16, 'MarkerFaceColor', group1Col ); hold on
p(1) = errorbar(xVec, estPar(1:5,1), 1.96*estPar(1:5,2), '--','Color',group1Col, 'LineWidth', 4);
% significant different line
sigline([3 5],[],4.6); sigline([4 5],[],4.0);
texline([3 5],4.6,'(7/12)',16);
texline([4 5],4.0,'(11/12)',16);

set(gca, 'FontSize', 20);
title('','FontSize',24)
xticklabels({'T_1','T_2', 'T_3', 'BackOnly','PertOnly'})
xlabel('TMS Mode', 'FontSize', 24)
ylabel({'LLRa [n.u.]'}, 'FontSize', 24, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
grid on

subplot(1,2,2)
plot(xVec, estPar2(1:5,1),'d','Color',group2Col, 'MarkerSize', 16, 'MarkerFaceColor', group2Col ); hold on
p(2) = errorbar(xVec, estPar2(1:5,1), 1.96*estPar2(1:5,2), '--','Color',group2Col, 'LineWidth', 4);
% significant different line
sigline([3 5],[],4.6); sigline([4 5],[],4);
texline([3 5],4.6,'(8/12)',16);
texline([4 5],4.0,'(10/12)',16);

set(gca, 'FontSize', 20);
title('','FontSize',24)
xticklabels({'T_1','T_2', 'T_3', 'BackOnly','PertOnly'})
xlabel('TMS Mode', 'FontSize', 24)
ylabel({''}, 'FontSize', 24, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
grid on

legend([p(1);p(2)],{'90% AMT','95% AMT'},'location','northwest')
%[0.83;0.87;0.1;0.1]



%% AHA preliminary data plotting - 90% group


% clc
% close all
 % 90% group
estPar = [2.6557493	0.39771271;
2.3218230	0.39789812;
1.9595050	0.39624085;
3.1392235	0.40059471];


%Plot     
figure('units', 'pixels', 'Position', [300 70 750 700])
subplot = @(m,n,p) subtightplot(m,n,p,[0.02 0.05], [0.10 0.10], [0.12 0.04]);
offset  = 0.05;
% sgtitle('Norm LLRa by Group', 'FontSize', 20)

group1Col = [0 0 0];

subplot(1,1,1)
xVec = (1:4);
plot(xVec, estPar(1:4,1),'d','Color',group1Col, 'MarkerSize', 16, 'MarkerFaceColor', group1Col ); hold on
p(1) = errorbar(xVec, estPar(1:4,1), 1.96*estPar(1:4,2), '--','Color',group1Col, 'LineWidth', 4);
sigline([3 4],[],4.3);
% texline([3 5],4.6,'');
% texline([4 5],4.0,'');


set(gca, 'FontSize', 24);
title('','FontSize',24)
xticklabels({'T_1','T_2', 'T_3','PertOnly'})
% xlabel('TMS Mode', 'FontSize', 24)
ylabel({'Norm LLR Amplitude'}, 'FontSize', 24, 'FontWeight','bold')
title({'Group Level Analysis'}, 'FontSize', 24, 'FontWeight','bold')
xlim([0.75 4.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
grid on


%[0.83;0.87;0.1;0.1]



%% Percent Reduction Calculation

% 90 group
estPar = [2.6557493	0.39771271;
2.3218230	0.39789812;
1.9595050	0.39624085;
0.9833586	0.38448674;
3.1392235	0.40059471];

% 95 group
estPar2 = [2.3715630	0.45214597;
2.1413724	0.44975992;
1.7049285	0.44826987;
1.0213544	0.44214641;
2.7133380	0.45060254];

a = estPar;
b = -[(a(5,1)-a(:,1))./(a(5,1)-a(4,1))]*100; % t1 reduction, t2 reduction, t3 reduction
round(b(1:3),2);

a = estPar2;
c = -[(a(5,1)-a(:,1))./(a(5,1)-a(4,1))]*100; % t1 reduction, t2 reduction, t3 reduction
round(c(1:3),2);

TMScond = [{'T_1';'T_2';'T_3'}];
group90 = round(b(1:3),2);
group95 = round(c(1:3),2);
percentReduction = table(TMScond,group90,group95)



