# Attached Mushroom Data


hist(mushroom$V2)


# run summary statistics
summary(mushroom)

# remove variable # 11 stalk‐rootwith missing 2480 values

mushroom1<-mushroom[,-12]

# remove variable # 16 veil‐type one type of value partial

mushroom1<-mushroom1[,-16]

# Data sample

smp_size <- floor(0.6 * nrow(mushroom1))

set.seed(1234)
train_ind <- sample(seq_len(nrow(mushroom1)), size = smp_size)
mushroom_train <- mushroom1[train_ind, ]
mushroom_test <- mushroom1[-train_ind, ]

write.table(mushroom_train,file="mushroom_train.csv",sep=",",row.names=F)
write.table(mushroom_test,file="mushroom_test.csv",sep=",",row.names=F)

library('ElemStatLearn')
library("klaR")
library("caret")

summary(mushroom)


model <- naiveBayes(V1 ~ ., data = mushroom_train) 

pred <-predict(model, mushroom_test[,-1]) 
pred1 <-predict(model, mushroom_test[,-1], type = "raw") 

tab <- table(pred, mushroom_test$V1) 
tab
sum(tab[row(tab)==col(tab)])/sum(tab)

# Result:   Confusion Matrix  
# pred    e    p
# e     1721  170
# p       6   1353
# [1] 0.9458462  -- Accuracy

#Decision Tree

myFormula <- V1 ~ factor(V6) + factor(V21) + factor(V10) +factor(V20) +factor(V13) +factor(V14) +factor(V15) +factor(V16) +factor(V9) +factor(V22) 
mushroom_ctree <- ctree(myFormula, data = mushroom_train)

table(predict(mushroom_ctree), mushroom_train$V1)
print(mushroom_ctree)
plot(mushroom_ctree)
plot(mushroom_ctree, type="simple")
testPred <- predict(mushroom_ctree, newdata = mushroom_test)
table(testPred, mushroom_test$V1)
library(ggvis)
library(class)

library(FSelector)
weights <- information.gain(V1~., mushroom)
print(weights)


