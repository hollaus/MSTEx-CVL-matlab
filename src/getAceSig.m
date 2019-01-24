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