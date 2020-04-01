function acc = accuracy_calcu()
  load('accuracy\classificationRes.mat','classificationRes');
  load('accuracy\groundTruth.mat','groundTruth');
  rate = sum(double(classificationRes(:)==groundTruth(:)))/200;
  disp(['Your accuracy rate is ',num2str(rate*100), ' %' ]);
  acc = num2str(rate*100);
end