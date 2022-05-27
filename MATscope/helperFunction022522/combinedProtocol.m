%% Set up: username, metadata, position, and AcqData
%userdata
Scp.basePath = 'E:\';
Scp.Username = 'Clara'; % your username!
Scp.Project = 'GPR68'; % the project this dataset correspond to
Scp.Dataset = '211015_ogerin_multidrug_FALCOscope_20minIncubation';  % the name of this specific image dataset - i.e. this experiment.

Scp.AutoFocusType = 'hardware'; %hardware or none
%% metadata
[ExperimentConfig,Desc] = GUIgetMetadata;
Scp.ExperimentDescription = 'HEK293 cells (IL)transfected with H188; ND 20; Room Temp';
% Scp.reduceAllOverheadForSpeed=true;
%% Aquisition Data
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

% 
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
% % AcqData(nAcq).Fluorophore='RCaMP1.017';
% nAcq = nAcq+1;

%% Set chambers
Scp.Chamber = Plate('Costar96 (3904)');
% Scp.Chamber.x0y0 = [ 25366 28389];
Scp.Chamber.x0y0   =   [926676       29164];
Scp.Chamber.directionXY = [-1 -1];
% Scp.createPositionFromMM('guessWells',1);

% Scp.Chamber = Plate('Microfluidics Wounding Device Ver 3.0');
% Scp.Chamber.x0y0 = Scp.XY;
% Scp.Chamber.directionXY = [-1 1];
% Scp.createPositionFromMM('guessWells',1);

%% positions
msk = false(8,12);

r=2:7;%do rows 1-8
c=3:12; % do columns 1-8,10,11

msk(r,c)=1;

batchInds = zeros(8,12);
for k = 1:length(c)
batchInds(1:8,c(k)) = k;
end
% batchInds(r,1:2) = 1;
% batchInds(r,3:4) = 1;
% batchInds(r,5:6) = 1;
% batchInds(r,7:8) =2;
% batchInds(r,9:10) = 1;
% batchInds(r,11:12) = 2;
% manBatchOrder = zeros(8,12);
% manBatchOrder(:,1:2) = [[1:8]',[16:-1:9]'];
% manBatchOrder(:,3:4) = [[1:8]',[16:-1:9]'];
% manBatchOrder(:,5:6) = [[1:8]',[16:-1:9]'];
% manBatchOrder(:,7:8) = [[1:8]',[16:-1:9]'];
% manBatchOrder(:,9:10) = [[1:8]',[16:-1:9]'];
% manBatchOrder(:,11:12) = [[1:8]',[16:-1:9]'];
% 


%% positions
% msk = false(8,12);
% msk(r,c)=1;
% Scp.createPositions([],'sitesperwell',[1,1],'msk',msk);
% Scp.createPositions([],'sitesperwell',[1,1],'msk',msk,'batchinds',batchInds,'manbatchorder',manBatchOrder);
Scp.createPositions([],'sitesperwell',[1,1],'msk',msk,'batchinds',batchInds,'experimentdata',ExperimentConfig);

% Scp.createPositions([],'msk',msk,'experimentdata',ExperimentConfig,'optimize',true);
% Scp.createPositions([],'msk',msk);

% Scp.createPositions([]);

%% imaging
%initial image
Scp.Tpnts = Timepoints;
Scp.Tpnts = createEqualSpacingTimelapse(Scp.Tpnts,85,60); % # of time points, seconds btwn each timepoint
% initOut = Scp.initAcq(AcqData);
initOut = Scp.initQueue(AcqData,'liveupdates',0,'baseacqname','HEK293_multidrugadd','usemda',1);

%%
% Scp.acqOne(AcqData,initOut);
% Scp.addLiveCalc('(Ch2-Bkgr2)./(Ch1-Bkgr1)','FRET Ratio','CY_FRETr');
% Scp.addLiveCalc('(Ch1-Bkgr1)','CFP Background Subtrackted','CFPbkgrSub');
% 

%% Initiate OpenTrons
OT = OpenTrons;

%% Specify deck

