function [f, fileNames, r, p, nrm] = folderFMeasureMSBin(imgPath, gtPath, varargin)

params = parseInputs(varargin{:});

gtImgs = getFileList(gtPath);

f = zeros(length(gtImgs),1);
r = f;
p = f;
nrm = f;

fileNames = gtImgs;

for i = 1 : length(gtImgs)
   
    gtName = gtImgs{i};
    gtImg = imread(fullfile(gtPath, gtName));
    
    img = im2double(imread(fullfile(imgPath, gtName)));

    if (params.excludeRegions)
        notAnnotated = gtImg(:,:,3) == 255;
    else
        notAnnotated = zeros(size(gtImg));
    end
    
    if (size(img,3) == 3)
        [f(i), r(i), p(i), nrm(i)] = getFMeasure(...
            (img(:,:,params.channelNum) == 1) .* ~notAnnotated, ...
            gtImg(:,:,params.channelNum) == 255);
    else
        [f(i), r(i), p(i), nrm(i)] = getFMeasure(img>0 .* ~notAnnotated, ...
            gtImg(:,:,params.channelNum) == 255);
    end
    
end

nonNanIdx = ~isnan(f);
disp(' % ===============================================================================================================');
disp(' % ');
disp([' % ' imgPath]);
disp([' % F: ' num2str(mean(f(nonNanIdx))) ' R: ' ...
    num2str(mean(r(nonNanIdx))) ' P: ' num2str(mean(p(nonNanIdx)))])
disp([' % F: ' num2str(f')]);
disp(' % ');
% f = f';
fileNames = fileNames';


function params = parseInputs(varargin)


if nargin < 1
    params = [];
else
    params = varargin{1};
end

% This is the channel number in which the writing is - for MSBin the
% main writing is colored green.
defaultParams.channelNum = 2;
defaultParams.excludeRegions = 1;
defaultParams.notAnnotatedChannelNum = 3;

params = mergeParams(defaultParams, params);