function uniqueIds = getUniqueFileIds(pathName, varargin)

params = parseInputs(varargin{:});

fileNames = getFileList(pathName, params);

% Get the unique fileNames:
sepIdx = strfind(fileNames, params.separator);

ids = fileNames;
for i = 1 : length(fileNames)
    
    if (isempty(sepIdx{i}))
        continue;
    end
    
    actSepIdx = sepIdx{i};
   
    f = fileNames{i};
    ids{i} = f(1:actSepIdx-1);
    
end

uniqueIds = unique(ids);


function params = parseInputs(varargin)

if nargin < 1
    params = [];
else
    params = varargin{1};
end

defaultParams.ext = '.png';
defaultParams.separator = '_';

params = mergeParams(defaultParams, params);