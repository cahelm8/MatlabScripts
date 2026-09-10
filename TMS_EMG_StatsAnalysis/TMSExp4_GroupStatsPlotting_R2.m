
% TMS only group - group level - Figure Plotting

close all
clc
clear

%%

% Add processing pathway
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
% addpath(genpath(processingPath));

%plotting Scripts
plottingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts'];
addpath(genpath(plottingPath));

Fig_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\R2_Plots\'];



%% Display F ratio table for full mixed model (TMS, Pert, TMS*Pert)

FixedEffect = [{'TMS';'Pert';'TMS*Pert'}];
DFDen = [11.0;11.0;11.0];
F_Ratio = [9.157;17.752;1.757];
ProbF = [{'0.0115';'0.0015';'0.2118'}];

FullTable = table(FixedEffect,DFDen,F_Ratio,ProbF)

%% TMS Exp 4 plotting - Effect of Pert and TMS

% 1X SD (R2 intended model)
estPar = [1.0240946	0.30254937;
0.7941203	0.30477539;
0.9901648	0.30129225;
2.8825754	0.30254937;
2.5208198	0.30475399;
2.2151859	0.30129225];


% 1X SD (R2 All data model)
% estPar = [1.0240946	0.31007859;
% 0.8325948	0.30668947;
% 0.9901648	0.30888141;
% 2.8825754	0.31007859;
% 2.6250667	0.30668947;
% 2.2151859	0.30888141];


estParNorm = estPar;
estParNorm(4:6,:) = estPar(4:6,:)./estPar(4,1);

j = 0;
if j == 1
    estPar = estParNorm ;
else
end

%Plot    
close all
figure('units', 'pixels', 'Position', [300 70 700 550])
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.05], [0.2 0.08], [0.15 0.1]);
offset  = 0.05;

subplot(1,1,1)
col1 = [188,57,19;22,160,72;136,204,238;153,50,204]./255;

xVec = ([0.85 1 1.15 1.85 2 2.15]);
for i = [1 3]
p(i) = plot(xVec([i,i+3]), estPar([i,i+3],1),'d-.','Color',col1(i,:),...
    'MarkerSize', 12, 'MarkerFaceColor', col1(i,:),'LineWidth',3); hold on
errorbar(xVec([i,i+3]), estPar([i,i+3],1), 1.96*estPar([i,i+3],2),...
    'LineStyle','none','Color',col1(i,:),'CapSize',15,'LineWidth',4);
end

% grid on

sigline([xVec(1) xVec(4)],[],4.1,4.1,col1(1,:));
% sigline([xVec(4) xVec(5)],[],1.5,1.5,col1(2,:));
% sigline([xVec(4) xVec(5)],[],1.45,1.45,col1(2,:))
sigline([xVec(4) xVec(6)],[],1.1,1.1,col1(3,:))
sigline([xVec(4) xVec(6)],[],0.7,0.7,col1(4,:))

% sigline([xVec(1) xVec(4)],[],1.5,1.5,col1(1,:));
% sigline([xVec(4) xVec(5)],[],1.5,1.5,col1(2,:));
% sigline([xVec(4) xVec(6)],[],0.2,0.2,col1(3,:))
% sigline([xVec(4) xVec(6)],[],-0.2,-0.2,col1(4,:))

set(gca, 'FontSize', 20);
xticklabels({'','off','on'})
xlabel('Pert Mode','FontSize',28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.7 2.30])
xticks([0:2])
ylim([-0.5 4.5])
% yticks(-2:2:6)
box on
ax = gca;
ax.LineWidth = 2;
set(gcf,'Color','white');

% leg = legend(p(1:3),'TMS^{(-)}','TMS^{(sub)}','TMS^{(supra)}','location','northeastoutside','FontSize',22);
leg = legend(p([1 3]),'No TMS','TMS^{(supra)}','location','northeastoutside','FontSize',22);

title(leg,'TMS')

% FileName = ['Stats_TMSExp4-EffectofTMS_Pert_1SD_AllData_R2'];
FileName = ['Stats_TMSExp4_1SD_Intended_ProposalFigure'];
% saveas(gcf,[Fig_path,FileName,'.fig'])
exportgraphics(gcf,[Fig_path,FileName,'.png'],'ContentType','vector');
% exportgraphics(gcf,[Fig_path,FileName,'.png']);

% export_fig(gcf, [Fig_path FileName '.pdf']);
% print(gcf,'-dpdf', [Figure_path FileName '.pdf']);


%% TMS Exp 4 plotting - Effect of Pert and TMS Mode

% 1X SD
estPar = [0.3897798	0.05258874;
0.2848298	0.05283745;
0.3201026	0.05029378;
1.0024229	0.05258874;
0.8787561	0.05337930;
0.8097926	0.05024591];

