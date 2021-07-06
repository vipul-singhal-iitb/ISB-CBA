function feature_extraction(filelist, outputFile, classID, imgID, imgPerClass,algorithm)
    
    % In this function, we read a training images and extract
    % feature on it. All those features is recorded in struct array 'featurePatch'. 
    % Each element of 'featurePatch' is a struct including only one menber:
    % This menber is "patch" which record extracting patch itself. 
   
   
    
   Im = im2double(imread(filelist{(classID-1)*imgPerClass+imgID,1}));
           
    featurePatch = extractPatch(Im,algorithm);
            
   
    save([outputFile,'\feature\featurePatch_',num2str(classID),'_',num2str(imgID),'.mat'],'featurePatch');
    
end