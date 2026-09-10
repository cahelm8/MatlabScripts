clc
close all


% load('SavedData\FinalEMGData_TMSExp4.mat')


%%

% close all
% plotting the uncropped non-normalized bandpass filtered only EMG data
close all
subplot = @(m,n,p) subtightplot(m,n,p,[0.06 0.1], [0.14 0.10], [0.10 0.1]);

for s = [12]
close all

figure('Position',[100 100 1000 650])
sgtitle(['\bf P0' num2str(s) ' - BP Filtered'],'FontSize',30)
for c = 1:nConds
    subplot(3,2,c)
    plot(squeeze(FCR_nonnormBP(:,:,c,s))')
    xticks([0:500:2250])
    if c == 6
    xticklabels({'-200', '-100','0','100','200'})
    else
        xticklabels({'', '','','',''})
    end
    hold on
    xline([1000],'--','Pert Onset','LineWidth',2)
    xline([1500],'--','LLR Offset','LineWidth',2)
    xline([1250],'--','LLR Onset','LineWidth',2)
    if c == 1
    ylabel('EMG [\mu V]')
    end
    if c == 6
    xlabel('Time [ms]')
    end
    xlim([0 2250])
    ylim([-400 400])
    set(gca,'FontSize',18)
end

FigurePath_Subj = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];
FileName = ['TMSExp4_FCR_EMG_Subject_BPFilteredEMG'];

