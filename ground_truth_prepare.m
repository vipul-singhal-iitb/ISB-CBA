function groundTruth = ground_truth_prepare(readFile,outFile) 
eachClass = 40;
imgIndex = [1:eachClass,1:eachClass,1:eachClass,1:eachClass, 1:eachClass];
classID = [ones(1,eachClass), 2*ones(1,eachClass), 3*ones(1,eachClass), 4*ones(1,eachClass), 5*ones(1,eachClass)];
rt = randperm(eachClass*5);
groundTruth = zeros(1,200); 
for ii = 1 : eachClass*5
   Im = imread([readFile,'\images\',num2str(classID(rt(ii))),'\image_',MyNum2str(imgIndex(rt(ii)),4),'.jpg']);
   imwrite(Im,[outFile,'\img_',MyNum2str( ii ,4),'.jpg']);
   groundTruth(ii) = classID(rt(ii));
end