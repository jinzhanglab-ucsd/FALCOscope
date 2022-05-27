function [QueueList, QueueNum] = getTip(QueueList, QueueNum, stageWell, pipettes)
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