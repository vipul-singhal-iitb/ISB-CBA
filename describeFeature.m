function featureDescriptor = describeFeature(featurePatch,algorithm)

   %%%%%%%%%% TO Do  %%%%%%%%%%%%%
    %The example code employ "hist", which is not an feature descriptor. It
    %just let you know how to obtain "featureDescriptor" in matlab platform.
    % Please remove this example code and rewrite your feather descriptor computing here.

% for ii = 1 : length(featurePatch)
%        featureDescriptor(ii).vector = hist(featurePatch(ii).patch(:),64);
%    end

   % get feature descriptor according to setting in config.ini
  featureTypeList = algorithm.feature;
  featureTypes= regexp(featureTypeList, ',', 'split');
  
  for type=featureTypes
      switch type{1}
          case 'sift' 
              patch = featurePatch.sift;
              [featureDescriptor.sift,featureDescriptor.sift_pos] = extract_sift(patch,algorithm);
              featureDescriptor.sift_sizeX = size(patch,2);
              featureDescriptor.sift_sizeY = size(patch,1);
          case 'surf'
              patch = featurePatch.surf;
              [featureDescriptor.surf,featureDescriptor.surf_pos] = extract_surf(patch,algorithm);
              featureDescriptor.surf_sizeX = size(patch,2);
              featureDescriptor.surf_sizeY = size(patch,1);
          case 'gist'
              patch = featurePatch.gist;
              [featureDescriptor.gist,featureDescriptor.gist_pos] = extract_gist(patch,algorithm);
              featureDescriptor.gist_sizeX = size(patch,2);
              featureDescriptor.gist_sizeY = size(patch,1);
      end
  end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end