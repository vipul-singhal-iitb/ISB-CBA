setwd("c:\\workarea\\CBA2015")
install.packages(c('rpart','party'), repos = 'http://cran.rstudio.com/')
# Required packages
library(tm)
library(wordcloud)
library(stringr)
library(ggplot2)
library(SnowballC)
library(gbm)
library(nnet)
library(caret)
library(rpart)

nytimesDataset = read.csv("NYTimesBlogTrain1.csv", stringsAsFactors=FALSE)

nytimesDataset$combcol=str_c(nytimesDataset$Headline,' ',nytimesDataset$Snippet,' ', nytimesDataset$Abstract)

nytimesCorpus = Corpus(VectorSource(c(nytimesDataset$combcol)))

nytimesCorpus = tm_map(nytimesCorpus, tolower)
nytimesCorpus = tm_map(nytimesCorpus, PlainTextDocument)
nytimesCorpus = tm_map(nytimesCorpus, removePunctuation)
nytimesCorpus = tm_map(nytimesCorpus, removeWords, stopwords("english"))
nytimesCorpus = tm_map(nytimesCorpus, stemDocument,language="english")
nytimesDatasetCorpus <- tm_map(nytimesCorpus, PlainTextDocument)

dtm = DocumentTermMatrix(nytimesCorpus)
dtm

sparse_dtm = removeSparseTerms(dtm, 0.98)
sparse_dtm

nytimes.df = as.data.frame(as.matrix(sparse_dtm))

colnames(nytimes.df) = make.names(colnames(nytimes.df), unique=TRUE )
colnames(nytimes.df)
nytimes.df$Popular = as.factor(nytimesDataset$Popular)
nytimes.df$NewsDesk=as.factor(nytimesDataset$NewsDesk)
nytimes.df$SectionName=as.factor(nytimesDataset$SectionName)
nytimes.df$SubsectionName=as.factor(nytimesDataset$SubsectionName)
nytimes.df$WordCount = nytimesDataset$WordCount
nytimes.df$Weekday = as.factor(nytimesDataset$Weekday)
nytimes.df$DayofMonth=as.factor(nytimesDataset$DayofMonth)
nytimes.df$Time=as.factor(nytimesDataset$Time)
nytimes.df$UniqueID = nytimesDataset$UniqueID 
nytimes.df$Popular
set.seed(1234)
inTrain = createDataPartition(nytimes.df$Popular, p = 2/3, list = FALSE)
nytimes.dfTrain = nytimes.df[inTrain,]
nytimes.dfTest =  nytimes.df[-inTrain,]
nytimes.dfTest
inTrain
nrow(nytimes.df)

nnet.nytimes <- nnet(Popular ~ .,data=nytimes.dfTrain,size=5, decay=0.1, maxit=1000)
nnet.nytimes.pred <- predict(nnet.nytimes,nytimes.dfTest,"class")
nnet.nytimes.pred1 <- predict(nnet.nytimes,nytimes.dfTest,"raw")

nnet.nytimes.result = data.frame(UniqueID = nytimes.dfTest$UniqueID,Predicted=nnet.nytimes.pred, Popular=nytimes.dfTest$Popular)
nnet.nytimes.result$CorrectPrediction <- 0
nnet.nytimes.result$CorrectPrediction[nnet.nytimes.result$Predicted == nnet.nytimes.result$Popular] <- 1
sum(nnet.nytimes.result$CorrectPrediction)/nrow(nnet.nytimes.result)

library(party)
ctree.nytimes <- ctree(Popular ~ .,data=nytimes.dfTrain)
ctree.nytimes.pred <- predict(ctree.nytimes,nytimes.dfTest,"class")
ctree.nytimes.result = data.frame(UniqueID = nytimes.dfTest$UniqueID,Predicted=ctree.nytimes.pred, Popular=nytimes.dfTest$Popular)
ctree.nytimes.result$CorrectPrediction <- 0
ctree.nytimes.result$CorrectPrediction[ctree.nytimes.result$Predicted == ctree.nytimes.result$Popular] <- 1
sum(ctree.nytimes.result$CorrectPrediction)/nrow(ctree.nytimes.result)

rpart.nytimes <- rpart(Popular ~ .,data=nytimes.dfTrain)
rpart.nytimes.pred <- predict(rpart.nytimes,nytimes.dfTest,"class")
rpart.nytimes.result = data.frame(UniqueID = nytimes.dfTest$UniqueID,Predicted=rpart.nytimes.pred, Popular=nytimes.dfTest$Popular)
rpart.nytimes.result$CorrectPrediction <- 0
rpart.nytimes.result$CorrectPrediction[rpart.nytimes.result$Predicted == rpart.nytimes.result$Popular] <- 1
sum(rpart.nytimes.result$CorrectPrediction)/nrow(rpart.nytimes.result)

cforest.nytimes <- cforest(Popular ~ .,data=nytimes.dfTrain)
cforest.nytimes.pred <- predict(cforest.nytimes,nytimes.dfTest,OOB = TRUE)
cforest.nytimes.result = data.frame(UniqueID = nytimes.dfTest$UniqueID, Predicted=cforest.nytimes.pred, Popular=nytimes.dfTest$Popular)
cforest.nytimes.result$CorrectPrediction <- 0
cforest.nytimes.result$CorrectPrediction[cforest.nytimes.result$Predicted == cforest.nytimes.result$Popular] <- 1
sum(cforest.nytimes.result$CorrectPrediction)/nrow(cforest.nytimes.result)


#write.csv(rpart.nytimes.result, "SubmissionNYTimesRPART.csv", row.names=FALSE)


# probability that Blog is Popular
sum(nytimes.dfTrain$Popular == 'Y')/nrow(nytimes.dfTrain)
sum(nytimes.dfTest$Popular == 'Y')/nrow(nytimes.dfTest)
nrow(nytimes.dfTest)
n <- nrow(nytimes.dfTest)
random.nytimes.pred <- character(n)
set.seed(12345)
u <- runif(n)

random.nytimes.pred[u<=0.167] <- "Y"
random.nytimes.pred[u>0.167 & u<=1] <- "N"
random.nytimes.pred = as.factor(random.nytimes.pred)
random.nytimes.result = data.frame(UniqueID = nytimes.dfTest$UniqueID,Predicted=random.nytimes.pred, Popular=nytimes.dfTest$Popular)
random.nytimes.result$CorrectPrediction <- 0
random.nytimes.result$CorrectPrediction[random.nytimes.result$Predicted == random.nytimes.result$Popular] <- 1
sum(random.nytimes.result$CorrectPrediction)/nrow(random.nytimes.result)

random.nytimes.result$CorrectPredictionY <- 0
random.nytimes.result$CorrectPredictionY[random.nytimes.result$Predicted == random.nytimes.result$Popular & random.nytimes.result$Popular == 'Y' ] <- 1
sum(random.nytimes.result$CorrectPredictionY)/sum(nytimes.dfTest$Popular == 'Y')

rpart.nytimes.result$CorrectPredictionY <- 0
rpart.nytimes.result$CorrectPredictionY[rpart.nytimes.result$Predicted == rpart.nytimes.result$Popular & rpart.nytimes.result$Popular == 'Y' ] <- 1
sum(rpart.nytimes.result$CorrectPredictionY)/sum(nytimes.dfTest$Popular == 'Y')
