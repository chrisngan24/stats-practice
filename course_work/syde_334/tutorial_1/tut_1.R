####
# Generate N = 1000 Random variables x1,...xn ~ N(0, 5^2)
# 
####
library(stats)
library(graphics)

simp_lm_gen <- function(x_vector, b0, b1, m_sd){
  ei <- rnorm(length(x_vector), 0, m_sd)
  y_vector <- b0 + b1*x_vector + ei
  return(y_vector)
}

mle_b1 <- function(y, x){

  var_x <- var(x)
  var_xy <- var(x, y = y)
  
  return(var_xy / var_x)  
  
}

mle_b0 <- function(y, x, b1){
  return(mean(y) - b1*mean(x))
}


####
# Generate some data from a known linear regression
# calculate the MLE and explore how close/far it is 
# from the real value.
####
q2 <- function(){
  # initial setup
  N <- 1000
  x <- rnorm(N, 0, 5)
  b0 <- 1
  b1 <- 2
  m_sd <- 3.5
  
  y <- simp_lm_gen(x, b0, b1, m_sd)
  # part 1 - calculate MLE for b0 and b1
  b1_mle <- mle_b1(y,x) # arou
  b0_mle <- mle_b0(y,x, b1)
  print(c('MLE of b0:',  b0_mle)) 
  print(c('b0 true value:', b0))
  print(c('MLE of b1:',  b1_mle))
  print(c('b1 true value:', b1))
  
  # part 2 - plot the data and the estimated line
  plot(x,y)
  abline(b0_mle, b1_mle)
  
  # part 3 - calculate 92% conf interval for b1_mle
  error <- qnorm(0.92)*m_sd
  left <- b1_mle - error
  right <- b1_mle + error
  print(c('92% confidence interval: [', left, ',', right,']'))
}

q3 <- function(){
  # setup data
  N <- 1000
  M <- 10000
  x <- rnorm(N, 0, 5)
  b0 <- 1
  b1 <- 2
  m_sd <- 3.5
  
  y_mat <- replicate(M, simp_lm_gen(x, b0, b1, m_sd))
  
  # Part 1 - calculate b1_mle, plot histogram
  b1_mle_mat <- apply(y_mat, 2, mle_b1, x)
  hist(b1_mle_mat)
  
  return(c(y_mat, b1_mle_mat))
  
  
}


q2()
list[y_mat, b1_mle_mat] <- q3()
