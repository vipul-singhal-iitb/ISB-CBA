% This is an code for image classification 
% It is used in CUHK course (CSCI5280, prof.Jia Jiaya ) 

clear
addpath(genpath('C:/Users/rmantri/Downloads/image_classification_XiongYuanjun/lib'));
buildFileList

load testing_list
load training_list
load perm_list

config = fetchIniData('config.ini','section','algorithm');
algorithm = config.algorithm;

image_classification_training(filelist_training,algorithm); % training step
image_classification_testing(filelist_perm,algorithm);  % testing step
acc = accuracy_calcu();                % accuraccy computing

notification_address = 'your_email@mail.com';
notifyMe(['Accuracy:' num2str(acc) '%'],notification_address);