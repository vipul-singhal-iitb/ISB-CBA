function feature_extraction_list(filelist, outputFile, id,algorithm)
    
    % In this function, we read a training images and extract
    % feature on it. All those features is recorded in struct array 'featurePatch'. 
    % Each element of 'featurePatch' is a struct including only one menber:
    % This menber is "patch" which record extracting patch itself. 
   
   
    
   Im = im2double(imread(filelist{id,1}));
           
   featurePatch = extractPatch(Im,algorithm);
            
   
    save([outputFile,'\feature\featurePatch_',num2str(id),'.mat'],'featurePatch');
    
end