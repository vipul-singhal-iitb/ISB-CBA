install.packages(c('bit64','caret','dplyr','e1071','gbm','ggplot2','httr','plyr','qdap','qdapDictionaries','RColorBrewer','RCurl','rjson','RTextTools','RWeka','scales','SnowballC','stringr','tm','topicmodels','twitteR','XML'), repos = 'http://cran.rstudio.com/')


setwd("D:\\Stuff\\ISB\\ISB Course Material\\Term 3\\text\\Textanalytics")
# Required packages
library(tm)
library(wordcloud)
library(stringr)
library(ggplot2)
library(SnowballC)


# Locate and load the data.
examplesCSV = read.csv("examples.csv", stringsAsFactors=FALSE)

# example tm_map functions

getTransformations()

stopwords("english")

# Create Corpus
examplesCorpus = Corpus(VectorSource(c(examplesCSV$Text)))


examplesCorpus <- tm_map(examplesCorpus, tolower)
inspect(examplesCorpus)

examplesCorpus <- tm_map(examplesCorpus, removeNumbers)
inspect(examplesCorpus)

examplesCorpus <- tm_map(examplesCorpus, removePunctuation)
inspect(examplesCorpus)

examplesCorpus <- tm_map(examplesCorpus, removeWords, stopwords("english"))
inspect(examplesCorpus)

#Custom  list  stopwords
c("go","to")
examplesCorpus <- tm_map(examplesCorpus, removeWords, c("go"))

inspect(examplesCorpus)


examplesCorpus <- tm_map(examplesCorpus, removeWords, c("presentations"))
inspect(examplesCorpus)

removeURL <- function(x) gsub("http[[:alnum:]]*", " ", x)
examplesCorpus <- tm_map(examplesCorpus, removeURL)
inspect(examplesCorpus)

examplesCorpus <- tm_map(examplesCorpus, PlainTextDocument)
examplesCorpus <- tm_map(examplesCorpus, stemDocument, language="english")
examplesCorpus <- tm_map(examplesCorpus, tolower)
inspect(examplesCorpus)

