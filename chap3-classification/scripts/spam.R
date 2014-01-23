library('tm')
library('ggplot2')


# get's message portion of email
get.msg <- function(path){
    con <- file(path, open="rt", encoding ="latin1")
    text <- readLines(con)
    # assumes that the message always has a blank line before message starts
    msg <- text[seq(which(text=="")[1]+1, length(text),1)]
    close(con)
    return(paste(msg, collapse="\n"))
}

# Generates a Term Document Matrix
get.tdm <- function(doc){
    corpus <- Corpus(VectorSource(doc))
    control <- list(
                stopwords=TRUE,  # ignores common words, run stopwords() to see what they are
                removePunctuation=TRUE,
                removeNumbers=TRUE,
                minDocFreq=2 # minimum number of times a word must appear
             )
    return(TermDocumentMatrix(corpus, control))
}

spam.path <- "data/easy_ham/"
#list all files in path
spam.docs <- dir(spam.path)
spam.docs <- spam.docs[which(spam.docs!= 'cmds')]
# apply the function of get.msg for each item in spam.docs
all.spam <- sapply(spam.docs, function(p) get.msg(paste(spam.path, p, sep='')))



spam.tdm <- get.tdm(all.spam)

