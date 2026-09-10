
% code for plotting the TMS stimulation marker locations for all subjects
% (TMS Experiment 4)
clc
close all
clear all



%%
processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
% addpath(genpath(processingPath));

plottingScriptsPath = [processingPath '\PlottingScripts'];
addpath(genpath(plottingScriptsPath));

FigurePath = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\'...
    'Figs4Paper_R3\TMSExp4\Subject_Specific\'];


load('processedMarkersExp4.mat')


%% mean displacement for each participant

meanDisplaceTar;

groupMeanDisplace = mean(meanDisplaceTar)


%% group level target location
nSubjs = 12;
for s = 1:12
subjAVG_C_proj_XY(1,s) = mean([C_proj_XY{:,1,s}]);
subjAVG_C_proj_XY(2,s) = mean([C_proj_XY{:,2,s}]);
end

groupCI_C_proj_XY = 1.96*std(subjAVG_C_proj_XY,0,2) ./ sqrt(nSubjs);
groupAVG_C_proj_XY = mean(subjAVG_C_proj_XY,2);



%% Head movement calculation with X and Y movement

clear subjSD_C_XY subjSD_Move_Cat
for s = 1:12
subjSD_C_XY(1,s) = std([C_proj_XY{:,1,s}]);
subjSD_C_XY(2,s) = std([C_proj_XY{:,2,s}]);

subjSD_C_total(s) = sqrt(subjSD_C_XY(1,s)^2 + subjSD_C_XY(2,s)^2); % total movement
end

