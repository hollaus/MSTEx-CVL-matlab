function [data, width, height] = readMSImages(folderName, fileNames)

img = imread(fullfile(folderName, fileNames{1}));
img = im2double(img);

[height, width] = size(img);

numChannels = length(fileNames);
numPixels = height * width;
data = zeros(numPixels, numChannels);

for i = 1 : numChannels
   
    if (i > 1)
       img = imread(fullfile(folderName, fileNames{i}));
       img = im2double(img);
%        TODO: check if normalization should be used:
%         img = img-min(img(:));
%         img = img./max(img(:));
    end
    data(:,i) = reshape(img, numPixels, 1);
    
end
