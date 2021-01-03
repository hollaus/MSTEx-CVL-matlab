sP = 'C:\cvl\msi\data\mstex\original_synchromedia\train\MSI\';
tRP = 'D:\msi\ace_v1\params_eval\aceThresh_msbin';

%% Evaluate the four different stages: 
sP = 'C:\cvl\msi\data\msbin\MSBin\train\images';
% tP = 'D:\msi\su\msbin';
clear p
p.dbName = 'msbin';
tRP = 'D:\msi\ace_v1\stages_eval\msbin_2';
evalStages = 0 : 4;
evalStages(1) = -1;
paramset = [];
for i = 1 : length(evalStages)
    p.evalStage = evalStages(i);
    p.folderName = append('stage_', num2str(p.evalStage));
    paramset{i} = p;
end
paramEval(sP, tRP, paramset);
% p.evalStage = 3;
% binarizeBatch(sP, tRP)

%% Single folder experiment:
clear paramset
sP = 'C:\cvl\msi\data\msbin\MSBin\train\images';
tP = 'D:\msi\su\msbin';
p.dbName = 'msbin';
low = [31 51 71 91]
high = [30 50 70 100 150 200]

idx = 1;
for i = 1 : length(low)
    p.neighSize = low(i);
    for j = 1 : length(high)
        p.numNeighbors = high(j);
        p.evalStage = 1;
        p.folderName = [num2str(low(i)) '_' num2str(high(j))];
        p.dbName = 'msbin';
        paramset{idx} = p;
        idx = idx + 1;
    end
end

% p.evalStage = 1;
% p.neighSize = 51;
% p.numNeighbors = 100;
% p.folderName = [num2str(p.neighSize) '_' num2str(p.numNeighbors)];
% paramset{1} = p;
paramEval(sP, tP, paramset);

figure;


%%
sP = 'C:\cvl\msi\data\msbin\MSBin\train\images_correct'
tRP = 'D:\msi\ace_v1\params_eval\aceThresh_msbin';
    
low = 0;
low(end+1:end+6) = (.0005 : .05 : .3)
% low = (.0005 : .05 : .3)
% low = 0;
high = (.3 : .05 : .65)

paramset = [];
clear p
idx = 1;
for i = 1 : length(low)
    p.aceThreshLow = low(i);
    for j = 1 : length(high)
        p.aceThreshHigh = high(j);
        p.folderName = [num2str(low(i)) '_' num2str(high(j))];
        p.dbName = 'msbin';
        paramset{idx} = p;
        idx = idx + 1;
    end
end
% 
% % TODO: Place here a loop:
% p1.aceThreshLow = .1;
% p1.aceThreshHigh = .9;
% p1.folderName = 'p1';
% 
% p2.aceThreshold = .1;
% p2.aceThreshold = .9;
% p2.folderName = 'p2';

% paramset = {p1, p2};
paramEval(sP, tRP, paramset);