repelem(round(subjSD_C_total,2)',120,1);

subjSD_Move_Cat(find(stdDistfromTar>median(stdDistfromTar))) = 2;
subjSD_Move_Cat(find(stdDistfromTar<median(stdDistfromTar))) = 1;

[~, I] = sort(stdDistfromTar);
[~, rank_index] = sort(I);

move_Cat_Quart(find(rank_index<5)) = 1;
move_Cat_Quart(intersect(find(rank_index>4),find(rank_index<9))) = 2;
move_Cat_Quart(find(rank_index>8)) = 3;

repelem(move_Cat_Quart',120,1);

repelem(round(stdDistfromTar,2)',120,1);


%%
% Histogram for all subjects for the distribution of stimulation line distance to the target

subplot = @ (m,n,p) subtightplot(m,n,p,[0.08 0.03],[0.14 0.1],[0.1 0.1]);

for s = 1:12
distLtoT(:,s) = subjLocalite(s).DistLineTarget(end-numTaskMarkers:end);
end

withSubjDistanceMean = mean(distLtoT,1);

close all
figure('Position',[100 100 1100 700])
for s = 1:12
subplot(3,4,s)

histogram(distLtoT(:,s),'BinWidth',0.4,'FaceColor','b')
hold on
xline(withSubjDistanceMean(s),'r--','LineWidth',2.5)

if s == 1 | s== 5 | s== 9
ylabel('\bf Counts','FontSize',24)
end
ylim([0 Inf])
yticks(0:25:50)
xlim([0 10])

if s ~= 1 & s~= 5 & s~= 9
yticklabels('')
end

if s>8
xlabel('\bf Dist(mm)','FontSize',24)
end

if s<9
xticklabels('')
end

set(gca, 'FontSize',24)
set(gca,'linew',2)

ylim([0 63])
box on

title(['P0' num2str(s)],'FontSize',24)

end

exportgraphics(gcf, [FigurePath 'R2_Targets\' 'LineToTargetHistogram' '.pdf'],'ContentType','vector')
exportgraphics(gcf, [FigurePath 'R2_Targets\' 'LineToTargetHistogram' '.png'])


%%
withSubjDistanceMean = mean(distLtoT,1);

groupDistanceMean = mean(withSubjDistanceMean)
groupDistancestd = std(withSubjDistanceMean)


%%
% plotting the target accuracy for each subject

close all

subplot = @ (m,n,p) subtightplot(m,n,p,[0.06 0.05],[0.14 0.1],[0.1 0.1]);

for sID = 1:12
% close all
if sID == 1
figure('Position',[100 100 920 660])
end
subplot(3,4,sID)

plot(0,0,'ro','LineWidth',2)
hold on;

if sID == 1 | sID == 5 | sID == 9
ylabel('\bf Y (mm)','FontSize',20)
else
yticklabels('')
end

if sID > 8
xlabel('\bf A-P (mm)','FontSize',20)
end

if sID < 9
xticklabels('')
end

yticks([-10 0 10])
xticks([-10 0 10])
xtickangle(0)

ax = gca;
xline(0','r-','LineWidth',2)
yline(0','r-','LineWidth',2)
grid on
box on

set(gca,'linew',2)

r = 3;  % Define the radius
theta = linspace(0, 2*pi, 100); % Define angles from 0 to 2*pi (a full circle)
x = r * cos(theta); % Calculate x coordinates
y = r * sin(theta); % Calculate y coordinates
plot(x, y,'g-','LineWidth',2);        % Plot the circle

r = 6;  % Define the radius
theta = linspace(0, 2*pi, 100); % Define angles from 0 to 2*pi (a full circle)
x = r * cos(theta); % Calculate x coordinates
y = r * sin(theta); % Calculate y coordinates
plot(x, y,'m-','LineWidth',2);          % Plot the circle


r = 9;  % Define the radius
theta = linspace(0, 2*pi, 100); % Define angles from 0 to 2*pi (a full circle)
x = r * cos(theta); % Calculate x coordinates
y = r * sin(theta); % Calculate y coordinates
plot(x, y,'k-','LineWidth',2);          % Plot the circle


% plot([C_proj_XY{:,1,sID}],[C_proj_XY{:,2,sID}],'b.','MarkerSize',10)

colMap = jet(length([C_proj_XY{:,1,sID}]));

scatter([C_proj_XY{:,1,sID}],[C_proj_XY{:,2,sID}],...
    16,[colMap],'filled')

if sID == nSubjs
colormap('jet');
cb = colorbar;
cb.Position = [0.91 0.168 0.022 0.7];
cb.Ticks = ([0 1]);
cb.TickLabels = [{'0%','100%'}];
end

title(['P0' num2str(sID)])
set(ax,'FontSize',18)
xlim([-10 10])
ylim([-10 10])
ax.XDir = 'reverse';

end

exportgraphics(gcf, [FigurePath 'R2_Targets\' 'Group_TargetAccuracy' '.pdf'],'ContentType','vector')




%%
% plotting the target accuracy, the group average, average for each subject
% and group level

close all

subplot = @ (m,n,p) subtightplot(m,n,p,[0.06 0.05],[0.16 0.1],[0.18 0.1]);

figure('Position',[100 100 540 480])
subplot(1,1,1)

plot(0,0,'ro','LineWidth',2)
hold on;
ylabel('\bf Y (mm)','FontSize',20)
xlabel('\bf A-P (mm)','FontSize',20)

yticks([-10 0 10])
xticks([-10 0 10])
xtickangle(0)

ax = gca;
xline(0','r-','LineWidth',2.5)
yline(0','r-','LineWidth',2.5)
grid on
box on

set(gca,'linew',2)

r = 3;  % Define the radius
theta = linspace(0, 2*pi, 100); % Define angles from 0 to 2*pi (a full circle)
x = r * cos(theta); % Calculate x coordinates
y = r * sin(theta); % Calculate y coordinates
plot(x, y,'g-','LineWidth',2.5);        % Plot the circle

r = 6;  % Define the radius
theta = linspace(0, 2*pi, 100); % Define angles from 0 to 2*pi (a full circle)
x = r * cos(theta); % Calculate x coordinates
y = r * sin(theta); % Calculate y coordinates
plot(x, y,'m-','LineWidth',2.5);          % Plot the circle

r = 9;  % Define the radius
theta = linspace(0, 2*pi, 100); % Define angles from 0 to 2*pi (a full circle)
x = r * cos(theta); % Calculate x coordinates
y = r * sin(theta); % Calculate y coordinates
plot(x, y,'k-','LineWidth',2.5);          % Plot the circle

eP = ellipse(groupCI_C_proj_XY(1),groupCI_C_proj_XY(2),groupAVG_C_proj_XY(1),groupAVG_C_proj_XY(2)...
    ,0,'c',[0.5 0.5 0.5]);
alpha(eP, 0.2)
eP.LineWidth = 2.5;

plot(groupAVG_C_proj_XY(1),groupAVG_C_proj_XY(2),'kx','MarkerSize',15,'LineWidth',2)

plot(subjAVG_C_proj_XY(1,:),subjAVG_C_proj_XY(2,:),'b.','MarkerSize',25)

title(['Group'])
set(ax,'FontSize',18)
xlim([-10 10])
ylim([-10 10])
ax.XDir = 'reverse';

saveas(gcf, [FigurePath 'GroupAVG_TargetAccuracy' '.png'])


%%

for sID = 1:12
    
% Estimate a continuous pdf
[pdfx xi]= ksdensity([C_proj_XY{:,1,sID}]);
[pdfy yi]= ksdensity([C_proj_XY{:,2,sID}]);

% Create 2-d grid of coordinates and function values
[xxi,yyi] = meshgrid(xi,yi);
[pdfxx,pdfyy] = meshgrid(pdfx,pdfy);

% Calculate combined pdf
pdfxy = pdfxx.*pdfyy;

% close all
if sID == 1
close all
figure('Position',[100 100 1100 600])
end

subplot(3,4,sID)
% Plot the results
surf(xxi,yyi,pdfxy)
view(2)
ax = gca;
xlabel('\bf A-P')
set(ax,'FontSize',16)
title(['P0' num2str(sID) ' - Heatmap'])
ylabel('\bf Y (Laterality)')
ax.XDir = 'reverse';
% xlim([-10 10])
% ylim([-10 10])

set(gca,'XLim',[min(xi) max(xi)])
set(gca,'YLim',[min(yi) max(yi)])

end


%%


for sID = [1:12]

numStimMarkers = length([distLineT{:,sID}]);
maxYVal = max([distLineT{:,sID},dSE{:,sID}])*1.2;

if sID == 1
close all
figure('Position',[100 100 1200 600])
% figure('Position',[100 100 600 400])
end

subplot(3,4,sID)

pTask = patch([numStimMarkers-numTaskMarkers numStimMarkers numStimMarkers numStimMarkers-numTaskMarkers],...
    [0 0 maxYVal maxYVal],[0.5 0.5 0.5],'FaceAlpha',0.4);

hold on
pAMT = patch([0 numStimMarkers-numTaskMarkers numStimMarkers-numTaskMarkers 0 ],...
    [0 0 maxYVal maxYVal],[0.67 0.85 0.90],'FaceAlpha',0.4);


hold on
p1 = plot([dSE{:,sID}],'r-','LineWidth',3);
hold on
p2 = plot([distLineT{:,sID}],'b-','LineWidth',3);

% text([numStimMarkers-round(numTaskMarkers-numTaskMarkers*0.4)], maxYVal*0.90,'\bf Task','FontSize',15)

if sID == 1
ylabel('Distance (mm)')
xlabel('Stimulation Marker')
end
box on

xlim([0 inf])
ylim([0 inf])

if sID == 1
legend([p1 p2 pTask pAMT],'Dist:S-E','Dist:L-T','Task','AMT','Position',[0.015,0.49,0.097,0.15])
end

title(['P0' num2str(sID)],'FontSize',22)

set(gca,'FontSize',16)

end

fileName = ['Localite_GroupLevel_3DMarkerDistances'];
saveas(gcf, [FigurePath fileName '.png'])

% saveas(gcf, [FigurePath '\' fileName '.fig'])


%% subject specific target movement over time plots

sID = [12];

numStimMarkers = length([distLineT{:,sID}]);
maxYVal = max([distLineT{:,sID},dSE{:,sID}])*1.2;

close all
figure('Position',[100 100 800 500])
subplot(1,1,1)

pTask = patch([numStimMarkers-numTaskMarkers numStimMarkers numStimMarkers numStimMarkers-numTaskMarkers],...
    [0 0 maxYVal maxYVal],[0.5 0.5 0.5],'FaceAlpha',0.4);

hold on
pAMT = patch([0 numStimMarkers-numTaskMarkers numStimMarkers-numTaskMarkers 0 ],...
    [0 0 maxYVal maxYVal],[0.67 0.85 0.90],'FaceAlpha',0.4);

hold on
p1 = plot([dSE{:,sID}],'r-','LineWidth',3);
hold on
p2 = plot([distLineT{:,sID}],'b-','LineWidth',3);

% text([numStimMarkers-round(numTaskMarkers-numTaskMarkers*0.4)], maxYVal*0.90,'\bf Task','FontSize',15)

ylabel('Distance (mm)')
xlabel('Stimulation Marker')
box on

xlim([0 inf])
ylim([0 inf])

legend([p1 p2 pTask pAMT],'Dist:S-E','Dist:L-T','Task','AMT','Lccation','Best')

title(['P0' num2str(sID)],'FontSize',22)

set(gca,'FontSize',16)

fileName = ['Localite_' expName{j} '_P0' num2str(sID) '_3DMarkerDistances'];
saveas(gcf, [FigurePath 'P0' num2str(sID) '\Localite\' fileName '.png'])


%%


