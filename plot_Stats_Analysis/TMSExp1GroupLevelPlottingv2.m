% TMS Exp 1 Group Level Figure Plotting

close all
clc
clear

dataTablePath = ['Z:\StudentFolders\Cody\Projects\TMS\Statistical_Analysis\R1 Paper Stats\Group Level Analysis']; %<- change this if data table is stored somewhere else
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(dataTablePath));
addpath(genpath(processingPath));

%plotting Scripts
plottingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts'];
addpath(genpath(plottingPath));

Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\'];


%% Display F ratio table for full mixed model

FixedEffect = [{'Mode';'Group';'Mode*Group'}];
DFDen = [88.1;22.0;88.1];
F_Ratio = [17.28;0.184;0.233];
ProbF = [{'<.0001';'0.6718';'0.9188'}];

FullTable = table(FixedEffect,DFDen,F_Ratio,ProbF)


%% Exp 1 - Effect of TMS Plotting
estPar = [2.5136382	0.29703138;
2.2317104	0.29701157;
1.8322599	0.29698491;
1.0023565	0.29692748;
2.9260687	0.29712498];

%Plot     
close all
figure('units', 'pixels', 'Position', [300 70 1000 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.05], [0.21 0.04], [0.1 0.04]);
offset  = 0.05;

subplot(1,1,1)
xVec = (1:5);
plot(xVec, estPar(1:5,1),'kd', 'MarkerSize', 16, 'MarkerFaceColor', 'k' ); hold on
p(1) = errorbar(xVec, estPar(1:5,1), 1.96*estPar(1:5,2), '--k', 'LineWidth', 4);
sigline([2 5],[],4.8);sigline([3 5],[],4.25);sigline([4 5],[],3.7)
% texline([2 5],4.8,'\bf (8/24)',21);
% texline([3 5],4.25,'\bf (15/24)',21);
% texline([4 5],3.7,'\bf (21/24)',21);

set(gca, 'FontSize', 30);
title('', 'FontSize', 26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode','FontSize',33)
ylabel({'LLRa [n.u.]'}, 'FontSize', 33, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
% grid on
box on
ax = gca;
ax.LineWidth = 2;

Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_Resubmit\'];
FileName = ['EffectofTMSMode_CombinedGroups_TMSExp1'];

exportgraphics(gcf,[Figure_path FileName '.png'])
export_fig(gcf, [Figure_path FileName '.pdf']);
% print(gcf,'-dpdf', [Figure_path FileName '.pdf']);

% export_fig(gcf,[Figure_path FileName '.eps'])


%% Exp 1 - Full Factorial Plotting
estPar = [2.6559096	0.42772555;
2.3715630	0.42743636;
2.3219583	0.42755319;
2.1414512	0.42755319;
1.9594157	0.42747527;
1.7050522	0.42755707;
0.9833586	0.42743636;
1.0213544	0.42743636;
3.1394843	0.42777833;
2.7129803	0.42764349];
  
%Plot     
figure('units', 'pixels', 'Position', [350 150 800 600])
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.04], [0.105 0.105], [0.1 0.1]);
offset  = 0.05;

xVec = (1:5);
plot(xVec-offset, estPar(1:2:10,1),'rd', 'MarkerSize', 12, 'MarkerFaceColor', 'r' ); hold on
p(1) = errorbar(xVec-offset, estPar(1:2:10,1), 1.96*estPar(1:2:10,2), '--r', 'LineWidth', 3);
% sigline([4 5],[],4);sigline([3 5],[],4.25);

plot(xVec+offset, estPar(2:2:10,1),'bd', 'MarkerSize', 12, 'MarkerFaceColor', 'b' ); hold on
p(2) = errorbar(xVec+offset, estPar(2:2:10,1), 1.96*estPar(2:2:10,2), '--b', 'LineWidth', 3);

