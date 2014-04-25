# Let's say we are interested in discovering the classification of alochol and the color. Group all the categories together(three in total) and gather the Color values. 
# Given the set of data, we notice that there are three classifications of alcohol- 1,2 and 3.  How are these results classified?  Let's utilize some basic statistics
# for this exercise. It will be done so by calculating the confidence interval for each category based on different columns.  Make it as versatile as possible


# Input:
#     df <- data frame input
#     column     <- String of column that holds the category
# Output:
#     returns <- a vector of data frames accessed by index
get.categories <- function(df, category.column){
  return(split(df, df[category.column]))
}

# Input:
#     data.vector.list <- index item within a vector
#     column <- column label of interest
# Output:
#     return <- a list of values that correspond with the category requested
get.column.category <- function(data.vector.list,index, column){
  # convert index item of vector into dataframe for bulk computations
  df <- data.frame(data.vector.list)
  label <- paste("X",as.character(index), ".", column, sep="")
  print(label)
  print(summary(df[[label]]))
  return(df[[label]])
}

# Input:
#     data.list <- list of values where confidence interval is to be calculated
# Output:
#     return <- nothing
get.confidence.interval <- function(data.list){
  # calculate sample mean, size and standard deviation
  avg <- mean(data.list)
  stdev <- sd(data.list) 
  num <- length(data.list)

  # Calculates the error of confidence interval
  error <- qt(0.975,df=num-1)*stdev/sqrt(num) 
  upper <- avg + error
  lower <- avg - error
  print(paste(lower, upper))
}


WINE_CSV_FILE = "../../data/wine/wine.csv"

# generates a data frame
wi.df <- read.table(WINE_CSV_FILE, sep=",", header=TRUE)
# basic view of our data

# splits it into the multiple alcohol classifications
wi.df.vector <- get.categories(wi.df, 'Alcohol')
i <- 1
apply.confidence <- function(x) {
  get.confidence.interval(get.column.category(x,as.numeric(i),"Color"))
  i <- i + 1
}

get.confidence.interval(get.column.category(wi.df.vector[1], 1, "Color"))
get.confidence.interval(get.column.category(wi.df.vector[2], 2, "Color"))
get.confidence.interval(get.column.category(wi.df.vector[3], 3, "Color"))
get.confidence.interval(get.column.category(wi.df.vector[1], 1, "Ash"))


# the results show that there is a rather distinctive boundry for confidence intervals.  However, looking at the maximum and minimum values, it can be seen that using confidence intervals to define a classification for no reason.  
