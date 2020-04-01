#Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_45')
options(java.parameters = "- Xmx1024m")
library(rJava)
library(NLP)
library(openNLP)
library(openNLPmodels.en)
install.packages("openNLPmodels.en", repos = 'http://datacube.wu.ac.at/')

inputtext <- paste(c("Bill Gates (born October 28, 1955) is an American business magnate, philanthropist, investor, computer programmer, and inventor. Gates originally established his reputation as the co-founder of Microsoft Inc, the world?s largest PC software company, with Paul Allen. During his career at Microsoft, Gates held the positions of chairman, CEO and chief software architect, and was also the largest individual shareholder until May 2014. ",
	     " He stays in Seattle.\n",
             "Gate Foundation was founded by Bill and Melinda Gates. It was launched in 2000 and is said to be the largest operated private foundation in the world.\n"
	     ),
           collapse = "")
inputtext <- as.String(inputtext)

## Example for sentence and word annotations.
sentence_annotator <- Maxent_Sent_Token_Annotator()
word_annotator <- Maxent_Word_Token_Annotator()

pipeline <- list(sentence_annotator, word_annotator)

our_annotations <- annotate(inputtext, pipeline)

inputtext_doc <- AnnotatedPlainTextDocument(inputtext, our_annotations)

words(inputtext_doc)
sents(inputtext_doc)

### Now lets get Parts Of Speech

pos_tag_annotator <- Maxent_POS_Tag_Annotator()
pipeline <- list(sentence_annotator, word_annotator, pos_tag_annotator)
our_annotations <- annotate(inputtext, pipeline)
inputtext_doc <- AnnotatedPlainTextDocument(inputtext, our_annotations)

word_subset <- subset(our_annotations, type == "word")
tags <- sapply(word_subset$features, '[[', "POS")
sprintf("%s/%s", inputtext[word_subset], tags)

### Now lets get Entities from the input text
person_ann <- Maxent_Entity_Annotator(kind = "person")
location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")

pipeline <- list(sentence_annotator, word_annotator, person_ann, location_ann, organization_ann)
our_annotations <- annotate(inputtext, pipeline)
inputtext_doc <- AnnotatedPlainTextDocument(inputtext, our_annotations)

entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}

entities(inputtext_doc, "person")
entities(inputtext_doc, "organization")
entities(inputtext_doc, "location")

### How about actual sentence parser, that chunks meaningful information

parse_annotator <- Parse_Annotator()

inputtext <- paste(c(" Bill Gates stays in Seattle. "),
           collapse = "")
inputtext <- as.String(inputtext)
inputtext <- paste(c(" Bill will bill you for software "),
                   collapse = "")
inputtext <- as.String(inputtext)

a2 <- annotate(inputtext, pipeline )
## Compute the parse annotations only.
our_annotations<- parse_annotator(inputtext, a2)

## Extract the formatted parse trees.
ptexts <- sapply(our_annotations$features, `[[`, "parse")
#ptexts
## Read into NLP Tree objects.
ptrees <- lapply(ptexts, Tree_parse)
ptrees

