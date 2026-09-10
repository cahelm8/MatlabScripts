

clc
clear all
close all
% load in modesMat

plottingScriptsPath = ['Z:\StudentFolders\Cody\Projects\TMS\Processing\PlottingScripts'];
addpath(plottingScriptsPath)

saveFig = 0;

load('SubjBehavData.mat','SubjBehavData');

%%
for s = 1:12
groupTorque(:,:,:,s) = SubjBehavData(s).SubjTorque;

groupPos(:,:,s) = SubjBehavData(s).MotorPos;
groupVel(:,:,s) = SubjBehavData(s).MotorVel;
end

withSubj_groupTorque = squeeze(mean(groupTorque,2));

mean_groupTorque = mean(withSubj_groupTorque,3);
std_groupTorque = std(withSubj_groupTorque,0,3);

withSubj_groupPos = squeeze(mean(groupPos,2));
withSubj_groupVel = squeeze(mean(groupVel,2));

%%

x = [1:651];
close all
figure('Position',[100 100 1100 650])


col = flipud([1 0 0;1 0.5 0;1 1 0;0 1 0;0 0.5 1;0 0 1]);

subplot(1,1,1)

p(1) = plot(x, mean_groupTorque(:,1),'-','Color',col(1,:),'LineWidth',3);
hold on
std_plot(squeeze(withSubj_groupTorque(:,1,:))',x,col(1,:),0.2);

p(2) = plot(x, mean_groupTorque(:,2),'-','Color',col(2,:),'LineWidth',3);
hold on
std_plot(squeeze(withSubj_groupTorque(:,2,:))',x,col(2,:),0.2);

p(3) = plot(x, mean_groupTorque(:,3),'-','Color',col(3,:),'LineWidth',3);
hold on
std_plot(squeeze(withSubj_groupTorque(:,3,:))',x,col(3,:),0.2);

p(4) = plot(x, mean_groupTorque(:,4),'Color',col(4,:),'LineWidth',3);
hold on
std_plot(squeeze(withSubj_groupTorque(:,4,:))',x,col(4,:),0.2);

p(5) = plot(x, mean_groupTorque(:,5),'-','Color',col(5,:),'LineWidth',3);
hold on
std_plot(squeeze(withSubj_groupTorque(:,5,:))',x,col(5,:),0.2);

p(6) = plot(x, mean_groupTorque(:,6),'-','Color',col(6,:),'LineWidth',3);
hold on
std_plot(squeeze(withSubj_groupTorque(:,6,:))',x,col(6,:),0.2);

xline(200,'k--','Pert Onset','LineWidth',2.5,'FontSize',24,'LabelHorizontalAlignment','left')
xline(400,'k--','Pert Offset','LineWidth',2.5,'FontSize',24,'LabelHorizontalAlignment','right')
yline(0.3+0.07,'m--','Torque Target','LineWidth',3,'FontSize',20,'LabelHorizontalAlignment','left')
yline(0.3-0.07,'m--','LineWidth',3)

% title('FE Torque')
xlim([0 650])
xticks([0:100:650])
xticklabels([{'-200','-100','0','100','200','300','400','500'}])
set(gca,'FontSize',20)
xlabel('\bf Time [ms]','FontSize',30)
ylabel('\bf FE Torque [Nm]','FontSize',30)
box on
legend([p(1:6)],'Back','Pert','TMS(Sub)','T_3(Sub)','TMS(Sup)','T_3(Sup)')
ylim([0 2])


if saveFig == 1
Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];
FileName = ['\FETorqData-GroupLevel.png'];
exportgraphics(gcf,[Figure_path FileName]);
end



%%


%% Plotting Behavioral Data (Robot position and velocity measurements)

x = [1:651];

close all
figure('Position',[100 100 1300 650])

subplot(1,2,1)
plot(x, mean(withSubj_groupPos,2),'b-','LineWidth',3)
hold on
xline(200,'k--','Pert Onset','LineWidth',2,'FontSize',22,'LabelHorizontalAlignment','left')
xline(400,'k--','Pert Offset','LineWidth',2,'FontSize',22)
std_plot(withSubj_groupPos',x,'b',0.2);

set(gca,'FontSize',18)
% title('Motor Displacement','FontSize',28)
xlabel('\bf Time [ms]','FontSize',26)
ylabel('\bf Motor Displacement [^{\circ}]','FontSize',26)
xlim([0 650])
xticks([0:100:600])
xticklabels([{'-200','-100','0','100','200','300','400'}])
box on
xtickangle(0)
ylim([-1 50])

subplot(1,2,2)
plot(x, mean(withSubj_groupVel,2),'r-','LineWidth',3)
hold on
xline(200,'k--','Pert Onset','LineWidth',2,'FontSize',22,'LabelHorizontalAlignment','left')
xline(400,'k--','Pert Offset','LineWidth',2,'FontSize',22)
std_plot(withSubj_groupVel',x,'r',0.2);

set(gca,'FontSize',18)
% title('Motor Velocity','FontSize',28)
xlabel('\bf Time [ms]','FontSize',28)
ylabel('\bf Motor Velocity [^{\circ}/s]','FontSize',28)
xlim([0 650])
ylim([-1 400])
xticks([0:100:600])
xticklabels([{'-200','-100','0','100','200','300','400'}])
xtickangle(0)
box on


if saveFig == 1
Figure_path = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];
FileName = ['\RobotData-GroupLevel.png'];
exportgraphics(gcf,[Figure_path FileName]);
end



%%