tiprack200a = OT.loadContainer('tiprack200a','tiprack-200ul','C3');
% tiprack200b = OT.loadContainer('tiprack200b','tiprack-200ul','B3');
% tiprack200sing = OT.loadContainer('tiprack200sing','tiprack-200ul','A3');
trash = OT.loadContainer('trash','point','A3');

py.opentrons.containers.create('96-supertall-well',pyargs('grid',int8([8, 12]),'spacing',int8([9, 9]),'diameter',7.5,'depth',45))                   
    
%plate96pH = OT.loadContainer('plate96pH','96-supertall-well','B2');
%plate96pHtrash = OT.loadContainer('plate96pHtrash','96-supertall-well','C2');

plate96ogerin = OT.loadContainer('plate96ogerin','96-PCR-flat','A1');
plate96fsk = OT.loadContainer('plate96fsk','96-PCR-flat','B2');
plate96drugs = OT.loadContainer('plate96drugs','96-PCR-flat','C1');
plate96IBMX = OT.loadContainer('plate96IBMX','96-PCR-flat','C2');

heightSet = OT.loadContainer('heightSet','96-PCR-flat','D1');
% tubeRack = OT.loadContainer('tubeRack','tube-rack-2ml','A3');
% plate96drugspre = OT.loadContainer('plate96drugspre','96-PCR-flat','C3');
% Specify  the dynamic plate
plate96scp = OT.loadContainer('plate96scp','96-deep-well','D2');
OT.set_dynamic_cont(plate96scp,Scp)
%% Specify pipettes

p300_multi = OT.loadPipette('p300_multi','a',300,'min_volume',50,'channels',8,'trash_container',OT.trash,'tip_racks',{OT.tiprack200a});
% p1000 = OT.loadPipette('p1000','b',1000,'min_volume',200,'trash_container',OT.trash,'tip_racks',{OT.tiprack1000});

%% Specify starting tip location

% p300_multi.start_at_tip(tiprack200,'A1');
p300_multi.pypette.start_at_tip(OT.helper.getRow(tiprack200a,'2'))
% p1000.start_at_tip(tiprack1000,'G3');

%% Common Calibration Commands
p300_multi.pick_up_tip('presses',6,'queuing','Now') %after this command, it will start tip pickup at the next column

%Aspirate 100 uL alone
p300_multi.aspirate(100,py.None,'rate',0.5,'queuing','Now')

%Dispense all alone
p300_multi.dispense([],py.None,'rate',0.5,'queuing','Now')

%Mixing sequence **switch plates as you go!
p300_multi.dispense(100,plate96ogerin.well('A2').bottom(),'rate',1,'queuing','Now')
p300_multi.mix(3,100,'rate',1,'queuing','Now')

p300_multi.aspirate(100,plate96ogerin.well('A2').bottom(),'rate',0.25,'queuing','Now')
p300_multi.move_to(plate96ogerin.well('A2').top(),'strategy','direct','queuing','Now')

%% Calibration stuff [graveyard]
p300_multi.pick_up_tip('presses',6,'queuing','Now') %after this command, it will start tip pickup at the next column

