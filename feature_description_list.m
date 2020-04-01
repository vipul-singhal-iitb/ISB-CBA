function  feature_description_list(inputFile,outputFile,id,algorithm)
   
   load([inputFile,'\feature\featurePatch_',num2str(id),'.mat'],'featurePatch');
    % In this function, we calculate the feature descriptor using your
    % extracted patch.
    % Each element of 'featureDescriptor' is a struct with one menbers: 
    % The menber is "vector" which records descriptor. 
    
   %%%%%%%%%% TO Do  %%%%%%%%%%%%%
    %The example code employ "hist", which is not an feature descriptor. It
    %just let you know how to obtain "featureDescriptor" in matlab platform.
    % Please remove this example code and rewrite your feather descriptor computing here.
    
%    for ii = 1 : length(featurePatch)
%        featureDescriptor(ii).vector = hist(featurePatch(ii).patch(:),64);
%    end
   featureDescriptor = describeFeature(featurePatch,algorithm);
   %%%%%%%%%% To Do  End %%%%%%%%%%
    
  save([outputFile,'\feature_descriptor\featureDescriptor_',num2str(id),'.mat'], 'featureDescriptor');
    
end