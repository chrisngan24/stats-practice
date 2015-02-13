
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
b1.hat <- sxy / sxx # b1.hat = -0.5357754
b0.hat <- y.bar - b1.hat * x.bar # b0.hat = 74.60 
y.hat <- b0.hat + b1.hat * x 
var.hat <- sum((y - y.hat)^2) / (n - 2) # var.hat  = 76.84194

s1 <- sqrt(var.hat / sxx)


# Part B
# Confidence Interval of b1.hat
alpha <- 0.95
z.alpha <- qt(p = 1 - (1-alpha)/2, df = n-2)
conf.interval <- b1.hat + c(-1,1) * s1 * z.alpha
# conf.interval = [-0.6003030 -0.4712478]


# Part C
# Plot regressino line with prediction intervals
x.p <- seq(min(x)-1,max(x) + 1, len = 1e3)
y.p <- b0.hat + b1.hat*x.p

s.x0 <- sqrt(var.hat * (1 + 1 / n + ((x.p - x.bar)^2 / sxx)))

# Prediction intervals
z.pred <- qt(p = 1 - (1-alpha)/2, df = n-2)
pred.upper.int <- y.p + z.pred * s.x0
pred.lower.int <- y.p - z.pred * s.x0

# Plot data
plot(x, y, xlab = 'Poverty Index', ylab='Mean Test Scores',
   main='Poverty Index vs. Mean Test Score for Iowa' )
abline(b0.hat, b1.hat, col='blue')
lines(x.p, pred.upper.int, col='red', lty = 2)
lines(x.p, pred.lower.int, col='red', lty = 2)


# Part D
# is b1.hat < 0?
# Utilize a hypothesis test to determine if this true or not
# Null hypothesis: b1.hat >= 0 
test.stat <- b1.hat / sqrt(var.hat / sxx) # -16.425

#one sided hypothesis test
c1 <- qt( alpha, df = n-2)
# c1 = 
# reject Null hypothesis if T < c1
# c1 = -1.656569 
reject.null.d <- test.stat < c1 # True! Reject null hypothesis

# Part E
# is b1.hat != 0?
# Null Hypothesis: b1.hat = 0
c2 <- qt( 1 - (1 - alpha)/2, df = n - 2)
# c2 = 1.978239
reject.null.e <- abs(test.stat) > c2 # True! Reject null hypothesis



