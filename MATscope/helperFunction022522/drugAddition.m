% what is the last of  [x x x x] and waitToContinue
function [QueueList, QueueNum] = drugAddition(QueueList, QueueNum, stageWell, wellIdx, pipettes,  drugName, time, vol, drugPlate, scpPlate, heightSet)
    QueueNum = QueueNum +1; 
    QueueList(QueueNum).Name = strcat("Pick up media for ", drugName);
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = 1;
    QueueList(QueueNum).QueueIndex = [wellIdx time-2 0 -1];
    MDinfo.desc = strcat("Pick up media for ", drugName);
    MDinfo.conc = vol;
    MDinfo.units = 'uL';
    MDinfo.type = 'Drug Prep';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 1;

    pipettes.aspirate(vol,scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.move_to(scpPlate.well(stageWell{wellIdx}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = strcat("Mix With ", drugName);
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = 1;
    QueueList(QueueNum).QueueIndex = [wellIdx time-1 0 1];
    MDinfo.desc = strcat("Mix With ", drugName);
    MDinfo.conc = vol;
    MDinfo.units = 'uL';
    MDinfo.type = 'Drug Prep';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 0;

    pipettes.dispense(vol,drugPlate.well(stageWell{wellIdx}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.mix(3,vol,'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.aspirate(vol,drugPlate.well(stageWell{wellIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.move_to(drugPlate.well(stageWell{wellIdx}).top(),'strategy','direct','queuing','ExtQueue','locqueue',QueueList(QueueNum))

    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = strcat("Deliver ", drugName); 
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = 1;
    QueueList(QueueNum).QueueIndex = [wellIdx time 0 1];
    MDinfo.desc = strcat("Deliver ", drugName);
    MDinfo.conc = vol;
    MDinfo.units = 'uL';
    MDinfo.type = 'Drug delivery';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 1;

    pipettes.dispense(vol,scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.mix(3,vol,'loc',scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
    pipettes.move_to(heightSet.well('A12').top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))
end