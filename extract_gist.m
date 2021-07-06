function [features,pos] =  extract_gist(patch,algorithm)
   param.imageSize = [256 256];
   param.orientationsPerScale = [8 8 8 8];
   param.numberBlocks = 4;
   param.fc_prefilt = 4; 
   feature = LMgist(double(patch),'',param);
   features = feature';
%    features = features/norm(features,2);
   pos = 0;
end