exportgraphics(gcf, [FigurePath_Subj 'P0' num2str(s) '\' FileName '.png']);

end



%%

for s = 1
figure('Position',[100 100 900 600])
sgtitle(['/bf P0' num2str(s) '- Raw EMG'],'FontSize',30)
for c = 1:nConds
    subplot(4,1,c)
    plot(squeeze(allSubjData_nonnormRaw_TMSExp4(:,:,c,s))')
    xticks([0:250:1250])
    xticklabels({'-100','-50','0','50','100','150'})
    hold on
    xline([500],'--','Pert Onset','LineWidth',2)
    xline([1000],'--','LLR Offset','LineWidth',2)
    xline([750],'--','LLR Onset','LineWidth',2)
    ylabel('EMG [\mu V]')
    xlabel('Time [ms]')
    xlim([0 1250])
    set(gca,'FontSize',18)
end
end


%%

for s = 1
figure('Position',[100 100 900 600])
sgtitle(['P0' num2str(s) '- Detrend'],'FontSize',30)
for c = 1:nConds
    subplot(4,1,c)
    plot(squeeze(FCR_nonnorm_DT(:,:,c,s))')
    xticks([0:250:1250])
    xticklabels({'-100','-50','0','50','100','150'})
    hold on
    xline([500],'--','Pert Onset','LineWidth',2)
    xline([1000],'--','LLR Offset','LineWidth',2)
    xline([750],'--','LLR Onset','LineWidth',2)
    ylabel('EMG [\mu V]')
    xlabel('Time [ms]')
    xlim([0 1250])
    set(gca,'FontSize',18)
end
end


%%

for s = 1
figure('Position',[100 100 900 600])
sgtitle(['P0' num2str(s) '- Back Mean Removed'],'FontSize',30)
for c = 1:nConds
    subplot(4,1,c)
    plot(squeeze(FCR_nonnorm_demean(:,:,c,s))')
    xticks([0:250:1250])
    xticklabels({'-100','-50','0','50','100','150'})
    hold on
    xline([500],'--','Pert Onset','LineWidth',2)
    xline([1000],'--','LLR Offset','LineWidth',2)
    xline([750],'--','LLR Onset','LineWidth',2)
    ylabel('EMG [\mu V]')
    xlabel('Time [ms]')
    xlim([0 1250])
    set(gca,'FontSize',18)
end
end

%%

for s = 1
figure('Position',[100 100 900 600])
sgtitle(['P0' num2str(s) ' - Fully Filtered'],'FontSize',30)
for c = 1:nConds
    subplot(4,1,c)
    % plot(squeeze(FCR_nonnorm_enveloped(:,:,c,s))')
    xticks([0:250:1250])
    xticklabels({'-100','-50','0','50','100','150'})
    hold on
    xline([500],'--','Pert Onset','LineWidth',2)
    xline([1000],'--','LLR Offset','LineWidth',2)
    xline([750],'--','LLR Onset','LineWidth',2)
    ylabel('EMG [\mu V]')
    xlabel('Time [ms]')
    xlim([0 1250])
    set(gca,'FontSize',18)
end
end


%% Plotting EMG peak and standard deviation

close all
x = [1:6];

figure('Position',[100 100 1400 600])
for s = 1:nSubjs
subplot(3,4,s)

for t = 1:20
for c = 1:6
p1 = plot([x(c)-0.1 x(c)+0.1],[MEPpeak(t,c,s) MEPstd(t,c,s)],'k-o');
hold on
end
end

% p2 = plot(x-0.1,MEPstd(:,:,s),'ro');
hold on

xticks([1:6])
xtickangle(0)
xticklabels({'B','P','T','T3','T(S)','T3(S)'})

ylabel('EMG (\muv)')
title(['EMG - P0' num2str(s)])
set(gca,'FontSize',20)

% if s == 1
% legend([p1(1) p2(1)],'EMG Peak','EMG STD')
% end

end



%%
close all

figure('Position',[100 60 1300 600])
subplot = @(m,n,p) subtightplot(m,n,p,[0.18 0.1], [0.14 0.12], [0.10 0.1]);

for s = 1:nSubjs
subplot(3,4,s)
cdfplot(MEPpeakCat(:,s))
hold on
xline(x_value(s), 'r--', 'CDF = 0.95','LineWidth',2);
yline([0.95],'--r','LineWidth',2)
sgtitle(['\bf MEP Peak CDF'],'FontSize',25)
title(['P0' num2str(s)])
set(gca, 'FontSize',18)
ylim([0 1.2])
end

% close all

FileName = ['TMSExp4_MEPPeak_CDF_plot'];
% saveas(gcf, [FigurePath FileName '.fig']);
% 
% exportgraphics(gcf, [FigurePath FileName '.png']);

% figure
% hist(MEPstdCat)
% title('MEP EMG St. Dev. Histogram')

%%

close all

figure('Position',[100 60 1100 600])
subplot = @(m,n,p) subtightplot(m,n,p,[0.18 0.1], [0.14 0.10], [0.10 0.1]);
subplot(1,1,1)

col = jet(12);

for s = 1:nSubjs
hold on
xLine = xline(x_value(s), '--', ['P0' num2str(s)], 'Color',col(s,:), 'LineWidth',3);

if s > 10
xLine.LabelHorizontalAlignment = 'left';
end

hold on
end
xlabel(['EMG (\mu V)'])
sgtitle(['MEP Threshold'],'FontSize',26)
set(gca, 'FontSize',18)
box on

FileName = ['TMSExp4_MEPThresh_Exp_plot'];
% saveas(gcf, [FigurePath FileName '.fig']);
exportgraphics(gcf, [FigurePath FileName '.png']);

%%

close all
figure('Position',[100 60 600 500])
histogram(x_value,'BinWidth',25,'FaceColor',[0.1 0.6 0.75])
hold on
title(['MEP Threshold'],'FontSize',26)
ylabel('Freq')
xlabel('EMG (\muV)')
set(gca, 'FontSize',18)

FileName = ['TMSExp4_MEPThresh_Histogram_plot'];
exportgraphics(gcf, [FigurePath FileName '.png']);


%%

close all
x = [1:6];

figure('Position',[100 100 1000 600])
for s = 1:nSubjs
subplot(2,3,s)
p1 = plot(x-0.1,MEPControlMean(:,:,s),'ro');
hold on
p2 = plot(x,MEPControlSTD(:,:,s),'bo');
hold on
p3 = plot(x+0.1,MEPpeak(:,:,s),'go');
hold on

boxplot(MEPControlMean(:,:,s),x,'Colors','r','Positions',x-0.1);
hold on
boxplot(MEPControlSTD(:,:,s),x,'Colors','b','Positions',x);
hold on
boxplot(MEPpeak(:,:,s),x,'Colors','g','Positions',x+0.1);
hold on
ylabel('EMG (\muv)')
title(['EMG MEP - P0' num2str(s)])
set(gca,'FontSize',20)

if s == 1
legend([p1(1) p2(1) p3(1)],'Back Mean','Back STD','MEP Peak')
end

end




%% Threshold Table for MEP + and MEP - for each subject

for s = [1:nSubjs]
MEPPos_1X(s) = sum(MEPthres_1X_I(:,s)==2);
MEPNeg_1X(s) = sum(MEPthres_1X_I(:,s)==1);
MEPPos200(s) = sum(MEP_200Thres(:,s)==2);
MEPNeg200(s) = sum(MEP_200Thres(:,s)==1);
MEPPos95CI(s) = sum(MEP_95CIThres(:,s)==2);
MEPNeg95CI(s) = sum(MEP_95CIThres(:,s)==1);
MEPPosAMT(s) = sum(MEP_AMT_Thres(:,s)==2);
MEPNegAMT(s) = sum(MEP_AMT_Thres(:,s)==1);
MEPPos_2X(s) = sum(MEPthres_2X_I(:,s)==2);
MEPNeg_2X(s) = sum(MEPthres_2X_I(:,s)==1);
MEPPos_3X(s) = sum(MEPthres_3X_I(:,s)==2);
MEPNeg_3X(s) = sum(MEPthres_3X_I(:,s)==1);
MEPPos_Med(s) = sum(MEPthresP(:,s)==2);
MEPNeg_Med(s) = sum(MEPthresP(:,s)==1);
end

T = table(MEPNeg_1X',MEPPos_1X',MEPNeg_2X',MEPPos_2X',MEPNeg_3X',MEPPos_3X',MEPNeg200',MEPPos200',MEPNeg95CI',MEPPos95CI',MEPNeg_Med',MEPPos_Med');
totals = sum([MEPNeg_1X',MEPPos_1X',MEPNeg_2X',MEPPos_2X',MEPNeg_3X',MEPPos_3X',MEPNeg200',MEPPos200',MEPNeg95CI',MEPPos95CI',MEPNeg_Med',MEPPos_Med'],1);
T.Properties.VariableNames = [{'1X:MEP(-)','1X:MEP(+)','2X:MEP(-)','2X:MEP(+)','3X:MEP(-)','3X:MEP(+)',...
    '200:MEP(-)','200:MEP(+)','95CI:MEP(-)','95CI:MEP(+)','Median:MEP(-)','Median:MEP(+)'}];
% last line includes the totals
T2 = [T;num2cell(totals)]



%%

T3 = table(MEPNeg95CI',MEPPos95CI',MEPNegAMT',MEPPosAMT');
totals = sum([MEPNeg95CI',MEPPos95CI',MEPNegAMT',MEPPosAMT'],1);
T3.Properties.VariableNames = [{'95CI:MEP(-)','95CI:MEP(+)','AMT:MEP(-)','AMT:MEP(+)'}];


%% MEP thresholding by conditions

MEPthres_1X_I_reshape = reshape(MEPthres_1X_I,20,6,12);

MEPPos_1X_Cond = squeeze(sum(MEPthres_1X_I_reshape(:,:,:)==2));

MEPPos_1X_Cond([1],:) = sum(MEPPos_1X_Cond(1:2,:));
MEPPos_1X_Cond([3],:) = sum(MEPPos_1X_Cond(3:4,:));
MEPPos_1X_Cond([5],:) = sum(MEPPos_1X_Cond(5:6,:));

MEPAMTPos_Cond = squeeze(sum(IndSave2_MEP_AMT(:,:,:)==2));

MEPAMTPos_Cond([1],:) = sum(MEPAMTPos_Cond(1:2,:));
MEPAMTPos_Cond([3],:) = sum(MEPAMTPos_Cond(3:4,:));
MEPAMTPos_Cond([5],:) = sum(MEPAMTPos_Cond(5:6,:));



%% Plotting MEP peak during MEP window for all subjects and conditions


close all
subplot = @(m,n,p) subtightplot(m,n,p,[0.11 0.04], [0.14 0.17], [0.10 0.11]);

fig = figure('Position',[100 0 1400 700]);
sgtitle('\bf MEP Peak','FontSize',30)
cmap = jet(nReps);

for s = [1:nSubjs]
subplot(3,4,s)
hold on
for j = 1:nReps
plot([1:nConds],MEPpeak(j,:,s)','.','Color',cmap(j,:),'MarkerSize',10)
hold on
end
title(['P0' num2str(s)])
set(gca,'FontSize',16)
xticks([1:nConds])
% ylim([-20 550])

% threshold value
j(1) = yline([200],'r--','LineWidth',2);
% j(2) = yline([MEPthres_median(s)],'b--','LineWidth',2);
j(3) = yline([threshold_3x(s)],'g--','LineWidth',2);
j(4) = yline([threshold_2x(s)],'m--','LineWidth',2);
j(5) = yline([threshold_1x(s)],'c--','LineWidth',2);
j(6) = yline([x_value(s)],'k--','LineWidth',2);
% j(6) = yline([threshold_10x(s)],'k--','LineWidth',2);

if s == 1
    legend([j([1 3:6])],'200uV','3SD','2SD','1SD','95% CI',...
        'Position',[0.72,0.89,0.15,0.09],'FontSize',14,'NumColumns',2)
end

xtickangle(0)
ax = gca;
% yticks([0:200:500])
xlim([0.5 6.5])
xticklabels({'B','P','T','T_3','T(S)','T_3(S)'})
ax.XAxis.FontSize = 14;

grid on
box on

han = axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'TMS Mode','FontSize',25);
ylabel('\bf MEP Peak (\mu V)','Position',[-0.10 0.45],'FontSize',25);

end

colormap(jet)
caxis([0 nReps])
hcb = colorbar('Position',[0.93 0.14 0.02 0.7],'FontSize',16);
hcb.Title.String = ['\bf Trial #'];

FileName = ['TMSExp4_MEPPeak_ThresholdPlot'];
% saveas(gcf, [FigurePath FileName '.fig']);
exportgraphics(gcf, [FigurePath FileName '.png']);


%% Plotting MEP peak during MEP window for all subjects and conditions

close all
subplot = @(m,n,p) subtightplot(m,n,p,[0.17 0.04], [0.14 0.17], [0.10 0.11]);

fig = figure('Position',[100 0 1400 700]);
sgtitle('\bf MEP Peak','FontSize',30)

% Define color range and threshold
v_min = 0;
v_max = 200;
v_thresh = x_value(1);  % color transition happens HERE

% Number of total colormap colors
n = 256;

% Calculate position of the threshold relative to full range
pos_thresh = (v_thresh - v_min) / (v_max - v_min);
n1 = round(pos_thresh * n);     % # of colors before threshold
n2 = n - n1;                    % # of colors after threshold

% from red to red
cmap1 = [linspace(1, 1, n1)', linspace(0, 0, n1)', linspace(0,0,n1)'];
% From green to green
cmap2 = [linspace(0,0,n2)', linspace(1, 1, n2)', linspace(0, 0, n2)'];

customMap = [cmap1; cmap2];

clear col

for s = [1:nSubjs]
subplot(3,4,s)
hold on

for t = 1:nReps

for c = 1:nConds

if MEPpeak(t,c,s) > x_value(s)
    col(t,c,s,:) = [0 1 0];
else
    col(t,c,s,:) = [1 0 0];
end

p1(s) = plot(c,MEPpeak(t,c,s)','.','Color',col(t,c,s,:),'MarkerSize',20);
hold on
end
end

title(['P0' num2str(s)])
set(gca,'FontSize',18)
xticks([1:nConds])
% ylim([-20 550])

% threshold value
j(1) = yline([200],'r--','LineWidth',2);
% j(2) = yline([MEPthres_median(s)],'b--','LineWidth',2);
j(3) = yline([threshold_3x(s)],'g--','LineWidth',2);
j(4) = yline([threshold_2x(s)],'m--','LineWidth',2);
j(5) = yline([threshold_1x(s)],'c--','LineWidth',2);
j(6) = yline([x_value(s)],'k--','LineWidth',2);
% j(6) = yline([threshold_10x(s)],'k--','LineWidth',2);

if s == 1
    legend([j([1 3:6])],'200uV','3SD','2SD','1SD','95% CI',...
        'Position',[0.72,0.89,0.15,0.09],'FontSize',14,'NumColumns',3)
% elseif s==2
%     legend(p1(1),'MEP(-)')
end


xtickangle(0)
% yticks([0:200:500])
xlim([0.5 6.5])
ax = gca;
xticklabels({'B','P','T','T_3','T(S)','T_3(S)'})
ax.XAxis.FontSize = 14;

grid on
box on

han = axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'TMS Mode','FontSize',25);
ylabel('\bf MEP Peak (\mu V)','Position',[-0.10 0.45],'FontSize',25);

end

colormap(customMap)
caxis([0 200])
% hcb = colorbar('Position',[0.93 0.14 0.02 0.7],'FontSize',16);
% hcb.Title.String = ['\bf MEP Peak'];


FileName = ['TMSExp4_MEPPeak_ThresholdPlot_ColorThresh'];
% saveas(gcf, [FigurePath FileName '.fig']);
exportgraphics(gcf, [FigurePath FileName '.png']);



%% Plotting MEP peak during MEP window for all subjects and conditions

close all
subplot = @(m,n,p) subtightplot(m,n,p,[0.17 0.07], [0.13 0.16], [0.10 0.12]);

fig = figure('Position',[100 100 1100 600]);
sgtitle('MEP Peak','FontSize',25)

for s = 1:nSubjs
subplot(3,4,s)
imagesc(MEPpeak(:,:,s))
title(['P0' num2str(s)])
set(gca,'FontSize',18)
colormap(turbo)
caxis([0 300])
xticks([1:nConds])
xticklabels({'B','P','T','T_3','T(S)','T_3(S)'})
xtickangle(0)
yticks([0:10:25])


han = axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'TMS Mode','FontSize',20);
ylabel('\bf Repetition #','Position',[-0.10 0.45],'FontSize',25);

end

hcb = colorbar('Position',[0.92 0.14 0.026 0.7],'FontSize',16);
caxis([0 200])
hcb.Title.String = ['MEP Peak \muV'];


FileName = ['TMSExp4_MEPPeaksGraphics_AllSubj'];
% saveas(gcf, [FigurePath FileName '.fig']);
exportgraphics(gcf, [FigurePath FileName '.png']);



%% Plotting the MEP counts for each subject and each condition

close all
subplot = @(m,n,p) subtightplot(m,n,p,[0.06 0.05], [0.17 0.12], [0.08 0.12]);
cMap = [linspace(0.9,0,2000)' linspace(0.9,0,2000)' linspace(1,1,2000)'];

figure('Position',[200 100 1300 600])
subplot(1,1,1)
imagesc(squeeze(IndCount(1,:,:))')
colormap(turbo)
title('Group')
hold on
ylabel('SubjectID')
yticks([1:nSubjs])
xlabel('TMS Mode')
xticks([1:nConds])
set(gca,'FontSize',16)
xticklabels({'Back','Pert','TMS','T_3','TMS(S)','T_3(S)'})
sgtitle('MEP Counts','FontSize',25)

% subplot(1,2,2)
% imagesc(IndCount(13:24,:,:))
% colormap(turbo)
% hold on
% title('95% Group')

hcb = colorbar('Position',[0.90 0.17 0.02 0.70],'FontSize',16);
hcb.Title.String = ['MEP Counts'];
caxis([0 nReps])

% ylabel('')
% yticks([1:nSubjs])
% xlabel('TMS Mode')
% xticks([1:5])
% set(gca,'FontSize',16)
% xticklabels({'BackOnly','PertOnly','TMSOnly','T_3'})



%% plot the EMG timeseries plots and LLRa data for each subject

% size(allSubjAvg_norm_high_95CI)

colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];
titleNames = {'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra'};


yHeight = [7];
LLRheight = [7];
LLRmin = -0.5;
Ymin = -0.5;

for s = [1:12]
    
close all
col = [colk;colBlue;colGre;colOra;coly;colr];

figure('Position',[50 50 1000 700])
tiledlayout(4,12,"TileSpacing","compact")
sgtitle(['\bf P0' num2str(s)],'FontSize',22)

nexttile(1,[2 9])

for c = 1:nConds

if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end
hold on

p1(c) = plot(allSubjAvg_norm_high_1X(:,c,s),'Color',col(c,:),'LineWidth',2);
hold on
std_plot(squeeze(allSubjData_norm_cropS_high_1X(:,:,c,s)),[1:size(allSubjAvg_norm_high_1X,1)],col(c,:),0.2);
end

% yline(1,'--k','LineWidth',2)

xlim([0 2250])
ylim([Ymin yHeight])
ylabel('EMG [n.u.]')
xticklabels({'' '' '' '' ''})
xlabel('')
% xticklabels({'' '' '' '' ''})
xticks([0:500:2250])

set(gca,'FontSize',20)
ax = gca();
ax.LineWidth = 2;

hleg2 = legend([p1(1) p1(2) p1(3) p1(4) p1(5) p1(6)],...
    'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra','location','northwest','FontSize',17,'NumColumns',4);

allSubjLLRa_high_1X_2 = allSubjLLRa_high_1X;
allSubjLLRa_high_1X_2(:,[2 3],:) = allSubjLLRa_high_1X(:,[3 5],:);
allSubjLLRa_high_1X_2(:,[4 5],:) = allSubjLLRa_high_1X(:,[2 4],:);

allSubjLLRa_low_1X_2 = allSubjLLRa_low_1X;
allSubjLLRa_low_1X_2(:,[2 3],:) = allSubjLLRa_low_1X(:,[3 5],:);
allSubjLLRa_low_1X_2(:,[4 5],:) = allSubjLLRa_low_1X(:,[2 4],:);

nexttile(10,[2 3])
hold on
boxplot(allSubjLLRa_high_1X_2(:,:,s))
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];

scatter(x, allSubjLLRa_high_1X_2(:,:,s),22,[0.7 0.7 0.7],'filled','jitter',0);
hold on
% plot(x(1:2),allSubjLLRa_norm_high_95CI2(:,1:2,s),'k--','LineWidth',0.5)
% plot(x(3:4),allSubjLLRa_norm_high_95CI2(:,3:4,s),'k--','LineWidth',0.5)

hold on
box off

ylim([LLRmin LLRheight])
xlim([0 7])
set(gca,'FontSize',22)
ylabel('LLRa [n.u.]','FontSize',22,'Rotation',270)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

set(ax,'YAxisLocation','right')
set(ax,'XTickLabel',{'','','',''});
ax.TickLabelInterpreter = 'tex';

yh = get(gca,'ylabel'); % handle to the label object
p = get(yh,'position'); % get the current position property
p(1) = 1.15*p(1);        % double the distance, 
set(yh,'position',p) ;

col = [colk;colBlue;colGre;colOra;coly;colr];
nexttile(25,[2 9])

for c = 1:nConds

if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end
hold on

plot(allSubjAvg_norm_low_1X(:,c,s),'Color',col(c,:),'LineWidth',2)
hold on
std_plot(squeeze(allSubjData_norm_cropS_low_1X(:,:,c,s)),[1:size(allSubjAvg_norm_low_1X,1)],col(c,:),0.2);
end

% yline(1,'--k','LineWidth',2)

% xline(750,'k--','MEP Peak','FontSize',14,'LineWidth',3)

xlim([0 2250])
ylim([Ymin yHeight])
ylabel('EMG [n.u.]')
xticklabels({'-200' '-100' '0' '100' '200'})
xlabel('Time [ms]')
xticks([0:500:2250])
set(gca,'FontSize',20)

ax = gca();
ax.LineWidth = 2;

nexttile(34,[2 3])
hold on
boxplot(allSubjLLRa_low_1X_2(:,:,s))
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];

scatter(x, allSubjLLRa_low_1X_2(:,:,s),22,[0.7 0.7 0.7],'filled','jitter',0);
hold on
% plot(x(1:2),allSubjLLRa_norm_low_95CI2(:,1:2,s),'k--','LineWidth',0.5)
% plot(x(3:4),allSubjLLRa_norm_low_95CI2(:,3:4,s),'k--','LineWidth',0.5)

hold on
box off

ylim([LLRmin LLRheight])
xlim([0 7])
set(gca,'FontSize',22)
ylabel('LLRa [n.u.]','FontSize',22,'Rotation',270)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

set(ax,'YAxisLocation','right')
set(ax,'XTickLabel',{'','','',''});
ax.TickLabelInterpreter = 'tex';

yh = get(gca,'ylabel'); % handle to the label object
p = get(yh,'position'); % get the current position property
p(1) = 1.15*p(1);        % double the distance, 
set(yh,'position',p) ;


FigurePath_Subj = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];

FileName = ['TMSExp4_EMG_Subj_1SD_R1'];
exportgraphics(gcf, [FigurePath_Subj 'P0' num2str(s) '\' FileName '.png']);

end



%% Plotting the tiled plots for timeseries and LLRa data - TMS Exp4 group 
% - separated by MEP+ and MEP-

close all

colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];

yHeight = [10];
yMin = [-1];
LLRheight = [7];
LLRmin = -0.5;

col = [colk;colBlue;colGre;colOra;coly;colr];

titleNames = {'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra'};

subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.06], [0.25 0.12], [0.12 0.1]);
pos = [1 2 1 2];

figure('Position',[100 100 1000 700])
tiledlayout(4,12,"TileSpacing","compact")

for c = 1:nConds

nexttile(1,[2 9])
   
if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end

hold on
p1(c) = plot(allEMGAVG_norm_high_1X(:,c),'Color',col(c,:),'LineWidth',2.5);
hold on
std_plot_mean(squeeze(allSubjAvg_norm_high_1X(:,c,:))',[1:size(allEMGAVG_norm_high_1X,1)],col(c,:),0.2);
end

xlim([0 2250])
ylim([yMin yHeight])
ylabel('EMG [n.u.]')
xticklabels({'-200' '-100' '0' '100' '200'})
xlabel('Time [ms]')
% xticklabels({'' '' '' '' ''})
xticks([0:500:2250])


set(gca,'FontSize',20)
ax = gca();
ax.LineWidth = 2;

text(-350,yHeight,'\bf A','FontSize',27)

hleg2 = legend([p1(1) p1(2) p1(3) p1(4) p1(5) p1(6)],...
   'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra','Location','Northwest',...
   'FontSize',15,'NumColumns',3);

line_symbols = findobj(hleg2, 'Type', 'line'); 
set(line_symbols, 'MarkerSize', 2); 

group_LLRa_norm_high = squeeze(nanmedian(allSubjLLRa_high_1X,1));
group_LLRa_norm_high2 = group_LLRa_norm_high;

group_LLRa_norm_high2([2 3],:) = group_LLRa_norm_high([3 5],:);
group_LLRa_norm_high2([4 5],:) = group_LLRa_norm_high([2 4],:);

nexttile(10,[2 3])
hold on
boxplot(group_LLRa_norm_high2')
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];
for s = 1:nSubjs
scatter(x, group_LLRa_norm_high2(:,:),22,[0.7 0.7 0.7],'filled','jitter',0);
hold on
plot(x(1:3),group_LLRa_norm_high2(1:3,:),'k--','LineWidth',0.5)
plot(x(4:6),group_LLRa_norm_high2(4:6,:),'k--','LineWidth',0.5)
end

hold on
box off

ylim([LLRmin LLRheight])
xlim([0 7])
set(gca,'FontSize',22)
ylabel('LLRa [n.u.]','FontSize',22,'Rotation',270)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

set(ax,'YAxisLocation','right')
set(ax,'XTickLabel',{'','','',''});
ax.TickLabelInterpreter = 'tex';

yh = get(gca,'ylabel'); % handle to the label object
p = get(yh,'position'); % get the current position property
p(1) = 1.15*p(1);        % double the distance, 
set(yh,'position',p) ;



col = [colk;colBlue;colGre;colOra;coly;colr];

nexttile(25,[2 9])
for c = 1:nConds

if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end

hold on
p1(c) = plot(allEMGAVG_norm_low_1X(:,c),'Color',col(c,:),'LineWidth',2.5);
hold on
std_plot_mean(squeeze(allSubjAvg_norm_low_1X(:,c,:))',[1:size(allEMGAVG_norm_low_1X,1)],col(c,:),0.2);

ylabel('EMG [n.u.]')

xticks([0:500:2250])
xlim([0 2250])
% xticklabels({'' '' '' '' '' ''})
xticklabels({'-200' '-100' '0' '100' '200'})
xlabel('Time [ms]')
ylim([yMin yHeight])
set(gca,'FontSize',22)
% box on
% grid on

end

text(-350,yHeight,'\bf B','FontSize',27)

ax = gca();
ax.LineWidth = 2;

group_LLRa_norm_low = squeeze(nanmedian(allSubjLLRa_low_1X,1));
group_LLRa_norm_low2 = group_LLRa_norm_low;
group_LLRa_norm_low2([2 3],:) = group_LLRa_norm_low([3 5],:);
group_LLRa_norm_low2([4 5],:) = group_LLRa_norm_low([2 4],:);


nexttile(34,[2 3])
hold on
boxplot(group_LLRa_norm_low2')
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];
for s = 1:nSubjs
scatter(x, group_LLRa_norm_low2(:,:),22,[0.7 0.7 0.7],'filled','jitter',0);
hold on
plot(x(1:3),group_LLRa_norm_low2(1:3,:),'k--','LineWidth',0.5)
plot(x(4:6),group_LLRa_norm_low2(4:6,:),'k--','LineWidth',0.5)
end

hold on
box off

ylim([LLRmin LLRheight])
xlim([0 7])
set(gca,'FontSize',22)
ylabel('LLRa [n.u.]','FontSize',22,'Rotation',270)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

set(ax,'YAxisLocation','right')
set(ax,'XTickLabel',{'','','',''});
xtickangle(0)
ax.TickLabelInterpreter = 'tex';

yh = get(gca,'ylabel'); % handle to the label object
p = get(yh,'position'); % get the current position property
p(1) = 1.15*p(1);        % double the distance, 
set(yh,'position',p);

set(gcf,'Color','white');

% FileName = ['EMGData_Exp2_Thres_1SD_Combined_Panel'];
FileName = ['Group_EMG_Exp4_1SD_R1'];
exportgraphics(gcf, [FigurePath 'R1_Plots\' FileName '.png']);

% saveas(gcf, [FigurePath FileName '.png']);

% export_fig(gcf, [FigurePath FileName '.pdf']);
% print(gcf,'-dpdf', [FigurePath FileName '.pdf']);



%% Plotting the tiled plots for timeseries and LLRa data - TMS Exp4 group 
% - separated by MEP+ and MEP- (only MEP(-) for subthreshold and only
% MEP(+) for suprathreshold

close all

colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];

yHeight = [14];
yMin = [-1];
LLRheight = [7];
LLRmin = -0.5;

allEMGAVG_norm_1X_combined = allEMGAVG_norm_high_1X;
allSubjAvg_norm_1X_combined = allSubjAvg_norm_high_1X;

allEMGAVG_norm_1X_combined(:,[3 4]) = allEMGAVG_norm_low_1X(:,[3 4]);
allSubjAvg_norm_1X_combined(:,[3 4]) = allSubjAvg_norm_low_1X(:,[3 4]);


col = [colk;colBlue;colGre;colOra;coly;colr];

titleNames = {'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra'};

subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.06], [0.25 0.12], [0.12 0.1]);
pos = [1 2 1 2];

figure('Position',[100 100 1000 400])
tiledlayout(2,9,"TileSpacing","compact")

for c = 1:nConds

nexttile(1,[2 9])
   
if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end

hold on
p1(c) = plot(allEMGAVG_norm_1X_combined(:,c),'Color',col(c,:),'LineWidth',2.5);
hold on
std_plot_mean(squeeze(allSubjAvg_norm_1X_combined(:,c,:))',[1:size(allEMGAVG_norm_1X_combined,1)],col(c,:),0.2);
end

set(gca,'FontSize',22)

text(1300,12,'\bf LLR','FontSize',20)

xlim([250 2000])
ylim([yMin yHeight])
ylabel('\bf EMG [n.u.]','FontSize',24)
xticklabels({'-200' '-100' '0' '100' '200'})
xlabel('Time [ms]','FontSize',24)
% xticklabels({'' '' '' '' ''})
xticks([0:500:2250])

ax = gca();
ax.LineWidth = 2;

% text(-350,yHeight,'\bf A','FontSize',27)

line_symbols = findobj(hleg2, 'Type', 'line'); 
set(line_symbols, 'MarkerSize', 2); 


hleg2 = legend([p1(1) p1(2) p1(3) p1(4) p1(5) p1(6)],...
   'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra','Location','Northeast',...
   'FontSize',15,'NumColumns',1);

set(gcf,'Color','white');

% FileName = ['EMGData_Exp2_Thres_1SD_Combined_Panel'];
FileName = ['EMGData_Exp4_Thres_1SD_TSOnly_N=12_Panelv2'];
exportgraphics(gcf, [FigurePath FileName '.png']);

% saveas(gcf, [FigurePath FileName '.png']);

% export_fig(gcf, [FigurePath FileName '.pdf']);
% print(gcf,'-dpdf', [FigurePath FileName '.pdf']);




%% Plotting the tiled plots for timeseries and LLRa data - TMS Exp4 group 
% - separated by MEP+ and MEP- (LLR a plots only)

close all
clc

colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];

yHeight = [10];
yMin = [-1];
LLRheight = [7];
LLRmin = -1;

col = [colk;colBlue;colGre;colOra;coly;colr];

titleNames = {'Back','B:Sub','B:Supra','Pert','P:Sub','P:Supra'};

subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.06], [0.20 0.12], [0.35 0.1]);
pos = [1 2 1 2];

figure('Position',[100 100 800 600])
tiledlayout(2,4,"TileSpacing","compact")

group_LLRa_norm_high = squeeze(nanmedian(allSubjLLRa_high_1X,1));
group_LLRa_norm_high2 = group_LLRa_norm_high;
group_LLRa_norm_high2([2 3],:) = group_LLRa_norm_high([3 5],:);
group_LLRa_norm_high2([4 5],:) = group_LLRa_norm_high([2 4],:);

group_LLRa_norm_low = squeeze(nanmedian(allSubjLLRa_low_1X,1));
group_LLRa_norm_low2 = group_LLRa_norm_low;
group_LLRa_norm_low2([2 3],:) = group_LLRa_norm_low([3 5],:);
group_LLRa_norm_low2([4 5],:) = group_LLRa_norm_low([2 4],:);

combined_LLRa_norm([1 2 4 5],:) =  group_LLRa_norm_low2([1 2 4 5],:);
combined_LLRa_norm([3 6],:) =  group_LLRa_norm_high2([3 6],:);


nexttile(1,[2 4])
hold on
b1 = boxplot(combined_LLRa_norm');
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
   p1(j) =  patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];
for s = 1:nSubjs
scatter(x, combined_LLRa_norm(:,:),22,[0.7 0.7 0.7],'filled','jitter',0);
hold on
plot(x(1:3),combined_LLRa_norm(1:3,:),'k--','LineWidth',0.5)
plot(x(4:6),combined_LLRa_norm(4:6,:),'k--','LineWidth',0.5)
end

hold on
box on

sigline([1 4],'',[5.5],[5.5],col(3,:))
sigline([4 6],'',[0.1],[0.1],col(1,:))
sigline([4 6],'',[-0.3],[-0.3],'m')


lgd = legend([p1(end:-1:1)],titleNames,'FontSize',18,'NumColumns',1,'Location','northeastoutside'); %,...
   % 'Position',[0.131043109805225,0.933761904053461,0.773899041953328,0.035428572137015]);
% set(lgd, 'MarkerSize', 4);


ylim([LLRmin LLRheight])
xlim([0 7])
set(gca,'FontSize',22)
ylabel('\bf LLRa [n.u.]','FontSize',24,'Rotation',90)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

% set(ax,'YAxisLocation','right')
set(ax,'XTickLabel',{'','','',''});
ax.TickLabelInterpreter = 'tex';
yticks([0:2:8])

yh = get(gca,'ylabel'); % handle to the label object
p = get(yh,'position'); % get the current position property
p(1) = 1.15*p(1);        % double the distance, 
set(yh,'position',p) ;

set(gcf,'Color','white');

% FileName = ['EMGData_Exp2_Thres_1SD_Combined_Panel'];
FileName = ['EMGData_Exp4_Thres_1SD_LLRaOnly_N=12_Panelv2'];
% exportgraphics(gcf, [FigurePath FileName '.png']);

% saveas(gcf, [FigurePath FileName '.png']);

% export_fig(gcf, [FigurePath FileName '.pdf']);
% print(gcf,'-dpdf', [FigurePath FileName '.pdf']);



%% Plotting the tiled plots for timeseries and post MEP amplitude
% data - TMS only group - separated by MEP+ and MEP-

close all

colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];

yHeight = [3.5];
LLRheight = [2];

col = [colk;colBlue;colGre;colOra;coly;colr];

titleNames = {'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra'};

subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.06], [0.25 0.12], [0.12 0.1]);
pos = [1 2 1 2];

