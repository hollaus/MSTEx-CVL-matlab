function  cleanImg = removeFalsePositives(suImg, aceThresh, varargin)

params = parseInputs(varargin{:});

% neighSize = 21;
% numSafeFGNeighbors = 1;

falsePositiveCandidate = (suImg - aceThresh) > 0;
safeFG = suImg .* aceThresh;
sumSafeFG = imfilter(safeFG, ones(params.rPNeighSize), 'symmetric');

numSafeFG = falsePositiveCandidate .* sumSafeFG;

falsePositives = falsePositiveCandidate .* (numSafeFG < params.numSafeFGNeighbors);

cleanImg = (suImg - falsePositives) > 0;

function [params] = parseInputs(varargin)

params = [];


if nargin >= 1
    params = varargin{1};
end

defaultParams.rPNeighSize = 21;
defaultParams.numSafeFGNeighbors = 1;

defaultParams.rImg = [];

params = mergeParams(defaultParams, params);
