clear

config = fetchIniData('config.ini','section','dataset');

nClass = str2num(config.dataset.nClass);


count = 1;
if(strcmp(config.dataset.training_dir,'')~=1)
    nImgPerClass=str2num(config.dataset.nImgPerClass_training);
    trPath = [config.dataset.training_dir,'/images/'];
    for iClass = 1:nClass
        classPath = [trPath,num2str(iClass),'/'];
        listing = dir(classPath);
        listing = listing(3:end);%discard '.' and '..'
        for fileNo = 1:nImgPerClass
            name = listing(fileNo).name;
            fullPath = [classPath,name];
            filelist_training(count,:)  = [{fullPath},{iClass},{fileNo}];
            count = count+1;
        end
    end
    save('training_list.mat','filelist_training');
end


clear filelist
count = 1;
if(strcmp(config.dataset.training_dir,'')~=1)
    nImgPerClass=str2num(config.dataset.nImgPerClass_testing);
    testPath = [config.dataset.testing_dir,'/images/'];
    for iClass = 1:nClass
        classPath = [testPath,num2str(iClass),'/'];
        listing = dir(classPath);
        listing = listing(3:end);%discard '.' and '..'
        for fileNo = 1:nImgPerClass
            name = listing(fileNo).name;
            fullPath = [classPath,name];
            filelist_testing(count,:)  = [{fullPath},{iClass},{fileNo}];
            count = count+1;
        end
        
    end
    save('testing_list.mat','filelist_testing');
end

if(strcmp(config.dataset.permutation,'true')==1)
    order = randperm(size(filelist_testing,1));
    filelist_perm = filelist_testing(order,:);
    groundTruth = cell2mat(filelist_perm(:,2));
    save('perm_list.mat','filelist_perm');
    save('accuracy/groundTruth.mat','groundTruth');
end