figure('Position',[100 100 1000 700])
tiledlayout(4,12,"TileSpacing","compact")

for c = 1:nConds

nexttile(1,[2 9])
   
if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end

hold on
p1(c) = plot(allEMGAVG_norm_high_1X(:,c),'Color',col(c,:),'LineWidth',2.5);
hold on
std_plot(squeeze(allSubjAvg_norm_high_1X(:,c,:))',[1:size(allEMGAVG_norm_high_1X,1)],col(c,:),0.2);
end

xlim([0 2250])
ylim([0 yHeight])
ylabel('EMG [n.u.]')
xticklabels({'-200' '-100' '0' '100' '200'})
xlabel('Time [ms]')
% xticklabels({'' '' '' '' ''})
xticks([0:500:2250])


set(gca,'FontSize',20)
ax = gca();
ax.LineWidth = 2;

text(-350,yHeight,'\bf A','FontSize',27)

hleg2 = legend([p1(1) p1(2) p1(3) p1(4) p1(5) p1(6)],...
   'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra','location','northwest','FontSize',16,'NumColumns',4);

group_postMEPa_norm_high = squeeze(nanmedian(allSubjPostMEPa_high_1X,1));
group_postMEPa_norm_high2 = group_postMEPa_norm_high;

group_postMEPa_norm_high2([2 3],:) = group_postMEPa_norm_high([3 5],:);
group_postMEPa_norm_high2([4 5],:) = group_postMEPa_norm_high([2 4],:);

nexttile(10,[2 3])
hold on
boxplot(group_postMEPa_norm_high2')
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];
for s = 1:nSubjs
scatter(x, group_postMEPa_norm_high2(:,:),22,[0.7 0.7 0.7],'filled','jitter',0);
hold on
plot(x(1:3),group_postMEPa_norm_high2(1:3,:),'k--','LineWidth',0.5)
plot(x(4:6),group_postMEPa_norm_high2(4:6,:),'k--','LineWidth',0.5)
end

hold on
box off

ylim([-0.5 LLRheight])
xlim([0 7])
set(gca,'FontSize',22)
ylabel('PostMEPa [n.u.]','FontSize',22,'Rotation',270)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

set(ax,'YAxisLocation','right')
set(ax,'XTickLabel',{'','','',''});
ax.TickLabelInterpreter = 'tex';

yh = get(gca,'ylabel'); % handle to the label object
p = get(yh,'position'); % get the current position property
p(1) = 1.15*p(1);        % double the distance, 
set(yh,'position',p) ;


col = [colk;colBlue;colGre;colOra;coly;colr];

nexttile(25,[2 9])
for c = 1:nConds

if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end

hold on
p1(c) = plot(allEMGAVG_norm_low_1X(:,c),'Color',col(c,:),'LineWidth',2.5);
hold on
std_plot(squeeze(allSubjAvg_norm_low_1X(:,c,:))',[1:size(allEMGAVG_norm_low_1X,1)],col(c,:),0.2);

ylabel('EMG [n.u.]')

xticks([0:500:2250])
xlim([0 2250])
xticklabels({'-200' '-100' '0' '100' '200'})
xlabel('Time [ms]')
ylim([0 yHeight])
set(gca,'FontSize',22)
% box on
% grid on

end

text(-350,yHeight,'\bf B','FontSize',27)

ax = gca();
ax.LineWidth = 2;

group_postMEPa_norm_low = squeeze(nanmedian(allSubjPostMEPa_low_1X,1));
group_postMEPa_norm_low2 = group_postMEPa_norm_low;
group_postMEPa_norm_low2([2 3],:) = group_postMEPa_norm_low([3 5],:);
group_postMEPa_norm_low2([4 5],:) = group_postMEPa_norm_low([2 4],:);


nexttile(34,[2 3])
hold on
boxplot(group_postMEPa_norm_low2')
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];
for s = 1:nSubjs
scatter(x, group_postMEPa_norm_low2(:,:),22,[0.7 0.7 0.7],'filled','jitter',0);
hold on
plot(x(1:3),group_postMEPa_norm_low2(1:3,:),'k--','LineWidth',0.5)
plot(x(4:6),group_postMEPa_norm_low2(4:6,:),'k--','LineWidth',0.5)
end

hold on
box off

ylim([-0.5 LLRheight])
xlim([0 7])
set(gca,'FontSize',22)
ylabel('PostMEPa [n.u.]','FontSize',22,'Rotation',270)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

set(ax,'YAxisLocation','right')
set(ax,'XTickLabel',{'','','',''});
xtickangle(0)
ax.TickLabelInterpreter = 'tex';

yh = get(gca,'ylabel'); % handle to the label object
p = get(yh,'position'); % get the current position property
p(1) = 1.15*p(1);        % double the distance, 
set(yh,'position',p);

set(gcf,'Color','white');

% FileName = ['EMGData_Exp2_Thres_1SD_Combined_Panel'];
FileName = ['EMGData_Exp4_Thres_1SD_PostMEPa_N=12_Panelv2'];
exportgraphics(gcf, [FigurePath FileName '.png']);

% saveas(gcf, [FigurePath FileName '.png']);

% export_fig(gcf, [FigurePath FileName '.pdf']);
% print(gcf,'-dpdf', [FigurePath FileName '.pdf']);


%% Plotting the tiled plots for timeseries and LLRa data - TMS only group

close all

colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];

col = [colk;colBlue;colGre;colOra];
titleNames = {'Back','Pert','TMS','T_3'};
subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.06], [0.25 0.12], [0.12 0.1]);
pos = [1 2 1 2];

