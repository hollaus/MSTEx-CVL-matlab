function output = binarMS(data, width, height, varargin)

params = parseInputs(varargin{:});

writingImg = reshape(data(:, params.writingIdx), height, width);

b = suBinar(writingImg, params);
b = removeBackground(b);

fgIdx = find(b);
fgIdx = removeOutlier(data, fgIdx);

tmp = zeros(height, width);
tmp(fgIdx) = 1;
bgIdx = find(~tmp);

aceSig = getAceSig(data, fgIdx, bgIdx);
aceImg = reshape(aceSig, height, width); 

bp.rImg = aceImg;
bc = suBinar(writingImg, bp);

aceThresh = aceImg>graythresh(aceImg);

cleanImg = removeFalsePositives(b, aceThresh);

combinedSu = combineBinaryMasks(bc, cleanImg);
combinedSu = removeBackground(combinedSu);


suAceImg = combinedSu & aceImg > 0.1;
suAceImg = suAceImg | aceImg > 0.9;

output = refineBorder(suAceImg, writingImg);

output = output > 0;

function [params] = parseInputs(varargin)

params = [];


if nargin >= 1
    params = varargin{1};
end

% These are the su params for the msbin dataset:
defaultParams.writingIdx = 2;
defaultParams.neighSize = 71;
defaultParams.numNeighbors = 100;

params = mergeParams(defaultParams, params);



