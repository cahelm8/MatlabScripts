
% loading, processing, and analyzing TMS experiments marker locations

clc
clear all
close all

processingPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing'];
% addpath(genpath(processingPath));

processingScriptsPath = [processingPath '\ProcessingScripts'];
addpath(genpath(processingScriptsPath));

FigurePath = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\'...
    'Figs4Paper_R3\TMSExp4\Subject_Specific\'];


load('processedMarkersExp4.mat')



%% Load in target and entry marker locations for each participant

TMSExcelPath = ['Z:\StudentFolders\Cody\Projects\TMS\Dataset\'];

excelFileName1 = ['TMS Exp1 - Marker Locations.xlsx'];
excelFileName2 = ['TMS Exp2 - Marker Locations.xlsx'];
excelFileName3 = ['TMS Exp3 - Marker Locations.xlsx'];
excelFileName4 = ['TMS Exp4 - Marker Locations.xlsx'];

TMSMarkerTable1 = xlsread([TMSExcelPath 'TMSExp1Group\' excelFileName1]);
T1 = array2table(TMSMarkerTable1);
T1.Properties.VariableNames = [{'SubID','Tar-X','Tar-Y','Tar-Z','Entry-X',...
    'Entry-Y','Entry-Z','Coil-X','Coil-Y','Coil-Z'}];

TMSMarkerTable2 = xlsread([TMSExcelPath 'TMSExp2Group\' excelFileName2]);
T2 = array2table(TMSMarkerTable2);
T2.Properties.VariableNames = [{'SubID','Tar-X','Tar-Y','Tar-Z','Entry-X',...
    'Entry-Y','Entry-Z','Coil-X','Coil-Y','Coil-Z'}];

TMSMarkerTable3 = xlsread([TMSExcelPath 'TMSExp3Group\' excelFileName3],'TMSExp3(RAS)');
T3 = array2table(TMSMarkerTable3);
T3.Properties.VariableNames = [{'SubID','Tar-X','Tar-Y','Tar-Z','Entry-X',...
    'Entry-Y','Entry-Z'}];

TMSMarkerTable4 = xlsread([TMSExcelPath 'TMSExp4Group\' excelFileName4],'TMSExp4(RAS)');
T4 = array2table(TMSMarkerTable4);
T4.Properties.VariableNames = [{'SubID','Tar-X','Tar-Y','Tar-Z','Entry-X',...
    'Entry-Y','Entry-Z'}];


% AMT intensities

TMSExp1AMTs = [70, 85,79, 86, 60, 78, 63, 80, 59, 55, 90, 57,...
    75, 49, 68, 59, 89, 57, 65, 59, 65, 70, 72, 60]';
TMSExp2AMTs = [44, 60, 40, 60, 56, 62, 57, 48, 54, 55, 68, 50]';
TMSExp3AMTs = [53, 60, 54, 65, 50, 68, 50, 67, 68]';
TMSExp4AMTs = [47 48 37 52 48 48 45 53 50 43 44 39]';

numTaskMarkers = [79]; % Exp3: 49 (50), Exp4: 79(80), Exp4 test:39(40)

%% Load in the stimulation markers for the subject to process


for sID = [12]

if sID<10
subjName = ['P0' num2str(sID)];
else
subjName = ['P' num2str(sID)];
end

clear stimMark4DVectors

% load in stimulation markers
stimSubjFolder = ['Z:\StudentFolders\Cody\Projects\TMS\Dataset\LocaliteSessions\TMS-Exp4-Group\TMS-' subjName '\'];
addpath(genpath(stimSubjFolder))

listing = dir(fullfile(stimSubjFolder, '**', 'TMSTrigger')); 
listing = listing([listing.isdir]);
folderPath = fullfile(listing(1).folder, listing(1).name); 

stimTrigFolder = [folderPath(1:end-1)];

fileList = dir([stimTrigFolder '*.xml']);
fileList.name

fileName = [fileList(1).name];

% type ([stimTrigFolder fileName]);

% read in the xml file of the stimulation markers 
stimMarkerXML = readstruct([stimTrigFolder fileName]);

coordinateSpace = stimMarkerXML.coordinateSpaceAttribute;

% convert to a workable format
stimMark4DMatrix = stimMarkerXML.TriggerMarker(:);

stimMark4DMatrix = stimMark4DMatrix(:);

% convert from a structure into a vector for each marker
for i = 1:size(stimMark4DMatrix,1)
stimMark4DVectors(i,:) = cell2mat(struct2cell(stimMark4DMatrix(i).Matrix4D));
end

rmNanIDs = find(stimMark4DVectors(:,1) == -1);

stimMark4DVectors(rmNanIDs,:) = [];

% check the size of the stimulation markers
size(stimMark4DVectors)

if strcmp(coordinateSpace,'LPS')
scale = [-1 -1 1];
rotScale = [1 1 1 1 1 1 1 1 1];
pFinal = [40;0;0];
elseif strcmp(coordinateSpace,'RAS')
scale = [1 1 1];
rotScale = [1 1 1 1 1 1 1 1 1];
pFinal = [40;0;0];
end

% define a variable with only the stimulation marker positions
stimMarkerPoints = [stimMark4DVectors(:,[4 8 12])];

stimMarkerRot = [stimMark4DVectors(:,[1:3 5:7 9:11])] .* rotScale;

stimRotMat = reshape(stimMarkerRot',3,3,[]);
stimRotMat2 = permute(stimRotMat,[2 1 3]);


%%

% this section of code computes the points of the location that the TMS
% coil sees after the new rotation and transformation

clear stimMarkerEnds stimMarkerPoints2 pBSave

for i = 1:size(stimMarkerPoints,1)
pA = stimMarkerPoints(i,:)';
R0 = eye(3,3);
T0A = [R0; 0 0 0];
T0A = [T0A, [pA; 1]];

R1 = [stimRotMat2(:,:,i)];
TAB = [R1; 0 0 0];
TAB = [TAB, [0; 0; 0; 1]];
pB = T0A*TAB*[pFinal;1];

stimMarkerEnds(i,:) = scale'.*pB(1:3);
pBSave(i,:) = pB(1:3);
end

stimMarkerPoints2 = stimMarkerPoints .* scale;

I = find(stimMarkerPoints2(:,1)==0);
stimMarkerPoints2(I,:) = [];
stimMarkerEnds(I,:) = [];

%%

clear stimLineVectors C C_proj

% creating the plane of projection for the stimulation markers

stimLineVectors = [stimMarkerPoints2 - stimMarkerEnds]; % vector for each line of stimulation

AVG_line_stimulation = squeeze(nanmean(stimLineVectors,1));

AP_Vector = [0,1,0]; % anterior posterior unit vector;

y_Line = cross(AP_Vector,AVG_line_stimulation); % normal vector
AVG_line_stimulation = cross(y_Line,AP_Vector);

Target_Marker = [T4{sID,2},T4{sID,3},T4{sID,4}]; % point on the plane

origin = Target_Marker;
e_1 = AP_Vector;
e_2 = y_Line ./ norm(y_Line);

% iterate through all the sitmulation marker end points and project them
% onto the plane
for i = 1:size(stimMarkerPoints,1)
C(i,:) = stimMarkerEnds(i,:); % point to project
C_proj(i,:) = projPointToPlane(AVG_line_stimulation,Target_Marker,C(i,:));

C_proj_XY{i,1,sID} = [dot(e_1, (C_proj(i,:) - origin))];
C_proj_XY{i,2,sID} = [dot(e_2, (C_proj(i,:) - origin))];
end

s = dot(AVG_line_stimulation,(C_proj(1,:) - origin)); % distance between the plane and the point

dot(e_1, AVG_line_stimulation);
dot(e_2, AVG_line_stimulation);


%%
% close all
% figure;
% plot3(C(:,1), C(:,2), C(:,3), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b'); % Original point
% hold on;
% plot3([0 AP_Vector(1)],[0 AP_Vector(2)*10],[0 AP_Vector(3)],'k-','LineWidth',2)
% plot3([0 AVG_line_stimulation(1)],[0 AVG_line_stimulation(2)*10],[0 AVG_line_stimulation(3)],'r-','LineWidth',2)
% plot3([0 y_Line(1)],[0 y_Line(2)*10],[0 y_Line(3)],'g-','LineWidth',2)
% plot3(Target_Marker(1), Target_Marker(2), Target_Marker(3), 'g*', 'MarkerSize', 18,'LineWidth',3); % Point on plane
% plot3(C_proj(:,1), C_proj(:,2), C_proj(:,3), 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % Projected point
% % plot3([C(1), C_proj(1)], [C(2), C_proj(2)], [C(3), C_proj(3)], 'k--'); % Line connecting the points
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('Point Projection onto a Plane');
% legend('Original Point', 'Point on Plane', 'Projected Point');
% grid on;
% hold off;

%%

% plot the position of the target location for all subjects
close all

% Define the origin point
origin = [0, 0, 0];

subjName

% Define points on the x, y, and z axes
x_axis_point = [-100, 0, 0];
y_axis_point = [0, -100, 0];
z_axis_point = [0, 0, 100];

expName = {'Experiment 1','Experiment 2','Experiment 3','Experiment 4'};

for j = 4

figure('Position',[50 100 1400 600])
% col = jet(nSubjs);
% colororder(col)
subplot(1,1,1)

if j == 1
    TX = T1;
elseif j == 2
    TX = T2;
elseif j == 3
    TX = T3;
elseif j == 4
    TX = T4;
end

% plotting the points and lines for each target and entry

for i = sID

% Concatenate the coordinates into a matrix
ETmarkers = [TX{i,2},TX{i,3},TX{i,4};TX{i,5},TX{i,6},TX{i,7}];

% Plot the line
p1 = plot3(ETmarkers(:,1), ETmarkers(:,2), ETmarkers(:,3),'k-','LineWidth',2);
hold on
end

s1 = scatter3(TX{i,2},TX{i,3},TX{i,4},36,'ro','LineWidth',3);
s2 = scatter3(TX{i,5},TX{i,6},TX{i,7},36,'go','LineWidth',3);

s3 = scatter3(stimMarkerPoints2(:,1),stimMarkerPoints2(:,2)...
     ,stimMarkerPoints2(:,3),36,'bo','LineWidth',3);

for i = 1:size(stimMarkerPoints2,1)
p2 = plot3([stimMarkerPoints2(i,1) stimMarkerEnds(i,1)], ...
    [stimMarkerPoints2(i,2) stimMarkerEnds(i,2)], [stimMarkerPoints2(i,3) stimMarkerEnds(i,3)],...
    'c-','LineWidth',1);
hold on

% plotrefsys(stimulationRotMat2(:,:,i),stimulationMarkerPoints(i,:)','k')

end

% Plot the x-axis line
plot3([origin(1), x_axis_point(1)], [origin(2), x_axis_point(2)], [origin(3), x_axis_point(3)], 'k-', 'LineWidth', 2);
% Plot the y-axis line
plot3([origin(1), y_axis_point(1)], [origin(2), y_axis_point(2)], [origin(3), y_axis_point(3)], 'k-', 'LineWidth', 2);
% Plot the z-axis line
plot3([origin(1), z_axis_point(1)], [origin(2), z_axis_point(2)], [origin(3), z_axis_point(3)], 'k-', 'LineWidth', 2);

% plot the projected plane
% plot3([0 AP_Vector(1)],[0 AP_Vector(2)*10],[0 AP_Vector(3)],'k-','LineWidth',2)
% plot3([0 AVG_line_stimulation(1)],[0 AVG_line_stimulation(2)*10],[0 AVG_line_stimulation(3)],'r-','LineWidth',2)
% plot3([0 y_Line(1)],[0 y_Line(2)*10],[0 y_Line(3)],'g-','LineWidth',2)

% plot3(Target_Marker(1), Target_Marker(2), Target_Marker(3), 'g*', 'MarkerSize', 18,'LineWidth',3); % Point on plane

% plot3(C(:,1), C(:,2), C(:,3), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g'); % Original point
p4 = plot3(C_proj(:,1), C_proj(:,2), C_proj(:,3), 'ms', 'MarkerSize', 10, 'MarkerFaceColor', 'm'); % Projected point

title([expName{j} ' - P0' num2str(sID)])
grid on
box on

xlim([-110 10])
ylim([-110 10])
zlim([0 150])
xlabel('Marker-X')
ylabel('Marker-Y')
zlabel('Marker-Z')
ax = gca;
% ax.ColorOrder = col;
set(ax,'FontSize',20)
% colorbar
% caxis([0 nSubjs])
% colormap(jet)

legend([p1(1) s1(1) s2(1) s3(1) p4],'Line','Target','Entry','Stimulation','Projected Marker')

% view(0,0) % X and Z axes
view(-90,0) % Y and Z axes

fileName = ['Localite_' expName{j} '_P0' num2str(sID) '_3DMarkerPoints_YZ'];
exportgraphics(gcf, [FigurePath 'P0' num2str(sID) '\Localite\' fileName '.png'])

% view(10,30) 

view(0,0)

fileName = ['Localite_' expName{j} '_P0' num2str(sID) '_3DMarkerPoints_XZ'];
exportgraphics(gcf, [FigurePath 'P0' num2str(sID) '\Localite\' fileName '.png'])
saveas(gcf, [FigurePath 'P0' num2str(sID) '\Localite\' fileName '.fig'])

end

% close all


%% Stimulation Marker Point Distance Calculations

% size(stimMarkerPoints)
% size(TX)
if sID == 1
clear dSE distLineT
end

% distance from stimulation marker to the entry marker
for i = 1:size(stimMarkerPoints2,1)

A = stimMarkerPoints2(i,:);
B = TX{sID,5:7}; % entry marker location
dSE{i,sID} = norm(A - B);


% distance from stimulation line to target point
% Define the target point
point = [TX{sID,2:4}]; % target marker location
% Define the stimulation line (using two points)
line_point1 = [stimMarkerPoints2(i,:)];
line_point2 = [stimMarkerEnds(i,:)];

% Calculate the distance
distLineT{i,sID} = point_to_line_distance(point, line_point1, line_point2);

end


%% Save as subject structure to a matlab folder

subjLocalite(sID) = struct('stimMarkerPoints',stimMarkerPoints,'stimMarkerEnds',stimMarkerEnds,...
    'DistMarkerEntry',[dSE{:,sID}],'DistLineTarget',[distLineT{:,sID}],'stimRotMat2',stimRotMat2,...
    'T3',T3,'stimMarkerPoints2',stimMarkerPoints2);


end

% save('processedLocaliteMarkersExp4.mat')

save('processedMarkersExp4.mat')



%% Maximum Displacement and Maximum Distance from target


for sID = [1:12]

maxDisplaceTar(sID) = max( abs(subjLocalite(sID).DistLineTarget(end-numTaskMarkers:end) - subjLocalite(sID).DistLineTarget(end-numTaskMarkers)) ) ;
meanDisplaceTar(sID) = mean( abs(subjLocalite(sID).DistLineTarget(end-numTaskMarkers:end) - subjLocalite(sID).DistLineTarget(end-numTaskMarkers)) ) ;
stdDisplaceTar(sID) = std( abs(subjLocalite(sID).DistLineTarget(end-numTaskMarkers:end) - subjLocalite(sID).DistLineTarget(end-numTaskMarkers)) ) ;

maxDistfromTar(sID) = max(subjLocalite(sID).DistLineTarget(end-numTaskMarkers:end)) ;
meanDistfromTar(sID) = mean(subjLocalite(sID).DistLineTarget(end-numTaskMarkers:end)) ;
stdDistfromTar(sID) = std(subjLocalite(sID).DistLineTarget(end-numTaskMarkers:end)) ;

end



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

% fileName = ['TMSLocaliteEntry_AllExps_3DScatter_X,Z.png'];
% exportgraphics(gcf, [FigurePath '\' fileName])


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

% exportgraphics(gcf, [FigurePath '\' fileName])


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
set(gca,'FontSize',18)
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

% exportgraphics(gcf, [FigurePath '\' fileName])



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

% exportgraphics(gcf, [FigurePath '\' fileName])


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

% exportgraphics(gcf, [FigurePath '\' fileName])



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

% fileName = ['TargetLocationvsT3Reduction_AllExps.png'];
% exportgraphics(gcf, [FigurePath '\' fileName])



%%
