function  codebook_computation()
  disp('codebook computing begins......')
  descriptporMatrix = descriptpor_load();
  coding = getfield(fetchIniData('config.ini','section','coding'),'coding');
    % In this function, you calculate the codebook
    % the codebook is recorded using matrix "CodeBook"
    % All the descriptor is saved in "descriptporMatrix". Each column is a
    % descriptor.
    
    
    
    
   %%%%%%%%%% TO Do  %%%%%%%%%%%%%
    %The example code employs "random selection", which cannot get a
    %qualified codebook. It just let you know what is codebook matrix
    % Please remove this example code and rewrite your codebook computing code here.
%     codeNum = 1000; % you can change it by yourself.
%      CodeBook = zeros(size(descriptporMatrix,1),codeNum);
%     index = randperm(size(descriptporMatrix,2));
%     for ii = 1 : codeNum
%         CodeBook(:,ii) = descriptporMatrix(:, index(ii)) ;
%     end
    

%handle each feature descriptors
    if(isfield(descriptporMatrix,'sift'))
        fprintf('learning sift dictionaries..\n');
        CodeBook.sift=buildCodeBook(descriptporMatrix.sift,coding);
    end
    if(isfield(descriptporMatrix,'surf'))
        fprintf('learning surf dictionaries..\n');
        CodeBook.surf=buildCodeBook(descriptporMatrix.surf,coding);
    end
    if(isfield(descriptporMatrix,'surf'))
        fprintf('learning gist dictionaries..\n');
        CodeBook.surf=buildCodeBook(descriptporMatrix.gist,coding);
    end
   %%%%%%%%%% To Do  End %%%%%%%%%%
   
   save(['training\code_book\CodeBook_',coding.clustering,'.mat'],'CodeBook');
end


function  descriptporMatrix = descriptpor_load()
     %descriptporMatrix = matrix_inti();
     descriptporMatrix.numFeat = 0;
     kk = 0;
     for classID = 1 : 5
       for imgID = 1 : 60
         load(['training\feature_descriptor\featureDescriptor_',num2str(classID),'_',num2str(imgID),'.mat'], 'featureDescriptor');
%          for ii = 1 : length(featureDescriptor)
%              kk = kk + 1;
%             descriptporMatrix(:,kk) = featureDescriptor(ii).vector';
%          end
         
        % load all kind of features
        if(isfield(featureDescriptor,'sift'))
            if(isfield(descriptporMatrix,'sift')==0)
                descriptporMatrix.sift=[];
                descriptporMatrix.numFeat = descriptporMatrix.numFeat+1;
            end

            descriptporMatrix.sift=[descriptporMatrix.sift,featureDescriptor.sift];          
            
        end
        if(isfield(featureDescriptor,'surf'))
            if(isfield(descriptporMatrix,'surf')==0)
                descriptporMatrix.surf=[];
                descriptporMatrix.numFeat = descriptporMatrix.numFeat+1;
            end

            descriptporMatrix.surf=[descriptporMatrix.surf,featureDescriptor.surf];          
            
        end
       end
     end
end

function descriptporMatrix = matrix_inti()
     m = 0;
     for classID = 1 : 5
       for imgID = 1 : 60
         load(['training\feature_descriptor\featureDescriptor_',num2str(classID),'_',num2str(imgID),'.mat'], 'featureDescriptor');
         m = m + length(featureDescriptor);
       end
     end
     n = length(featureDescriptor(1).vector);
     descriptporMatrix = zeros(n,m);
end