p300_multi.aspirate(100,py.None,'rate',0.5,'queuing','Now')
% p300_multi.aspirate(50,plate96drugs.well('A2'),'queuing','Now')
% p300_multi.aspirate(50,py.None,'queuing','Now')
p300_multi.dispense([],py.None,'rate',0.5,'queuing','Now')
% p300_multi.aspirate(50,calibTube.well('A1'),'queuing','Now')
% p300_multi.dispense(50,trash.well('A1'),'queuing','Now')
% p300_multi.blow_out('queuing','Now')
% p300_multi.return_tip('queuing','Now')
% p300_multi.drop_tip('queuing','Now')
% p300_multi.homeAll('queuing','Now')
% % Test protocol by itself
% p300_multi.pick_up_tip('queuing','Now')
% p300_multi.aspirate(50,plate96drugs.well('A2'),'queuing','Now')
% p300_multi.dispense(50,plate96drugs.well('A3').bottom(),'queuing','Now')
% p300_multi.move_to(plate96scp.well('A1').top(),'queuing','Now')
% p300_multi.dispense(50,plate96scp.well('A1').bottom(),'queuing','Now')
% p300_multi.mix(10,200,'rate',0.5,'queuing','Now')
% p300_multi.blow_out('queuing','Now')
% p300_multi.move_to(plate96scp.well('A1').top(),'strategy','direct','queuing','Now')
% p300_multi.move_to(plate96scp.well('A1').bottom(),'queuing','Now')
% p300_multi.move_to(plate96drugs.well('A1').top(),'queuing','Now')
% p300_multi.move_to(plate96PH.well('A1').top(),'queuing','Now')
% p300_multi.aspirate(200,plate96pH.well(stageWell{1}).bottom(),'queuing','Now')
% 
% stageWell = {'A1','A2','A3','A4','A5','A6','A7','A8'};
% k=1;
% p300_multi.pick_up_tip('presses',4,'queuing','Now')
% 
% p300_multi.aspirate(200,plate96scp.well(stageWell{k}).bottom(),'queuing','Now')
% p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','Now')
% % 20 sec
% p300_multi.dispense(200,plate96pHtrash.well(stageWell{k}).bottom(),'queuing','Now')
% p300_multi.aspirate(200,plate96pH.well(stageWell{k}).bottom(),'queuing','Now')
% p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','Now')
% %40 sec
% p300_multi.dispense(200,plate96scp.well(stageWell{k}).bottom(),'queuing','Now')
% p300_multi.mix(4,200,'rate',0.75,'queuing','Now')
% p300_multi.aspirate(200,plate96scp.well(stageWell{k}).bottom(),'queuing','Now')
% p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','Now')
% %54 sec
% p300_multi.dispense(200,plate96pHtrash.well(stageWell{k}).bottom(),'queuing','Now')
% p300_multi.aspirate(200,plate96pH.well(stageWell{k}).bottom(),'queuing','Now')
% p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','Now')
% %38 sec
% p300_multi.dispense(200,plate96scp.well(stageWell{k}).bottom(),'queuing','Now')
% p300_multi.mix(4,200,'rate',0.75,'queuing','Now')
% p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','Now')
%47 sec
%% do pre incubate

        
%% Now set up protocol
% p1000.transfer_prep(200,tubes1_5mL.wells('A1'),tubes1_5mL.wells('B1'),'queuing','Now')
% p1000.transfer_disp(tubes1_5mL.wells('B1').bottom(),'vol',200,'mixreps',3,'blowout',1,'queuing','Now')
QueueList = OTexQueue;
p300_multi.pypette.start_at_tip(OT.helper.getRow(tiprack200a,'3'))
% IsoWell = {'A1','A2','A3','A4'};
% FIWell = {'A7','A8','A9','A10'};
% FIwell = 'A8';
stageWell = {'A3','A4','A5','A6','A7','A8','A9','A10','A11','A12'};%'A6','A7'};%{'A3','A4','A5','A6','A7'}; %,'A9','A10','A11','A12'};
%numExchange = [3,3,3,3,3,3,3,3,3,3,3];%[5,5,5,5,5]; %,3,5,3,5];
%Z%numMixCol = 0;
% trashWell = {'A11','A12','A1','A2','A3','A4','A5','A6','A7','A8'};
% preStimWell = {'A2','A3','A4','A5','A6','A7','A8','A9','A10'};
% stageWell = {'A9','A11'};
% stageWellb = {'A10','A12'};
% stageWell = {'A9','A11'};
% stageWellb = {'A10','A12'};
% stageWell = {'A2','A4','A5','A6','A8','A10','A11','A12'};

% stageWell = {'A6','A7','A8'};
% numMixes = [0,1,4];
% CUTie protocols

QueueNum = 0;
% switchVar = [1,2,3,4,1,2,3,4,1,2,3,4];
% pH protocols

for k = 1:length(stageWell)
    
