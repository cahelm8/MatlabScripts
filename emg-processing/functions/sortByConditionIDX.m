function [DurTrialNum] = sortByConditionIDX(triggerCount, dir, pertDuration, pertTorq)

torques=unique(pertTorq);
duration=unique(pertDuration);

flexion_Matrix = [];
extension_Matrix = [];

%A list of indices of which EMG tracks are flexion, and which are
%extension, sorted by torque AND velocity
for dur=1:length(duration)
    for tq=1:length(torques)
            for i=1:triggerCount
                if dir(i) == 0 %0=extension (CW)
                    if pertDuration(i) == duration(dur)
                        if pertTorq(i) == torques(tq)
                                extension_Matrix = [extension_Matrix; i 0 duration(dur) torques(tq)];
                        end
                    end
                 elseif dir(i) == 1 %1=flexion (CCW)
                     if pertDuration(i) == duration(dur)
                         if pertTorq(i) == torques(tq)
                                 flexion_Matrix = [flexion_Matrix; i 1 duration(dur) torques(tq)];
                         end
                     end
                end
            end
    end
end

DurTrialNum = [flexion_Matrix; extension_Matrix];