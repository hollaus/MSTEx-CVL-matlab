function cleanFGIdx = removeOutlier(data, fgIdx)

data = data(fgIdx,:);
medianData = median(data);
stdData = std(data);

diff = abs(data-repmat(medianData, size(data,1), 1));

fac = 1/3;
good = sum(diff > repmat(stdData*fac, size(diff,1), 1),2) <= ceil(size(data,2) / 2);

cleanFGIdx = fgIdx(good);