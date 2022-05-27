% what is the last of  [x x x x] and waitToContinue
function [QueueList, QueueNum] = pHChange(QueueList, QueueNum, stageWell, wellIdx, pipettes, time, vol, pHChangePlate, pHWastePlate, scpPlate, heightSet)
  QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Extract Well Liquid';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [wellIdx time-2 0 -1];
MDinfo.desc = 'Extract Media from well';
MDinfo.conc = vol;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
QueueList(QueueNum).waitToCont = 1;
% QueueList(2).MDdescr = 'Deliver 50 uL different Iso doses to stage 96 well and then mix';

pipettes.aspirate(vol,scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.move_to(scpPlate.well(stageWell{wellIdx}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))


QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Pick up fresh pH media';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [wellIdx time-1 0 1];
MDinfo.desc = 'Pick up pH media';
MDinfo.conc = vol;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
QueueList(QueueNum).waitToCont = 0;

pipettes.dispense(vol,pHWastePlate.well(stageWell{wellIdx}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.aspirate(vol,pHChangePlate.well(stageWell{wellIdx}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.move_to(scpPlate.well(stageWell{wellIdx}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'pH media change 1';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [wellIdx time 0 -1];
MDinfo.desc = 'pH media change 1';
MDinfo.conc = vol;
MDinfo.units = 'uL';
MDinfo.type = 'Drug delivery';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

%dispense new media
pipettes.dispense(vol,scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
%mix four times after dispensing if toMix true

pipettes.mix(3,vol-100,'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))

%aspirate out scp plate media and move to top
pipettes.aspirate(vol,scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.move_to(scpPlate.well(stageWell{wellIdx}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Pick up fresh pH media';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [wellIdx time+1 0 1];
MDinfo.desc = 'Pick up pH media';
MDinfo.conc = vol;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
QueueList(QueueNum).waitToCont = 0;

pipettes.dispense(vol,pHWastePlate.well(stageWell{wellIdx}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.aspirate(vol,pHChangePlate.well(stageWell{wellIdx}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.move_to(scpPlate.well(stageWell{wellIdx}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'pH media change 2';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [wellIdx time+2 0 -1];
MDinfo.desc = 'pH media change 2';
MDinfo.conc = vol;
MDinfo.units = 'uL';
MDinfo.type = 'Drug delivery';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

pipettes.dispense(vol,scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))

%mix amt of times based on numMix
pipettes.mix(3,vol-100,'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))  

%aspirate out scp plate media and move to top
pipettes.aspirate(vol,scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.move_to(scpPlate.well(stageWell{wellIdx}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Pick up fresh pH media';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [wellIdx time+3 0 1];
MDinfo.desc = 'Pick up pH media';
MDinfo.conc = vol;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
QueueList(QueueNum).waitToCont = 0;

pipettes.dispense(vol,pHWastePlate.well(stageWell{wellIdx}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.aspirate(vol,pHChangePlate.well(stageWell{wellIdx}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.move_to(scpPlate.well(stageWell{wellIdx}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'pH media change 3';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [wellIdx time+4 0 -1];
MDinfo.desc = 'pH media change 3';
MDinfo.conc = vol;
MDinfo.units = 'uL';
MDinfo.type = 'Drug delivery';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

pipettes.dispense(vol,scpPlate.well(stageWell{wellIdx}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
pipettes.mix(3,vol-100,'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))

pipettes.move_to(heightSet.well('A12').top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

end