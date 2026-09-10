


% plotting the LLRa percent reduction for TMS modes

clc
clear all
close all

dataTablePath = ['Z:\StudentFolders\Cody\Projects\TMS\Statistical Analysis\Group Level Analysis']; %<- change this if data table is stored somewhere else
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(dataTablePath));
addpath(genpath(processingPath));

%plotting Scripts
plottingPath = 'Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts';
addpath(genpath(plottingPath));



%%
% Calculates percent reduction in LLR for each condition
% Means for one way ANOVA for each condition

% all subjects, 90% AMT group, 95% AMT group
a = [
2.5137363 2.2317048 1.8322340 1.0023565 2.9262323;

2.6559096 2.3219583 1.9594157 0.9833586 3.1394843;

2.3715630 2.1414512 1.7050522 1.0213544 2.7129803;

0.30234541 0.30232576 0.30229959 0.30224315 0.30243729;

0.42772555 0.42755319 0.42747527 0.42743636 0.42777833;

0.42743636 0.42755319 0.42755707 0.42743636 0.42764349

];





% Calculates the percent reduction

for j = 1:3
    for i = 1:5

    b(j,i) = -[ (a(j,5)-a(j,i))  / (a(j,5)-a(j,4)) ] * 100;

    end
end

for j = 4:6
    for i = 1:5

    b(j,i) = -[ (a(j,i))  / (a(j-3,5)-a(j-3,4)) ] * 100;

    end
end



% Plotting percent reduction

%Plot     
figure('units', 'pixels', 'Position', [300 70 775 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.04 0.05], [0.16 0.04], [0.1 0.04]);
offset  = 0.05;

gray = [0.7 0.7 0.7];

subplot(1,1,1)
xVec = (1:3);
plot(xVec, abs(b(1,1:3)),'d','Color','k', 'MarkerSize', 16, 'MarkerFaceColor', 'k' ); hold on
p(1) = errorbar(xVec, abs(b(1,1:3)), 1.96*abs(b(4,1:3)), '--','Color','k', 'LineWidth', 4);
% sigline([2 5],[],4.8);sigline([3 5],[],4.25);sigline([4 5],[],3.7)

% texline([2 5],4.8,'(8/24)');
% texline([3 5],4.3,'(15/24)');
% texline([4 5],3.725,'(21/24)');

set(gca, 'FontSize', 22);
title('', 'FontSize', 26)
xticklabels({'T_1','T_2', 'T_3'})
xlabel('TMS Mode','FontSize',26)
ylabel({'% LLRa Reduction'}, 'FontSize',26, 'FontWeight','bold')
xlim([0.75 3.25])
xticks(xVec)
% ylim([0 3.5])
% yticks(0:1:3.5)
grid on




%
%Plot     
figure('units', 'pixels', 'Position', [300 70 650 700])
subplot = @(m,n,p) subtightplot(m,n,p,[0.02 0.05], [0.16 0.04], [0.12 0.04]);
offset  = 0.05;
% sgtitle('Norm LLRa by Group', 'FontSize', 20)

group1Col = [1 0.2 0.2];
group2Col = [0.2 0.7 1];

subplot(2,1,1)
xVec = (1:3);
plot(xVec, abs(b(2,1:3)),'d','Color',group1Col, 'MarkerSize', 16, 'MarkerFaceColor', group1Col ); hold on
p(1) = errorbar(xVec, abs(b(2,1:3)), 1.96*abs(b(5,1:3)), '--','Color',group1Col, 'LineWidth', 4);
% sigline([3 5],[],4.6); sigline([4 5],[],4.0);
% texline([3 5],4.6,'');
% texline([4 5],4.0,'');

set(gca, 'FontSize', 20);
title('','FontSize',24)
xticklabels({'','', ''})
xlabel('', 'FontSize', 24)
ylabel({'% LLRa Reduction'}, 'FontSize', 24, 'FontWeight','bold')
xlim([0.75 3.25])
xticks(xVec)
% ylim([0 5.5])
% yticks(0:1:5.5)
grid on

subplot(2,1,2)
plot(xVec, abs(b(3,1:3)),'d','Color',group2Col, 'MarkerSize', 16, 'MarkerFaceColor', group2Col ); hold on
p(2) = errorbar(xVec, abs(b(3,1:3)), 1.96*abs(b(6,1:3)), '--','Color',group2Col, 'LineWidth', 4);
% sigline([3 5],[],4.6); sigline([4 5],[],4);
% texline([3 5],4.6,'');
% texline([4 5],4.0,'');

set(gca, 'FontSize', 20);
title('','FontSize',24)
xticklabels({'T_1','T_2', 'T_3'})
xlabel('TMS Mode', 'FontSize', 24)
ylabel({'% LLRa Reduction'}, 'FontSize', 24, 'FontWeight','bold')
xlim([0.75 3.25])
xticks(xVec)
% ylim([0 5.5])
% yticks(0:1:5.5)
grid on

legend([p(1);p(2)],{'90% AMT','95% AMT'},'location','northwest')
%[0.83;0.87;0.1;0.1]



