function fileList = getFileList(path, varargin)

params = parseInputs(varargin{:});

if (~isdir(path))
    disp([path ' is not a directory']);
    fileList = [];
    return;
end


if (nargin == 1)
    fileList = dir(path);
else 
    fileList = dir(fullfile(path, ['*' params.ext]));
end

isFile = ~[fileList.isdir];
fileList = {fileList(isFile).name};

if (~isempty(params.id))
    
    if (isempty(params.separator))
        id = ['^' params.id];
    else
        id = ['^' params.id params.separator];
    end
   
    idIdx = regexp(fileList, id);
    hasId = cellfun(@isempty, idIdx);
    hasId = ~hasId;
    fileList = fileList(hasId);
    
end

function params = parseInputs(varargin)


if nargin < 1
    params = [];
else
    params = varargin{1};
end

defaultParams.id = [];
defaultParams.ext = '.png';
defaultParams.separator = [];

params = mergeParams(defaultParams, params);