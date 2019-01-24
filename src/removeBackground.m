function [bw] = removeBackground(img)

bg = imresize(im2double(img), 0.5, 'bicubic');
se = strel('disk', 15);
bg = imclose(bg, se);
bg = bg > 0.1;
bg = bwareaopen(bg, 400);
bg = imresize(bg, size(img), 'nearest');
bw = img&bg;