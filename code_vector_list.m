function  code_vector_list(inputFile ,  outputFile , imgID,algorithm) 
  coding = getfield(fetchIniData('config.ini','section','coding'),'coding');
  load([inputFile,'\feature_descriptor\featureDescriptor_',num2str(imgID),'.mat'], 'featureDescriptor'); 
  load(['training\code_book\CodeBook_',coding.clustering,'.mat'],'CodeBook');
    % In this function, we calculate the code vector.
    % We use a code vector to represent an image.
   
    
    
   %%%%%%%%%% TO Do  %%%%%%%%%%%%%
    % You may represent each image by the histogram of these indices over codebook or use "sparse code + pooling". 
    % Following example code just let you know relathship between code vector and descriptors.
    % Please remove this example code and rewrite your code vector computing here. 
    
%      curCodeVector = zeros(size(CodeBook,2),1);
%      for uu = 1 : length(featureDescriptor)
%         curCodeVector  = curCodeVector  + abs(CodeBook'*featureDescriptor(uu).vector');
%      end
%      codeVector  =  curCodeVector/length(featureDescriptor); 
          
    codeVector = featureCoding(featureDescriptor,CodeBook,algorithm); 
   %%%%%%%%%% To Do  End %%%%%%%%%%
   save([outputFile,'\code_vector\codeVector_',num2str(imgID),'.mat'], 'codeVector'); 
   
end