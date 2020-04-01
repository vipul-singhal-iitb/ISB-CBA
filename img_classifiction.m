function Res = img_classifiction(codeVector,codeVectorAll,classIDs,model)
 
   % if you use kNN, you may need all codebook in learning step
   % "codeVectorAll" and its class ID "classIDs"
   % For example, codeVectorAll(:,i) is i^{th} learnt code vector, and
   % classIDs(i) indicates its class.
   % if you use SVM, you need normal vector w 



    %%%%%%%%%% TO Do  %%%%%%%%%%%%%
    % The input codeVector represent an testing image. We should classify
    % this image. Using [codeVectorAll,classIDs] or [w] depends the
    % classifier you used
    % Please remove this example code and rewrite your testing code, here.
   
    
    [id,~,~] = predict(1,codeVector',model,'-q');
% 	id = svmpredict(1,codeVector',model,'-q');
    Res = id;
   %%%%%%%%%% To Do  End %%%%%%%%%%
   
end