estParNorm = estPar;
estParNorm(4:6,:) = estPar(4:6,:)./estPar(4,1);

j = 0;
if j == 1
    estPar = estParNorm ;
else
end

%Plot    
close all
figure('units', 'pixels', 'Position', [300 70 700 550])
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.05], [0.2 0.08], [0.15 0.1]);
offset  = 0.05;

subplot(1,1,1)
col1 = [188,57,19;22,160,72;136,204,238;153,50,204]./255;

xVec = ([0.85 1 1.15 1.85 2 2.15]);
for i = 1:3
p(i) = plot(xVec([i,i+3]), estPar([i,i+3],1),'d-.','Color',col1(i,:),...
    'MarkerSize', 12, 'MarkerFaceColor', col1(i,:),'LineWidth',3); hold on
errorbar(xVec([i,i+3]), estPar([i,i+3],1), 1.96*estPar([i,i+3],2),...
    'LineStyle','none','Color',col1(i,:),'CapSize',15,'LineWidth',4);
end

% grid on

% sigline([xVec(1) xVec(4)],[],4,4,col1(1,:));
% sigline([xVec(4) xVec(5)],[],1.5,1.5,col1(2,:));
% sigline([xVec(4) xVec(6)],[],1.1,1.1,col1(3,:));
% sigline([xVec(4) xVec(6)],[],0.7,0.7,col1(4,:));


sigline([xVec(1) xVec(4)],[],1.3,1.3,col1(1,:));
sigline([xVec(4) xVec(5)],[],0.5,0.5,col1(2,:));
sigline([xVec(4) xVec(6)],[],0.4,0.4,col1(3,:));
sigline([xVec(4) xVec(6)],[],0.3,0.3,col1(4,:));


set(gca, 'FontSize', 20);
title('2XSD - PTB Norm', 'FontSize', 22);
xticklabels({'','0','1'})
xlabel('Pert Mode','FontSize',28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.7 2.30])
xticks([0:2])
ylim([0 1.4])
% yticks(-2:2:6)
box on
ax = gca;
ax.LineWidth = 2;
set(gcf,'Color','white');

leg = legend(p(1:3),'TMS^{(-)}','MEP^{(-)}','MEP^{(+)}','location','northeastoutside','FontSize',22);
title(leg,'TMS')


FileName = ['TMSExp4-EffectofPert_MEPtype_2SD_normPTB_v2'];
% saveas(gcf,[Fig_path,FileName,'.fig'])
exportgraphics(gcf,[Fig_path,FileName,'.png'])

% export_fig(gcf, [Fig_path FileName '.pdf']);
% print(gcf,'-dpdf', [Figure_path FileName '.pdf']);



%% Effect of normalized MEP peak on the LLR amplitude grouped by Pert

%Plot    
close all
figure('units', 'pixels', 'Position', [300 70 800 550])
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.05], [0.2 0.08], [0.15 0.1]);
offset  = 0.05;

subplot(1,1,1)
col1 = [46,206,46;245,120,64]./255;

p(1) = fplot(@(x) 0.9059662 - 0.0020782*x, [0 , 250],'LineStyle','-','Color',col1(2,:),'LineWidth',4);
hold on 
p(2) = fplot(@(x) 3.8598988 - 0.0173941*x, [0 , 250],'LineStyle','-','Color',col1(1,:),'LineWidth',4);

set(gca, 'FontSize', 20);
title('TMS Exp2 Group', 'FontSize', 22);
% xticklabels({'','0','1'})
xlabel('Norm MEP Peak [n.u.]','FontSize',28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
% xlim([0.75 2.25])
% xticks([0:2])
ylim([0 5.5])
% yticks(-2:2:6)
box on
ax = gca;
ax.LineWidth = 2;
set(gcf,'Color','white');

hold on
text(13,1,' \bf Y = - 0.002*X + 0.91','FontSize',12)
text(8,4,' \bf Y = - 0.017*X + 3.86','FontSize',12)

leg = legend(p(1:2),'0','1','location','northeastoutside','FontSize',22);
title(leg,'Pert')


FileName = ['TMSExp2-EffectofNormMEPPeak_vsPert'];
exportgraphics(gcf,[Fig_path,FileName,'.png'])


%% TMS control group plotting - Effect of Pert and MEP Type - supplementary figure making

% 3X STD
estPar3X = [0.9961697	0.34652917;
0.7916197	0.35105168;
0.6939882	0.35558775;
3.1039606	0.34652457;
2.6743622	0.35090510;
2.5174810	0.35750320];

%2X STD
estPar2X = [1.0069017	0.34476445;
0.7539013	0.35123673;
0.7167721	0.35070907;
3.0954915	0.34476683;
2.7264462	0.35157292;
2.4735248	0.35208004];

%Median Thres
estParMedian = [1.0045469	0.35064231;
0.7060134	0.35290704;
0.7850324	0.35329736;
3.1103145	0.35064231;
2.6634750	0.35329736;
2.5371822	0.35290704];

%200uV Thres
estPar200 = [1.0006786	0.34771575;
0.7470004	0.34795840;
0.5630076	0.37720238;
3.1042503	0.34772053;
2.6220293	0.34804891;
2.3237640	0.38059756];


%Plot    
close all
figure('units', 'pixels', 'Position', [100 70 1300 900])
subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.05], [0.11 0.05], [0.1 0.18]);
offset  = 0.05;

