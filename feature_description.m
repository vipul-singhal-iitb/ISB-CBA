function  feature_description(inputFile, outputFile, classID, imgID,algorithm)
   
   load([inputFile,'\feature\featurePatch_',num2str(classID),'_',num2str(imgID),'.mat'],'featurePatch');
    % In this function, we calculate the feature descriptor using your
    % extracted patch.
    % Each element of 'featureDescriptor' is a struct with one menbers: 
    % The menber is "vector" which records descriptor. 
    
    featureDescriptor = describeFeature(featurePatch,algorithm);
    
  save([outputFile,'\feature_descriptor\featureDescriptor_',num2str(classID),'_',num2str(imgID),'.mat'], 'featureDescriptor');
    
end