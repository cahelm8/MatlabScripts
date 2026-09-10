
%EMG tracks from OTBioelettronica are split into raw EMG tracks and
    %triggers for pertubations, and the data has "_FCR-1", "_Trigger-1",
    %and "_Q2-1", etc. appended to the appropriate files for the tests.

    %CALL CLEAR ALL IN COMMAND WINDOW
    
    clc
    clear all
    
    %Set up location of data files
    emg_path = genpath('Z:/StudentFolders/Paria/EMG materials/EMG processing projects/New-SubjectDataDuration/Newest Data');
    function_path = genpath('Z:/StudentFolders/Paria/EMG materials/EMG processing projects/functions');
    addpath(emg_path);
    addpath(function_path);

    %List of all subjects to include in this test
    SubjArray = ["S03"];
    numSubj = length(SubjArray);
    
    
    %Locations of files, assumes 2 trials performed on each subject
    FCR_location = []; ECU_location = []; Trigger_location = []; Q2_location = []; MVC_location = [];
    for i=1:numSubj
       FCR_location = [FCR_location strcat(SubjArray(i)+"_FCR_1.mat")];
       ECU_location = [ECU_location strcat(SubjArray(i)+"_ECU_1.mat")];
       Trigger_location = [Trigger_location strcat(SubjArray(i)+"_Trigger_1.mat")];
       Q2_location = [Q2_location strcat(SubjArray(i)+"_Q2_1.mat")];
       %%%%%%%%%%MVC_location = [MVC_location strcat(SubjArray(i)+"-Ref.mat")];
    end
    

    %Retrieves the data and puts into cells or arrays
    FCRraw = {}; ECUraw = {}; EMGtime = {}; EMGtrigger = {}; MVCrawdata = {};
    MVCtime = {}; pertDir={}; pertTorque={}; pertDuration={}; timeToPerturb = {}; pertVel = {};
    for i=1:numSubj
        outputfcr_temp1 = load(FCR_location(i));
        outputecu_temp1 = load(ECU_location(i));
        outputtrigger_temp1 = load(Trigger_location(i));
        %%%%%%%%%%mvc_temp = load(MVC_location(i));
        %Figure out what variables I need to import
        outputq2_temp1 = load(Q2_location(i), 'perMode', 'modesMat', 'modesTime', 'timeToPerturb');
        
        %load each EMG muscle activity track into FCRraw & ECUraw
        FCRraw{i} = [outputfcr_temp1.Data'];
        ECUraw{i} = [outputecu_temp1.Data'];
        EMGtime{i} = [outputfcr_temp1.Time']; %acquisition time signal
              
        %load the EMG trigger signal into EMGtrigger
        EMGtrigger{i} = [outputtrigger_temp1.Data'];

        %load experimental settings into these variables
        perMode(i) = outputq2_temp1.perMode;
        pertDir{i} = outputq2_temp1.modesMat(4,:);
        pertTorque{i} = outputq2_temp1.modesMat(2,:);
        pertDuration{i} = outputq2_temp1.modesMat(5,:);
        pertVel{i} = outputq2_temp1.modesMat(1,:);
        timeToPerturb{i} = outputq2_temp1.timeToPerturb(:,1);
        %modesTime{i} = outputq2_temp1.modesTime;
    end
    
    
    clear outputfcr_temp1 outputecu_temp1 outputtrigger_temp1 outputq2_temp1

    %Band-pass filter
    Order = 4;
    fLP = 250;
    fHP = 20;
    fENV = 60;
    Fs = 10240;
    
    %List of indices of where the 0-200 ms time frame is active
    indexes_perturbation = [];
    %List of indices of where the 50-100 ms LLR time frame is active
    indexes_LLR = [];
    
    %Cells that will contain filtered EMG tracks
    EMGfcr = {};
    EMGecu = {};
    LLRfcr = {};
    LLRecu = {};
    t = [];
    
    for i=1:numSubj
        
        %FCRraw = double(FCRraw);
        %Filters raw EMG using parameters listed above
        fcrfilt{i} = EMGProcessing(FCRraw{i}, Order, fLP, fHP, fENV, Fs);
        ecufilt{i} = EMGProcessing(ECUraw{i}, Order, fLP, fHP, fENV, Fs);
        
        %Clear memory
        FCRraw{i} = [];
        ECUraw{i} = [];
        
        %Gets the indexes for 0 ms, 50 ms, 100 ms, 200 ms. (i.e. the LLR and full
        %perturbation)
        [timeIndex] = triggerpointsv2(EMGtime{i}, EMGtrigger{i});
        
        
        
        Perturb_begin_index(i,:) = timeIndex(1,:); %onset of perturbation
        LLR_50ms_index(i,:) = timeIndex(2,:); %50 ms after pert
        LLR_100ms_index(i,:) = timeIndex(3,:); %100 ms after pert
        Perturb_end_index(i,:) = timeIndex(4,:); %200 ms after pert
        Perturb_BL_index(i,:) = timeIndex(5,:); %100 ms before pert
        
        triggerCount(i) = length(Perturb_begin_index(i,:));
         
      
        
        
        %This is the variable that tells you where all the different
        %conditions are located in the experiment!!
        DurTrialNum{i} = sortByConditionIDX_2(triggerCount(i), pertDir{i}, pertDuration{i}, pertTorque{i}, pertVel{i});
  


        %This is for data normalization if you have a background torque
        [avgrefFlexion{i}, avgrefExtension{i}] = determineRef_PA(DurTrialNum{i}, Fs, timeToPerturb{i}, Perturb_begin_index(i,:), fcrfilt{i}, ecufilt{i});
        
        %WITH normalization:
        EMGfilt{i} = [(fcrfilt{i}./avgrefFlexion{i}); (ecufilt{i}./avgrefExtension{i})];
        %WITHOUT normalization
        %EMGfilt{i} = [fcrfilt{i}; ecufilt{i}];
        
        % Visualize data
        figure; 
        subplot(2,1,1); hold on; box on;
        plot(EMGtime{i},fcrfilt{i}./avgrefFlexion{i},'k');
        plot(EMGtime{i}, EMGtrigger{i}./300,'r:');
        plot(EMGtime{i}(timeIndex(1,:)), fcrfilt{i}(timeIndex(1,:))./avgrefFlexion{i}, 'g.', 'MarkerSize', 15);
        plot(EMGtime{i}(timeIndex(2,:)), fcrfilt{i}(timeIndex(2,:))./avgrefFlexion{i}, 'g*');
        plot(EMGtime{i}(timeIndex(3,:)), fcrfilt{i}(timeIndex(3,:))./avgrefFlexion{i}, 'r*');
        plot(EMGtime{i}(timeIndex(4,:)), fcrfilt{i}(timeIndex(4,:))./avgrefFlexion{i}, 'r.', 'MarkerSize', 15);
        plot(EMGtime{i}(timeIndex(5,:)), fcrfilt{i}(timeIndex(5,:))./avgrefFlexion{i}, 'b.', 'MarkerSize', 15);
        legend('EMG Signal', 'Trigger Signal', 'Trigger onset', '50ms after onset', '100ms after onset', '200 ms after onset', '100ms before onset')
        xlabel('time [s]'); ylabel('Norm. EMG amplitude [nu]');
        title('Filtered/Normalized FCR EMG track with Task markers')
        
        subplot(2,1,2); hold on; box on;
        plot(EMGtime{i},ecufilt{i}./avgrefExtension{i},'k');
        plot(EMGtime{i}, EMGtrigger{i}./300,'r:');
        plot(EMGtime{i}(timeIndex(1,:)), ecufilt{i}(timeIndex(1,:))./avgrefExtension{i}, 'g.', 'MarkerSize', 15);
        plot(EMGtime{i}(timeIndex(2,:)), ecufilt{i}(timeIndex(2,:))./avgrefExtension{i}, 'g.', 'MarkerSize', 15);
        plot(EMGtime{i}(timeIndex(3,:)), ecufilt{i}(timeIndex(3,:))./avgrefExtension{i}, 'r*');
        plot(EMGtime{i}(timeIndex(4,:)), ecufilt{i}(timeIndex(4,:))./avgrefExtension{i}, 'r.', 'MarkerSize', 15);
        plot(EMGtime{i}(timeIndex(5,:)), ecufilt{i}(timeIndex(5,:))./avgrefExtension{i}, 'b.', 'MarkerSize', 15);
        xlabel('time [s]'); ylabel('Norm. EMG amplitude [nu]');
        title('Filtered/Normalized ECU EMG track with Task markers')
        
        figure; 
        for j=1:150
            if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)==20
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,1);hold on; box on; grid on;
                    line_color='r';
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', line_color);
                    title('FCR: Flexion, 30 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                else
                    subplot(2,4,5);hold on; box on; grid on;
                    line_color='m';
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', line_color);
                    title('FCR: Extension, 30 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                end
            elseif DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)==40
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,2);hold on; box on; grid on;
                    line_color='b';
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', line_color);
                    title('FCR: Flexion, 50 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                else
                    subplot(2,4,6);hold on; box on; grid on;
                    line_color='c';
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', line_color);
                    title('FCR: Extension, 50 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                end
            elseif DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)==60
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,3);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', 'g');
                    title('FCR: Flexion, 70 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                else
                    subplot(2,4,7);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', [.5 1 0]);
                    title('FCR: Extension, 70 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                end
            elseif DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)>=200 %&& ?????? = 50
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,4);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', 'k');
                    title('FCR: Flexion, 200 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                else
                    subplot(2,4,8);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', [.5 .5 .5]);
                    title('FCR: Extension, 200 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                end
                elseif DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)>=200
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,4);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', 'k');
                    title('FCR: Flexion, 200 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                else
                    subplot(2,4,8);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefFlexion{i},'Color', [.5 .5 .5]);
                    title('FCR: Extension, 200 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefFlexion{i})]);
                 end
            end
        
        
        figure;
        for j=1:150
            if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)==30
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,1);hold on; box on; grid on;
                    line_color='r';
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                    title('ECU: Flexion, 30 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                else
                    subplot(2,4,5);hold on; box on; grid on;
                    line_color='m';
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                    title('ECU: Extension, 30 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                end
            elseif DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)==50
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,2);hold on; box on; grid on;
                    line_color='b';
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                    title('ECU: Flexion, 50 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                else
                    subplot(2,4,6);hold on; box on; grid on;
                    line_color='c';
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                    title('ECU: Extension, 50 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                end
            elseif DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)==70
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,3);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', 'g');
                    title('ECU: Flexion, 70 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                else
                    subplot(2,4,7);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', [.5 1 0]);
                    title('ECU: Extension, 70 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                end
            elseif DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)>=200
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    subplot(2,4,4);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', 'k');
                    title('ECU: Flexion, 200 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                else
                    subplot(2,4,8);hold on; box on; grid on;
                    plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                        ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', [.5 .5 .5]);
                    title('ECU: Extension, 200 Duration')
                    xlabel('time [s]'); ylabel('EMG activity [nu]');
                    xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                end
            end
        end
        
%       plots for 200 dation with 50 and 125 velocities  
        figure
        for k = 1:150
            if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)>=200
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),5)==50
                        subplot(2,2,1);hold on; box on; grid on;
                        line_color='r';
                        plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                            fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                        title('FCR: Flexion, 200 Duration')
                        xlabel('time [s]'); ylabel('EMG activity [nu]');
                        xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefExtension{i})]);
                    else
                        subplot(2,2,3);hold on; box on; grid on;
                        line_color='m';
                        plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                            fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                        title('FCR: Extension, 200 Duration')
                        xlabel('time [s]'); ylabel('EMG activity [nu]');
                        xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefExtension{i})]);
                    end
                end
            end
        end
        
             
        for k = 1:150
            if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)>=200
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),5)==125
                        subplot(2,2,1);hold on; box on; grid on;
                        line_color='g';
                        plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                            fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                        title('FCR: Flexion, 200 Duration')
                        xlabel('time [s]'); ylabel('EMG activity [nu]');
                        xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefExtension{i})]);
                    else
                        subplot(2,2,3);hold on; box on; grid on;
                        line_color='k';
                        plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                            fcrfilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                        title('FCR: Extension, 200 Duration')
                        xlabel('time [s]'); ylabel('EMG activity [nu]');
                        xlim([0 0.2]);ylim([-1 max(fcrfilt{i}./avgrefExtension{i})]);
                    end
                end
            end
         end
            
        
         for k = 1:150
            if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)>=200
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),5)==50
                        subplot(2,2,2);hold on; box on; grid on;
                        line_color='r';
                        plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                            ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                        title('ECU: Flexion, 200 Duration')
                        xlabel('time [s]'); ylabel('EMG activity [nu]');
                        xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                    else
                        subplot(2,2,4);hold on; box on; grid on;
                        line_color='m';
                        plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                            ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                        title('ECU: Extension, 200 Duration')
                        xlabel('time [s]'); ylabel('EMG activity [nu]');
                        xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                    end
                end
            end
        end
        
             
        for k = 1:150
            if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),3)>=200
                if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),2)==1
                    if DurTrialNum{i}(find(DurTrialNum{i}(:,1)==j),5)==125
                        subplot(2,2,4);hold on; box on; grid on;
                        line_color='g';
                        plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                            ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                        title('ECU: Flexion, 200 Duration')
                        xlabel('time [s]'); ylabel('EMG activity [nu]');
                        xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                    else
                        subplot(2,2,3);hold on; box on; grid on;
                        line_color='k';
                        plot(EMGtime{i}(timeIndex(1,j):timeIndex(4,j))-EMGtime{i}(timeIndex(1,j)), ...
                            ecufilt{i}(timeIndex(1,j):timeIndex(4,j))./avgrefExtension{i},'Color', line_color);
                        title('FCR: Extension, 200 Duration')
                        xlabel('time [s]'); ylabel('EMG activity [nu]');
                        xlim([0 0.2]);ylim([-1 max(ecufilt{i}./avgrefExtension{i})]);
                    end
                end
            end
         end
        
        %Clear memory
        fcrfilt{i} = [];
        ecufilt{i} = [];
       
        %Create an array of indices of where the pertubation (0-200 ms) and a list of
        %indices where the LLR (50-100 ms) is active in emgIndexes().  This can be then applied to
        %get EMG amplitude values from the full track in emgAmplitude(). EMGtypesplitv3() is used
        %to get EMG data for FCR and for ECU.
        
        %indexes_perturbation = whole trial indices
        %indexes_LLR = 50-100ms indices
        [indexes_perturbation{i}, indexes_LLR{i}] = emgIndexes(triggerCount(i), Perturb_begin_index(i,:), LLR_50ms_index(i,:), LLR_100ms_index(i,:), Perturb_end_index(i,:));
        [EMGfcr{i}, EMGecu{i}, LLRfcr{i}, LLRecu{i}, t{i}] = emgAmplitudev2(EMGtime{i}, EMGfilt{i}, triggerCount(i), indexes_perturbation{i}, indexes_LLR{i});
        [EMGbyConditionFCR{i}, EMGbyConditionECU{i}, LLRfcr_sorted{i}, LLRecu_sorted{i}, condArray{i}] = EMGtypesplitv3(pertTorque{i}, pertDuration{i}, pertVel{i}, EMGfcr{i}, EMGecu{i}, LLRfcr{i}, LLRecu{i}, perMode(i), DurTrialNum{i});
        
        %For the outputs of EMGtypesplitv2():
        %First half is flexion, second half is extension
        %Then sorted by instruction, then sorted by torque, then sorted by
        %velocity.
        %Each subject is in its own cell.
      
        plot_EMG_response(EMGbyConditionFCR{i},EMGbyConditionECU{i},LLRfcr_sorted{i},LLRecu_sorted{i},condArray{i}, SubjArray{i}, Fs)
        %condArray
        %Column 1: 1 is WRIST Flexion 2 is WRIST Extension -> 
            %muscle stretch and nonstretch are therefore inverted for the
            %flexor and extensor muscles
        %Column 2: 0 is yield, 1 is do not intervene (what I was previously
        %calling resist)
        %Column 3: torque is 0 Nm or 0.2 Nm
        %Column 4: velocity is 50, 125, or 200 deg/s
        end
    end