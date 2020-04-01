function featurePatch = extractPatch(image,algorithm)

%%%%%%%%%% TO Do  %%%%%%%%%%%%%
 % You are required extract the features patch in image 'Im'
 % To make requirement clearly, we just give you an example of random extraction, it is a baseline method.
 % Please remove those example code and rewrite your more power extraction code here. 
 % You can use spatial pyramid matching, which can improve your preformance
 % significantly.
%    [n,m,cch] = size(image);
%    Img = rgb2gray(repmat(image,[1,1,4-cch])); % this is standard color to gray. 
%    kk = 0;
%    extractNum = 10;  %
%     for iter = 1 : extractNum
%          kk = kk + 1;        
%          xs  = min(max(round(rand(1)*(n-16)),1),n-15); % patch size is 16 x 16, you can chose another patch size
%          ys =  min(max(round(rand(1)*(m-16)),1),m-15);
%          featurePatch(kk).patch = Img(xs : xs+15 , ys : ys+15);     % record the patch feature.
%     end
  featureTypeList = algorithm.feature;
  featureTypes= regexp(featureTypeList, ',', 'split');
  for type=featureTypes
      switch type{1}
          case 'sift' 
              [n,m,cch] = size(image);
              Img = rgb2gray(repmat(image,[1,1,4-cch])); % this is standard color to gray. 
              featurePatch.sift=Img;
          case 'surf'
              [n,m,cch] = size(image);
              Img = rgb2gray(repmat(image,[1,1,4-cch])); % this is standard color to gray. 
              featurePatch.surf=Img;
          case 'gist'
              [n,m,cch] = size(image);
              Img = rgb2gray(repmat(image,[1,1,4-cch])); % this is standard color to gray. 
              featurePatch.gist=Img;
      end
  end
  %%%%%%%%%% To Do  End %%%%%%%%%%
end