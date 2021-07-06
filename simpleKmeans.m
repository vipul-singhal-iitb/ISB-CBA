function [index, centroid,RSS] = simpleKmeans(dataset,nCluster, maxIter, distFuncHandle,thresh)
nPoints = size(dataset,1);
nLength = size(dataset,2);

%% gererate intial centroid
initialIdx = randi(nPoints,nCluster,1);
centroid = dataset(initialIdx,:);
pre_centroid = centroid;
if(distFuncHandle == 0)
    handle = @euclideanDist;
else
    handle = distFuncHandle;
end
%% iteration
index = zeros(nPoints,1);
pre_RSS = sum((max(dataset)-min(dataset)).^2)*nPoints;

for iteration = 1:maxIter
    %step 1, Assignment-step
    parfor iPoint = 1:nPoints
        dist = handle(dataset(iPoint,:),centroid);
        [none,id] = min(dist);
        index(iPoint) = id(1);
    end
    
    %step 2, Update-Step
    for iCluster = 1:nCluster
        clusterPnts = dataset(index == iCluster,:);
        if size(clusterPnts,1) == 0
            %the cluster has lost its all member
            newCIndex = randi(nPoints,1);
            newCentroid = dataset(newCIndex,:);
            index(newCIndex) = iCluster;
            centroid(iCluster,:) = newCentroid;
            continue;
        end
        
        centroid(iCluster,:) = mean(clusterPnts,1);
        
        
    end
    RSS = sum(sum((centroid-pre_centroid).^2,2),1);
%     if pre_RSS/RSS<threshold
    if RSS<thresh
        break;
    else
        pre_RSS = RSS;
    end
    pre_centroid = centroid;
    fprintf(['Iteration ',num2str(iteration),' finished\n']);
end


end

function dist = euclideanDist(point,pointList)
% points = repmat(point,size(pointList,1),1);
distVec = bsxfun(@minus,pointList,point);
% dist = (sum((points-pointList).^2,2));
dist = sum(distVec.^2,2);
end