title('Full Factorial Model', 'FontSize', 26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode', 'FontSize', 24)
ylabel({'LLRa [n.u.]'}, 'FontSize', 24, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
grid on
set(gca, 'FontSize', 22);

legend([p(1);p(2)],['90% Group';'95% Group'],'FontSize',18)


   
%% Exp 1 - Mixed Model by Group with Random interaction term & unequal variances

% clc
close all

TMSPar = [2.5136382	0.29703138;
2.2317104	0.29701157;
1.8322599	0.29698491;
1.0023565	0.29692748;
2.9260687	0.29712498];

group1estPar = [2.6557493	0.39771271;
2.3218230	0.39789812;
1.9595050	0.39624085;
0.9833586	0.38448674;
3.1392235	0.40059471]; % 90% group

group2estPar = [2.3715630	0.45214597;
2.1413724	0.44975992;
1.7049285	0.44826987;
1.0213544	0.44214641;
2.7133380	0.45060254];  % 95% group
  
%Plot     
figure('units', 'pixels', 'Position', [20 70 1550 900])
subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.2], [0.15 0.04], [0.07 0.02]);
offset  = 0.05;
% sgtitle('Norm LLRa by Group', 'FontSize', 20)


subplot(2,2,1.5)
xVec = (1:5);
plot(xVec, TMSPar(1:5,1),'kd', 'MarkerSize', 16, 'MarkerFaceColor', 'k' ); hold on
p(1) = errorbar(xVec, TMSPar(1:5,1), 1.96*TMSPar(1:5,2), '--k', 'LineWidth', 4);
sigline([2 5],[],4.8);sigline([3 5],[],4.25);sigline([4 5],[],3.7)

texline([2 5],4.8,'(8/24)',14);
texline([3 5],4.25,'(15/24)',14);
texline([4 5],3.7,'(21/24)',14);

