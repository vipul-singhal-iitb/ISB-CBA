function codeVector = histogramCode(codeVectorList,featureDescriptor, featureName, algorithm);
isPooling = strcmp(algorithm.pooling,'true');
isPyramid = strcmp(algorithm.spatialPyramid,'true');
if(isPyramid)
    nLevel = str2num(algorithm.pyramidLevel);
else
    nLevel = 1;
end

levels = power(2,(1:nLevel)-1);
weight = power(2,(-1)*(nLevel:-1:1));
sizeField_X = [featureName,'_sizeX'];
sizeField_Y = [featureName,'_sizeY'];
posField = [featureName,'_pos'];

size_X = featureDescriptor.(sizeField_X);
size_Y = featureDescriptor.(sizeField_Y);

steps_X = size_X./levels;
steps_Y = size_Y./levels;

positions = featureDescriptor.(posField);

nFeature = size(codeVectorList,2);

cNum = size(codeVectorList,1);

cbin = 0;

for level =1:nLevel
    step_X = steps_X(level);
    step_Y = steps_Y(level);
    xBins = ceil(positions(1,:)/step_X);
    yBins = ceil(positions(2,:)/step_Y);
    idBins = (yBins-1)*(levels(level))+xBins;
    
    nBins = levels(level)^2;
    if(isPooling)
        for iBin = 1:nBins
            cbin = cbin+1;
            indices = find(idBins == iBin);
            if(numel(indices)==0)
                codeVector(:,cbin) = zeros(size(codeVectorList,1),1);
                continue;
            end
            codeVector(:,cbin) = max(codeVectorList(:,indices),[],2).*weight(level);
        end

    else
        for iBin = 1:nBins
            cbin = cbin+1;
            indices = find(idBins == iBin);
            if(numel(indices)==0)
                codeVector(:,cbin) = zeros(size(codeVectorList,1),1);
                continue;
            end
            codeVector(:,cbin) = sum(codeVectorList(:,indices),2).*weight(level);
        end
    end
    
    

end
    codeVector = codeVector(:);
    if(isPooling)
        codeVector = codeVector./norm(codeVector,2);
    else
        codeVector = codeVector./norm(codeVector,1);
    end

end
