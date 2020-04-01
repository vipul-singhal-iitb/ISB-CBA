function codebook = buildCodeBook(data,coding)
    if(strcmp(coding.clustering,'kmeans')==1)
        %kmeans coding
        codebook = kmeansCodeBook(data,coding);
    end
    
    if(strcmp(coding.clustering,'sparse')==1)
        %kmeans coding
        codebook = learnSparseDiction(data,coding);
    end
    
end

function centroid = kmeansCodeBook(data,coding)
    cNum = str2num(coding.codeNum);
    options = statset('MaxIter',20,'Display','iter');
    nsp = size(data,2);
    ord = randperm(nsp,ceil(nsp/str2num(coding.downsample)));%down sampling to 1/5 samples
    data_d = data(:,ord);
    [~,centroid] = kmeans(data_d',cNum,'emptyaction','singleton','onlinephase','off','options',options);
%     [~,centroid,~] = simpleKmeans(data,cNum,15,0,1e-4);
%     [centroid,~]=vl_kmeans(data, cNum, 'verbose',  'algorithm','elkan');
    centroid = centroid';
end

function diction = learnSparseDiction(data,coding)
    param.K=str2num(coding.codeNum);  % learns a dictionary with 100 elements
    param.lambda=0.15;
    param.numThreads=5; % number of threads
    param.iter=50;
    nsp = size(data,2);
    ord = randperm(nsp,ceil(nsp/str2num(coding.downsample)));%down sampling to 1/5 samples
    data_d = data(:,ord);
    diction = mexTrainDL(data_d,param);
%     notifyMe;
end