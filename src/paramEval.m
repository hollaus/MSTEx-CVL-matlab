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
save(fullfile(tP, 'paramset.mat'), 'paramset')

for i = 1 : length(paramset)
    
    params = paramset{i};
%     Determine the current target sub folder:
    if (isfield(params, 'folderName'))
        tActP = fullfile(tP, params.folderName);
    else
        tActP = fullfile(tP, ['params_' num2str(i)]);
    end
    
    if isfolder(tActP)
%         error(['The target folder is existing. ' ...
%             'Execution is stopped to prevent overwritten images.']);
        warning('The target folder is existing.');
    else
        mkdir(tActP);
    end
    disp(['Evaluating params: ' num2str(i) ' / ' num2str(length(paramset))]);
    binarizeBatch(sP, tActP, params);
    
end
