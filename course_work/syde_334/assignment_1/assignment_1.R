
# Load Data Set
iowa <- read.csv("iowatest.txt", sep="\t")
# Remove NA cases
iowa <- iowa[complete.cases(iowa),]

n <- nrow(iowa)

y <- iowa$Test
x <- iowa$Poverty

x.bar <- mean(x)
y.bar <- mean(y)

sxx <- sum((x - x.bar)^2)
sxy <- sum((x - x.bar) * (y - y.bar))


# Part A
# Estimate B1, B0 and Sigma
b1.hat <- sxy / sxx
b0.hat <- y.bar - b1.hat * x.bar
y.hat <- b0.hat + b1.hat * x
var.hat <- sum((y - y.hat)^2) / (n - 2)

s1 <- sqrt(var.hat / sxx)


# Part B
# Confidence Interval of b1.hat
alpha <- 0.95
z.alpha <- qnorm(p = 1 - (1-alpha)/2)
conf.interval <- b1.hat + c(-1,1) * s1 * z.alpha


# Part C
# Plot regressino line with prediction intervals
x.p <- c(min(x):max(x))
y.p <- b0.hat + b1.hat*x.p

s.x0 <- sqrt(var.hat * (1 + 1 / n + ((x.p - x.bar)^2 / sxx)))

# Prediction intervals
z.pred <- qt(p = 1 - (1-alpha)/2, df = n-2)
pred.upper.int <- y.p + z.pred * s.x0
pred.lower.int <- y.p - z.pred * s.x0

# Part C
# Plot data
plot(x, y)
abline(b0.hat, b1.hat)
points(x.p, pred.upper.int)
points(x.p, pred.lower.int)


# Part D
# is b1.hat < 0?
# Utilize a hypothesis test to determine if this true or not
# Null hypothesis: b1.hat >= 0 
test.stat <- b1.hat / sqrt(var.hat / sxx)

#one sided hypothesis test
c1 <- qt( alpha, df = n-2)
# reject Null hypothesis if T < c1
reject.null.d <- test.stat < c1

# Part C
# is b1.hat != 0?
# Null Hypothesis: b1.hat = 0
c2 <- qt( 1 - (1 - alpha)/2, df = n - 2)
reject.null.e <- abs(test.stat) > c2