set(gca, 'FontSize', 24);
title('', 'FontSize', 26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode','FontSize',28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
grid on


subplot(2,2,3)
xVec = (1:5);
plot(xVec, group1estPar(1:5,1),'rd', 'MarkerSize', 16, 'MarkerFaceColor', 'r' ); hold on
p(2) = errorbar(xVec, group1estPar(1:5,1), 1.96*group1estPar(1:5,2), '--r', 'LineWidth', 4);
sigline([3 5],[],4.6); sigline([4 5],[],4.0);
texline([3 5],4.6,'(7/12)',14);
texline([4 5],4.0,'(11/12)',14);


set(gca, 'FontSize', 24);
title('','FontSize',26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode', 'FontSize', 28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
grid on



subplot(2,2,4)
plot(xVec, group2estPar(1:5,1),'bd', 'MarkerSize', 16, 'MarkerFaceColor', 'b' ); hold on
p(3) = errorbar(xVec, group2estPar(1:5,1), 1.96*group2estPar(1:5,2), '--b', 'LineWidth', 4);
sigline([3 5],[],4.6); sigline([4 5],[],4);
texline([3 5],4.6,'(8/12)',14);
texline([4 5],4.0,'(10/12)',14);

set(gca, 'FontSize', 24);
title('','FontSize',26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode', 'FontSize', 28)
ylabel({''}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
grid on

legend([p(1);p(2);p(3)],{'Combined','90% Group','95% Group'}...
    ,'FontSize',14,'location','southwest')

%[0.83;0.87;0.1;0.1]



%% Exp 1 - Mixed Model by Group with Random interaction term & unequal variances

% clc
close all

TMSPar = [2.5136382	0.29703138;
2.2317104	0.29701157;
1.8322599	0.29698491;
1.0023565	0.29692748;
2.9260687	0.29712498];

group1estPar = [2.6557493	0.39771271;
2.3218230	0.39789812;
1.9595050	0.39624085;
0.9833586	0.38448674;
3.1392235	0.40059471]; % 90% group

group2estPar = [2.3715630	0.45214597;
2.1413724	0.44975992;
1.7049285	0.44826987;
1.0213544	0.44214641;
2.7133380	0.45060254];  % 95% group
  
%Plot     
figure('units', 'pixels', 'Position', [-100 -400 1600 1000])
subplot = @(m,n,p) subtightplot(m,n,p,[0.05 0.04], [0.2 0.04], [0.1 0.02]);
offset  = 0.05;
% sgtitle('Norm LLRa by Group', 'FontSize', 20)

subplot(2,2,1)
xVec = (1:5);
plot(xVec, group1estPar(1:5,1),'rd', 'MarkerSize', 16, 'MarkerFaceColor', 'r' ); hold on
p(1) = errorbar(xVec, group1estPar(1:5,1), 1.96*group1estPar(1:5,2), '--r', 'LineWidth', 4);
sigline([3 5],[],4.6); sigline([4 5],[],4.0);
texline([3 5],4.54,'\bf (7/12)',22);
texline([4 5],4.0,'\bf (11/12)',22);


set(gca, 'FontSize', 30);
title('','FontSize',26)
% xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xticklabels({'','', '', '',''})
xlabel('', 'FontSize', 28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 32, 'FontWeight','bold')
xlim([0.75 5.5])
xticks(xVec)
ylim([0 5.5])
yticks(0:2:5.5)
% grid on
ax = gca;
ax.LineWidth = 2;
box on

subplot(2,2,2)
plot(xVec, group2estPar(1:5,1),'bd', 'MarkerSize', 16, 'MarkerFaceColor', 'b' ); hold on
p(2) = errorbar(xVec, group2estPar(1:5,1), 1.96*group2estPar(1:5,2), '--b', 'LineWidth', 4);
sigline([3 5],[],4.6); sigline([4 5],[],4);
texline([3 5],4.55,'\bf (8/12)',22);
texline([4 5],4.0,'\bf (10/12)',22);

set(gca, 'FontSize', 30);
title('','FontSize',26)
% xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xticklabels({'','', '', '',''})
xlabel('', 'FontSize', 28)
ylabel({''}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 5.5])
xticks(xVec)
ylim([0 5.5])
yticks(0:2:5.5)
% grid on
ax = gca;
ax.LineWidth = 2;
box on

legend([p(1);p(2)],{'90% AMT','95% AMT'},'FontSize',23,'location','northwest')

%[0.83;0.87;0.1;0.1]
% Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_Resubmit\'];
% FileName = ['EffectofTMSMode_byGroup_TMSExp1.png'];
% exportgraphics(gcf,[Figure_path FileName])

% Exp 1 - Mixed Model by Group with Random interaction term & unequal variances

% With 1X SD thresholding data only

% clc
% close all

group1estPar = [2.2308147	0.35501625;
2.0731903	0.34840948;
1.8119664	0.32567407;
0.9554750	0.27589068;
3.2031376	0.30321437]; % 90% group

group2estPar = [2.8236498	0.56164477;
2.5032267	0.54938364;
1.9868432	0.55293493;
0.9872704	0.46238792;
2.7275146	0.47156520];  % 95% group
  
%Plot     
% figure('units', 'pixels', 'Position', [20 70 1600 600])
% subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.04], [0.2 0.1], [0.1 0.02]);
offset  = 0.05;
% sgtitle('Norm LLRa by Group', 'FontSize', 20)

subplot(2,2,3)
xVec = (1:5);
plot(xVec, group1estPar(1:5,1),'rd', 'MarkerSize', 16, 'MarkerFaceColor', 'r' ); hold on
p(1) = errorbar(xVec, group1estPar(1:5,1), 1.96*group1estPar(1:5,2), '--r', 'LineWidth', 4);
sigline([2 5],[],5.3);sigline([3 5],[],4.6); sigline([4 5],[],4.0);
texline([2 5],5.3,'\bf (1/9)',22);
texline([3 5],4.6,'\bf (4/9)',22);
texline([4 5],4.0,'\bf (8/9)',22);


set(gca, 'FontSize', 30);
title('','FontSize',26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode', 'FontSize', 28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 32, 'FontWeight','bold')
xlim([0.75 5.5])
xticks(xVec)
ylim([0 6.5])
yticks(0:2:7.5)
% grid on
box on
ax = gca;
ax.LineWidth = 2;


text(-0.3,13.5,'\bf A','FontSize',35)
text(-0.3,6,'\bf B','FontSize',35)


subplot(2,2,4)
plot(xVec, group2estPar(1:5,1),'bd', 'MarkerSize', 16, 'MarkerFaceColor', 'b' ); hold on
p(2) = errorbar(xVec, group2estPar(1:5,1), 1.96*group2estPar(1:5,2), '--b', 'LineWidth', 4);
% sigline([3 5],[],4.6); 
sigline([4 5],[],4);
% texline([3 5],4.55,'\bf (4/8)',22);
texline([4 5],4.0,'\bf (7/8)',22);

set(gca, 'FontSize', 30);
title('','FontSize',26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode', 'FontSize', 28)
ylabel({''}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 5.5])
xticks(xVec)
ylim([0 6.5])
yticks(0:2:7.5)
% grid on
box on
ax = gca;
ax.LineWidth = 2;
set(gcf,'Color','white');

% legend([p(1);p(2)],{'90% AMT','95% AMT'},'FontSize',24,'location','northwest')


%[0.83;0.87;0.1;0.1]
Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_Resubmit\'];
FileName = ['EffectofTMSMode_byGroup_TMSExp1_1XSDThres_Combined'];

exportgraphics(gcf,[Figure_path FileName '.png'])

export_fig(gcf, [Figure_path FileName '.pdf']);
% print(gcf,'-dpdf', [Figure_path FileName '.pdf']);


%% Exp 1 - Mixed Model by Group with Random interaction term & unequal variances

% clc
close all

TMSParEst_3X = [0.9713727	0.22222032;
2.9653261	0.23549531;
1.9110613	0.25132829;
1.7606417	0.26837638];

TMSParEst_2X = [0.9713727	0.22289583;
2.9653261	0.23613007;
1.9589839	0.25942808;
1.8086141	0.25769898];

TMSParEst_1X = [0.9713727	0.22226920;
2.9653261	0.23554174;
1.9229031	0.27199563;
1.8840702	0.24351216];

TMSParEst_Median = [0.9713727	0.23091248;
2.9653261	0.24370031;
1.8082256	0.25129109;
1.8425908	0.24444187];

TMSParEst_200uV = [0.9713727	0.22465024;
2.9653261	0.23778531;
1.8168719	0.23763182;
1.8633872	0.28847939];

  
%Plot     
figure('units', 'pixels', 'Position', [20 70 1000 700])
subplot = @(m,n,p) subtightplot(m,n,p,[0.10 0.05], [0.23 0.1], [0.15 0.02]);
offset  = 0.05;
% sgtitle('Norm LLRa by Group', 'FontSize', 20)

subplot(1,1,1)
xVec = (1:4);
plot(xVec, TMSParEst_3X(1:4,1),'rd', 'MarkerSize', 12,'LineWidth', 3); hold on
p(1) = errorbar(xVec, TMSParEst_3X(1:4,1), 1.96*TMSParEst_3X(1:4,2), '--r', 'LineWidth', 3,'CapSize',15);
% sigline([1 2],[],4.0);
% sigline([2 3],[],4.4);
% sigline([2 4],[],4.5);
% texline([3 5],4.54,'\bf (7/12)',22);
% texline([4 5],4.0,'\bf (11/12)',22);

set(gca, 'FontSize', 26);
title('Threshold:3X SD','FontSize',26)
% xticklabels({'Back','Pert','No MEP','MEP'})
xticklabels({'','','',''})
% xlabel('TMS Mode', 'FontSize', 28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 32, 'FontWeight','bold')
xlim([0.75 4.25])
xticks(xVec)
ylim([0 4.5])
yticks(0:1:4.5)
% grid on
box on

% subplot(2,3,2)
plot(xVec, TMSParEst_2X(1:4,1),'bd', 'MarkerSize', 12,'LineWidth', 3); hold on
p(2) = errorbar(xVec, TMSParEst_2X(1:4,1), 1.96*TMSParEst_2X(1:4,2), '--b', 'LineWidth', 3,'CapSize',15);
% sigline([3 5],[],4.6); sigline([4 5],[],4);
% texline([3 5],4.55,'\bf (8/12)',22);
% texline([4 5],4.0,'\bf (10/12)',22);

set(gca, 'FontSize', 26);
title('Threshold:2X SD','FontSize',26)
% xticklabels({'Back','Pert','No MEP','MEP'})
xticklabels({'','','',''})
% xlabel('TMS Mode', 'FontSize', 28)
ylabel({''}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 4.25])
xticks(xVec)
ylim([0 4.5])
yticks(0:1:4.5)
% grid on
box on

% subplot(2,3,3)
plot(xVec, TMSParEst_1X(1:4,1),'gd', 'MarkerSize', 12,'LineWidth', 3); hold on
p(3) = errorbar(xVec, TMSParEst_1X(1:4,1), 1.96*TMSParEst_1X(1:4,2), '--g', 'LineWidth', 3,'CapSize',15);
% sigline([3 5],[],4.6); sigline([4 5],[],4);
% texline([3 5],4.55,'\bf (8/12)',22);
% texline([4 5],4.0,'\bf (10/12)',22);

set(gca, 'FontSize', 26);
title('Threshold:1X SD','FontSize',26)
xticklabels({'Back','Pert','No MEP','MEP'})
xlabel('TMS Mode', 'FontSize', 28)
ylabel({''}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 4.25])
xticks(xVec)
ylim([0 4.5])
yticks(0:1:4.5)
% grid on
box on

