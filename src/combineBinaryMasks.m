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
