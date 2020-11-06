function paramEval(sP, tP, paramset)

sP = fullfile(sP);
tP = fullfile(tP);

% Check if the target folder is existing and create one otherwise:
if isfolder(tP)
    warning('The target root folder is existing.')
else
    mkdir(tP);
end

% Save the parameter set:
save(paramset, fullfile(tP, 'paramset.mat'))

for i = 1 : length(paramset)
    
    params = paramset{i};
%     Determine the current target sub folder:
    if (isfield(params, 'folderName'))
        tActP = fullfile(tP, params.folderName);
    else
        tActP = fullfile(tP, ['params_' num2str(i)]);
    end
    
    if isfolder(tActP)
        error(['The target folder is existing. ' ...
            'Execution is stopped to prevent overwritten images.']);
    else
        mkdir(tActP);
    end
    
    binarizeBatch(sP, tActP, params);
    
end
