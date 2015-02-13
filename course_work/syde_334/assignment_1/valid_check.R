# Generate random numbers
n <- 100
x <- rnorm(n, mean = 10, sd = 5)
b1 <- 5
b0 <- 3
sigma <- 2

y <- b0 + b1*x + rnorm(n, mean = 0, sd = sigma)


x.bar <- mean(x)
y.bar <- mean(y)
xi.sq <- sum(x^2)
yi.sq <- sum(y^2)
xi.yi <- sum(x*y)



b1.check <-cov(x,y)/var(x) == (xi.yi - n*x.bar*y.bar)/(xi.sq - n*x.bar^2)
b1.hat <- cov(x,y) / var(x)

b0.hat <- y.bar - x.bar*b1.hat

var.hat <- sum((y - b0.hat - b1.hat*x)^2) / (n-2)
var.hat.v2 <- (yi.sq - 2*n*y.bar*b0.hat -2*b1.hat*xi.yi
              + b0.hat^2*n + b0.hat*b1.hat*n*x.bar*2 
              +b1.hat^2*xi.sq)/(n-2)
var.check <- var.hat  == var.hat.v2
