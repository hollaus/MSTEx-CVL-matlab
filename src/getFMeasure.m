function [f, recall, precision, nrm] = getFMeasure(result, gt)

tpImg = result .* gt;
fnImg = (gt - result) > 0;
fpImg = (result - gt) > 0;
tnImg = (~result .* ~gt);

tp = sum(tpImg(:));
fn = sum(fnImg(:));
fp = sum(fpImg(:));
tn = sum(tnImg(:));

recall = tp / (tp+fn);
precision = tp / (tp+fp);

f = 2*recall*precision / (recall + precision);

nrfn = fn/(fn+tp);
nrfp = fp/(fp+tn);

nrm = (nrfn+nrfp)/2;

% kappa = kappaindex(result(:), gt(:), 2);