
% 8/14/23

clc
clear all
close all

%%

%
% plotting statistical analysis for subject AMT measurements

statsFolder = ['Z:\StudentFolders\Cody\Projects\TMS\Statistical_Analysis\R1 Paper Stats\Group Level Analysis\'];

M = readtable([statsFolder 'SubjectMeasurementsJMPTable.xlsx']);
M2 = table2array(M(1:end,2:end));

AMT = M2(:,1);
TMEP = M2(:,2);
GroupID = cellstr(num2str(M2(:,3)));

AMTList = num2cell([40 54 36 54 50 56 51 43 39 50 61 48 45]);
T1List = [25 35 32 35 28 20 33 33 35 37 26 39 33];


AMT(25:36,1) = [44 60 40 60 56 62 57 48 43 56 68 53];
TMEP(25:36,1) = [25 35 32 35 28 20 33 33 35 37 26 39];
GroupID(25:36,:) = [{'Exp2'}];

AMT(37:48,1) = [47 48 37 52 48 48 45 53 50 43 44 39];
TMEP(37:48,1) = [24 21 24 22 20 21 26 21 20 26 20 20];
GroupID(37:48,:) = [{'Exp3'}];




%%
% Plotting
clc
close all

figure('Position',[300 100 800 500])
sgtitle('Participant Specific Parameters','FontSize',20,'FontWeight','bold')

subplot(1,2,1)
hold all
boxplot(AMT,GroupID);
h = findobj(gca,'Tag','Box');
col = [{'b'},{'r'}];
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col{j},'FaceAlpha',0.50,'Linew',2);
end

set(gca,'ytick',[40:10:90])
x=repelem([1:2]',length(AMT)/2,1);
scatter(x, AMT,'k','filled','jitter',1.5);

xlabel('TMS Group')
ylabel('AMT [% MSO]')
set(gca,'FontSize',20)


subplot(1,2,2)
hold all
boxplot(TMEP, GroupID);
xlabel('TMS Group')
ylabel('T_{MEP} [ms]')
set(gca,'FontSize',20)
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col{j},'FaceAlpha',0.50,'Linew',2);
end
set(gca,'ytick',[10:10:40])

x=repelem([1:2]',length(TMEP)/2,1);
scatter(x, TMEP,'k','filled','jitter',1.5);


lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);



%%
% Plotting
clc
close all

numGroups = 4;
groupNames = {'90%','95%','Exp2','Exp3'};

figure('Position',[300 100 900 500])
sgtitle('Participant Specific Parameters','FontSize',20,'FontWeight','bold')
subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.1],[0.1 0.15],[0.1 0.1]);

subplot(1,2,1)
hold all
boxplot(AMT,GroupID);
h = findobj(gca,'Tag','Box');
col = [[0,255,255];[0,255,0];[255,0,0];[0,0,255]]./255;
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

set(gca,'ytick',[30:10:100])
ylim([30 100])
xlim([0.5 4.5])
x=[ repelem([1:numGroups]',12,1)];
scatter(x, AMT,'k','filled','jitter',1.5);
box on
% grid on
hold on

ax = gca;
ax.LineWidth = 2;

xlabel('TMS Group')
ylabel('AMT [% MSO]')
set(gca,'FontSize',20)
set(gca,'xtick',1:numGroups,'XTickLabels',[groupNames])

subplot(1,2,2)
hold all
boxplot(TMEP,GroupID);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

set(gca,'ytick',[0:10:50])
ylim([0 50])
xlim([0.5 4.5])
x=[repelem([1:numGroups]',12,1)];
scatter(x, TMEP,'k','filled','jitter',1.5);
box on
% grid on
hold on
set(gca,'xtick',1:numGroups,'XTickLabels',[groupNames])

xlabel('TMS Group')
ylabel('T_{MEP} [ms]')
set(gca,'FontSize',20)

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca;
ax.LineWidth = 2;clc


Figure_Path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\'];
FileName = ['PartSpecParameters_Exp3'];

exportgraphics(gcf, [Figure_Path FileName '.png']);
% exportgraphics(gcf, [Figure_Path FileName '.eps']);

% export_fig(gcf, [Figure_Path FileName '.eps']);



%%
% Plotting
clc
close all

numGroups = 1;
groupNames = {''};

AMT2 = AMT(37:end);
TMEP2 = TMEP(37:end);
GroupID2 = GroupID(37:end);

figure('Position',[300 100 1000 450])
% sgtitle('Participant Specific Parameters','FontSize',20,'FontWeight','bold')
subplot = @(m,n,p) subtightplot(m,n,p,[0.1 0.1],[0.2 0.1],[0.1 0.1]);
col = [[0,0,255];[0,255,0];[255,0,0];[0,0,255]]./255;

subplot(1,2,1)
hold all
histogram(AMT2,'BinWidth',2,'FaceColor',col(1,:));
hold on
xline(mean(AMT2),'k--','LineWidth',2.5)

ylim([0 4])
xlim([20 70])
xticks([20:10:70])

box on
hold on

ax = gca;
ax.LineWidth = 2;

xlabel('\bf AMT [% MSO]')
ylabel('\bf Counts')
set(gca,'FontSize',20)

subplot(1,2,2)
hold all
histogram(TMEP2,'BinWidth',1,'FaceColor',col(1,:));
hold on
xline(mean(TMEP2),'k--','LineWidth',2.5)

ylim([0 5])
xlim([10 40])
box on
hold on

ylabel('')
xlabel('\bf T_{MEP} [ms]')
set(gca,'FontSize',20)

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);
ax = gca;
ax.LineWidth = 2;

Figure_Path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\'];

FileName = ['PartSpecParameters_Exp3DistributionOnly'];

exportgraphics(gcf, [Figure_Path FileName '.pdf'],'ContentType','vector');
% exportgraphics(gcf, [Figure_Path FileName '.eps']);

% export_fig(gcf, [Figure_Path FileName '.eps']);

%%


