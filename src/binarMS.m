function output = binarMS(data, width, height, varargin)

params = parseInputs(varargin{:});

writingImg = reshape(data(:, params.writingIdx), height, width);

b = suBinar(writingImg, params);
b = removeBackground(b);
if (isfield(params, 'evalStage')) && (params.evalStage == 1)
    output = b;
    return; 
end


fgIdx = find(b);
fgIdx = removeOutlier(data, fgIdx);

tmp = zeros(height, width);
tmp(fgIdx) = 1;
bgIdx = find(~tmp);

aceSig = getAceSig(data, fgIdx, bgIdx);
aceImg = reshape(aceSig, height, width); 

bp.rImg = aceImg;
if (isfield(params, 'dbName'))
    bp.dbName = params.dbName;
end
bc = suBinar(writingImg, bp);

aceThresh = aceImg>graythresh(aceImg);
if (isfield(params, 'evalStage')) && (params.evalStage == -1)
    output = aceThresh;
    return; 
end

cleanImg = removeFalsePositives(b, aceThresh);
if (isfield(params, 'evalStage')) && (params.evalStage == 2)
    output = cleanImg;
    return; 
end

combinedSu = combineBinaryMasks(bc, cleanImg);
combinedSu = removeBackground(combinedSu);

if (isfield(params, 'evalStage')) && (params.evalStage == 3)
    output = combinedSu;
    return; 
end

suAceImg = combinedSu & aceImg > params.aceThreshLow;
suAceImg = suAceImg | aceImg > params.aceThreshHigh;

output = refineBorder(suAceImg, writingImg);

output = output > 0;

function [params] = parseInputs(varargin)

params = [];


if nargin >= 1
    params = varargin{1};
end


defaultParams.writingIdx = 2;
defaultParams.aceThreshLow = .1;
defaultParams.aceThreshHigh = .85;
% These are the su params for the msbin dataset:
% defaultParams.neighSize = 71;
% defaultParams.numNeighbors = 100;
% defaultParams = [];

if isfield(params, 'dbName') && strcmp(params.dbName, 'msbin')
    defaultParams.aceThreshLow = 0;
    defaultParams.aceThreshHigh = 0.45;    
end

params = mergeParams(defaultParams, params);



