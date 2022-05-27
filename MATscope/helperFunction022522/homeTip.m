function [QueueList, QueueNum] = homeTip(QueueList, QueueNum, wellIdx, pipettes, time)
    QueueNum = QueueNum +1;
    QueueList(QueueNum).Name = 'Home Axes';
    QueueList(QueueNum).TimePoint = -1;
    QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
    QueueList(QueueNum).QueueIndex = [wellIdx time 0 -1];
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
    QueueList(QueueNum).QueueIndex = [wellIdx time+3 0 -1]; %3 mins before endpoint 
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
    QueueList(QueueNum).QueueIndex = [wellIdx time+6 0 -1]; %3 mins before endpoint 
    MDinfo.desc = 'Home Axes 3';
    MDinfo.conc = 0;
    MDinfo.units = 'N/A';
    MDinfo.type = 'Trash Tip';
    QueueList(QueueNum).MDdescr = MDinfo;
    QueueList(QueueNum).waitToCont = 0;

    pipettes.homeAll('queuing','ExtQueue','locqueue',QueueList(QueueNum))
end