function binaryImg = suBinar(img, varargin)

% Implementation of:
% Binarization of Historical Document Images Using the Local Maximum and Minimum
% - by: Bolan Su, Shijian Lu, Chew Lim Tan
% 
%  Copyright (C) 2014-2015 Fabian Hollaus <holl@caa.tuwien.ac.at>
%  Copyright (C) 2014-2015 Markus Diem <markus@nomacs.org>
%  Vienna University of Technology, Computer Vision Lab
%  This file is part of ViennaMS2.
% 
%  ViennaMS2 is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
% 
%  ViennaMS2 is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.


params = parseInputs(varargin{:});

if (size(img,3) == 3)
    img = rgb2gray(img);
end

img = im2double(img);

if ~isempty(params.rImg)

     rImg = params.rImg;
     rImg(rImg>1) = 1;
     rImg(rImg<0) = 0;
%      rt = rImg > graythresh(rImg);
     
%      conImgB = getConImgB(1-rImg, params);
     m = getMagImg(1-rImg);

     
%     Remove noise (usually it is located in the near of characters):
    cc = bwconncomp(m);
    stats = regionprops(cc, 'Area');
    idx = find([stats.Area] > params.noiseArea);
    binaryImg = ismember(labelmatrix(cc),idx);
    
%     Close small holes in characters:
    cc = bwconncomp(~binaryImg);
    stats = regionprops(cc, 'Area');
    idx = find([stats.Area] < params.holeArea);
    binaryImg2 = ismember(labelmatrix(cc),idx);
    binaryImg = binaryImg + binaryImg2;
    
    binaryImg = binaryImg > 0;     
     
    conImgB = imdilate(binaryImg, strel('disk',2));
       
else
    conImgB = getConImgB(img, params);
     
end

sumImg = imfilter(double(conImgB), ones(params.neighSize), 'replicate');
candidates = sumImg >= params.numNeighbors;



% Calculate the mean intensity of the high contrast pixels:
conIntensity = img .* conImgB;

conIntensitySum = imfilter(conIntensity, ones(params.neighSize), 'replicate');
conIntensityMean = conIntensitySum ./ sumImg;
conIntensityMean(sumImg == 0) = 1;

% Calculate the std of the intensity of the high contrast pixels:
% Based on
% http://en.wikipedia.org/wiki/Computational_formula_for_the_variance:

c1 = imfilter((conIntensity.^2), ones(params.neighSize), 'replicate') ./ sumImg;
c1(c1 == Inf) = 0;
c2 = conIntensitySum.^2 ./ sumImg.^2;
c2(c2 == Inf) = 0;

conIntensityStd = sqrt(max((c1 - c2),0));

% intensityCandidates = img <= conIntensityMean;

% This is the original equation found in the su paper:
intensityCandidates = (img <= (conIntensityMean - conIntensityStd /2));
binaryImg = logical(candidates .* intensityCandidates);

if (params.removeNoise)
   
%     Remove noise (usually it is located in the near of characters):
    cc = bwconncomp(binaryImg);
    stats = regionprops(cc, 'Area');
    idx = find([stats.Area] > params.noiseArea);
    binaryImg = ismember(labelmatrix(cc),idx);
    
%     Close small holes in characters:
    cc = bwconncomp(~binaryImg);
    stats = regionprops(cc, 'Area');
    idx = find([stats.Area] < params.holeArea);
    binaryImg2 = ismember(labelmatrix(cc),idx);
    binaryImg = binaryImg + binaryImg2;
    
    binaryImg = binaryImg > 0;
      
    
end

function conImgB = getConImgB(img, params)

maxImg = ordfilt2(img, params.conWinSize * params.conWinSize, true(params.conWinSize));
minImg = ordfilt2(img, 1, true(params.conWinSize), [], 'symmetric');

denominator = maxImg + minImg;
denominator(denominator == 0) = eps;
numerator = maxImg - minImg;

conImg = numerator ./ denominator;

% % TODO: replace this:
% conImg(1:5,:) = 0;
% conImg(:,1:5) = 0;
% conImg(end-5:end,:) = 0;
% conImg(:,end-5) = 0;

gt = graythresh(conImg(conImg < 1));

conImgB = conImg > gt;


function magImg = getMagImg(img)

gy = [-1 -1 -1; 0 0 0; 1 1 1];
gx = gy';
ix = imfilter(img, gx, 'replicate');
iy = imfilter(img, gy, 'replicate');

mag = sqrt(ix.*ix + iy.*iy);
mag = normimg(mag);

gt = graythresh(mag(mag<1));

magImg = mag > gt;
% magImg = mag > .05;



function [params] = parseInputs(varargin)

params = [];


if nargin >= 1
    params = varargin{1};
end


defaultParams.numNeighbors = 50;
defaultParams.neighSize = 11;
defaultParams.conWinSize = 9;
defaultParams.determineFG = 0;

defaultParams.removeNoise = 1;
defaultParams.noiseArea = 10;
defaultParams.holeArea = 10;

defaultParams.rImg = [];

params = mergeParams(defaultParams, params);

