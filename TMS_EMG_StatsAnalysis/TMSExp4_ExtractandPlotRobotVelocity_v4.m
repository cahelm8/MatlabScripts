


%% TMS Exp 4 - TMS Intensity Change group - Extract and Plot Robot Velocities and Position and Torque Data for Each Trial
clc
clear all
close all
% load in modesMat

plottingScriptsPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts'];
addpath(plottingScriptsPath)


saveFig = 0; % if saveFig = 1(figures will be saved as png, else figures will not be saved)

subjList = [{'P01','P02','P03','P04','P05','P06','P07','P08','P09','P010','P011','P012'}]; %
% T1List = [25 35 32 35 28 20 33 33 35 37 26 39 33];


%%


% enter the subject ID to be processed
for s = [3]
close all

TMSexp = 4;
    
% subjNum = subjList{s};
if s < 10
subjNum = ['P0' num2str(s)];
else
subjNum = ['P' num2str(s)];
end

subjNum
    
if TMSexp == 1
subjectPath = ['Z:\StudentFolders\Cody\Projects\TMS\Dataset\' subjNum];
load([subjectPath '\modesmat.mat'])

elseif TMSexp == 4
subjectPath = ['Z:\StudentFolders\Cody\Projects\TMS\Dataset\TMSExp4Group\' subjNum];
load([subjectPath '\modesMat_Intensity.mat'])

end

% state 1 - pert onset
% state 2 - wait
% state 3 - return
% state 4 - wait before next trial

% modes Mat Idx for each condition
BackOnlyIdx = find(modesMat(1,:) == 0 & modesMat(6,:) == 1);
PertOnlyIdx = find(modesMat(1,:) == 150 & modesMat(6,:) == 1);

TMSOnlyIdx = find(modesMat(1,:) == 0 & modesMat(6,:) == 4 & modesMat(7,:) == modesIntens(1) );
t3indx = find(modesMat(1,:) == 150 & modesMat(6,:) == 4  & modesMat(7,:) == modesIntens(1) );

TMSOnlyIdx_Sup = find(modesMat(1,:) == 0 & modesMat(6,:) == 4 & modesMat(7,:) == modesIntens(2) );
t3indx_Sup = find(modesMat(1,:) == 150 & modesMat(6,:) == 4  & modesMat(7,:) == modesIntens(2) );

% TMS conditions indexes
NoPertConditions = find(modesMat(1,:) == 0);

BackOnlyIdx2 = find(ismember( NoPertConditions ,BackOnlyIdx));
TMSOnlyIdx2 = find(ismember( NoPertConditions , TMSOnlyIdx));
TMSOnlyIdx2_Sup = find(ismember( NoPertConditions , TMSOnlyIdx_Sup));

% Pert conditions indexes
PertConditions = find(modesMat(1,:) == 150);

PertOnlyIdx2 = find(ismember( PertConditions ,PertOnlyIdx));
TMSPertIdx2 = find(ismember( PertConditions , t3indx));
TMSPertIdx2_Sup = find(ismember( PertConditions , t3indx_Sup));




%%

% Find the start time in terms of matlab IDs for each trial
stateAllTrials = state(:,2);

pertOnID = intersect(find(stateAllTrials==0),find(diff(stateAllTrials)==1));
nonPertTrials = intersect(find(stateAllTrials==0),find(diff(stateAllTrials)>1));

plot(stateAllTrials,'b-')
hold on
plot(pertOnID,[1],'ro')
legend('State','PertOn')

% in milliseconds
startID = pertOnID - 500;
endID = pertOnID + 1000;

startIDnoPert = nonPertTrials - 500;
endIDnoPert =  nonPertTrials + 1000;

for i = 1:length(startID)
   RobotPos(:,i) = measPos(startID(i):endID(i),2);
   RobotVel(:,i) = measVel(startID(i):endID(i),2);
   torque(:,i) = tauW(startID(i):endID(i),2); % FE wrist torque
end

for i = 1:length(startIDnoPert)
torqueBack(:,i) = tauW(startIDnoPert(i):endIDnoPert(i),2); % FE wrist torque
RobotBack(:,i) = measPos(startIDnoPert(i):endIDnoPert(i),2); % no PTB for background
end

torque = abs(torque);
torqueBack = abs(torqueBack);

torqueDataOrdered = cat(3,torqueBack(:,BackOnlyIdx2),torque(:,PertOnlyIdx2),...
    torqueBack(:,TMSOnlyIdx2), torque(:,TMSPertIdx2), torqueBack(:,TMSOnlyIdx2_Sup),torque(:,TMSPertIdx2_Sup));

size(torqueDataOrdered)


SubjBehavData(s) = struct('MotorPos',RobotPos,'MotorVel',RobotVel,'SubjTorque',torqueDataOrdered);

if s == 12
% save('SubjBehavData.mat','SubjBehavData')
end

end


%% Plotting Behavioral Data (Robot position and velocity measurements)

x = [1:1501];

close all
figure('Position',[100 100 1300 650])

subplot(1,2,1)
plot(x, mean(RobotPos,2),'b-','LineWidth',3)
hold on
xline(500,'k--','Pert Onset','LineWidth',2,'FontSize',22,'LabelHorizontalAlignment','left')
xline(700,'k--','Pert Offset','LineWidth',2,'FontSize',22)
std_plot(RobotPos',x,'b',0.2);

set(gca,'FontSize',18)
title('Motor Displacement')
xlabel('\bf Time [ms]','FontSize',26)
ylabel('\bf Position [^{\circ}]','FontSize',26)
xlim([0 1501])
xticks([0:500:1500])
xticklabels([{'-500','0','500','1000'}])
box on
xtickangle(0)
ylim([-1 50])

subplot(1,2,2)
plot(x, mean(RobotVel,2),'r-','LineWidth',3)
hold on
xline(500,'k--','Pert Onset','LineWidth',2,'FontSize',22,'LabelHorizontalAlignment','left')
xline(700,'k--','Pert Offset','LineWidth',2,'FontSize',22)
std_plot(RobotVel',x,'r',0.2);

set(gca,'FontSize',18)
title('Motor Velocity')
xlabel('\bf Time [ms]','FontSize',26)
ylabel('\bf Velocity [^{\circ}/s]','FontSize',26)
xlim([0 1501])
ylim([-1 400])
xticks([0:500:1500])
xticklabels([{'-500','0','500','1000'}])
xtickangle(0)
box on

sgtitle(['\bf' subjList{s}],'FontSize',24)

if saveFig == 1
Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];
FileName = [subjList{s} '\RobotData-' subjList{s} '.png'];
exportgraphics(gcf,[Figure_path FileName]);
end



%% Plotting Behavioral Data (Robot Position Only)

x = [1:1501];

close all
figure('Position',[100 100 800 650])

subplot(1,1,1)
p1 = plot(x, mean(RobotPos,2),'b-','LineWidth',3);
hold on
xline(500,'k--','Pert Onset','LineWidth',3,'FontSize',24,'LabelHorizontalAlignment','left')
xline(700,'k--','Pert Offset','LineWidth',3,'FontSize',24)
std_plot(RobotPos',x,'b',0.2);

hold on
p2 = plot(x, mean(RobotBack,2),'r-','LineWidth',3);
hold on
xline(500,'k--','Pert Onset','LineWidth',3,'FontSize',24,'LabelHorizontalAlignment','left')
xline(700,'k--','Pert Offset','LineWidth',3,'FontSize',24)
std_plot(RobotBack',x,'b',0.2);

set(gca,'FontSize',22)
% title('Robot Position')
xlabel('\bf Time [ms]','FontSize',26)
ylabel('\bf Motor Displacement [^{\circ}]','FontSize',26)
xlim([300 1000])
xticks([0:100:1000])
xticklabels([{'-500','-400','-300','-200','-100','0','100','200','300','400','500'}])
box on
ylim([-1 50])

legend([p1 p2],'PTB','Back')


if saveFig == 1
Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];
FileName = [subjList{s} '\RobotPosition-' subjList{s} '.png'];
exportgraphics(gcf,[Figure_path FileName]);
end


%% Plotting torque for each trial

x = [1:1501];
close all
figure('Position',[100 100 1100 650])


col = flipud([1 0 0;1 0.5 0;1 1 0;0 1 0;0 0.5 1;0 0 1]);

subplot(1,1,1)


p(1) = plot(x, mean(torqueDataOrdered(:,:,1),2),'-','Color',col(1,:),'LineWidth',3);
hold on
std_plot(torqueDataOrdered(:,:,1)',x,col(1,:),0.2);

p(2) = plot(x, mean(torqueDataOrdered(:,:,2),2),'-','Color',col(2,:),'LineWidth',3);
hold on
std_plot(torqueDataOrdered(:,:,2)',x,col(2,:),0.2);

p(3) = plot(x, mean(torqueDataOrdered(:,:,3),2),'-','Color',col(3,:),'LineWidth',3);
hold on
std_plot(torqueDataOrdered(:,:,3)',x,col(3,:),0.2);

p(4) = plot(x, mean(torqueDataOrdered(:,:,4),2),'Color',col(4,:),'LineWidth',3);
hold on
std_plot(torqueDataOrdered(:,:,4)',x,col(4,:),0.2);

p(5) = plot(x, mean(torqueDataOrdered(:,:,5),2),'-','Color',col(5,:),'LineWidth',3);
hold on
std_plot(torqueDataOrdered(:,:,5)',x,col(5,:),0.2);

p(6) = plot(x, mean(torqueDataOrdered(:,:,6),2),'-','Color',col(6,:),'LineWidth',3);
hold on
std_plot(torqueDataOrdered(:,:,6)',x,col(6,:),0.2);

xline(500,'k--','Pert Onset','LineWidth',2.5,'FontSize',24,'LabelHorizontalAlignment','left')
xline(700,'k--','Pert Offset','LineWidth',2.5,'FontSize',24,'LabelHorizontalAlignment','right')
yline(0.3+0.07,'k--','Target','LineWidth',3,'FontSize',20,'LabelHorizontalAlignment','left')
yline(0.3-0.07,'k--','LineWidth',3)

k1 = patch([500 500 700 700],[0 2 2 0],[0.8 0.8 0.8],'FaceAlpha',1);
hold on

% title('FE Torque')
xlim([0 1400])
xticks([0:250:1500])
xticklabels([{'-500','-250','0','250','500','750','1000'}])
set(gca,'FontSize',24)
xlabel('\bf Time [ms]','FontSize',30)
ylabel('\bf FE Torque [N\cdotm]','FontSize',30)
box on
legend([p(1:6)],[{'Back','Pert','TMS(sub)','T_3(sub)','TMS(supra)','T_3(supra)'}],'NumColumns',2,'IconColumnWidth',10)
ylim([0 2])

sgtitle(['\bf ' subjList{s}],'FontSize',30)

if saveFig == 1
Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];
FileName = [subjList{s} '\FETorqData-' subjList{s} '.png'];
exportgraphics(gcf,[Figure_path FileName]);
end


% close all
% end

%%





