# Let's say we are interested in discovering the classification of alochol and the color. Let's plot some points to see what we can learn 


WINE_CSV_FILE = "../../data/wine/wine.csv"

# generates a data frame
wi.df <- read.table(WINE_CSV_FILE, sep=",", header=TRUE)
# basic view of our data

summary(wi.df)
plot(wi.df$Alcohol, wi.df$Color)
plot(wi.df$Hue, wi.df$Color)
