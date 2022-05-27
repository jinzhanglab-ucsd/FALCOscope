ScopeCtrlLoc = 'C:\Users\Scope4\Documents\MATLAB\MATscope';
addpath(genpath([ScopeCtrlLoc,'\helperFunction022522']))

% Initiate OpenTrons
OT = OpenTrons;
% Specify deck
tiprack200a = OT.loadContainer('tiprack200a','tiprack-200ul','C3');
trash = OT.loadContainer('trash','point','A3');

py.opentrons.containers.create('96-supertall-well',pyargs('grid',int8([8, 12]),'spacing',int8([9, 9]),'diameter',7.5,'depth',45))                   

% types of containers at each grid locations
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODIFY THIS FOR EXPERIMENT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
plate96drug1 = OT.loadContainer('plate96drug1','96-PCR-flat','A1');
plate96drug2 = OT.loadContainer('plate96drug2','96-PCR-flat','B2');
plate96drug3 = OT.loadContainer('plate96drug3','96-PCR-flat','C1');
plate96drug4 = OT.loadContainer('plate96drug4','96-PCR-flat','C2');
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Specify  the dynamic plate
plate96scp = OT.loadContainer('plate96scp','96-deep-well','D2');
OT.set_dynamic_cont(plate96scp,Scp);
heightSet = OT.loadContainer('heightSet','96-PCR-flat','D1');

% Specify pipettes
p300_multi = OT.loadPipette('p300_multi','a',300,'min_volume',50,'channels',8,'trash_container',OT.trash,'tip_racks',{OT.tiprack200a});

% Specify starting tip location
p300_multi.pypette.start_at_tip(OT.helper.getRow(tiprack200a,'2'));

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ USER MUST CALIBRATE SCOPE IMAGINE PLATE POSITION~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 % scope imagining station
Scp.Chamber = Plate('Costar96 (3904)');
Scp.Chamber.x0y0   =   Scp.XY;
Scp.Chamber.directionXY = [-1 -1];

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ USER MUST CALIBRATE STATIC FIELDS ON OT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   % DONE IN OPENTRON CONTROL GUI


%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODIFY THIS FOR EXPERIMENT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Set up: username, metadata, position, and AcqData
Scp.basePath = 'E:\';
Scp.Username = 'Clara'; % your username!
Scp.Project = 'Falcoscope_Upgrade'; % the project this dataset correspond to
Scp.Dataset = 'test_protocol_022822';  % the name of this specific image dataset - i.e. this experiment.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Scp.AutoFocusType = 'hardware'; %hardware or none
[ExperimentConfig,Desc] = GUIgetMetadata; % metadata
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODIFY THIS FOR EXPERIMENT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Scp.ExperimentDescription = 'HEK293 cells (IL)transfected with H188; ND 20; Room Temp';

% Aquisition Data
    AcqData = AcquisitionData;

    nAcq = 1;
    
    AcqData(nAcq).Channel='DAPI';
    AcqData(nAcq).Exposure=50;
    AcqData(nAcq).Fluorophore='Hoechst';
    nAcq = nAcq+1;

    AcqData(nAcq).Channel='CFP';
    AcqData(nAcq).Exposure=100;
    AcqData(nAcq).Fluorophore='H188';
    nAcq = nAcq+1;

    AcqData(nAcq).Channel='CY_FRET';
    AcqData(nAcq).Exposure=100;
    AcqData(nAcq).Fluorophore='H188';
    nAcq = nAcq+1;

    AcqData(nAcq).Channel='YFP';
    AcqData(nAcq).Exposure=100;
    AcqData(nAcq).Fluorophore='H188';
    nAcq = nAcq+1;

    % AcqData(nAcq).Channel='RFP';
    % AcqData(nAcq).Exposure=200;
    % AcqData(nAcq).Fluorophore='RCaMP1.017';
    % nAcq = nAcq+1;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODIFY THIS FOR EXPERIMENT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
startRow = 1;
endRow = 8;
startCol = 1;
endCol = 8;

setPlateIndex(Scp, startRow, endRow, startCol, endCol, ExperimentConfig)

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODIFY THIS FOR EXPERIMENT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
numTp = 85;    
timeInterval = 60;    %sec / tp
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
setTimepoints(Scp, numTp, timeInterval)
initOut = Scp.initQueue(AcqData,'liveupdates',0,'baseacqname','HEK293_multidrugadd','usemda',1);

%% third
% Now set up protocol
QueueList = OTexQueue;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODIFY THIS FOR EXPERIMENT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
p300_multi.pypette.start_at_tip(OT.helper.getRow(tiprack200a,'3'))
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fullStage = {'A1','A2','A3','A4','A5','A6','A7','A8','A9','A9','A11','A12'};
stageWell = fullStage(startCol:endCol);

QueueNum = 0;
for wellIdx = 1:length(stageWell)         %% loop through each stageWell and add 4 types of drugs
    % queue management
    QueueNum = QueueNum +1;
    [QueueList, QueueNum] = getTip(QueueList, QueueNum, wellIdx, p300_multi);
    
    % drugAddition(QueueList, QueueNum, stageWell, wellIdx, pipettes,  drugName, time, vol, drugPlate, scpPlate, heightSet)
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODIFY THIS FOR EXPERIMENT~~~~~~~~~~~~~~~~~~~~~~~~~~
    %%%% drug addition 1
    [QueueList, QueueNum] = drugAddition(QueueList, QueueNum, stageWell, wellIdx, p300_multi, 'drug 1', 3, 100, plate96drug1, plate96scp, heightSet );
    %%%% drug addition 2 (time2 need to be > t1 + 3)
    [QueueList, QueueNum] = drugAddition(QueueList, QueueNum, stageWell, wellIdx, p300_multi, 'drug 2', 6, 50, plate96drug2, plate96scp, heightSet );
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % trash tip at end of experiment and home 3 times
    % trashTip/homeTip(QueueList, QueueNum, wellIdx, pipettes, time)
    [QueueList, QueueNum] = trashTip(QueueList, QueueNum, wellIdx, p300_multi, numTp - 10);
    [QueueList, QueueNum] = homeTip(QueueList, QueueNum, wellIdx, p300_multi, numTp - 9);
    
end

OT.sendToExtQueue(Scp.Sched,QueueList)

%% fourth

queueGUI(Scp)