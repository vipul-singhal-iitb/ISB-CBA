setwd("c:\\workarea\\CBA2015")
library(rpart)
## Variables 
## A1	binary		L-1 is one of	trail | strong | nylon | tow | safety | shroud | anchor | exercise | rope
## A2	binary		L-1 is one of	fine | racial | class | thin | bright | legal | regional | political | partisan | ethic | draw | clear
## A3	binary		L-1 is one of	long | checkout | straight
## A4	binary		L-1 is one of	telephone | access | direct | gab | customer | open | subscriber | free | complaint | chat | private | phone | subscribe
## A5	binary		L-1 is one of	computer | car | products | ibm | product | broad | minicomputer | broad | truck | model | care | vax | apparel | jeep | drug | cosmetics | sportswear | clothing | shoe
## A6	binary		L-1 is one of	open | famous | good | funny | every | cover | close
## A7	binary		L+1 is one of	increase | charge | open | busy | grow
## A8	binary		L+1 is one of	extension | include | last
## A9	binary		L+1 is	between		
## A10	binary		L-1 or L-2 or L-3 or L-4 is one of	toll-* | direct | phone | subscribe

#wsdDataset = read.csv("wsd_dataset.csv", stringsAsFactors=FALSE)

wsdDataset = read.csv("wsd_dataset.csv");

## Get the number of input examples
num.wsdDataset <- nrow(wsdDataset)

## Set the number of training examples = 90% of all examples
num.wsdDataset.train <- round(0.9 * num.wsdDataset)

## Set the number of test examples = 10% of all examples
num.wsdDataset.test <- num.wsdDataset - num.wsdDataset.train

## Check the numbers
num.wsdDataset
num.wsdDataset.train
num.wsdDataset.test

## Randomly split examples into training and test data using sample()
## Use set.seed() to be able to reconstruct the experiment with the SAME training and test sets
set.seed(123)
s <- sample(num.wsdDataset) 

### Get the training set
## First, generate indices of training examples
indices.train <- s[1:num.wsdDataset.train]

## Second, get the training examples
wsdDataset.dfTrain <- wsdDataset[indices.train,]

### Get the test set 
indices.test <- s[(num.wsdDataset.train+1):num.wsdDataset]
wsdDataset.dfTest <- wsdDataset[indices.test,]


rpart.wsdDataset <- rpart(SENSE ~ A1+A2+A3+A4+A5+A6+A7+A8+A9+A10+A11, 
			data = wsdDataset.dfTrain, method="class")
rpart.wsdDataset.pred <- predict(rpart.wsdDataset,wsdDataset.dfTest,"class")
rpart.wsdDataset.result = data.frame(Predicted=rpart.wsdDataset.pred, SENSE=wsdDataset.dfTest$SENSE)
rpart.wsdDataset.result$CorrectPrediction <- 0
rpart.wsdDataset.result$CorrectPrediction[rpart.wsdDataset.result$Predicted == rpart.wsdDataset.result$SENSE] <- 1
sum(rpart.wsdDataset.result$CorrectPrediction)/nrow(rpart.wsdDataset.result)

