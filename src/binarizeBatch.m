function binarizeBatch(srcPath, trgPath, varargin)

params = parseInputs(varargin{:});

ids = getUniqueFileIds(srcPath, params);

for i = 1 : length(ids)
    
    id = ids{i};
    params.id = id;
    fileNames = getFileList(srcPath, params);
    [data, width, height] = readMSImages(srcPath, fileNames);
    result = binarMS(data, width, height, params);
    
    trgName = fullfile(trgPath, [id params.ext]);
    imwrite(result, trgName);
    
end

function [params] = parseInputs(varargin)

params = [];


if nargin >= 1
    params = varargin{1};
end

defaultParams.ext = '.png';
% This is required for the msbin dataset
defaultParams.separator = '_';

params = mergeParams(defaultParams, params);


