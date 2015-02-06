
# Load Data Set
iowa <- read.csv("iowatest.txt", sep="\t")
# Remove NA cases
iowa <- iowa[complete.cases(iowa),]

n <- length(iowa)

y <- iowa$Test
x <- iowa$Poverty

x.bar <- mean(x)
y.bar <- mean(y)

sxx <- sum((x - x.bar)^2)
sxy <- sum((x - x.bar) * (y - y.bar))



# Estimate B1, B0 and Sigma
b1.hat <- sxy / sxx
b0.hat <- y.bar - b1.hat * x.bar
y.hat <- b0.hat + b1.hat * x
sigma.hat <- sum((y - y.hat)^2) / (n - 2)