subplot(2,2,1)
col1 = [188,57,19;22,160,72;136,204,238]./255;
xVec = ([0.92 1 1.08 1.92 2 2.08]);
for i = 1:3
p(i) = plot(xVec([i,i+3]), estPar3X([i,i+3],1),'d--','Color',col1(i,:),...
    'MarkerSize', 10, 'MarkerFaceColor', col1(i,:),'LineWidth',3); hold on
errorbar(xVec([i,i+3]), estPar3X([i,i+3],1), 1.96*estPar3X([i,i+3],2),...
    'LineStyle','none','Color',col1(i,:),'CapSize',15,'LineWidth',3);
end
sigline([xVec(1) xVec(4)],[],4.4,4.4,'k'); %col1(1,:));
sigline([xVec(4) xVec(5)],[],1.4,1.4,'k'); %col1(2,:));
sigline([xVec(4) xVec(6)],[],0.8,0.8,'k'); %col1(3,:));

set(gca, 'FontSize', 22);
title('Threshold:3X SD', 'FontSize', 22)
xticklabels({'','0','1'})
% xlabel('Pert Mode','FontSize',28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 2.25])
xticks([0:2])
ylim([-0.8 5.5])
% grid on
box on
ax = gca;
ax.LineWidth = 2;

subplot(2,2,2)
col1 = [188,57,19;22,160,72;136,204,238]./255;
xVec = ([0.92 1 1.08 1.92 2 2.08]);
for i = 1:3
p(i) = plot(xVec([i,i+3]), estPar2X([i,i+3],1),'d--','Color',col1(i,:),...
    'MarkerSize', 10, 'MarkerFaceColor', col1(i,:),'LineWidth',3); hold on
errorbar(xVec([i,i+3]), estPar2X([i,i+3],1), 1.96*estPar2X([i,i+3],2),...
    'LineStyle','none','Color',col1(i,:),'CapSize',15,'LineWidth',3);
end
sigline([xVec(1) xVec(4)],[],4.4,4.4,'k'); %col1(1,:));
sigline([xVec(4) xVec(5)],[],1.4,1.4,'k'); %col1(2,:));
sigline([xVec(4) xVec(6)],[],0.8,0.8,'k'); %col1(3,:));

set(gca, 'FontSize', 22);
title('Threshold:2X SD', 'FontSize', 22)
xticklabels({'','0','1'})
% xlabel('Pert Mode','FontSize',28)
% ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 2.25])
xticks([0:2])
ylim([-0.8 5.5])
% grid on
box on
ax = gca;
ax.LineWidth = 2;

subplot(2,2,3)
col1 = [188,57,19;22,160,72;136,204,238]./255;
xVec = ([0.92 1 1.08 1.92 2 2.08]);
for i = 1:3
p(i) = plot(xVec([i,i+3]), estParMedian([i,i+3],1),'d--','Color',col1(i,:),...
    'MarkerSize', 10, 'MarkerFaceColor', col1(i,:),'LineWidth',3); hold on
errorbar(xVec([i,i+3]), estParMedian([i,i+3],1), 1.96*estParMedian([i,i+3],2),...
    'LineStyle','none','Color',col1(i,:),'CapSize',15,'LineWidth',3);
end
sigline([xVec(1) xVec(4)],[],4.4,4.4,'k'); %col1(1,:));
sigline([xVec(4) xVec(5)],[],1.4,1.4,'k'); %col1(2,:));
sigline([xVec(4) xVec(6)],[],0.8,0.8,'k'); %col1(3,:));

set(gca, 'FontSize', 22);
title('Threshold: Median', 'FontSize', 22)
xticklabels({'','0','1'})
xlabel('Pert Mode','FontSize',28)
ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 2.25])
xticks([0:2])
ylim([-0.8 5.5])
% grid on
box on
ax = gca;
ax.LineWidth = 2;

