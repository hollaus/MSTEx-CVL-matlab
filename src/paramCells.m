sP = 'C:\cvl\msi\data\mstex\original_synchromedia\test\MSI\';
tRP = 'D:\msi\ace_v1\params_eval';

% TODO: Place here a loop:
p1.aceThreshLow = .2;
p1.aceThreshHigh = .5;

p2.aceThreshold = .1;
p2.aceThreshold = .9;

paramset = {p1, p2};
paramEval(sP, tRP, paramset);