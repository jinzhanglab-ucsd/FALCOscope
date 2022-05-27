
function set_plate_index(Scp, start_row, end_row, start_col, end_col, ExperimentConfig)
    msk = false(8,12);
    r=2:7;  %do rows 1-8
    c=3:12; %do columns 1-8,10,11
    msk(r,c)=1;

    batchInds = zeros(8,12);
    for k = 1:length(c)
        batchInds(1:8,c(k)) = k;
    end
    Scp.createPositions([],'sitesperwell',[1,1],'msk',msk,'batchinds',batchInds,'experimentdata',ExperimentConfig);
end



function set_timepoints(Scp, num_tp, time_interval)
    Scp.Tpnts = Timepoints;
    Scp.Tpnts = createEqualSpacingTimelapse(Scp.Tpnts, num_tp, time_interval); % # of time points, seconds btwn each timepoint
end


function get_tip(QueueList, QueueNum, stageWell, pipettes)
    QueueList(QueueNum).Name = 'Get Tip';
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = 1;
    QueueList(QueueNum).QueueIndex = [stageWell 1 0 -1];

    MDinfo.desc = 'Get Tip';
    MDinfo.conc = 0;
    MDinfo.units = 'N/A';
    MDinfo.type = 'Drug Prep';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 1;

    pipettes.pick_up_tip('presses',6,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
end

% what is the last of  [x x x x] and waitToContinue
function drug_addition(QueueList, QueueNum, stageIdx, pipettes,  drugName, time, vol, drugPlate, scpPlate)
    QueueNum = QueueNum +1; 
    QueueList(QueueNum).Name = strcat("Pick up media for ", drugName);
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = 1;
    QueueList(QueueNum).QueueIndex = [stageIdx time 0 -1];
    MDinfo.desc = strcat("Pick up media for ", drugName);
    MDinfo.conc = vol;
    MDinfo.units = 'uL';
    MDinfo.type = 'Drug Prep';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 1;

    pipettes.aspirate(vol,scpPlate.well(stageWell{stageIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.move_to(scpPlate.well(stageWell{stageIdx}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = strcat("Mix With ", drugName);
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = 1;
    QueueList(QueueNum).QueueIndex = [stageIdx time+1 0 1];
    MDinfo.desc = strcat("Mix With ", drugName);
    MDinfo.conc = vol;
    MDinfo.units = 'uL';
    MDinfo.type = 'Drug Prep';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 0;

    pipettes.dispense(vol,drugPlate.well(stageWell{stageIdx}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.mix(3,vol,'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.aspirate(vol,drugPlate.well(stageWell{stageIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.move_to(drugPlate.well(stageWell{stageIdx}).top(),'strategy','direct','queuing','ExtQueue','locqueue',QueueList(QueueNum))

    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = strcat("Deliver ", drugName); 
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = 1;
    QueueList(QueueNum).QueueIndex = [stageIdx time+2 0 1];
    MDinfo.desc = strcat("Deliver ", drugName);
    MDinfo.conc = vol;
    MDinfo.units = 'uL';
    MDinfo.type = 'Drug delivery';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 1;

    pipettes.dispense(vol,scpPlate.well(stageWell{stageIdx}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.mix(3,vol,'loc',scpPlate.well(stageWell{stageIdx}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.move_to(heightSet.well('A12').top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))
end

function trash_tip(QueueList, QueueNum, stageIdx, pipettes, time)
    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = 'trashTip';
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
    QueueList(QueueNum).QueueIndex = [stageIdx time 0 -1]; %10 mins before endpoint
    MDinfo.desc = 'Trash Tip';
    MDinfo.conc = 0;
    MDinfo.units = 'N/A';
    MDinfo.type = 'Trash Tip';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 1;

    pipettes.drop_tip('queuing','ExtQueue','locqueue',QueueList(QueueNum))
end

function home_tip(QueueList, QueueNum, stageIdx, pipettes, time)
    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = 'Home Axes';
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
    QueueList(QueueNum).QueueIndex = [stageIdx time 0 -1];
    MDinfo.desc = 'Home Axes';
    MDinfo.conc = 0;
    MDinfo.units = 'N/A';
    MDinfo.type = 'Trash Tip';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 0;

    pipettes.homeAll('queuing','ExtQueue','locqueue',QueueList(QueueNum))

    %home 2
    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = 'Home Axes 2';
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
    QueueList(QueueNum).QueueIndex = [stageIdx time+3 0 -1]; %3 mins before endpoint 
    MDinfo.desc = 'Home Axes 2';
    MDinfo.conc = 0;
    MDinfo.units = 'N/A';
    MDinfo.type = 'Trash Tip';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 0;

    pipettes.homeAll('queuing','ExtQueue','locqueue',QueueList(QueueNum))

    % home 3
    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = 'Home Axes 3';
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
    QueueList(QueueNum).QueueIndex = [stageIdx time+6 0 -1]; %3 mins before endpoint 
    MDinfo.desc = 'Home Axes 3';
    MDinfo.conc = 0;
    MDinfo.units = 'N/A';
    MDinfo.type = 'Trash Tip';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 0;

    pipettes.homeAll('queuing','ExtQueue','locqueue',QueueList(QueueNum))
end














%
function [msk, batchInds] = set_plate_index(Scp, start_row, end_row, start_col, end_col, ExperimentConfig)
    msk = false(8,12);
    r=2:7;  %do rows 1-8
    c=3:12; %do columns 1-8,10,11
    msk(r,c)=1;

    batchInds = zeros(8,12);
    for k = 1:length(c)
        batchInds(1:8,c(k)) = k;
    end
end
%