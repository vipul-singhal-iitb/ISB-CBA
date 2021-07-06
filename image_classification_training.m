function image_classification_training(filelist,algorithm)
  
   % The function name is corresponding to "System Outline and
   % Implementation Details" of project page. 
   
  disp('extraction computing begins......')
  
  if(strcmp(algorithm.extractFeat,'true')==1)
   for classID = 1 : 5   % five class.
       for imgID = 1 : 60 % training image number in each class.
          disp(['extraction: the ',num2str(imgID),' th image in class ', num2str(classID), ' is processing'])
          feature_extraction(filelist,'training',classID,imgID,60,algorithm);
          feature_description('training', 'training', classID, imgID,algorithm);
       end
   end
  end
    
   if(strcmp(algorithm.trainBook,'true')==1)
        codebook_computation();
   end
   
   disp('code vector computing begins......')
   for classID = 1 : 5
      parfor imgID = 1 : 60
        disp(['coding:  the ',num2str(imgID),' th image in class ', num2str(classID), ' is processing'])
        code_vector('training', 'training', classID, imgID,algorithm);
      end
   end
   
   
   %If you don't use SVM as classifier, you can ignore svm_learning
   %function and set 'is_SVM_used = false'
   if(strcmp(algorithm.svm,'true')==1)
    is_SVM_used = true;   
   else
       is_SVM_used = false;
   end
   svm_learning(is_SVM_used); 
   
   disp('Training phase is done!')
end 



  



























