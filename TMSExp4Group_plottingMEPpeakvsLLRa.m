
clc
clear all
close all

processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
% addpath(genpath(processingPath));

processingScriptsPath = [processingPath '\ProcessingScripts'];
addpath(genpath(processingScriptsPath));

%plotting Scripts
plottingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts'];
addpath(genpath(plottingPath));

figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\R2_Plots\'];


%% load in the JMP table from excel for the TMS exp 2 group

LLRaJMPTable = readtable("LLR-avg-group-TMSExp4-JMPTable.xlsx");


%% Set variables of interest
LLRaClean = table2array( LLRaJMPTable(:,'LLRa_nu_NoEnv'));
TMSmodes = table2array( LLRaJMPTable(:,'Condition'));
Pertmodes = table2array( LLRaJMPTable(:,'Pert'));
NormMEPpeak = table2array( LLRaJMPTable(:,'NormMEPPeakWindow_noEnv_'));


%% Find indices that correspond to each condition

TMmodeNames = [{'Sub TMS','Supra TMS','Pert & Sub TMS','Pert & Supra TMS'}];

for i = 1:length(TMmodeNames)
    condIdx(:,i) = find(strcmp(TMSmodes,TMmodeNames{i}));
end


%% Find the line of best fit for all conditions

j = [1 3;2 4];

for c = 1:2

idx = squeeze(condIdx(:,j(:,c)));
idx = idx(:);

coefficients(c,:) = polyfit(NormMEPpeak(idx),LLRaClean(idx), 1);
y_fit(:,c) = polyval(coefficients(c,:), NormMEPpeak(idx) );
end


%%
close all

col = ['bm']; % Back, sub TMS, supra TMS, sub PertTMS, supra PertTMS
figure('Position',[100 100 900 600])

for c = [1:2]
idx = squeeze(condIdx(:,j(:,c)));
idx = idx(:);
plot(NormMEPpeak(idx),LLRaClean(idx),'o','MarkerFaceColor',col(c),'Color',col(c),'MarkerSize',5);
hold on
end

for c = [1:2]
idx = squeeze(condIdx(:,j(:,c)));
idx = idx(:);

p(c) = plot(NormMEPpeak(idx),y_fit(:,c) ,'-','Color',col(c),'LineWidth',3);
hold on
% pause(2)
end

xlim([0 1500])
ylim([-0.1 10])
legend([p([1 2])],'Pert:0','Pert:1')

box on
xlabel(['\bf Norm MEP Peak'])
ylabel('\bf LLRa [n.u.]')
% title('TMS Exp 3 Group')
set(gca,'FontSize',25)

fileName = ['TMSExp4_LLRavsNormMEPPeak_AllData_NoEnv'];
saveas(gcf,[figure_path fileName],'png')



%%
close all

X = linspace(0,1800,1801);

estimates = [1.7042482984;
-0.000116033;
-0.755358198;
0.0002738009];

CIError = [0.2312056076;
0.0000168157;
0.1746769553;
0.0001362893].*1.96;

estCI = [estimates] + [-CIError CIError];


PeakWindowOffset = [-265.90120231];

Pert_0Line = [estimates(1) + X*estimates(2) + estimates(3) + estimates(4)*(X+PeakWindowOffset)];

Pert_0LineLCI = [estCI(1,1) + X*estCI(2,1) + estCI(3,1) + estCI(4,1)*(X+PeakWindowOffset)];
Pert_0LineUCI = [estCI(1,2) + X*estCI(2,2) + estCI(3,2) + estCI(4,2)*(X+PeakWindowOffset)];

Pert_1Line = [estimates(1) + X*estimates(2) - estimates(3) - estimates(4)*(X+PeakWindowOffset)];

Pert_1LineLCI = [estCI(1,1) + X*estCI(2,1) - estCI(3,2) - estCI(4,2)*(X+PeakWindowOffset)];
Pert_1LineUCI = [estCI(1,2) + X*estCI(2,2) - estCI(3,1) - estCI(4,1)*(X+PeakWindowOffset)];


col = ['bm']; % Back, sub TMS, supra TMS, sub PertTMS, supra PertTMS
figure('Position',[100 100 900 600])

p(1) = plot(X,Pert_0Line,'-','Color','b','LineWidth',3);
hold on
patch([X(1) X(1) X(end) X(end)],[Pert_0LineLCI(1) Pert_0LineUCI(1) Pert_0LineUCI(end)...
    Pert_0LineLCI(end)],'b','FaceAlpha',0.2,'EdgeColor', 'none')
% plot(X,Pert_0LineLCI,'--','Color','c','LineWidth',3);
% plot(X,Pert_0LineUCI,'--','Color','c','LineWidth',3);


p(2) = plot(X,Pert_1Line,'-','Color','r','LineWidth',3);
hold on
patch([X(1) X(1) X(end) X(end)],[Pert_1LineLCI(1) Pert_1LineUCI(1) Pert_1LineUCI(end)...
    Pert_1LineLCI(end)],'r','FaceAlpha',0.2,'EdgeColor', 'none')
% plot(X,Pert_1LineLCI,'--','Color','r','LineWidth',3);
% plot(X,Pert_1LineUCI,'--','Color','r','LineWidth',3);

xlim([0 1800])
ylim([-0.1 5])
legend([p([1 2])],'Pert:0','Pert:1')

box on
xlabel(['\bf MEP Peak [n.u.]'])
ylabel('\bf LLRa [n.u.]')
set(gca,'FontSize',25)

fileName = ['LLRavsNormMEPP_S2_R2'];

saveas(gcf,[figure_path fileName],'png')

exportgraphics(gcf,[figure_path fileName '.pdf'],'ContentType','Vector')



%%