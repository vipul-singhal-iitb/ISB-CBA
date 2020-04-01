# Required packages
library(tm)
library(wordcloud)
library(stringr)
library(ggplot2)


# Locate and load the data.
nytimesTrain = read.csv("NYTimesBlogTrain1.csv", stringsAsFactors=FALSE)


nytimesTrain$combcol=str_c(nytimesTrain$Headline,' ',nytimesTrain$Snippet,' ',nytimesTrain$Abstract)
nytimesTrainCorpus = Corpus(VectorSource(c(nytimesTrain$combcol)))

#summary(nytimesTrainCorpus)
inspect(nytimesTrainCorpus[1])

# Transforms
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, toSpace, "/|@|\\/")

nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, content_transformer(tolower))
nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, removeNumbers)
nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, removePunctuation)
nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, removeWords, stopwords("english"))
#nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, removeWords, c("own", "stop", "words"))
nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, stripWhitespace)

toString <- content_transformer(function(x, from, to) gsub(from, to, x))
#nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, toString, "specific transform", "ST")
#nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, toString, "other specific transform", "OST")

removeURL <- function(x) gsub("http[[:alnum:]]*", " ", x)
nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, removeURL)

nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, stemDocument)
nytimesTrainCorpus <- tm_map(nytimesTrainCorpus, PlainTextDocument)


# Document term matrix.
dtm <- DocumentTermMatrix(nytimesTrainCorpus)
dtm

sparse_dtm = removeSparseTerms(dtm, 0.99)
sparse_dtm

#inspect(dtm[1:5, 1000:1005])
# Explore the corpus.

findFreqTerms(sparse_dtm, lowfreq=100)
findAssocs(sparse_dtm, "fashion", corlimit=0.1)

freq <- sort(colSums(as.matrix(sparse_dtm)), decreasing=TRUE)
wf <- data.frame(word=names(freq), freq=freq)

# create a plot
p <- ggplot(subset(wf, freq>500), aes(word, freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

# Generate a word cloud
set.seed(142)
wordcloud(names(freq), freq, min.freq=50, colors=brewer.pal(6, "Dark2"))

