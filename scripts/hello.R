x <- 1:10000	
x_bar <- array()
for (i in 1:50){
	samp <- sample(x, 10)
	x_bar[i] <- mean(samp)	

}

str(x_bar)

mean(x_bar)
mean(x)

