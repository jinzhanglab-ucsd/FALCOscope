function [QueueList, QueueNum] = trashTip(QueueList, QueueNum, wellIdx, pipettes, time)
    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = 'trashTip';
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
    QueueList(QueueNum).QueueIndex = [wellIdx time 0 -1]; %trash tip at time
    MDinfo.desc = 'Trash Tip';
    MDinfo.conc = 0;
    MDinfo.units = 'N/A';
    MDinfo.type = 'Trash Tip';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 0;

    pipettes.drop_tip('queuing','ExtQueue','locqueue',QueueList(QueueNum))
end