%numMixCol = numMix(k);

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Get Tip';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 1 0 -1];
MDinfo.desc = 'Get Tip';
MDinfo.conc = 0;
MDinfo.units = 'N/A';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.pick_up_tip('presses',6,'queuing','ExtQueue','locqueue',QueueList(QueueNum))

%%%% drug addition 1

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Pick up media for ogerin';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 3 0 -1];
MDinfo.desc = 'Pick up media for ogerin';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.aspirate(100,plate96scp.well(stageWell{k}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Mix With ogerin';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 4 0 1];
MDinfo.desc = 'Mix with ogerin';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
QueueList(QueueNum).waitToCont = 0;

p300_multi.dispense(100,plate96ogerin.well(stageWell{k}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.mix(3,100,'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.aspirate(100,plate96ogerin.well(stageWell{k}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(plate96ogerin.well(stageWell{k}).top(),'strategy','direct','queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Deliver ogerin';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 5 0 1];
MDinfo.desc = 'Deliver ogerin';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug delivery';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.dispense(100,plate96scp.well(stageWell{k}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
%Annie Change Test: switch from 150 --> 100 uL mix volume
p300_multi.mix(3,100,'loc',plate96scp.well(stageWell{k}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(heightSet.well('A12').top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

% %%%% drug addition 2

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Pick up media for drug';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 23 0 -1];
MDinfo.desc = 'Pick up media for drug';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.aspirate(100,plate96scp.well(stageWell{k}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Mix With drug';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 24 0 1];
MDinfo.desc = 'Mix with drug';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
QueueList(QueueNum).waitToCont = 0;

p300_multi.dispense(100,plate96drugs.well(stageWell{k}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.mix(3,100,'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.aspirate(100,plate96drugs.well(stageWell{k}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(plate96drugs.well(stageWell{k}).top(),'strategy','direct','queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Deliver drugs';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 25 0 1];
MDinfo.desc = 'Deliver drugs';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug delivery';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.dispense(100,plate96scp.well(stageWell{k}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.mix(3,100,'loc',plate96scp.well(stageWell{k}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(heightSet.well('A12').top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

%%% drug addition 3
QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Pick up media for ibmx';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 43 0 -1];
MDinfo.desc = 'Pick up media for ibmx';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.aspirate(100,plate96scp.well(stageWell{k}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Mix With ibmx';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 44 0 1];
MDinfo.desc = 'Mix with ibmx';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
QueueList(QueueNum).waitToCont = 0;

p300_multi.dispense(100,plate96IBMX.well(stageWell{k}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.mix(3,100,'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.aspirate(100,plate96IBMX.well(stageWell{k}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(plate96IBMX.well(stageWell{k}).top(),'strategy','direct','queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Deliver IBMX';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 45 0 1];
MDinfo.desc = 'Deliver IBMX';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug delivery';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.dispense(100,plate96scp.well(stageWell{k}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.mix(3,100,'loc',plate96scp.well(stageWell{k}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(heightSet.well('A12').top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))
% 
% %%% drug addition 4
QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Pick up media for Fsk';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 63 0 -1];
MDinfo.desc = 'Pick up media for Fsk';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.aspirate(100,plate96scp.well(stageWell{k}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(plate96scp.well(stageWell{k}).top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Mix With Fsk';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 64 0 1];
MDinfo.desc = 'Mix with Fsk';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug Prep';
QueueList(QueueNum).MDdescr = MDinfo;
QueueList(QueueNum).waitToCont = 0;

p300_multi.dispense(100,plate96fsk.well(stageWell{k}).bottom(),'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.mix(3,100,'rate',1,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.aspirate(100,plate96fsk.well(stageWell{k}).bottom(),'rate',0.25,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(plate96fsk.well(stageWell{k}).top(),'strategy','direct','queuing','ExtQueue','locqueue',QueueList(QueueNum))

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Deliver Fsk';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = 1;
QueueList(QueueNum).QueueIndex = [k 65 0 1];
MDinfo.desc = 'Deliver Fsk';
MDinfo.conc = 100;
MDinfo.units = 'uL';
MDinfo.type = 'Drug delivery';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(1).MDdescr = ' 50 uL Iso dose range to stage plate row 1 from row 1 of 96 well drugs';
QueueList(QueueNum).waitToCont = 1;

p300_multi.dispense(100,plate96scp.well(stageWell{k}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.mix(3,100,'loc',plate96scp.well(stageWell{k}).bottom(),'rate',0.5,'queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.move_to(heightSet.well('A12').top(),'queuing','ExtQueue','locqueue',QueueList(QueueNum))

%%%trash tip at end of experiment

QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'trashTip';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
QueueList(QueueNum).QueueIndex = [k 70 0 -1]; %10 mins before endpoint
MDinfo.desc = 'Trash Tip';
MDinfo.conc = 0;
MDinfo.units = 'N/A';
MDinfo.type = 'Trash Tip';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(5).MDdescr = 'get rid of tip and home';
QueueList(QueueNum).waitToCont = 1;

p300_multi.drop_tip('queuing','ExtQueue','locqueue',QueueList(QueueNum))

%home 1
QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Home Axes';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
QueueList(QueueNum).QueueIndex = [k 73 0 -1]; %7 mins before endpoint 
MDinfo.desc = 'Home Axes';
MDinfo.conc = 0;
MDinfo.units = 'N/A';
MDinfo.type = 'Trash Tip';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(5).MDdescr = 'get rid of tip and home';
QueueList(QueueNum).waitToCont = 0;

% p300_multi.drop_tip('queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.homeAll('queuing','ExtQueue','locqueue',QueueList(QueueNum))

%home 2
QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Home Axes 2';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
QueueList(QueueNum).QueueIndex = [k 77 0 -1]; %3 mins before endpoint 
MDinfo.desc = 'Home Axes 2';
MDinfo.conc = 0;
MDinfo.units = 'N/A';
MDinfo.type = 'Trash Tip';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(5).MDdescr = 'get rid of tip and home';
QueueList(QueueNum).waitToCont = 0;

% p300_multi.drop_tip('queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.homeAll('queuing','ExtQueue','locqueue',QueueList(QueueNum))

%home 3
QueueNum = QueueNum +1;
QueueList(QueueNum).Name = 'Home Axes 3';
QueueList(QueueNum).TimePoint = -1;
QueueList(QueueNum).TimeOrder = -1; % add to end of the same time point
QueueList(QueueNum).QueueIndex = [k 81 0 -1]; %3 mins before endpoint 
MDinfo.desc = 'Home Axes 3';
MDinfo.conc = 0;
MDinfo.units = 'N/A';
MDinfo.type = 'Trash Tip';
QueueList(QueueNum).MDdescr = MDinfo;
% QueueList(5).MDdescr = 'get rid of tip and home';
QueueList(QueueNum).waitToCont = 0;

% p300_multi.drop_tip('queuing','ExtQueue','locqueue',QueueList(QueueNum))
p300_multi.homeAll('queuing','ExtQueue','locqueue',QueueList(QueueNum))


end


OT.sendToExtQueue(Scp.Sched,QueueList)
% QueueList(3).Name = 'trashTip';
% QueueList(3).TimePoint = 60;
% QueueList(3).TimeOrder = -1; % add to end of the same time point
% QueueList(3).MDdescr = 'get rid of tip and home';
% QueueList(3).waitToCont = 0;
% 
% p300_multi.drop_tip('queuing','ExtQueue','locqueue',QueueList(3))
% p300_multi.home('queuing','ExtQueue','locqueue',QueueList(3))

%% 

% Scp.addLiveCalc('Ch2-Bkgr2','Bkgr subtracted YFP FRET');
queueGUI(Scp)
% Scp.acquireQueue(AcqData,'acqname',initOut);
% Scp.acquire(AcqData);
% pause(5)
% Scp.Tpnts = Timepoints;
% Scp.Tpnts = createEqualSpacingTimelapse(Scp.Tpnts,100,3);
% Scp.initAcq(AcqData);
% Scp.acquire(AcqData);