figure('Position',[100 100 1000 700])
tiledlayout(4,9,"TileSpacing","compact")

text(-240,12,'\bf A','FontSize',27)

combSubj_LLR_norm_high = cat(1,allSubjLLRa_high_1X(:,:,1),allSubjLLRa_high_1X(:,:,2));
combSubj_LLR_norm_low = cat(1,allSubjLLRa_low_1X(:,:,1),allSubjLLRa_low_1X(:,:,2));

combSubj_LLR_norm_low2 = combSubj_LLR_norm_low;
combSubj_LLR_norm_low2(:,3) = combSubj_LLR_norm_low(:,2);
combSubj_LLR_norm_low2(:,2) = combSubj_LLR_norm_low(:,3);

combSubj_LLR_norm_high2 = combSubj_LLR_norm_high;
combSubj_LLR_norm_high2(:,3) = combSubj_LLR_norm_high(:,2);
combSubj_LLR_norm_high2(:,2) = combSubj_LLR_norm_high(:,3);

nexttile(1,[2 9])
hold on
boxplot(combSubj_LLR_norm_high2)
xticks([1:4])
col = [colOra;colBlue;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=repelem([1:4],50,1);
swarmchart(x,combSubj_LLR_norm_high2,22,[0.7 0.7 0.7],'filled','XJitter','rand', ...
    'XJitterWidth',0.4);

hold on
box on

ylim([-0.5 7])
xlim([0 5])
set(gca,'FontSize',22)
ylabel('\bf LLRa [n.u.]','FontSize',22)
title('MEP(+)','FontSize',22)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

set(ax,'YAxisLocation','left')
set(ax,'XTickLabel',{'','','',''});
ax.TickLabelInterpreter = 'tex';

text(-240,12,'\bf B','FontSize',27)

nexttile(19,[2 9])
hold on
boxplot(combSubj_LLR_norm_low2)
xticks([1:4])
col = [colOra;colBlue;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=repelem([1:4],50,1);
swarmchart(x, combSubj_LLR_norm_low2, 22,[0.7 0.7 0.7], 'filled','XJitter','rand', ...
    'XJitterWidth',0.4);

hold on
box on

ylim([-0.5 6])
xlim([0 5])
set(gca,'FontSize',22)
ylabel('\bf LLRa [n.u.]','FontSize',22,'Rotation',90)
title('MEP(-)','FontSize',22)
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
ax.LineWidth = 2;

set(ax,'YAxisLocation','left')
set(ax,'XTickLabel',{'B','T','P','PwT'});
xtickangle(0)
ax.TickLabelInterpreter = 'tex';
set(gcf,'Color','white');

FileName = ['EMGData_Exp3_Thres_Separated_1XSD_Panel_AllDataPoints'];
exportgraphics(gcf, [FigurePath FileName '.png']);


%% Plotting the EMG timeseries data for all subjects for the TMS only group, high and low MEP

close all
col = ['k','c','g','b','m'];
titleNames = {'Back','Pert','TMS','Pert w TMS'};
subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.06], [0.25 0.12], [0.12 0.1]);

