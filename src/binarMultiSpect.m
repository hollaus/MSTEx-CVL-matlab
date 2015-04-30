function binarMultiSpect(folderName, outputImgName)

%BINARMULTISPECT Applies document binarization on multispectral images.
% BINARMULTISPECT reads the images contained in a folder folderName and 
% writes the resulting image outputImgName.
% The folder should contain 8 image files (FXXs.png) where XX is the
% channel number.
% 
% Submission for MS-TEx competition
% Authors: Fabian Hollaus, Markus Diem and Robert Sablatnig
% Computer Vision Lab, Vienna University of Technology
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

[data, width, height] = readMultiSpect(folderName);

writingImg = reshape(data(:,2), height, width);

b = suBinar(writingImg);
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

try
    imwrite(output, outputImgName);
catch
    error(['Sorry I could not write to : ' outputImgName]);
end


function  cleanImg = removeFalsePositives(suImg, aceThresh)

neighSize = 21;
numSafeFGNeighbors = 1;

falsePositiveCandidate = (suImg - aceThresh) > 0;
safeFG = suImg .* aceThresh;
sumSafeFG = imfilter(safeFG, ones(neighSize), 'symmetric');

numSafeFG = falsePositiveCandidate .* sumSafeFG;

falsePositives = falsePositiveCandidate .* (numSafeFG < numSafeFGNeighbors);

cleanImg = (suImg - falsePositives) > 0;


function aceSig = getAceSig(data, fgIdx, bgIdx)


meanBg = mean(data(bgIdx,:));
meanFg = mean(data(fgIdx,:));

t = (meanFg - meanBg)';

dataMR = data;
dataMR = dataMR - repmat(meanBg, size(data,1), 1);

C = cov(dataMR(bgIdx,:));
Cinv = pinv(C);

aceSig = (dataMR * Cinv * t) .* abs(dataMR * Cinv * t) ./ ((t' * Cinv * t) * sum((dataMR * Cinv) .* dataMR, 2));
aceSig(aceSig<0) = 0;
aceSig(aceSig>1) = 1;

function bw = refineBorder(bw, img)

% add 1px to permeter
se = strel('disk', 1);
bwd = imdilate(bw, se);
% se = strel('disk', 1);
% bwo = imerode(bwo, se);
bwd = bwd&~bw;  % select border

% remove 1px to permeter
se = strel('disk', 1);
bwe = imerode(bw, se);
bwe = bw&~bwe;  % select border
peri = bwe | bwd;

img(~peri) = 0.5;    % other pixels schould not influence normalization
img = normimg(img);
img(~peri) = 0.5;    % ignore all other pixels

bw = bw | img < 0.5;

function cleanFGIdx = removeOutlier(data, fgIdx)

data = data(fgIdx,:);
medianData = median(data);
stdData = std(data);

diff = abs(data-repmat(medianData, size(data,1), 1));

fac = 1/3;
good = sum(diff > repmat(stdData*fac, size(diff,1), 1),2) <= 4;

cleanFGIdx = fgIdx(good);

function combined = combineBinaryMasks(bSoft, bHard)
% Combines two binary images in such a way that only fg regions of the
% bSoft are connected to bHard remain in the result.
% 
% bSoft = bSoft + bHard;

lSoft = bwlabel(bSoft);
lHard = lSoft .* bHard;

badIdx = setdiff(unique(lSoft),unique(lHard));

badMask = ismember(lSoft, badIdx);

combined = bSoft .* ~badMask;

b = bwmorph(combined, 'skel','Inf');
missingLinks = b-b.*bHard > 0;
missingLinksDil = imdilate(missingLinks, strel('disk',3));
missingLinksMask = missingLinksDil.*bSoft;

combined = bHard+missingLinksMask;


function [bw] = removeBackground(img)

bg = imresize(im2double(img), 0.5, 'bicubic');
se = strel('disk', 15);
bg = imclose(bg, se);
bg = bg > 0.1;
bg = bwareaopen(bg, 400);
bg = imresize(bg, size(img), 'nearest');
bw = img&bg;

function [data, width, height] = readMultiSpect(folderName)

fileNames = {'F1s.png', 'F2s.png', 'F3s.png', 'F4s.png', 'F5s.png', 'F6s.png', ...
    'F7s.png', 'F8s.png'};
% fileNames = {'F1n.png', 'F2n.png', 'F3n.png', 'F4n.png', 'F5n.png', 'F6n.png', ...
%     'F7n.png', 'F8n.png'};

img = readImg(folderName, fileNames{1});

[height, width] = size(img);

numChannels = length(fileNames);
numPixels = height * width;
data = zeros(numPixels, numChannels);

for i = 1 : numChannels
   
    if (i > 1)
       img = readImg(folderName, fileNames{i});
    end
    
    if (size(img,3)==3) 
        img = img(:,:,1);
    end
    
    data(:,i) = reshape(img, numPixels, 1);
    
end


function img = readImg(folderName, fileName)

fileName = fullfile(folderName, fileName);

try
    img = imread(fileName);
    img = im2double(img);
    img = img-min(img(:));
    img = img./max(img(:));
catch
    error(['Could not read file: ' fileName]);
end

