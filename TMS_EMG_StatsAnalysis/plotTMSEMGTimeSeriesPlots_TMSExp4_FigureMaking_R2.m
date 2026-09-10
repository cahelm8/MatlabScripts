clc
close all


% load('SavedData\FinalEMGData_TMSExp4.mat')

%%

[p_in, f_in] = periodogram(allSubjData_nonnormRaw_TMSExp4(1,:,1,4), [], [], 5000);
[p_out, f_out] = periodogram(norm_Old_plot(1,:,1,4), [], [], 5000);

figure;
plot(f_in, 10*log10(p_in));
hold on;
plot(f_out, 10*log10(p_out), '--', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectrum of Original and Filtered Signals');
legend('Original Signal', 'Filtered Signal');
grid on;


%%

n = size(allSubjData_nonnormRaw_TMSExp4,2);

s = 6;
Fs = 5000;
cond = 1;
Order = 4;
fLP = 500;
fHP = 20;

d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',Fs);

subjData_Notch = filtfilt(d,allSubjData_nonnormRaw_TMSExp4(1,:,cond,s));
subjData_BP = EMGProcessing_noSmooth(subjData_Notch, Order, fLP, fHP, Fs);

% desiredSignal = filtfilt(d,allSubjData_nonnorm_TMSExp4(1,:,cond,s));
desiredSignal = norm_Old_plot(1,:,cond,s);

y_in = fft(subjData_BP);
y_out = fft(desiredSignal);
Fs = 5000;

% n = length(x);          % number of samples
f = (0:n-1)*(Fs/n);     % frequency range
power_in = abs(y_in).^2/n;    % power of the DFT
power_out = abs(y_out).^2/n;   

close all
plot(f,power_in,'-')
hold on
plot(f,power_out,'--')
xlabel('Frequency')
ylabel('Power')
xlim([0 1000])
legend('Filtered Signal', 'Desired Signal');


%%

New1 = load('SavedEMGData\allSubjData_norm_TMSExp4.mat');
OG1 = load('SavedEMGData\allSubjData_norm_TMSExp4_R1Data.mat');

norm_New_plot = New1.allSubjData_nonnorm_TMSExp4;
norm_Old_plot = OG1.allSubjData_nonnorm_TMSExp4;

diff_Raw_Data = abs(norm_New_plot) - abs(norm_Old_plot);
size(diff_Raw_Data)

squeeze(mean(mean(diff_Raw_Data,1),2))

% squeeze(diff_Raw_Data(10,1000,:,:))


%%

% Create a second-order-section (SOS) representation for better stability
[sos, g] = zp2sos(b, a);

% Define the frequency vector for the plot
f = linspace(0, Fs/2, 1024);

% Calculate the frequency response
[h, w] = freqz(sos, f, Fs);

% Plot the magnitude response in dB
figure;
plot(f, mag2db(abs(h)));
title('Butterworth Bandstop Filter Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;



%%

original_signal = OG1.allSubjData_nonnormRaw_TMSExp4(1,:,5,4);
filtered_signal_OG = OG1.allSubjData_nonnorm_TMSExp4(1,:,5,4);
filtered_signal_New = New1.allSubjData_nonnorm_TMSExp4(1,:,5,4);

[TrFn, Fv] = tfestimate(original_signal, filtered_signal_OG, [], [], [], Fs);
[TrFn2, Fv2] = tfestimate(original_signal, filtered_signal_New, [], [], [], Fs);
    
close all
figure;
subplot(2,1,1);
plot(Fv, 20*log10(abs(TrFn)));
hold on
plot(Fv2, 20*log10(abs(TrFn2)));
title('Estimated Filter Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;
    
subplot(2,1,2);
plot(Fv, unwrap(angle(TrFn))*180/pi);
hold on
plot(Fv2, unwrap(angle(TrFn2))*180/pi);
title('Estimated Filter Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
grid on;

%%

nReps = 20;
nConds = 5;
nSubjs = 12;

% good participants - 3,4,5(maybe), 6, 7, 8, 10, 12, 9(mostly)
% bad participants - 1, 2, 11

for s = [11]
% close all

figure('Position',[100 100 1000 650])
sgtitle(['\bf P0' num2str(s) ' - Fully Filtered'],'FontSize',30)
for c = 1:nConds
    subplot(3,2,c)
    plot(squeeze(nanmean(norm_Old_plot(:,:,c,s),1)),'-r','Linewidth',2)
    hold on
    plot(squeeze(nanmean(norm_New_plot(:,:,c,s),1)),'-b','Linewidth',2)
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
    % ylim([-1 18])
    set(gca,'FontSize',18)

end
end


%%
L = size(allSubjData_nonnormRaw_TMSExp4,2);

s = 4;
cond = 6;

% d = designfilt('bandstopiir','FilterOrder',2, ...
%                'HalfPowerFrequency1',59,'HalfPowerFrequency2',60, ...
%                'DesignMethod','butter','SampleRate',Fs);
subjData_Notch = allSubjData_nonnormRaw_TMSExp4(1,:,cond,s);

subjData_BP = EMGProcessing_noSmooth(subjData_Notch, Order, fLP, fHP, Fs);

% 3. Compute the FFT for both signals.
n_fft = 2^nextpow2(L); % Next power of 2 from length of signal
Y_in = fft(subjData_BP, n_fft) / L;
Y_out = fft(allSubjData_nonnorm_TMSExp4(1,:,cond,s), n_fft) / L;

% 4. Create the frequency vector and plot the single-sided amplitude spectrum.
f = Fs*(0:(n_fft/2))/n_fft;

% close all
% figure;
plot(f, 2*abs(Y_in(1:n_fft/2+1)),'--');
hold on;
plot(f, 2*abs(Y_out(1:n_fft/2+1)), '--', 'LineWidth', 1);
% plot(f, 2*abs(Y_out2(1:n_fft/2+1)), '--', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Single-Sided Amplitude Spectrum');
legend('Filtered Signal', 'Desired Signal');
grid on;


%%

% close all
% plotting the uncropped non-normalized bandpass filtered only EMG data
% close all
subplot = @(m,n,p) subtightplot(m,n,p,[0.06 0.1], [0.14 0.10], [0.10 0.1]);

for s = [4]
% close all

figure('Position',[100 100 1000 650])
sgtitle(['\bf P0' num2str(s) ' - BP Filtered'],'FontSize',30)
for c = 1:nConds
    subplot(3,2,c)
    plot(squeeze(allSubjData_nonnorm_TMSExp4(:,:,c,s))')
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
    ylim([-200 900])
    set(gca,'FontSize',18)
end

FigurePath_Subj = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];
FileName = ['TMSExp4_FCR_EMG_Subject_BPFilteredEMG'];

% exportgraphics(gcf, [FigurePath_Subj 'P0' num2str(s) '\' FileName '.png']);

end



%%

for s = 1
figure('Position',[100 100 900 600])
sgtitle(['\bf P0' num2str(s) '- Raw EMG'],'FontSize',30)
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

hcb = colorbar('Position',[0.90 0.17 0.02 0.70],'FontSize',16);
hcb.Title.String = ['MEP Counts'];
caxis([0 nReps])


%% plot the EMG timeseries plots and LLRa data for each subject

% size(allSubjAvg_norm_high_95CI)

colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];
titleNames = {'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra'};

yHeight = [12];
LLRheight = [12];
LLRmin = -0.5;
Ymin = -0.5;

for s = [7]
    
close all
col = [colk;colBlue;colGre;colOra;coly;colr];

figure('Position',[50 50 1000 700])
tiledlayout(4,14,"TileSpacing","compact")
sgtitle(['\bf P0' num2str(s)],'FontSize',22)

nexttile(1,[2 9])

for c = 1:nConds

if c == 1
patch([1500 1500 1250 1250],[-25 25 25 -25],[0.5 0.5 0.5],...
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

allSubjLLRa_high_1X_2 = allSubjLLRa_high_1X;
allSubjLLRa_high_1X_2(:,[2 3],:) = allSubjLLRa_high_1X(:,[3 5],:);
allSubjLLRa_high_1X_2(:,[4 5],:) = allSubjLLRa_high_1X(:,[2 4],:);

allSubjLLRa_low_1X_2 = allSubjLLRa_low_1X;
allSubjLLRa_low_1X_2(:,[2 3],:) = allSubjLLRa_low_1X(:,[3 5],:);
allSubjLLRa_low_1X_2(:,[4 5],:) = allSubjLLRa_low_1X(:,[2 4],:);

text(-350,yHeight,'\bf A','FontSize',27)

nexttile(10,[2 5])
hold on
boxplot(allSubjLLRa_high_1X_2(:,:,s))
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

hleg2 = legend([p1(1) p1(2) p1(3) p1(4) p1(5) p1(6)],...
    'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra',...
    'position',[0.5 0.79 0.35 0.1],'FontSize',17,'NumColumns',4);

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];

scatter(x, allSubjLLRa_high_1X_2(:,:,s),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
hold on
plot(x(1:3),nanmedian(allSubjLLRa_high_1X_2(:,1:3,s)),'k--','LineWidth',0.5)
plot(x(4:6),nanmedian(allSubjLLRa_high_1X_2(:,4:6,s)),'k--','LineWidth',0.5)

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
nexttile(29,[2 9])

for c = 1:nConds

if c == 1
patch([1500 1500 1250 1250],[-25 25 25 -25],[0.5 0.5 0.5],...
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

text(-350,yHeight,'\bf B','FontSize',27)

ax = gca();
ax.LineWidth = 2;

nexttile(38,[2 5])
hold on
boxplot(allSubjLLRa_low_1X_2(:,:,s))
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];

scatter(x, allSubjLLRa_low_1X_2(:,:,s),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
hold on
plot(x(1:3),nanmedian(allSubjLLRa_low_1X_2(:,1:3,s)),'k--','LineWidth',0.5)
plot(x(4:6),nanmedian(allSubjLLRa_low_1X_2(:,4:6,s)),'k--','LineWidth',0.5)

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

FileName = ['TMSExp4_EMG_Subj_P0' num2str(s) '_1SD_R2'];

exportgraphics(gcf, [FigurePath_Subj 'P0' num2str(s) '\' FileName '.png']);

exportgraphics(gcf, [FigurePath_Subj 'P0' num2str(s) '\' FileName '.pdf'],'ContentType','vector');

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
yMin = [-0.5];
LLRheight = [10];
LLRmin = -0.5;

col = [colk;colBlue;colGre;colOra;coly;colr];

titleNames = {'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra'};

subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.06], [0.25 0.12], [0.12 0.1]);
pos = [1 2 1 2];

figure('Position',[100 100 1000 700])
tiledlayout(4,14,"TileSpacing","compact")

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
xticklabels({'' '' '' '' ''})
% xlabel('Time [ms]')
% xticklabels({'' '' '' '' ''})
xticks([0:500:2250])


set(gca,'FontSize',20)
ax = gca();
ax.LineWidth = 2;

text(-350,yHeight,'\bf A','FontSize',27)

line_symbols = findobj(hleg2, 'Type', 'line'); 
set(line_symbols, 'MarkerSize', 2); 

group_LLRa_norm_high = squeeze(nanmedian(allSubjLLRa_high_1X,1));
group_LLRa_norm_high2 = group_LLRa_norm_high;

group_LLRa_norm_high2([2 3],:) = group_LLRa_norm_high([3 5],:);
group_LLRa_norm_high2([4 5],:) = group_LLRa_norm_high([2 4],:);

nexttile(10,[2 5])
hold on
boxplot(group_LLRa_norm_high2')
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];


hleg2 = legend([p1(1) p1(2) p1(3) p1(4) p1(5) p1(6)],...
   'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra',...
   'position',[0.5 0.8 0.35 0.1],'FontSize',15,'NumColumns',3);

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];
for s = 1:nSubjs
scatter(x, group_LLRa_norm_high2(:,:),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
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

nexttile(29,[2 9])
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


nexttile(38,[2 5])
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
scatter(x, group_LLRa_norm_low2(:,:),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
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
FileName = ['Group_EMGData_Exp4_Thres_1SD_R2'];

exportgraphics(gcf, [FigurePath FileName '.png']);
exportgraphics(gcf, [FigurePath FileName '.pdf'],'ContentType','vector');

% saveas(gcf, [FigurePath FileName '.png']);

% export_fig(gcf, [FigurePath FileName '.pdf']);
% print(gcf,'-dpdf', [FigurePath FileName '.pdf']);



%% Plotting the tiled plots for timeseries data - TMS Exp4 group 
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
% exportgraphics(gcf, [FigurePath FileName '.png']);

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
tiledlayout(4,14,"TileSpacing","compact")

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
% xlabel('Time [ms]')
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

nexttile(10,[2 5])
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
scatter(x, group_postMEPa_norm_high2(:,:),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
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

nexttile(29,[2 9])
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


nexttile(38,[2 5])
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
scatter(x, group_postMEPa_norm_low2(:,:),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
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
FileName = ['Group_EMG_1SD_PostMEPa_R2'];
exportgraphics(gcf, [FigurePath FileName '.png']);

% saveas(gcf, [FigurePath FileName '.png']);

% export_fig(gcf, [FigurePath FileName '.pdf']);
% print(gcf,'-dpdf', [FigurePath FileName '.pdf']);




%% Plotting the tiled plots for timeseries and post MEP amplitude (By Subject)
% data - TMS only group - separated by MEP+ and MEP-

close all

colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];

yHeight = [3.5];
LLRheight = [3];

titleNames = {'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra'};

subplot = @(m,n,p) subtightplot(m,n,p,[0.07 0.06], [0.25 0.12], [0.12 0.1]);
pos = [1 2 1 2];


for s = [3:5]
close all

figure('Position',[100 100 1000 700])
tiledlayout(4,14,"TileSpacing","compact")
sgtitle(['\bf P0' num2str(s)],'FontSize',22)
   
for c = 1:nConds

nexttile(1,[2 9])


col = [colk;colBlue;colGre;colOra;coly;colr];
   
if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end

hold on
p1(c) = plot(allSubjAvg_norm_high_1X(:,c,s),'Color',col(c,:),'LineWidth',2.5);
hold on
std_plot(squeeze(allSubjData_norm_cropS_high_1X(:,:,c,s)),[1:size(allSubjAvg_norm_high_1X,1)],col(c,:),0.2);
end

xlim([0 2250])
ylim([0 yHeight])
ylabel('EMG [n.u.]')
xticklabels({'-200' '-100' '0' '100' '200'})
% xlabel('Time [ms]')
% xticklabels({'' '' '' '' ''})
xticks([0:500:2250])


set(gca,'FontSize',20)
ax = gca();
ax.LineWidth = 2;

text(-350,yHeight,'\bf A','FontSize',27)

hleg2 = legend([p1(1) p1(2) p1(3) p1(4) p1(5) p1(6)],...
   'Back','Pert','B:Sub','P:Sub','B:Supra','P:Supra','location','northwest','FontSize',16,'NumColumns',4);

group_postMEPa_norm_high = squeeze(allSubjPostMEPa_high_1X(:,:,s));
group_postMEPa_norm_high2 = group_postMEPa_norm_high;

group_postMEPa_norm_high2(:,[2 3]) = group_postMEPa_norm_high(:,[3 5]);
group_postMEPa_norm_high2(:,[4 5]) = group_postMEPa_norm_high(:,[2 4]);

nexttile(10,[2 5])
hold on
boxplot(group_postMEPa_norm_high2)
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];
scatter(x, group_postMEPa_norm_high2(:,:),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
hold on
plot(x(1:3),nanmedian(group_postMEPa_norm_high2(:,1:3),1),'k--','LineWidth',0.5)
plot(x(4:6),nanmedian(group_postMEPa_norm_high2(:,4:6),1),'k--','LineWidth',0.5)

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

nexttile(29,[2 9])
for c = 1:nConds

if c == 1
patch([1500 1500 1250 1250],[-20 20 20 -20],[0.5 0.5 0.5],...
    'EdgeColor','none','FaceAlpha',0.2)
end

hold on
p1(c) = plot(allSubjAvg_norm_low_1X(:,c,s),'Color',col(c,:),'LineWidth',2.5);
hold on
std_plot(squeeze(allSubjData_norm_cropS_low_1X(:,:,c,s)),[1:size(allSubjAvg_norm_low_1X,1)],col(c,:),0.2);

xticks([0:500:2250])
xlim([0 2250])
xticklabels({'-200' '-100' '0' '100' '200'})
xlabel('Time [ms]')
ylabel('EMG [n.u.]')
ylim([0 yHeight])
set(gca,'FontSize',22)
% box on
% grid on

end

text(-350,yHeight,'\bf B','FontSize',27)

ax = gca();
ax.LineWidth = 2;

group_postMEPa_norm_low = squeeze(allSubjPostMEPa_low_1X(:,:,s));
group_postMEPa_norm_low2 = group_postMEPa_norm_low;
group_postMEPa_norm_low2(:,[2 3]) = group_postMEPa_norm_low(:,[3 5]);
group_postMEPa_norm_low2(:,[4 5]) = group_postMEPa_norm_low(:,[2 4]);


nexttile(38,[2 5])
hold on
boxplot(group_postMEPa_norm_low2)
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];
scatter(x, group_postMEPa_norm_low2(:,:),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
hold on
plot(x(1:3),nanmedian(group_postMEPa_norm_low2(:,1:3),1),'k--','LineWidth',0.5)
plot(x(4:6),nanmedian(group_postMEPa_norm_low2(:,4:6),1),'k--','LineWidth',0.5)

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

FigurePath_Subj = ['Z:\StudentFolders\Cody\Projects\TMS\Figures\Figs4Paper_R3\TMSExp4\Subject_Specific\'];

FileName = ['Subj_P0' num2str(s) '_1SD_PostMEPa_R2'];

exportgraphics(gcf, [FigurePath_Subj 'P0' num2str(s) '\' FileName '.png']);
exportgraphics(gcf, [FigurePath_Subj 'P0' num2str(s) '\' FileName '.pdf'],'ContentType','vector');

% saveas(gcf, [FigurePath FileName '.png']);

end



%% plot LLRa for all data for all subjects grid
colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];

LLRheight = [squeeze(max(max(allSubjLLRa_high_1X)))];
LLRmin = -0.5;
    
close all
col = [colk;colBlue;colGre;colOra;coly;colr];

figure('Position',[50 50 1400 700])
tiledlayout(3,4,"TileSpacing","compact")
sgtitle(['\bf All Participants'],'FontSize',22)

for s = [1:12]
nexttile
title(['P0' num2str(s)])
clear h

allSubjLLRa_high_1X_2 = allSubjLLRa_high_1X;
allSubjLLRa_high_1X_2(:,[2 3],:) = allSubjLLRa_high_1X(:,[3 5],:);
allSubjLLRa_high_1X_2(:,[4 5],:) = allSubjLLRa_high_1X(:,[2 4],:);

hold on
boxplot(allSubjLLRa_high_1X_2(:,:,s))
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    p1(j) = patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];

scatter(x, allSubjLLRa_high_1X_2(:,:,s),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
hold on
plot(x(1:3),nanmedian(allSubjLLRa_high_1X_2(:,1:3,s)),'k--','LineWidth',0.5)
plot(x(4:6),nanmedian(allSubjLLRa_high_1X_2(:,4:6,s)),'k--','LineWidth',0.5)

if s == 12
hleg2 = legend([p1(6:-1:1)],...
    'Back','B:Sub','B:Supra','Pert','P:Sub','P:Supra','Position',[0.28 0.02 0.50 0.05],'FontSize',17,'NumColumns',6);
end

hold on
box off

ylim([LLRmin LLRheight(s)+1])
xlim([0 7])
set(gca,'FontSize',22)
if s == 4 | s == 8 | s == 12
ylabel('LLRa [n.u.]','FontSize',22,'Rotation',270)
end
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

end

FileName = ['TMSExp4_FCR_LLRa_all_Subjs_1SD_v2_filtered'];
exportgraphics(gcf, [FigurePath '\' FileName '.png']);



%% plot the Post MEPa data for all subjects grid
colGre = [37,179,0]./255;
colOra = [255,175,66]./255;
colBlue = [68,164,213]./255;
colk = [0 0 0];
coly = [1 1 0];
colr = [1 0 0];

LLRheight = [squeeze(max(max(allSubjPostMEPa_high_1X)))];
LLRmin = -0.1;
    
close all
col = [colk;colBlue;colGre;colOra;coly;colr];

figure('Position',[50 50 1400 700])
tiledlayout(3,4,"TileSpacing","compact")
sgtitle(['\bf All Participants'],'FontSize',22)

for s = [1:12]
nexttile
title(['P0' num2str(s)])
clear h

group_postMEPa_norm_high = squeeze(allSubjPostMEPa_high_1X(:,:,s));
group_postMEPa_norm_high2 = group_postMEPa_norm_high;

group_postMEPa_norm_high2(:,[2 3]) = group_postMEPa_norm_high(:,[3 5]);
group_postMEPa_norm_high2(:,[4 5]) = group_postMEPa_norm_high(:,[2 4]);

hold on
boxplot(group_postMEPa_norm_high2(:,:))
xticks([1:nConds])
col = [colr;colOra;colBlue;coly;colGre;colk];

h = findobj(gca,'Tag','Box');
for j=1:length(h)
    p1(j) = patch(get(h(j),'XData'),get(h(j),'YData'),col(j,:),'FaceAlpha',0.50);
end

x=[1:nConds];

scatter(x, group_postMEPa_norm_high2(:,:),30,[0.7 0.7 0.7],'filled','jitter',0,'MarkerEdgeColor','k');
hold on
plot(x(1:3),nanmedian(group_postMEPa_norm_high2(:,1:3)),'k--','LineWidth',0.5)
plot(x(4:6),nanmedian(group_postMEPa_norm_high2(:,4:6)),'k--','LineWidth',0.5)

if s == 12
hleg2 = legend([p1(6:-1:1)],...
    'Back','B:Sub','B:Supra','Pert','P:Sub','P:Supra','Position',[0.28 0.02 0.50 0.05],'FontSize',17,'NumColumns',6);
end

hold on
box off

ylim([LLRmin LLRheight(s)+0.5])
xlim([0 7])
set(gca,'FontSize',22)
if s == 4 | s == 8 | s == 12
ylabel('PostMEPa [n.u.]','FontSize',18,'Rotation',270)
end
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

end

FileName = ['TMSExp4_FCR_PostMEPa_all_Subjs_1SD_v2_filtered'];
exportgraphics(gcf, [FigurePath '\' FileName '.png']);



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