pos = [1 2 1 2];

% plotting cropped mean of all repetitions and all subjects
figure('Position',[200 200 800 350])
for c = 1:4
subplot(1,2,pos(c))
patch([1000 1000 750 750],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
% text (825, (8), '\bf LLR','FontSize',10);
hold on
if c == 3 || c == 4
p2(c) = plot(allEMGAVG_norm_low(:,c),'Color','g','LineWidth',2);
hold on
std_plot(squeeze(allSubjAvg_norm_low(:,c,:))',[1:size(allEMGAVG_norm_low,1)],'g',0.2);
else
p1(c) = plot(allEMGAVG_norm_low(:,c),'Color','k','LineWidth',2);
hold on
std_plot(squeeze(allSubjAvg_norm_low(:,c,:))',[1:size(allEMGAVG_norm_low,1)],'k',0.2);
end

ylabel('EMG [n.u.]')
if c==4
    ylabel('')
end
% title(titleNames(c))
xticks([0:250:1250])
xlim([0 1250])
% xticklabels({'' '' '' '' '' ''})
xticklabels({'-100' '-50' '0' '50' '100' '150'})
if c > 3
xticklabels({'-100' '-50' '0' '50' '100' '150'})
end
xlabel('Time [ms]')
ylim([-1 10])
% sgtitle('TMS Exp 2','FontSize',20)
set(gca,'FontSize',16)
box on
grid on

end

legend([p1(1) p2(3)],'Back','TMS','location','northwest')
legend([p1(2) p2(4)],'Pert','Pert w TMS','location','northwest')

hold on

% pos = [1 2 3 4];

% % plotting cropped mean of all repetitions and all subjects
% % figure('Position',[100 100 800 600])
% for c = 1:4
% subplot(4,1,pos(c))
% % patch([1000 1000 750 750],[-20 20 20 -20],[0.5 0.5 0.5],...
% %     'EdgeColor','none','FaceAlpha',0.2)
% % text (825, (8), '\bf LLR','FontSize',10);
% hold on
% p2 = plot(allEMGAVG_norm_high(:,c),'Color','b','LineWidth',2);
% hold on
% std_plot(squeeze(allSubjAvg_norm_high(:,c,:))',[1:size(allEMGAVG_norm_high,1)],'c',0.2);
% 
% % ylabel('EMG [n.u.]')
% title(titleNames(c))
% xticks([0:250:1250])
% xlim([0 1250])
% if c > 1
% % xline(500,'r--','PERT ON','LineWidth',2,'FontSize',10)
% else
% % xline(500,'r--',{'TARGET';'MET'},'LineWidth',2,'FontSize',10)
% end
% xticklabels({'' '' '' '' '' ''})
% % xticklabels({'-100' '-50' '0' '50' '100' '150'})
% if c == 4
% xticklabels({'-100' '-50' '0' '50' '100' '150'})
% xlabel('Time (ms)')
% end
% ylim([-1 10])
% sgtitle('TMS Control','FontSize',20)
% set(gca,'FontSize',16)
% box on
% grid on
% 
% end

% legend([p1,p2],'Low MEP','High MEP','FontSize',10,'location','northeast')


% FileName = ['EMGData_Exp2_LowMEP_TS'];
% saveas(gcf, [FigurePath FileName '.fig']);
% exportgraphics(gcf, [FigurePath FileName '.png']);



%% Plotting the LLRa data for all subjects for the separated by high and low MEP

% allSubjLLRa_norm_low
% allSubjLLRa_norm_high

group_LLRa_norm_low = squeeze(nanmean(allSubjLLRa_norm_low,1));
group_LLRa_norm_low2 = group_LLRa_norm_low;
group_LLRa_norm_low2(3,:) = group_LLRa_norm_low(2,:);
group_LLRa_norm_low2(2,:) = group_LLRa_norm_low(3,:);

group_LLRa_norm_high = squeeze(nanmean(allSubjLLRa_norm_high,1));
group_LLRa_norm_high2 = group_LLRa_norm_high;
group_LLRa_norm_high2(3,:) = group_LLRa_norm_high(2,:);
group_LLRa_norm_high2(2,:) = group_LLRa_norm_high(3,:);

close all
col = ['k','c','g','b','m'];
subplot = @(m,n,p) subtightplot(m,n,p,[0.12 0.09], [0.14 0.14], [0.1 0.05]);

% plotting cropped mean of all repetitions and all subjects
figure('Position',[200 200 400 400])
subplot(1,1,1)
hold on
boxplot(group_LLRa_norm_low2')
xticks([1:4])
% set(gca,'XTickLabel',{'Back' 'TMS' 'Pert','PertwTMS'} )

h = findobj(gca,'Tag','Box');
col = [[0,128,0];[255,0,0];[0,0,255]]./255;
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'g','FaceAlpha',0.50);
end

x=[1:4];
for s = 1:12
scatter(x, group_LLRa_norm_low2(:,s),18,'k','filled','jitter',0);
% plot(x,group_LLRa_norm_low2(:,s),'k--','LineWidth',0.5)
end
box on
grid on
hold on

ylim([-0.5 8])
% sgtitle('TMS Exp 2','FontSize',20)
set(gca,'FontSize',16)
ylabel('\bf LLRa [n.u.]','FontSize',20)
xlabel('TMS Mode')
% title('Low MEP')

lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k','LineWidth', 2);

ax = gca();
set(ax,'XTickLabel',{'Back','Pert','TMS',sprintf('Pert w\\newline TMS ')});
ax.TickLabelInterpreter = 'tex';


% code out the MEP high conditions
% subplot(1,2,2)
% hold on
% boxplot(group_LLRa_norm_high2')
% ylabel('LLRa [n.u.]')
% xticks([1:4])
% xticklabels({'BackOnly','TMS','Pert','PertwTMS'})
% 
% h = findobj(gca,'Tag','Box');
% col = [[0,128,0];[255,0,0];[0,0,255]]./255;
% for j=1:length(h)
%     patch(get(h(j),'XData'),get(h(j),'YData'),'c','FaceAlpha',0.50);
% end
% 
% x=[1:4];
% for s = 1:12
% scatter(x, group_LLRa_norm_high2(:,s),18,'k','filled','jitter',0);
% % plot(x,group_LLRa_norm_high2(:,s),'k--','LineWidth',0.5)
% end
% box on
% grid on
% hold on
% 
% ylim([-0.5 8])
% sgtitle('TMS Exp 2','FontSize',20)
% set(gca,'FontSize',16)
% box on
% grid on
% hold on
% title('High MEP')
% 
% lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
% set(lines, 'Color', 'k','LineWidth', 3);


% FileName = ['EMGData_Exp2_LowMEP_LLRa'];
% saveas(gcf, [FigurePath FileName '.fig']);
% exportgraphics(gcf, [FigurePath FileName '.png']);



%%
pos = [2 4 6 8];

% plotting cropped mean of all repetitions and all subjects
% figure('Position',[100 100 800 600])
for c = 1:4
subplot(4,2,pos(c))
patch([1000 1000 750 750],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
% text (825, (8), '\bf LLR','FontSize',10);
hold on
plot(allEMGAVG_norm_high(:,c),'Color',col(1),'LineWidth',2)
hold on
std_plot(squeeze(allSubjAvg_norm_high(:,c,:))',[1:size(allEMGAVG_norm_high,1)],'r',0.2);

% ylabel('EMG [n.u.]')
title(titleNames(c))
xticks([0:250:1250])
xlim([0 1250])
xticklabels({'' '' '' '' '' ''})
% xticklabels({'-100' '-50' '0' '50' '100' '150'})
if c == 4
xticklabels({'-100' '-50' '0' '50' '100' '150'})
xlabel('Time (ms)')
end
ylim([-1 10])
sgtitle('TMS Control','FontSize',20)
set(gca,'FontSize',16)
box on
grid on

end




%% 
% plotting the EMG timeseries for each group
close all
col = ['r','b'];
titleNames = {'Back','Pert','TMS','PertwTMS'};
subplot = @(m,n,p) subtightplot(m,n,p,[0.12 0.09], [0.12 0.12], [0.13 0.1]);

g1 = [1:10];
g2 = [13:24];

figure('Position',[100 100 650 600])

for group = 1

if group == 1
g = g1;
groupTitle = 'Group 1';
pos = [0 1:4];
else
g = g2;
groupTitle = 'Group 2';
pos = [0 1:4];
end

allEMGAVG_normG = squeeze(nanmean(allSubjAvg_norm(:,:,g),3));

% plotting cropped mean of all repetitions and all subjects
for c = 2:4
subplot(3,1,pos(c))
if group == 1
q(c) = patch([1000 1000 750 750],[-20 20 20 -20],[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.2);
end
% text (825, (8), '\bf LLR','FontSize',10);
hold on
p(group,c) = plot(allEMGAVG_normG(:,c),'Color',col(group),'LineWidth',2);
hold on
std_plot(squeeze(allSubjAvg_norm(:,c,g))',[1:size(allEMGAVG_normG,1)],col(group),0.2);

ylabel('EMG [n.u.]')
title(titleNames(c))
xticks([0:250:1250])
xlim([0 1250])
if c > 1
% xline(500,'r--','PERT ON','LineWidth',2,'FontSize',10)
else
% xline(500,'r--',{'TARGET';'MET'},'LineWidth',2,'FontSize',10)
end
xticklabels({'' '' '' '' '' ''})
% xticklabels({'-100' '-50' '0' '50' '100' '150'})
if c == 1 | c == 4
xticklabels({'-100' '-50' '0' '50' '100' '150'})
xlabel('Time (ms)')
end
ylim([-1 12])
sgtitle('By Group','FontSize',20)
set(gca,'FontSize',16)
box on
grid on

if group == 1 & c == 4
legend([q(2) p(1,2)],'LLR','TMS Exp 2','orientation','horizontal','location','northwest')
end

% if group == 2
%     if c == 2
% legend([p(1) p(2)],'Group 1','Group 2','orientation','horizontal','location','northwest')
%     end
% end

end
end


%% plotting LLRa for all subjects

AllSubjLLRa2(:,1:2,:) = AllSubjLLRa(:,1:2,:);
AllSubjLLRa2(:,3:4,:) = AllSubjLLRa(:,3:4,:);

% mean per conditon and subject
LLRabySubject = squeeze(nanmean(AllSubjLLRa2,1));

% mean per condition
LLRaGroup = squeeze(nanmean(LLRabySubject,2));

% std for each condition across subjects
LLRaSTD = squeeze(std(LLRabySubject,0,2));

col = turbo(10);
subplot = @(m,n,p) subtightplot(m,n,p,[0.12 0.09], [0.14 0.1], [0.1 0.05]);

close all
figure('Position',[300 100 800 600])
subplot(1,1,1)
errorbar([1:4],LLRaGroup,LLRaSTD,'kd--','LineWidth',3,'MarkerSize',16,'MarkerFaceColor','k')
hold on
% for s = 1:24
% plot([1:5],LLRabySubject(:,s),'o','Color',col(s,:),'MarkerFaceColor',col(s,:),'MarkerSize',4)
% end
% sigline([2 5],'(8/24)',5.75)
% sigline([3 5],'(15/24)',5.25)
% sigline([4 5],'(21/24)',4.75)
set(gca,'FontSize',18)

ylabel('\bf LLRa [n.u.]','FontSize',24)
xlabel('TMS Mode','FontSize',24)
xlim([0.5 4.5])
ylim([0 7])
yticks([0:2:10])
xticks([1:4])
xticklabels({'Back','Pert','TMS','PertwTMS'})
set(gca,'FontSize',18)
box on
grid on



%% Plotting EMG time series for the Low vs High MEPs
close all
col = ['g','m','k','b','r'];
titleNames = {'Back','Pert','TMS','PertwTMS'};
subplot = @(m,n,p) subtightplot(m,n,p,[0.09 0.06], [0.12 0.12], [0.08 0.05]);
pos = [0 1 3 5 7];

% plotting cropped mean of all repetitions and all subjects
figure('Position',[100 100 800 600])
for c = 2:4
    
subplot(4,2,pos(c))
patch([1000 1000 750 750],[-20 20 20 -20],[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.2)
% text (825, (8), '\bf LLR','FontSize',10);
hold on
h(1) = plot(allEMGAVG_norm_Low(:,c),'Color',col(1),'LineWidth',2);
hold on
% std_plot(squeeze(allSubjAvg_norm_Low(:,c,:))',[1:size(allEMGAVG_norm_Low,1)],col(1),0.2);

ylabel('EMG [n.u.]')
title(titleNames(c))
xticks([0:250:1250])
xlim([0 1250])
if c == 4
xticklabels({'-100' '-50' '0' '50' '100' '150'})
else
xticklabels({'' '' '' '' '' ''})
end
if c == 2
legend(h(1), 'Low MEP','Location','northwest')
end
if c == 1 | c == 4
xlabel('Time (ms)')
end
ylim([-1 12])
sgtitle('Low vs High MEP Amplitude','FontSize',20)
set(gca,'FontSize',16)
box on
grid on

subplot(4,2,pos(c)+1)
patch([1000 1000 750 750],[-20 20 20 -20],[0.5 0.5 0.5],'EdgeColor','none','FaceAlpha',0.2)
hold on
h(2) = plot(allEMGAVG_norm_High(:,c),'Color',col(2),'LineWidth',2);
hold on
% std_plot(squeeze(allSubjAvg_norm_High(:,c,:))',[1:size(allEMGAVG_norm_High,1)],col(2),0.2);

title(titleNames(c))
xticks([0:250:1250])
xlim([0 1250])
if c == 4
xticklabels({'-100' '-50' '0' '50' '100' '150'})
else
xticklabels({'' '' '' '' '' ''})
end
if c == 2
legend(h(2),'High MEP','Location','northwest')
end
if c == 1 | c == 4
xlabel('Time [ms]')
end
ylim([-1 12])
set(gca,'FontSize',16)
box on
grid on

end


% FileName = ['TimeSeries_LowvHighMEP_AllSubj'];
% saveas(gcf, [FigurePath FileName '.fig']);
% saveas(gcf, [FigurePath FileName '.png']);



%% plotting LLRa for all subjects (Low MEP)

AllSubjLLRa_Low2(:,1:2,:) = AllSubjLLRa_Low(:,3:4,:);
AllSubjLLRa_Low2(:,3:4,:) = AllSubjLLRa_Low(:,1:2,:);

% mean per conditon and subject
LLRabySubject_Low = squeeze(nanmean(AllSubjLLRa_Low2,1));

% mean per condition
LLraGroup_Low = squeeze(nanmean(LLRabySubject_Low,2));

% std for each condition across subjects
LLRaSTD_Low = nanstd(AllSubjLLRa_Low2,0,1);

col = turbo(nSubjs);
subplot = @(m,n,p) subtightplot(m,n,p,[0.12 0.09], [0.14 0.1], [0.1 0.05]);

close all
figure('Position',[100 100 1400 600])
subplot(1,2,1)
errorbar([1:4],LLRabySubject_Low,LLRaSTD_Low,'kd--','LineWidth',3,'MarkerSize',16,'MarkerFaceColor','g')
hold on
% for s = 1:24
% plot([1:5],LLRabySubject(:,s),'o','Color',col(s,:),'MarkerFaceColor',col(s,:),'MarkerSize',4)
% end
% sigline([2 5],'(8/24)',5.75)
% sigline([3 5],'(15/24)',5.25)
% sigline([4 5],'(21/24)',4.75)
set(gca,'FontSize',18)

ylabel('\bf LLRa [n.u.]','FontSize',24)
xlabel('TMS Mode','FontSize',24)
title('LLRa - Low MEP')
xlim([0.5 4.5])
ylim([0 7])
yticks([0:2:10])
xticks([1:5])
xticklabels({'TMSOnly','T_3','BackOnly','PertOnly'})
set(gca,'FontSize',18)
box on
grid on


% plotting LLRa for all subjects (High MEP)

AllSubjLLRa_High2(:,1:2,:) = AllSubjLLRa_High(:,3:4,:);
AllSubjLLRa_High2(:,3:4,:) = AllSubjLLRa_High(:,1:2,:);

% mean per conditon and subject
LLRabySubject_High = squeeze(nanmean(AllSubjLLRa_High2,1));

% mean per condition
LLraGroup_High = squeeze(nanmean(LLRabySubject_High,2));

% std for each condition across subjects
LLRaSTD_High = nanstd(LLRabySubject_High,0,1);

col = turbo(24);
% subplot = @(m,n,p) subtightplot(m,n,p,[0.12 0.09], [0.14 0.1], [0.1 0.05]);

% close all
% figure('Position',[300 100 800 600])
subplot(1,2,2)
errorbar([1:4],LLRabySubject_High,LLRaSTD_High,'kd--','LineWidth',3,'MarkerSize',16,'MarkerFaceColor','m')
hold on
% for s = 1:24
% plot([1:5],LLRabySubject(:,s),'o','Color',col(s,:),'MarkerFaceColor',col(s,:),'MarkerSize',4)
% end
% sigline([2 5],'(8/24)',5.75)
% sigline([3 5],'(15/24)',5.25)
% sigline([4 5],'(21/24)',4.75)
set(gca,'FontSize',18)

ylabel('\bf LLRa [n.u.]','FontSize',24)
xlabel('TMS Mode','FontSize',24)
title('LLRa - High MEP')
xlim([0.5 4.5])
ylim([0 7])
yticks([0:2:10])
xticks([1:5])
xticklabels({'TMS','PertwTMS','Back','Pert'})
set(gca,'FontSize',18)
box on
grid on


% FileName = ['LLRa_LowvHighMEP_AllSubj'];
% saveas(gcf, [FigurePath FileName '.fig']);
% saveas(gcf, [FigurePath FileName '.png']);



%% Plot the normalized EMG timeseries for 1 subject

size(allSubjData_norm_TMSOnly);
close all
% p = 2;
% subj = 1;

figure('Position',[100 100 1000 600])
for p = 1:4
for subj = 1:10
subplot(3,2,p)
plot(nanmean(squeeze(allSubjData_norm_TMSOnly(:,:,p,subj))))
hold on

ylim([0 15])
xlim([0 1250])
xlabel('Time [ms]')
ylabel('EMG [n.u.]')
set(gca,'FontSize',20)
hold on
box on
grid on
end
end


%%

LLRAmplitude = squeeze(nanmean(allSubjData_norm_TMSOnly(:,750:1000,:,:),2));
LLRArea = squeeze(trapz(allSubjData_norm_TMSOnly(:,750:1000,:,:),2));

close all
col = turbo(10);
figure('Position',[100 100 1000 600])
for subj = 1:10
subplot(2,1,1)
plot(squeeze(nanmean(LLRAmplitude(:,:,subj)))','-o','color',col(subj,:))
hold on
plot(squeeze(nanmean(nanmean(LLRAmplitude,1),3)),'d-k','MarkerSize',10,'LineWidth',2)
% ylim([0 10])
yline(squeeze(nanmean(nanmean(LLRAmplitude(:,1,:),1),3)),'--','LineWidth',3)
xlim([0 5])
xlabel('TMS Mode')
ylabel('LLR Amplitude [n.u.]')
set(gca,'FontSize',20)
hold on
box on
grid on
xticks([1:4])
xticklabels({'Back','Pert','TMS','PertwTMS'})

subplot(2,1,2)
plot(squeeze(nanmean(LLRArea(:,:,subj)))','o-','color',col(subj,:))
hold on
plot(squeeze(nanmean(nanmean(LLRArea,1),3)),'d-k','MarkerSize',10,'LineWidth',2)
% ylim([0 5000])
yline(squeeze(nanmean(nanmean(LLRArea(:,1,:),1),3)),'--','LineWidth',3)
xlim([0 5])
xlabel('TMS Mode')
ylabel('LLR Area [n.u.]')
set(gca,'FontSize',20)
hold on
box on
grid on
xticks([1:4])
xticklabels({'Back','Pert','TMS','PertwTMS'})

end



%%
% writematrix(IndCount,'IndexCount.xls','Sheet',1)


%%

% save('FCR_EMGData_LowvHighMEP.mat')


%% TMS Experiment 4 group timeseries analysis


%% Figure 7: Group Level - T-test taking the mean within subject - for exp 4 group
% Makes figure that includes entire timeseries for one group
% (200 ms before to 250 ms after pert)
% close all

% size(allSubjData_norm_cropS_low)
% size(allSubjData_norm_cropS)
% [20, 1251, 6, 1]

upperlimgr = nanmax(allSubjData_norm_cropS(:))+5; % group level upper limit
lowerlimgr = nanmin(allSubjData_norm_cropS(:))-5; % group level lower limit

Ygroup1s = [];
for s = 1:nSubjs
    Ygroup1s = cat(1,Ygroup1s, allSubjData_norm_cropS(:,:,:,s));
end

% concatenates the data in the 1st dimension in terms of subjects
Ygroup1sr = [];
for cond = 1:nConds
    Ygroup1sr = cat(1,Ygroup1sr, Ygroup1s(:,:,cond));
end

groupPlotting = allSubjData_norm_cropS; % one group EMG data
Y0 = Ygroup1sr; % one group EMG data
Y0s = Ygroup1s; % all subjects combined
col2 = 'g';
g = 1;

nReps = 20;
subjID = repmat(repelem([1:nSubjs]',nReps),nConds,1); % subject ID
TMSmode = repelem([1:6]',nReps*nSubjs); %tms mode

K = Y0(:,1);
I = isnan(K); 

Y0(I,:)=[];
subjID = subjID;
subjID(I,:) = [];
TMSmode = TMSmode;
TMSmode(I,:) = [];

for i = 1:nConds
I = isnan(Y0s(:,1,i));
Y0s(I,:,:) = [];
end


close all
figure('units', 'pixels', 'Position', [250 100 1100 650])
subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.09], [0.115 0.115], [0.13 0.06]);

sgtitle(['\bf TMS Exp 4'],'FontSize', 25)
% Left side plots, include all 20 trials for each condition: no tms, t1, t2, t3
titles = {'Back','Pert','TMS','T_3','TMS(S)','T_3(S)'};

% for i = 1:6
% subplot(6,2,1+(i-1)*2)
% 
% p = patch ([250 300 300 250], [upperlimgr upperlimgr, lowerlimgr lowerlimgr],...
%     [0.17 0.17 0.17],'EdgeColor','none');
% set(p,'FaceAlpha',0.2)
% hold on
% 
% % for s = 1:24
% % plot([0:0.0002:0.25]*1000,squeeze(mean(groupPlotting(:,:,i,s),1)),'LineWidth',1.5,'Color',col(s,:)) % mean within subjects
% % hold on
% % end
% 
% plot([0:0.0002:0.45]*1000,nanmean(nanmean(groupPlotting(:,:,i,:),1),4),col2,'LineWidth',2) % all data subject for plotting
% hold on
% box on
% % std_plot(squeeze(nanmean(groupPlotting(:,:,i,:),1))',[0:0.0002:0.45]*1000, col2, 0.2);
% 
% title([titles(i)],'FontSize',18)
% ylim([-2 20]);
% yticks([0:10:20])
% xlim([0 450])
% xlabel ('');
% xtickangle(0)
% if i == 1
% ylabel ('EMG [n.u.]','FontSize',14);
% end
% set(gca,'box','on', 'XGrid', 'on', ...
%     'XTick', [0:100:450], 'XTickLabel','','FontSize',16)
% 
% if i == 6
%     set(gca,'XTickLabel',[-200 -100 0 100 200])
% end
% 
% if i == 6
% xlabel ('Time [ms]');
% end
% 
% end

% Right side plots *NEEDS SPM FOLDER IN PATH*, conducts 1d spm analysis for all tms conditions against no tms condition
titles = {'TMS Mode','Pert','TMS','T_3','TMS(S)','T_3(S)'};

for i = 1:6

if i == 1
    %(1) Conduct SPM analysis:
    spm       = spm1d.stats.anova1(Y0, TMSmode);
    p_critical = 0.05;
    spmi      = spm.inference(p_critical);
    %     disp(spmi);

else
    
%     Y1 = squeeze(mean(groupPlotting(:,:,1,:),1))'; % mean within subjects
%     Yi = squeeze(mean(groupPlotting(:,:,i,:),1))'; % mean within subjects
    if i == 2 || i == 3 || i == 5
    Y1 = Y0s(:,:,1); % all data for condition - TMS minus Back
    Yi = Y0s(:,:,i); % all data for condition
    else
    Y1 = Y0s(:,:,2); % all data for condition - T3 minus Pert
    Yi = Y0s(:,:,i); % all data for condition
    end


    %(1) Conduct SPM analysis:
    spm  = spm1d.stats.ttest_paired(Yi, Y1);

    % bonferroni correction for multiple comparisons
    alpha = 0.05;
    nTests = 5;
    p_critical = spm1d.util.p_critical_bonf(alpha, nTests);

    spmi  = spm.inference(p_critical, 'two_tailed',true, 'interp',true);
    % spmi.plot()
    % disp(spmi);
        
end


pos = [1:6];
%(2) Plot:
subplot(3,2,(i))

EMGtime = linspace(0,451,size(Y0,2));

InstEff = spmi.z;
zstar = spmi.zstar;
maxEff = ceil(max(InstEff)./10)*10;

InstEffSave(i,:) = InstEff;
zstarSave(i,:) = zstar;

xr = [250 300 300 250];
if i == 1
%yr = [-2 -2 maxEff+0.1*maxEff maxEff+0.1*maxEff];
yr = [-maxEff-1*maxEff -maxEff-1*maxEff maxEff+1*maxEff maxEff+1*maxEff];
else
yr = [-maxEff-1*maxEff -maxEff-1*maxEff maxEff+1*maxEff maxEff+1*maxEff];
end
p = patch(xr,yr,[0.17 0.17 0.17],'EdgeColor','none');
set(p,'FaceAlpha',0.2)
hold on

plot(EMGtime, zstar*ones(size(EMGtime,1),size(EMGtime,2)),'--r','LineWidth',2)
hold on
plot(EMGtime, -zstar*ones(size(EMGtime,1),size(EMGtime,2)),'--r','LineWidth',2)
hold on
plot(EMGtime, 0*ones(size(EMGtime,1),size(EMGtime,2)),'--k','LineWidth',1)
hold on
   
fillX = [EMGtime, fliplr(EMGtime)];
fillY = [InstEff, zstar*ones(size(EMGtime,1),size(EMGtime,2))];
fillZ = [InstEff, -zstar*ones(size(EMGtime,1),size(EMGtime,2))];
for j=1:length(fillY)
    if fillY(j) <= zstar
       fillY(j) = zstar; 
    end
    if fillZ(j) >= -zstar
        fillZ(j) = -zstar;
    end
end

fill(fillX,fillY,'g','EdgeColor','none');
fill(fillX,fillZ,'g','EdgeColor','none');
plot(EMGtime, InstEff, 'k', 'LineWidth', 3) % time vs z score
  
if i == 1
% ylim([-2 maxEff+0.1*maxEff]); 
ylim([-10 60]);
elseif i == 2
ylim([-15 15]);
else
ylim([-15 15]);
end

xlim([0 450]);
xlabel('')
xtickangle(0)
if i == 1
    title(['Effect of TMS Mode'],'FontSize',18)
    ylabel('F','FontSize',14)
elseif i == 4 || i == 6
    title([titles{i} '-Pert'],'FontSize',18)
    ylabel('T','FontSize',14)
else
    title([titles{i} '-Back'],'FontSize',18)
    ylabel('T','FontSize',14)
end
set(gca,'box','on', 'XGrid', 'on', ...
    'XTick', [0:100:450], 'XTickLabel','','FontSize',18)

if i >= 5
    set(gca,'XTickLabel',[-200 -100 0 100 200])
end
    
yticks([-15 0 15])

txt = num2str(zstar, '%0.3f');
if i == 1
    yticks([0:20:100])
    txt = strcat('\alpha = ',num2str(p_critical,'%0.3f'),' F* = ', {' '}, txt);
else
    txt = strcat('\alpha = ',num2str(p_critical,'%0.3f'),' T* = ', {' '}, txt);
end
xL=xlim;
yL=ylim;
if i > 4
text(0.99*xL(2),0.95*yL(2),txt,'HorizontalAlignment',...
    'right','VerticalAlignment','top','FontSize',14,'Color','r')
else
text(0.01*xL(2),0.95*yL(2),txt,'HorizontalAlignment',...
'left','VerticalAlignment','top','FontSize',14,'Color','r')
end

if i >= 5
xlabel ('Time [ms]');
end

% spmi.plot();
% spmi.plot_threshold_label();
% spmi.plot_p_values();

% spmi.z([500 750 875]);

% clear spm spmi
end


FileName = ['EMGData_Exp4_N=2_SPM1D'];

% saveas(gcf, [FigurePath FileName '.fig']);
saveas(gcf, [FigurePath FileName '.png']);
% exportgraphics(gcf, [FigurePath FileName '.png']);



