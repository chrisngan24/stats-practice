data <- read.csv("stat331-tut2_data.csv")

y_bar <- mean(data$y)
x_bar <- mean(data$x)
n <- nrow(data)

sxy <- sum((data$y-y_bar)*(data$x - x_bar))
sxx <- sum((data$x - x_bar)^2)


b1_hat <- sxy / sxx
b0_hat <- y_bar - b1_hat * x_bar
sigma_hat <- sqrt(sum((data$y - b0_hat - b1_hat * data$x)^2)/(n - 2))


test_stat <- b1_hat / (sigma_hat / sqrt(sxx))


p_val <- 2*pt(-abs(test_stat), df = n-2)
p_val
