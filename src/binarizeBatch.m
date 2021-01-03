function binarizeBatch(srcPath, trgPath, varargin)

params = parseInputs(varargin{:});

ids = getUniqueFileIds(srcPath, params);

for i = 1 : length(ids)
    
    id = ids{i};
    
    if strcmp(params.dbName, 'mstex')
        msPath = fullfile(srcPath, id);
    elseif strcmp(params.dbName, 'msbin')
        params.numNeighbors = 71;
        params.neighSize = 150;
        params.noiseArea = 50;
%         params.aceThreshLow = 0;
%         params.aceThreshHigh = 0.4;
%         params.neighSize = 51;
%         params.noiseArea = ;
        params.removeNoise = 1;
        params.id = id;
        msPath = fullfile(srcPath);
    end
    
    fileNames = getFileList(msPath, params);
    
    [data, width, height] = readMSImages(msPath, fileNames);
    result = binarMS(data, width, height, params);
    result = ~result;
    trgName = fullfile(trgPath, [id params.ext]);
    imwrite(result, trgName);
    
end

function [params] = parseInputs(varargin)

params = [];


if nargin >= 1
    params = varargin{1};
end

defaultParams.ext = '.png';
defaultParams.dbName = 'mstex';
% This is required for the msbin dataset
defaultParams.separator = '_';

params = mergeParams(defaultParams, params);