% subplot(2,3,4)
plot(xVec, TMSParEst_Median(1:4,1),'md', 'MarkerSize', 11,'LineWidth', 3); hold on
p(4) = errorbar(xVec, TMSParEst_Median(1:4,1), 1.96*TMSParEst_Median(1:4,2), '--m', 'LineWidth',3,'CapSize',15);
% sigline([3 5],[],4.6); sigline([4 5],[],4);
% texline([3 5],4.55,'\bf (8/12)',22);
% texline([4 5],4.0,'\bf (10/12)',22);

set(gca, 'FontSize', 26);
title('Threshold:Median','FontSize',26)
xticklabels({'Back','Pert','No MEP','MEP'})
xlabel('TMS Mode', 'FontSize', 28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 32, 'FontWeight','bold')
xlim([0.75 4.25])
xticks(xVec)
ylim([0 4.5])
yticks(0:1:4.5)
% grid on
box on

% subplot(2,3,5)
plot(xVec, TMSParEst_200uV(1:4,1),'cd', 'MarkerSize', 12, 'LineWidth', 3); hold on
p(5) = errorbar(xVec, TMSParEst_200uV(1:4,1), 1.96*TMSParEst_200uV(1:4,2), '--c', 'LineWidth', 3,'CapSize',15);
% sigline([3 5],[],4.6); sigline([4 5],[],4);
% texline([3 5],4.55,'\bf (8/12)',22);
% texline([4 5],4.0,'\bf (10/12)',22);

