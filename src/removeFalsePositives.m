function  cleanImg = removeFalsePositives(suImg, aceThresh)

neighSize = 21;
numSafeFGNeighbors = 1;

falsePositiveCandidate = (suImg - aceThresh) > 0;
safeFG = suImg .* aceThresh;
sumSafeFG = imfilter(safeFG, ones(neighSize), 'symmetric');

numSafeFG = falsePositiveCandidate .* sumSafeFG;

falsePositives = falsePositiveCandidate .* (numSafeFG < numSafeFGNeighbors);

cleanImg = (suImg - falsePositives) > 0;