subplot(2,2,4)
col1 = [188,57,19;22,160,72;136,204,238]./255;
xVec = ([0.92 1 1.08 1.92 2 2.08]);
for i = 1:3
p(i) = plot(xVec([i,i+3]), estPar200([i,i+3],1),'d--','Color',col1(i,:),...
    'MarkerSize', 10, 'MarkerFaceColor', col1(i,:),'LineWidth',3); hold on
errorbar(xVec([i,i+3]), estPar200([i,i+3],1), 1.96*estPar200([i,i+3],2),...
    'LineStyle','none','Color',col1(i,:),'CapSize',15,'LineWidth',3);
end
sigline([xVec(1) xVec(4)],[],4.4,4.4,'k'); %col1(1,:));
sigline([xVec(4) xVec(5)],[],1.4,1.4,'k'); %col1(2,:));
sigline([xVec(4) xVec(6)],[],0.8,0.8,'k'); %col1(3,:));

set(gca, 'FontSize', 22);
title('Threshold: 200\muV', 'FontSize', 22)
xticklabels({'','0','1'})
xlabel('Pert Mode','FontSize',28)
% ylabel({'LLRa [n.u.]'}, 'FontSize', 28, 'FontWeight','bold')
xlim([0.75 2.25])
xticks([0:2])
ylim([-0.8 5.5])
% grid on
box on
ax = gca;
ax.LineWidth = 2;
set(gcf,'Color','white');

leg = legend(p(1:3),'TMS^{(-)}','MEP^{(-)}','MEP^{(+)}','position',[0.88 0.5 0.06 0.06],'FontSize',16);
title(leg,'MEP Type')

FileName = ['TMSExp2-EffectofMEPType_ThresholdingPlots'];
saveas(gcf,[Fig_path,FileName,'.fig'])
exportgraphic(gcf,[Fig_path,FileName,'.png'])

export_fig(gcf, [Fig_path FileName '.pdf']);
% print(gcf,'-dpdf', [Figure_path FileName '.pdf']);



%% Exp 1 - Full Factorial Plotting
estPar = [2.2456363		0.43386905;
2.6131076		0.44319463;
2.1566058		0.43107317;
2.3823978		0.44498740;
1.8445115		0.42064763;
1.8077646		0.43494973;
0.9554750		0.39488199;
0.9872704		0.39488199;
3.0200836		0.40672334;
2.6408124		0.40654357];

close all  
%Plot     
figure('units', 'pixels', 'Position', [350 150 1000 400])
subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.1], [0.3 0.105], [0.1 0.06]);
offset  = 0.05;

subplot(1,2,1)
xVec = (1:5);
plot(xVec, estPar(1:2:10,1),'rd', 'MarkerSize', 12, 'MarkerFaceColor', 'r' ); hold on
p(1) = errorbar(xVec, estPar(1:2:10,1), 1.96*estPar(1:2:10,2), '--r', 'LineWidth', 3);
sigline([4 5],[],4);sigline([3 5],[],4.50);

% title('Full Factorial Model', 'FontSize', 26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode', 'FontSize', 24)
ylabel({'LLRa [n.u.]'}, 'FontSize', 24, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
% grid on
box on
set(gca, 'FontSize', 22);


subplot(1,2,2)
plot(xVec, estPar(2:2:10,1),'bd', 'MarkerSize', 12, 'MarkerFaceColor', 'b' ); hold on
p(2) = errorbar(xVec, estPar(2:2:10,1), 1.96*estPar(2:2:10,2), '--b', 'LineWidth', 3);
sigline([4 5],[],4);

% title('Full Factorial Model', 'FontSize', 26)
xticklabels({'T_1','T_2', 'T_3', 'Back','Pert'})
xlabel('TMS Mode', 'FontSize', 24)
% ylabel({'LLRa (nu)'}, 'FontSize', 24, 'FontWeight','bold')
xlim([0.75 5.25])
xticks(xVec)
ylim([0 5.5])
yticks(0:1:5.5)
box on
set(gca, 'FontSize', 22);
legend([p(1);p(2)],['90% Group';'95% Group'],'FontSize',14,'location','northwest')

% 
% FigureName = ['TMSExp1_ByGroupTMSModel'];
% exportgraphics(gcf,[Fig_path,FigureName,'.png'])
% saveas(gcf,[Fig_path,FigureName,'.fig'])
   

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

legend([p(1);p(2);p(3)],{'Combined','90% Group','95% Group'},'FontSize',14,'location','southwest')

%[0.83;0.87;0.1;0.1]


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


%%
a = [3.0200836	;2.6408124]

b = [2.2456363, 2.1566058,1.8445115	;2.6131076,2.3823978,1.8077646]

[a(1) - b(1,3)]./[(a(1)-1)]
[a(2) - b(2,3)]./[(a(2)-1)]





