
ScopeCtrlLoc = 'C:\Users\Scope4\Documents\MATLAB\MATscope';
addpath(genpath([ScopeCtrlLoc,'\helperFunction022522']))
%% first setting up OT enviroment

% Testing new class
% Initiate OpenTrons
OT = OpenTrons;

% Specify deck
tiprack200a = OT.loadContainer('tiprack200a','tiprack-200ul','C3');
trash = OT.loadContainer('trash','point','A3');

py.opentrons.containers.create('96-supertall-well',pyargs('grid',int8([8, 12]),'spacing',int8([9, 9]),'diameter',7.5,'depth',45))                   

% types of containers at each grid locations
plate96ogerin = OT.loadContainer('plate96ogerin','96-PCR-flat','A1');
plate96fsk = OT.loadContainer('plate96fsk','96-PCR-flat','B2');
plate96drugs = OT.loadContainer('plate96drugs','96-PCR-flat','C1');
plate96IBMX = OT.loadContainer('plate96IBMX','96-PCR-flat','C2');
heightSet = OT.loadContainer('heightSet','96-PCR-flat','D1');

% Specify  the dynamic plate
plate96scp = OT.loadContainer('plate96scp','96-deep-well','D2');
OT.set_dynamic_cont(plate96scp,Scp)

% Specify pipettes
p300_multi = OT.loadPipette('p300_multi','a',300,'min_volume',50,'channels',8,'trash_container',OT.trash,'tip_racks',{OT.tiprack200a});

% Specify starting tip location
p300_multi.pypette.start_at_tip(OT.helper.getRow(tiprack200a,'2'))

%% calibrate FALCOScope deck using GUI
 % scope imagining station
Scp.Chamber = Plate('Costar96 (3904)');
Scp.Chamber.x0y0   =   Scp.XY;
%Scp.Chamber.x0y0   =   [926676       29164];
Scp.Chamber.directionXY = [-1 -1];

% calibrate static fields on OT
   % DONE IN OPENTRON CONTROL GUI

%% second setting up scope enviroment
% Set up: username, metadata, position, and AcqData
%userdata

Scp.basePath = 'E:\';
Scp.Username = 'Clara'; % your username!
Scp.Project = 'Falcoscope_Upgrade'; % the project this dataset correspond to
Scp.Dataset = 'test_protocol_022522';  % the name of this specific image dataset - i.e. this experiment.

Scp.AutoFocusType = 'hardware'; %hardware or none
% metadata
[ExperimentConfig,Desc] = GUIgetMetadata;
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

%%
startRow = 2;
endRow = 8;
startCol = 2;
endCol = 8;
setPlateIndex(Scp, startRow, endRow, startCol, endCol, ExperimentConfig)

% imaging
%initial image
numTp = 60;
timeInterval = 60;

setTimepoints(Scp, numTp, timeInterval)
initOut = Scp.initQueue(AcqData,'liveupdates',0,'baseacqname','HEK293_multidrugadd','usemda',1);
%% queueGUI(Scp)

%% third
% Now set up protocol
QueueList = OTexQueue;
p300_multi.pypette.start_at_tip(OT.helper.getRow(tiprack200a,'3'))

stageWell = {'A3','A4','A5','A6','A7','A8','A9','A9','A11','A12'};
QueueNum = 0;
for k = 1:length(stageWell)         %% loop through each stageWell and add 4 types of drugs
    % queue management
    QueueNum = QueueNum +1;
    QueueList = getTip(QueueList, QueueNum, k, p300_multi);

    %%%% drug addition 1
    QueueList = drugAddition(QueueList, QueueNum, stageWell, k, p300_multi,  'ogerin', 3, 100, plate96ogerin, plate96scp, heightSet );

    % %%%% drug addition 2

    %drugAddition(QueueList, QueueNum, k, p300_multi,  'drug', 23, vol, plate96drugs, plate96scp)

    %%% drug addition 3

    %drugAddition(QueueList, QueueNum, k, p300_multi,  'ibmx', 43, vol, plate96IBMX, plate96scp) 

    %%% drug addition 4
    %drugAddition(QueueList, QueueNum, k, p300_multi,  'Fsk', 43, vol, plate96fsk, plate96scp) 
    
    %%%trash tip at end of experiment
    QueueList = trashTip(QueueList, QueueNum, k, p300_multi, 70);

    %home 3x
    QueueList = homeTip(QueueList, QueueNum, k, p300_multi, 73);
    
end

OT.sendToExtQueue(Scp.Sched,QueueList)

%% fourth

queueGUI(Scp)