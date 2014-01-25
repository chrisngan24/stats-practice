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

train.tdm <- function(email.tdm){
    email.matrix <- as.matrix(email.tdm)
    email.counts <- rowSums(email.matrix)
    email.df <- data.frame(cbind(names(email.counts), as.numeric(email.counts)), stringsAsFactors=FALSE)
    names(email.df) <- c("term", "frequency")
    email.df$frequency <- as.numeric(email.df$frequency)
    email.occurence <- sapply(1:nrow(email.matrix),
        function(i){
            length(which(email.matrix[i,]>0))/ncol(email.matrix)
        })
    email.density <- email.df$frequency/sum(email.df$frequency)

    email.df <- transform(email.df, density = email.density, occurrence=email.occurence)   
    return(email.df)
}       

get.training.df <- function(path){
    #list all files in path
    email.docs <- dir(path)
    email.docs <- email.docs[which(email.docs!= 'cmds')]
    # apply the function of get.msg for each item in email.docs
    all.email <- sapply(email.docs, function(p) get.msg(paste(path, p, sep='')))
    email.tdm <- get.tdm(all.email)
    return(train.tdm(email.tdm)) 

}

ham.df <- get.training.df("data/easy_ham/")
spam.df <- get.training.df("data/spam_2/")

