
# atatched mnist train data with 708 variables post removing collinear

library("MASS", lib.loc="C:/Program Files/R/R-3.2.0/library")
summary(mnist_train_new)

# LDA Models

mnist_train_1 <- mnist_train_new[,-1]
train.lda <- lda(label ~ .,data=mnist_train_1) # training model

train.lda$LD1
train.lda$counts

# predict LDA on train data

plda <- predict(object = train.lda,
                newdata = mnist_train_1[-1])

plda$x     
head(plda$x) # LD projections



dataset = data.frame(label = mnist_train_1[,"label"],
                     lda = plda$x) # dataset


write.table(dataset,file="mnist_lda_final.csv",sep=",",row.names=T)

           


#PCA on Mnist train data

mnist_train_scale <- as.data.frame(scale(mnist_train_new)) # standardise the variables


mnist_train.pca <- prcomp(mnist_train_1)

summary(mnist_train.pca)

mnist_train.pca$sdev

sum((mnist_train.pca$sdev)^2)


dataset_pca = data.frame(label = mnist_train_1[,"label"],
                     pca = mnist_train.pca$x) # dataset

write.table(dataset_pca,file="mnist_pca_final.csv",sep=",",row.names=F)


# Data Merge for pca and LDA

data_final<- data.frame(mnist_train_1,dataset[,-1],dataset_pca[,2:12])
write.table(data_final,file="mnist_model_final.csv",sep=",",row.names=F)

# Data sampling 1000

set.seed(12343)

data_sample_model<- data_final[sample(1:nrow(data_final), 500,
                                     replace=FALSE),]

data_sample_model1<- data_sample_model[,710:729]
data_sample_model1$label<- data_sample_model$label

write.table(data_sample_model1,file="mnist_model_sample.csv",sep=",",row.names=F)



data_sample_model3<- data_sample_model[,1:709]

write.table(data_sample_model2,file="mnist_model_sample_all.csv",sep=",",row.names=F)

# Data sample
set.seed(1234)
data_final_train<- data_final[sample(1:nrow(data_final), 25200,
                           replace=FALSE),]
write.table(data_final_train,file="mnist_model_final_train.csv",sep=",",row.names=F)

table(data_final$label)
data_final_test<- data_final[!data_final_train,]

table(data_final_train$label)
data_final_test<- data_final[sample(1:nrow(data_final), 16800,
                                     replace=FALSE),]
write.table(data_final_test,file="mnist_model_final_test.csv",sep=",",row.names=F)

# Logit Model

data_final_train1 <- subset(data_final_train, data_final_train$label==0 | data_final_train$label==1 )
data_final_test1 <- subset(data_final_test, data_final_test$label==0 | data_final_test$label==1 )


data_final_train$label <- factor(data_final_train$label)
logit_784_train<-data_final_train[,1:709]
summary(data_final_train)

m_logit_709 <- glm(label ~ ., data = data_final_train[,1:709], family = "binomial")

summary(m_logit_709)

confint(m_logit_709)

logit_LDA_train<-data.frame(label = data_final_train[,1],data_final_train[,710:718])

m_logit_LDA <- glm(label ~ ., data = logit_LDA_train, family = "binomial")

summary(m_logit_LDA)


m_logit_PCA <- glm(label ~ ., data = data.frame(label = data_final_train[,1],data_final_train[,719:727]), family = "binomial")

summary(m_logit_PCA)

confint(m_logit_LDA)

exp(coef(m_logit_LDA))

data_final_test$Label_LDA <- predict(m_logit_LDA,newdata=data_final_test[,710:718], type = "response")

head(data_final_test$Label_LDA)


m_logit_LDA1 <- glm(label ~ ., data = data.frame(label = data_final_train1[,1],data_final_train1[,710:718]), family = "binomial")

summary(m_logit_LDA1)



probsTest <- predict(m_logit_LDA1, data_final_test1, type = "response")
threshold <- 0.5
pred      <- factor( ifelse(probsTest[, 1] > threshold, 1, 0) )
pred      <- relevel(pred, "yes")   # you may or may not need this; I did
confusionMatrix(pred, test$response)

library(pROC)
probsTrain <- predict(tune, train, type = "prob")
rocCurve   <- roc(response = train$response,
                  predictor = probsTrain[, "yes"],
                  levels = rev(levels(train$response)))
plot(rocCurve, print.thres = "best")

# Naive Bayes


train<- data_final_train[,719:727]
test<- data_final_test[,719:727]

train$label<- data_final_train$label
test$label<- data_final_test$label

model <- naiveBayes(label ~ ., data = train, laplace = 3)
pred <- predict(model, test[,-10])

table(pred, test$label)

xTrain = train[,-10]
yTrain = train$label

xTest = test[,-10]
yTest = test$label

model = train(xTrain,yTrain,'nb',trControl=trainControl(method='cv',number=10))
prop.table(table(predict(model$finalModel,xTest)$class,yTest))


# KNN

mnist.training <- data_sample_model2[, 1:709]
mnist.test <- data_sample_model3[, 1:709]
mnist.traininglabels <- data_sample_model2[, 1]
mnist.testlabels <- data_sample_model3[, 1]

mnist_pred <- knn(train = mnist.training, test = mnist.test, cl = mnist.traininglabels, k=7)

mnist_pred

library(gmodels)

CrossTable(x = mnist.testlabels, y = mnist_pred, prop.chisq=FALSE)