set(gca, 'FontSize', 26);
title('','FontSize',26)
xticklabels({'Back','Pert','MEP^{(-)}','MEP^{(+)}'})
xlabel('TMS Mode', 'FontSize', 28)
% ylabel({'LLRa [n.u.]'}, 'FontSize', 32, 'FontWeight','bold')
xlim([0.75 4.25])
xticks(xVec)
ylim([-0.5 5])
yticks(0:1:4.5)
% grid on
box on

subplot(1,1,1)
sigline([1 2],[],4.0,4.0,'k');
sigline([2 3],[],0.6,0.6,'k');
sigline([2 4],[],0.1,0.1,'k');

ax = gca;
ax.LineWidth = 2;
set(gcf,'Color','white');


leg = legend([p(1:5)],'3X SD','2X SD','1X SD','Median','200\muV','FontSize',27,'location','northeastoutside','NumColumns',1);
title(leg,'Threshold')

%[0.83;0.87;0.1;0.1]
Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_Resubmit\'];
FileName = ['EffectofTMSMode_TMSExp1_MEPType_ThresholdPlots'];

exportgraphics(gcf,[Figure_path FileName '.png'])

export_fig(gcf, [Figure_path FileName '.pdf']);
% print(gcf,'-dpdf', [Figure_path FileName '.pdf']);



%% Percent Reduction Calculation

estPar = [2.6557493	0.39771271;
2.3218230	0.39789812;
1.9595050	0.39624085;
0.9833586	0.38448674;
3.1392235	0.40059471]; % 90% group

estPar2 = [2.3715630	0.45214597;
2.1413724	0.44975992;
1.7049285	0.44826987;
1.0213544	0.44214641;
2.7133380	0.45060254];  % 95% group

a = estPar;
b = -[(a(5,1)-a(:,1))./(a(5,1)-a(4,1))]*100; % t1 reduction, t2 reduction, t3 reduction
round(b(1:3),2);

a = estPar2;
c = -[(a(5,1)-a(:,1))./(a(5,1)-a(4,1))]*100; % t1 reduction, t2 reduction, t3 reduction
round(c(1:3),2);

TMScond = [{'T_1';'T_2';'T_3'}];
Group1 = round(b(1:3),2);
Group2 = round(c(1:3),2);
percentReduction = table(TMScond,Group1,Group2)



