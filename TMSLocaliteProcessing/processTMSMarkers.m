
% loading, processing, and analyzing TMS experiments marker locations

clc
clear all
close all

processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
addpath(genpath(processingPath));

processingScriptsPath = [processingPath '\ProcessingScripts'];
addpath(genpath(processingScriptsPath));

FigurePath = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\'...
    'Figs4Paper_R3\TMSExp1'];


%%

TMSExcelPath = ['Z:\StudentFolders\Cody\Projects\TMS\Dataset\'];
excelFileName1 = ['TMS Exp1 - Marker Locations.xlsx'];
excelFileName2 = ['TMS Exp2 - Marker Locations.xlsx'];
excelFileName3 = ['TMS Exp3 - Marker Locations.xlsx'];

TMSMarkerTable1 = xlsread([TMSExcelPath 'TMSExp1Group\' excelFileName1]);
T1 = array2table(TMSMarkerTable1);
T1.Properties.VariableNames = [{'SubID','Tar-X','Tar-Y','Tar-Z','Entry-X',...
    'Entry-Y','Entry-Z','Coil-X','Coil-Y','Coil-Z'}];

TMSMarkerTable2 = xlsread([TMSExcelPath 'TMSExp2Group\' excelFileName2]);
T2 = array2table(TMSMarkerTable2);
T2.Properties.VariableNames = [{'SubID','Tar-X','Tar-Y','Tar-Z','Entry-X',...
    'Entry-Y','Entry-Z','Coil-X','Coil-Y','Coil-Z'}];

TMSMarkerTable3 = xlsread([TMSExcelPath 'TMSExp3Group\' excelFileName3]);
T3 = array2table(TMSMarkerTable3);
T3.Properties.VariableNames = [{'SubID','Tar-X','Tar-Y','Tar-Z','Entry-X',...
    'Entry-Y','Entry-Z','Coil-X','Coil-Y','Coil-Z'}];


% AMT intensities

TMSExp1AMTs = [70, 85,79, 86, 60, 78, 63, 80, 59, 55, 90, 57,...
    75, 49, 68, 59, 89, 57, 65, 59, 65, 70, 72, 60]';
TMSExp2AMTs = [44, 60, 40, 60, 56, 62, 57, 48, 54, 55, 68, 50]';
TMSExp3AMTs = [53, 60, 54]';


%%

nSubjs = 12;

% plot the position of the target location for all subjects
close all

figure('Position',[50 100 1500 600])
col = jet(nSubjs);
colororder(col)

subplot(1,3,1)
for s = 1:nSubjs
scatter(T1{s,2},T1{s,3},35,'o','filled')
hold on
end
xlim([-40 -10])
ylim([-50 10])
xlabel('Tar-X')
ylabel('Tar-Y')
ax = gca;
ax.ColorOrder = col;
set(ax,'FontSize',20)

subplot(1,3,2)
for s = 1:nSubjs
scatter(T1{s,2},T1{s,4},35,'o','filled')
hold on
end
xlim([-40 -10])
ylim([10 70])
xlabel('Tar-X')
ylabel('Tar-Z')
ax = gca;
ax.ColorOrder = col;
set(ax,'FontSize',20)

subplot(1,3,3)
for s = 1:nSubjs
scatter(T{s,3},T{s,4},35,'o','filled')
hold on
end
xlabel('Tar-Y')
ylabel('Tar-Z')
xlim([-40 10])
ylim([10 70])
ax = gca;
ax.ColorOrder = col;
set(ax,'FontSize',20)



%%

% plot the position of the target location for all subjects
close all

% Define the origin point
origin = [0, 0, 0];

% Define points on the x, y, and z axes
x_axis_point = [-100, 0, 0];
y_axis_point = [0, -100, 0];
z_axis_point = [0, 0, 100];

% nSubjs = 12;

figure('Position',[50 100 1500 600])
% col = jet(nSubjs);
% colororder(col)
subplot(1,1,1)
% for s = 1:nSubjs
scatter3(T1{:,2},T1{:,3},T1{:,4},40,'bo','filled')
hold on
scatter3(T2{:,2},T2{:,3},T2{:,4},40,'ro','filled')
scatter3(T3{:,2},T3{:,3},T3{:,4},40,'go','filled')
scatter3(0,0,0,50,'ko','filled')
% end

% Plot the x-axis line
plot3([origin(1), x_axis_point(1)], [origin(2), x_axis_point(2)], [origin(3), x_axis_point(3)], 'k-', 'LineWidth', 2);
% Plot the y-axis line
plot3([origin(1), y_axis_point(1)], [origin(2), y_axis_point(2)], [origin(3), y_axis_point(3)], 'k-', 'LineWidth', 2);
% Plot the z-axis line
plot3([origin(1), z_axis_point(1)], [origin(2), z_axis_point(2)], [origin(3), z_axis_point(3)], 'k-', 'LineWidth', 2);

legend('Exp1','Exp2','Exp3')
grid on
box on
title('Target Position')

xlim([-80 10])
ylim([-60 10])
zlim([0 100])
xlabel('Target-X')
ylabel('Target-Y')
zlabel('Target-Z')
ax = gca;
% ax.ColorOrder = col;
set(ax,'FontSize',20)
% colorbar
% caxis([0 nSubjs])
% colormap(jet)

view(-90,0) % Y and Z axes
% view(180,0) % X and Z axes

fileName = ['TMSLocaliteTarget_AllExps_3DScatter_Y,Z.png'];
exportgraphics(gcf, [FigurePath '\' fileName])


%%
% plot the position of the entry location for all subjects
close all

% Define the origin point
origin = [0, 0, 0];

% Define points on the x, y, and z axes
x_axis_point = [-100, 0, 0];
y_axis_point = [0, -100, 0];
z_axis_point = [0, 0, 100];

figure('Position',[50 100 1500 600])
% col = jet(nSubjs);
% colororder(col)

subplot(1,1,1)
% for s = 1:nSubjs
scatter3(T1{:,5},T1{:,6},T1{:,7},40,'bo','filled')
hold on
scatter3(T2{:,5},T2{:,6},T2{:,7},40,'ro','filled')
scatter3(T3{:,5},T3{:,6},T3{:,7},40,'go','filled')
scatter3(0,0,0,50,'ko','filled')
% end

% Plot the x-axis line
plot3([origin(1), x_axis_point(1)], [origin(2), x_axis_point(2)], [origin(3), x_axis_point(3)], 'k-', 'LineWidth', 2);
% Plot the y-axis line
plot3([origin(1), y_axis_point(1)], [origin(2), y_axis_point(2)], [origin(3), y_axis_point(3)], 'k-', 'LineWidth', 2);
% Plot the z-axis line
plot3([origin(1), z_axis_point(1)], [origin(2), z_axis_point(2)], [origin(3), z_axis_point(3)], 'k-', 'LineWidth', 2);

legend('Exp1','Exp2','Exp3')
grid on
box on

title('Entry Position')
xlim([-80 10])
ylim([-50 10])
zlim([0 90])
xlabel('Entry-X')
ylabel('Entry-Y')
zlabel('Entry-Z')
ax = gca;
% ax.ColorOrder = col;
set(ax,'FontSize',20)
% colorbar
% caxis([0 nSubjs])
% colormap(jet)

% view(-90,0) % Y and Z axes
view(180,0) % X and Z axes

fileName = ['TMSLocaliteEntry_AllExps_3DScatter_X,Z.png'];
exportgraphics(gcf, [FigurePath '\' fileName])


%%

% mean and standard deviation for each location axis

meanMarkerPoints = nanmean(T1{:,2:end},1);
stdMarkerPoints = nanstd(T1{:,2:end},1);

statsTable = table(meanMarkerPoints',stdMarkerPoints');
statsTable.Properties.VariableNames = [{'Mean','St.Dev.'}];
statsTable


%%
% plot the position of the entry location for all subjects
close all
figure('Position',[50 50 1300 650])
spTitleNames = [{'Tar-X','Tar-Y','Tar-Z','Ent-X','Ent-Y','Ent-Z','Coil-X','Coil-Y','Coil-Z'}];

for m = 1:9
subplot(3,3,m)
h = histogram(T1{:,m+1},'FaceColor','b');
hold on
p(1) = xline(nanmean(T1{:,m+1}),'b--','LineWidth',3);

h = histogram(T2{:,m+1},'FaceColor','r');
p(2) = xline(nanmean(T2{:,m+1}),'r--','LineWidth',3);

h = histogram(T3{:,m+1},'FaceColor','g');
p(3) = xline(nanmean(T3{:,m+1}),'g--','LineWidth',3);

title(spTitleNames{m},'FontSize',18)
if m == 1
xlabel('Position (mm)')
ylabel('Freq')
end

ylim([0 15])
ax = gca;
set(gca,'FontSize',18)

end

legend([p(1:3)],'Exp1','Exp2','Exp3','Position',[0.92,0.58,0.07,0.13])

fileName = ['TMSLocaliteMarkerLocations_AllExps_HistogramPlot.png'];
exportgraphics(gcf, [FigurePath '\' fileName])


%%
% plot the position of the entry location for all subjects
close all
figure('Position',[50 50 1300 650])
spTitleNames = [{'Tar-X','Tar-Y','Tar-Z','Ent-X','Ent-Y','Ent-Z','Coil-X','Coil-Y','Coil-Z'}];

for m = 1:9
subplot(3,3,m)
x = [min((T1{:,m+1})):1:max((T1{:,m+1}))];
y = normpdf(x,nanmean(T1{:,m+1}),nanstd(T1{:,m+1}));
plot(x,y,'b','LineWidth',3)
hold on
p(1) = xline(nanmean(T1{:,m+1}),'b--','LineWidth',3);

x = [min((T1{:,m+1})):1:max((T1{:,m+1}))];
y = normpdf(x,nanmean(T2{:,m+1}),nanstd(T2{:,m+1}));
plot(x,y,'r','LineWidth',3)
p(2) = xline(nanmean(T2{:,m+1}),'r--','LineWidth',3);

x = [min((T1{:,m+1})):1:max((T1{:,m+1}))];
y = normpdf(x,nanmean(T3{:,m+1}),nanstd(T3{:,m+1}));
plot(x,y,'g','LineWidth',3)
p(3) = xline(nanmean(T3{:,m+1}),'g--','LineWidth',3);

title(spTitleNames{m},'FontSize',18)
if m == 1
xlabel('Position (mm)')
ylabel('Freq')
end

ylim([0 0.3])
ax = gca;
set(gca,'FontSize',18)s
end

legend([p(1:3)],'Exp1','Exp2','Exp3','Position',[0.92,0.58,0.07,0.13])


%%
% plotting the relationship between target position and the AMT intensity
close all
figure('Position',[100 150 1300 500])

subplot(1,3,1)

coefficients = polyfit(T1{:,2},TMSExp1AMTs, 1);
y_fit = polyval(coefficients,T1{:,2});

plot(T1{:,2},TMSExp1AMTs,'ob','MarkerSize',8,'MarkerFaceColor','b')
hold on
plot(T1{:,2}, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,2},TMSExp2AMTs, 1);
y_fit = polyval(coefficients,T2{:,2});

plot(T2{:,2},TMSExp2AMTs,'or','MarkerSize',8,'MarkerFaceColor','r')
hold on
plot(T2{:,2}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,2},TMSExp3AMTs, 1);
y_fit = polyval(coefficients,T3{:,2});

plot(T3{:,2},TMSExp3AMTs,'og','MarkerSize',8,'MarkerFaceColor','g')
hold on
plot(T3{:,2}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Target-X (mm)')
ylabel('AMT %(MSO)')


T1array = table2array(T1);

coefficients = polyfit(T1array(:,3),TMSExp1AMTs, 1);
y_fit = polyval(coefficients,T1array(:,3));

subplot(1,3,2)

plot(T1array(:,3),TMSExp1AMTs,'ob','MarkerSize',8,'MarkerFaceColor','b')
hold on
plot(T1array(:,3), y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,3},TMSExp2AMTs, 1);
y_fit = polyval(coefficients,T2{:,3});

plot(T2{:,3},TMSExp2AMTs,'or','MarkerSize',8,'MarkerFaceColor','r')
hold on
plot(T2{:,3}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,3},TMSExp3AMTs, 1);
y_fit = polyval(coefficients,T3{:,3});

plot(T3{:,3},TMSExp3AMTs,'og','MarkerSize',8,'MarkerFaceColor','g')
hold on
plot(T3{:,3}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Target-Y (mm)')


coefficients = polyfit(T1{:,4},TMSExp1AMTs, 1);
y_fit = polyval(coefficients,T1{:,4});

subplot(1,3,3)
p(1) = plot(T1{:,4},TMSExp1AMTs,'ob','MarkerSize',8,'MarkerFaceColor','b');
hold on
plot(T1{:,4}, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,4},TMSExp2AMTs, 1);
y_fit = polyval(coefficients,T2{:,4});

p(2) = plot(T2{:,4},TMSExp2AMTs,'or','MarkerSize',8,'MarkerFaceColor','r');
hold on
plot(T2{:,4}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,4},TMSExp3AMTs, 1);
y_fit = polyval(coefficients,T3{:,4});

p(3) = plot(T3{:,4},TMSExp3AMTs,'og','MarkerSize',8,'MarkerFaceColor','g');
hold on
plot(T3{:,4}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Target-Z (mm)')

legend([p(1:3)],'Exp1','Exp2','Exp3','Position',[0.93 0.55 0.03 0.05])

sgtitle('Target Location vs AMT Intensity','FontSize',25)

fileName = ['TMSLocaliteMarkerLocations_AllExps_AMTvsTarget.png'];
exportgraphics(gcf, [FigurePath '\' fileName])



%%
% plotting the relationship between entry location and the AMT intensity
close all
figure('Position',[100 150 1300 500])

subplot(1,3,1)

coefficients = polyfit(T1{:,5},TMSExp1AMTs, 1);
y_fit = polyval(coefficients,T1{:,5});

plot(T1{:,5},TMSExp1AMTs,'ob','MarkerSize',8,'MarkerFaceColor','b')
hold on
plot(T1{:,5}, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,5},TMSExp2AMTs, 1);
y_fit = polyval(coefficients,T2{:,5});

plot(T2{:,5},TMSExp2AMTs,'or','MarkerSize',8,'MarkerFaceColor','r')
hold on
plot(T2{:,5}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,5},TMSExp3AMTs, 1);
y_fit = polyval(coefficients,T3{:,5});

plot(T3{:,5},TMSExp3AMTs,'og','MarkerSize',8,'MarkerFaceColor','g')
hold on
plot(T3{:,5}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-X (mm)')
ylabel('AMT %(MSO)')


T1array = table2array(T1);

coefficients = polyfit(T1array(:,6),TMSExp1AMTs, 1);
y_fit = polyval(coefficients,T1array(:,6));

subplot(1,3,2)

plot(T1array(:,6),TMSExp1AMTs,'ob','MarkerSize',8,'MarkerFaceColor','b')
hold on
plot(T1array(:,6), y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,6},TMSExp2AMTs, 1);
y_fit = polyval(coefficients,T2{:,6});

plot(T2{:,6},TMSExp2AMTs,'or','MarkerSize',8,'MarkerFaceColor','r')
hold on
plot(T2{:,6}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,6},TMSExp3AMTs, 1);
y_fit = polyval(coefficients,T3{:,6});

plot(T3{:,6},TMSExp3AMTs,'og','MarkerSize',8,'MarkerFaceColor','g')
hold on
plot(T3{:,6}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-Y (mm)')


coefficients = polyfit(T1{:,7},TMSExp1AMTs, 1);
y_fit = polyval(coefficients,T1{:,7});

subplot(1,3,3)
p(1) = plot(T1{:,7},TMSExp1AMTs,'ob','MarkerSize',8,'MarkerFaceColor','b');
hold on
plot(T1{:,7}, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,7},TMSExp2AMTs, 1);
y_fit = polyval(coefficients,T2{:,7});

p(2) = plot(T2{:,7},TMSExp2AMTs,'or','MarkerSize',8,'MarkerFaceColor','r');
hold on
plot(T2{:,7}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,7},TMSExp3AMTs, 1);
y_fit = polyval(coefficients,T3{:,7});

p(3) = plot(T3{:,7},TMSExp3AMTs,'og','MarkerSize',8,'MarkerFaceColor','g');
hold on
plot(T3{:,7}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-Z (mm)')

legend([p(1:3)],'Exp1','Exp2','Exp3','Position',[0.93 0.55 0.03 0.05])

sgtitle('Entry Location vs AMT Intensity','FontSize',25)

% fileName = ['TMSLocaliteMarkerLocations_AllExps_AMTvsEntry.png'];
% exportgraphics(gcf, [FigurePath '\' fileName])


%%
% plotting the relationship between T3 reduction and AMT intensity
close all
figure('Position',[100 150 1100 500])

subplot(1,1,1)

coefficients = polyfit(TMSExp1AMTs,T3Reduction, 1);
y_fit = polyval(coefficients,TMSExp1AMTs);

p(1) = plot(TMSExp1AMTs,T3Reduction,'ob','MarkerSize',8,'MarkerFaceColor','b');
hold on
plot(TMSExp1AMTs, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(TMSExp2AMTs,T3ReductionExp2, 1);
y_fit = polyval(coefficients,TMSExp2AMTs);

p(2) = plot(TMSExp2AMTs,T3ReductionExp2,'or','MarkerSize',8,'MarkerFaceColor','r');
hold on
plot(TMSExp2AMTs, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(TMSExp3AMTs,T3ReductionExp3, 1);
y_fit = polyval(coefficients,TMSExp3AMTs);

p(3) = plot(TMSExp3AMTs,T3ReductionExp3,'og','MarkerSize',8,'MarkerFaceColor','g');
hold on
plot(TMSExp3AMTs, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('AMT %(MSO)')
ylabel('T_3 Reduction (LLR %)')

legend([p(1:3)],'Exp1','Exp2','Exp3','Position',[0.93 0.55 0.03 0.05])

sgtitle(' T_3 Reduction vs AMT Intensity','FontSize',25)

fileName = ['T3ReductionvsAMT_AllExps.png'];
exportgraphics(gcf, [FigurePath '\' fileName])


%%
% plotting the relationship between entry location and the AMT intensity
close all
figure('Position',[100 150 1300 500])

subplot(1,3,1)

coefficients = polyfit(T1{:,5},T3Reduction, 1);
y_fit = polyval(coefficients,T1{:,5});

plot(T1{:,5},T3Reduction,'ob','MarkerSize',8,'MarkerFaceColor','b')
hold on
plot(T1{:,5}, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,5},T3ReductionExp2, 1);
y_fit = polyval(coefficients,T2{:,5});

plot(T2{:,5},T3ReductionExp2,'or','MarkerSize',8,'MarkerFaceColor','r')
hold on
plot(T2{:,5}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,5},T3ReductionExp3, 1);
y_fit = polyval(coefficients,T3{:,5});

plot(T3{:,5},T3ReductionExp3,'og','MarkerSize',8,'MarkerFaceColor','g')
hold on
plot(T3{:,5}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-X (mm)')
ylabel('T_3 Reduction (LLR%)')

T1array = table2array(T1);

coefficients = polyfit(T1array(:,6),T3Reduction, 1);
y_fit = polyval(coefficients,T1array(:,6));

subplot(1,3,2)

plot(T1array(:,6),T3Reduction,'ob','MarkerSize',8,'MarkerFaceColor','b')
hold on
plot(T1array(:,6), y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,6},T3ReductionExp2, 1);
y_fit = polyval(coefficients,T2{:,6});

plot(T2{:,6},T3ReductionExp2,'or','MarkerSize',8,'MarkerFaceColor','r')
hold on
plot(T2{:,6}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,6},T3ReductionExp3, 1);
y_fit = polyval(coefficients,T3{:,6});

plot(T3{:,6},T3ReductionExp3,'og','MarkerSize',8,'MarkerFaceColor','g')
hold on
plot(T3{:,6}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-Y (mm)')


coefficients = polyfit(T1{:,7},T3Reduction, 1);
y_fit = polyval(coefficients,T1{:,7});

subplot(1,3,3)
p(1) = plot(T1{:,7},T3Reduction,'ob','MarkerSize',8,'MarkerFaceColor','b');
hold on
plot(T1{:,7}, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,7},T3ReductionExp2, 1);
y_fit = polyval(coefficients,T2{:,7});

p(2) = plot(T2{:,7},T3ReductionExp2,'or','MarkerSize',8,'MarkerFaceColor','r');
hold on
plot(T2{:,7}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,7},T3ReductionExp3, 1);
y_fit = polyval(coefficients,T3{:,7});

p(3) = plot(T3{:,7},T3ReductionExp3,'og','MarkerSize',8,'MarkerFaceColor','g');
hold on
plot(T3{:,7}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-Z (mm)')

legend([p(1:3)],'Exp1','Exp2','Exp3','Position',[0.93 0.55 0.03 0.05])

sgtitle('Entry Location vs T_3 Reduction','FontSize',25)

fileName = ['EntryLocationvsT3Reduction_AllExps.png'];
exportgraphics(gcf, [FigurePath '\' fileName])



%%
% plotting the relationship between target location and the AMT intensity
close all
figure('Position',[100 150 1300 500])

subplot(1,3,1)

coefficients = polyfit(T1{:,2},T3Reduction, 1);
y_fit = polyval(coefficients,T1{:,2});

plot(T1{:,2},T3Reduction,'ob','MarkerSize',8,'MarkerFaceColor','b')
hold on
plot(T1{:,2}, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,2},T3ReductionExp2, 1);
y_fit = polyval(coefficients,T2{:,2});

plot(T2{:,2},T3ReductionExp2,'or','MarkerSize',8,'MarkerFaceColor','r')
hold on
plot(T2{:,2}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,2},T3ReductionExp3, 1);
y_fit = polyval(coefficients,T3{:,2});

plot(T3{:,2},T3ReductionExp3,'og','MarkerSize',8,'MarkerFaceColor','g')
hold on
plot(T3{:,2}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-X (mm)')
ylabel('T_3 Reduction (LLR%)')

T1array = table2array(T1);

coefficients = polyfit(T1array(:,3),T3Reduction, 1);
y_fit = polyval(coefficients,T1array(:,3));

subplot(1,3,2)

plot(T1array(:,3),T3Reduction,'ob','MarkerSize',8,'MarkerFaceColor','b')
hold on
plot(T1array(:,3), y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,3},T3ReductionExp2, 1);
y_fit = polyval(coefficients,T2{:,3});

plot(T2{:,3},T3ReductionExp2,'or','MarkerSize',8,'MarkerFaceColor','r')
hold on
plot(T2{:,3}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,3},T3ReductionExp3, 1);
y_fit = polyval(coefficients,T3{:,3});

plot(T3{:,3},T3ReductionExp3,'og','MarkerSize',8,'MarkerFaceColor','g')
hold on
plot(T3{:,3}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-Y (mm)')


coefficients = polyfit(T1{:,4},T3Reduction, 1);
y_fit = polyval(coefficients,T1{:,4});

subplot(1,3,3)
p(1) = plot(T1{:,4},T3Reduction,'ob','MarkerSize',8,'MarkerFaceColor','b');
hold on
plot(T1{:,4}, y_fit, '-b', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T2{:,4},T3ReductionExp2, 1);
y_fit = polyval(coefficients,T2{:,4});

p(2) = plot(T2{:,4},T3ReductionExp2,'or','MarkerSize',8,'MarkerFaceColor','r');
hold on
plot(T2{:,4}, y_fit, '-r', 'DisplayName', 'Line of Best Fit','LineWidth',3);

coefficients = polyfit(T3{:,4},T3ReductionExp3, 1);
y_fit = polyval(coefficients,T3{:,4});

p(3) = plot(T3{:,4},T3ReductionExp3,'og','MarkerSize',8,'MarkerFaceColor','g');
hold on
plot(T3{:,4}, y_fit, '-g', 'DisplayName', 'Line of Best Fit','LineWidth',3);

set(gca,'FontSize',18)
xlabel('Entry-Z (mm)')

legend([p(1:3)],'Exp1','Exp2','Exp3','Position',[0.93 0.55 0.03 0.05])

sgtitle('Target Location vs T_3 Reduction','FontSize',25)

fileName = ['TargetLocationvsT3Reduction_AllExps.png'];
exportgraphics(gcf, [FigurePath '\' fileName])



%%
