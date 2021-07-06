function codeVector = featureCoding(featureDescriptor,codeBook,algorithm)

featureTypeList = algorithm.feature;
featureTypes= regexp(featureTypeList, ',', 'split');

codeVector=[];
%code sift feature
for type=featureTypes
    ftName = type{1};
    if(strcmp(ftName,'gist')==1)
        codeVector = [codeVector;sparse(double(featureDescriptor.(ftName)))];
        continue;
    end
% if(isfield(featureDescriptor,'sift'))
    switch algorithm.([ftName,'_coder'])
        case 'nn' 
            algorithm.pooling='false';
            codeVectorList=nnCoding(featureDescriptor.(ftName),codeBook.(ftName));
        case 'knn'
            algorithm.pooling='true';
            codeVectorList=knnCoding(featureDescriptor.(ftName),codeBook.(ftName),str2num(algorithm.knn));
        case 'llc'
            algorithm.pooling='true';
            codeVectorList=llcCoding(featureDescriptor.(ftName),codeBook.(ftName),str2num(algorithm.knn));
        case 'sparse'
            algorithm.pooling='true';
            codeVectorList=L1Coding(featureDescriptor.(ftName),codeBook.(ftName),str2num(algorithm.knn));
            
    end
% 	if(strcmp(algorithm.pooling,'true')==1)
%         codeVector = codePooling(codeVectorList,algorithm)
% 	else
% 		%no pooling
% 		histo = sum(codeVectorList,2);
% 		codeVector = histo/sum(histo(:));
% 	end
    codeVector = [codeVector;histogramCode(codeVectorList,featureDescriptor, ftName, algorithm)];
end

% if(isfield(featureDescriptor,'surf'))
%     switch algorithm.surf_coder
%         case 'nn' 
%             algorithm.pooling='false';
%             codeVectorList=[codeVector,nnCoding(featureDescriptor.surf,codeBook.surf)];
%         case 'knn'
%             algorithm.pooling='true';
%             codeVectorList=[codeVector,knnCoding(featureDescriptor.surf,codeBook.surf,str2num(algorithm.knn))];
%         case 'llc'
%             algorithm.pooling='true';
%             codeVectorList=[codeVector,llcCoding(featureDescriptor.surf,codeBook.surf,str2num(algorithm.knn))];
%         case 'sparse'
%             algorithm.pooling='true';
%             codeVectorList=[codeVector,L1Coding(featureDescriptor.surf,codeBook.surf,str2num(algorithm.knn))];
%             
%     end
% % 	if(strcmp(algorithm.pooling,'true')==1)
% %         codeVector = codePooling(codeVectorList,algorithm)
% % 	else
% % 		%no pooling
% % 		histo = sum(codeVectorList,2);
% % 		codeVector = histo/sum(histo(:));
% % 	end
%     codeVector = histogramCode(codeVectorList,featureDescriptor, 'surf', algorithm);
% end

end

function codeVectorList = nnCoding(features,codeBook)
    nCode = size(codeBook,2);
    nObs = size(features,2);
    dist= pdist2(codeBook',features','euclidean');
    [~,I] = min(dist,[],1);
    I = I';
    
    codeVectorList = sparse(I,1:nObs,1,nCode,nObs,nObs);
end

function codeVectorList = knnCoding(features,codeBook,knn)
    nCode = size(codeBook,2);
    nObs = size(features,2);
    dist= pdist2(codeBook',features','euclidean');
    [s_dist,I] = sort(dist,1,'ascend');
    I_k = reshape(I(1:knn,:),knn*nObs,1);
    s_distK=reshape(s_dist(1:knn,:),knn*nObs,1);
    obid = 1:nObs;
    x = repmat(obid,knn,1);
    x = reshape(x,knn*nObs,1);
    s_distK = gaussianKernel(s_distK,500);
    codeVectorList = sparse(I_k,x,double(s_distK),nCode,nObs,nObs*knn);
    
end

function codeVectorList = llcCoding(features,codeBook,knn)
    codeVectorList = sparse(LLC_coding_appr(codeBook',features',knn)');
end

function similarity = gaussianKernel(dist,sigma)
    %gaussian kernel
    similarity = exp((-1)*(dist.^2)/2/(sigma^2));
end

function codeVectorList = L1Coding(features,codeBook,varargin)
    for i = 1:size(features,2)
        codeVectorList(:,i) = sparse(double(SolveHomotopy(codeBook,features(:,i),'stoppingCriterion', -2, ...
            'groundTruth', zeros(size(codeBook,2),1),'maxtime', 8, 'maxiteration', 1e3)));
    end
end