function classificationRes = image_classification_testing(filelist,algorithm)
% to run this code, the first thing you need to do, is to put all the
% testing images into one folder named "1"(that contains 40*5 images in all.)



 disp('code_vector computing begins......')
 
  classID = 1;
  parfor imgID = 1 : 200
     disp(['code vector: the ',num2str(imgID),' th image in class ', num2str(classID), ' is processing'])
      if(strcmp(algorithm.extractFeat,'true'))
        feature_extraction_list(filelist, 'testing', imgID,algorithm);
        feature_description_list('testing', 'testing', imgID,algorithm);
      end
     code_vector_list('testing', 'testing', imgID,algorithm);
  end
 
  classificationRes = testing(classID);
  save('accuracy\classificationRes.mat', 'classificationRes');
  
  disp('testing phase is done!')
end

function  classificationRes = testing(classIDread)
  
    % if you use kNN, you may need all codebook in learning step
    % "codeVectorAll" and its classID "classIDs"
    
    load([ 'training\code_vector\codeVector_',num2str(1),'_',num2str(1),'.mat'], 'codeVector');
    codeVectorAll = zeros(size(codeVector,1),300);
    classIDs = zeros(1,200);
    kk = 0;
     for classID = 1 : 5
       for imgID = 1 : 60
          load([ 'training\code_vector\codeVector_',num2str(classID),'_',num2str(imgID),'.mat'], 'codeVector');
          kk = kk + 1;
          codeVectorAll(:,kk) = codeVector;
          classIDs(kk) = classID;
       end
     end
     
   % if you use SVM, you may need all normal vector w, please load it
    load('training\SVM\model.mat','model')
   
     
  
  classificationRes = zeros(1,200);
  for imgID = 1 : 200
    load(['testing\code_vector\codeVector_',num2str(imgID),'.mat'], 'codeVector');
    classificationRes(imgID) = img_classifiction(codeVector,codeVectorAll,classIDs,model);
  end
  

end