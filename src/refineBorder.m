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